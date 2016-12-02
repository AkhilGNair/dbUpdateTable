library(magrittr)

model_People = data.table::data.table(
  PersonID = numeric(0),
  LastName = character(0),
  FirstName = character(0),
  Age = numeric(0),
  key = c("PersonID", "LastName")
)

# Build the create table query
create_query = dbCreateTable::create(model_People)

# database configuration in ~/.my.cnf
db = RMySQL::dbConnect(RMySQL::MySQL(), group = "MySQL")

# Sync the database model to the database
RMySQL::dbGetQuery(db, create_query)

# Sample SQL inserts
# INSERT INTO People (PersonID, LastName, FirstName)
# VALUES (1, "Nair", "Akhil");
#
# INSERT INTO People (PersonID, LastName, FirstName, Age)
# VALUES (5, "Mandla", "Moyo", 26);

# Create a table with ordered values
dt_people = copy(model_People)
dt_people = dt_people %>% dbCreateTable::add(1, "Nair",    "Akhil",  NULL)
dt_people = dt_people %>% dbCreateTable::add(2, "Beedie",  "Chris",  65)
dt_people = dt_people %>% dbCreateTable::add(3, "Melody",  "Lee",    26)
dt_people = dt_people %>% dbCreateTable::add(4, "Timothy", "Jones1", 21)

# Append data to table
# Duplicates of Primary key are ignored
RMySQL::dbWriteTable(db, "People", as.data.frame(dt_people), append = TRUE, row.names = FALSE)
