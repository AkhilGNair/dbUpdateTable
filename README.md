# Easily update keyed tables in MySQL from R without duplicating data

The only purpose of this library is to create a table before we start inserting data into it, such that it can be keyed.  As it is keyed, duplicate keys are ignored.

 - Create the Model in R
```
library(magrittr)

model_People = data.table::data.table(
  PersonID = numeric(0),
  LastName = character(0),
  FirstName = character(0),
  Age = numeric(0),
  key = c("PersonID", "LastName")
)
```
 - Connect to the database
 - Build the query
 - Insert the query

```
# database configuration in ~/.my.cnf
db = RMySQL::dbConnect(RMySQL::MySQL(), group = "MySQL")
create_query = dbCreateTable::create(model_People)
RMySQL::dbGetQuery(db, create_query)
```
Sample SQL data to insert into the built table from the command line, or other
```
INSERT INTO People (PersonID, LastName, FirstName)
VALUES (1, "LastName1", "Akhil");

INSERT INTO People (PersonID, LastName, FirstName, Age)
VALUES (5, "LastName2", "Mandla", 26);
```

 - Sync update to table
```
# Create a table with ordered values
dt_people = copy(model_People)
dt_people = dt_people %>% dbCreateTable::add(1, "LastName1",    "Akhil",  NULL)
dt_people = dt_people %>% dbCreateTable::add(2, "LastName3",  "Chris",  65)
dt_people = dt_people %>% dbCreateTable::add(3, "LastName4",  "Lee",    26)
dt_people = dt_people %>% dbCreateTable::add(4, "LastName5", "Jones1", 21)

# Append data to table
# Duplicates of Primary key are ignored
RMySQL::dbWriteTable(db, "People", dt_people, append = TRUE, row.names = FALSE)
```
