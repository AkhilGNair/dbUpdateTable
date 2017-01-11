# dbUpdateTable

[![Build Status](https://travis-ci.org/AkhilNairAmey/dbUpdateTable.svg?branch=master)](https://travis-ci.org/AkhilNairAmey/dbUpdateTable)

#### Easily update keyed tables in MySQL from R without duplicating data

This library has two purposes:

 - Create a table in MySQL before inserting data into it, such that it can be keyed.
 - Provide a function to update values to the table, respecting the key.
   - Although the function is written to look like standard `RMySQL` functions, it does not conform to the coding practices of the main package.
   - Workload is mainly carried out by `RMySQL` functions, with the exception of `dbDeleteRowByKey`, for which the performance isn't too bad.
     - TODO: Add benchmark
   
## Define model

 - Create the Model in R

```
library(magrittr)

model_People = data.table::data.table(
  PersonID = integer(0),
  LastName = character(0),
  FirstName = character(0),
  Age = integer(0),
  key = c("PersonID", "LastName")
)
```

## dbSyncTable 

 - Connect to the database
 - Sync model to database

```
# database configuration in ~/.my.cnf
db = RMySQL::dbConnect(RMySQL::MySQL(), group = "MySQL")
dbUpdateTable::dbSyncTable(db, model_People)
```

Sample SQL data to insert into the built table from the command line or other

```
INSERT INTO People (PersonID, LastName, FirstName)
VALUES (1, "LastName1", "Akhil");

INSERT INTO People (PersonID, LastName, FirstName, Age)
VALUES (5, "LastName2", "Mandla", 26);
```

Resulting in

| PersonID | LastName  | FirstName | Age  |
|----------|-----------|-----------|------|
|        1 | LastName1 | Akhil     | NULL |
|        5 | LastName2 | Mandla    |   26 |

## Keyed Append

 - Sync update to table
 
```
# Create a table with ordered values
dt_people = data.table::copy(model_People)
dt_people = dt_people %>% dbUpdateTable::add(1, "LastName1", "Akhil", 10)
dt_people = dt_people %>% dbUpdateTable::add(2, "LastName3", "Chris",  65)
dt_people = dt_people %>% dbUpdateTable::add(3, "LastName4", "Meldoy", 26)
dt_people = dt_people %>% dbUpdateTable::add(4, "LastName5", "Tim",    21)

# Append data to table
# Duplicates of Primary key are ignored
RMySQL::dbWriteTable(db, "People", dt_people, append = TRUE, row.names = FALSE)
```

Resulting in the new entries being appended
 - `Akhil` is not duplicated as the primary key already exists
 - `Akhil` is not updated with `Age <- 10` as this is an UPDATE IGNORE

| PersonID | LastName  | FirstName | Age  |
|----------|-----------|-----------|------|
|        1 | LastName1 | Akhil     | NULL |
|        2 | LastName3 | Chris     |   65 |
|        3 | LastName4 | Melody    |   26 |
|        4 | LastName5 | Tim       |   21 |
|        5 | LastName2 | Mandla    |   26 |

## Keyed Update

 - Sync update to table values

```
# Create a table with ordered values
dt_people = data.table::copy(model_People)
dt_people = dt_people %>% dbUpdateTable::add(1, "LastName1", "Akhil", 10)

# Append data to table
# Duplicates of Primary key are ignored
dbUpdateTable::dbUpdateTable(db, "People", dt_people)
```

Resulting in the passed rows being updated
 - `Akhil` is now updated with `Age <- 10`
 
| PersonID | LastName  | FirstName | Age  |
|----------|-----------|-----------|------|
|    1     | LastName1 | Akhil     |   10 |
|    2     | LastName3 | Chris     |   65 |
|    3     | LastName4 | Meldoy    |   26 |
|    4     | LastName5 | Tim       |   21 |
|    5     | LastName2 | Mandla    |   26 |

