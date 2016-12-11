# Login details at ~/.my.cnf
db = RMySQL::dbConnect(RMySQL::MySQL(), group = "MySQL")

# define model
model_People = data.table::data.table(
  PersonID = integer(0),
  LastName = character(0),
  FirstName = character(0),
  Age = numeric(0),
  key = c("PersonID", "LastName")
)

# sync model to db
dbSyncTable(db, model_People, verbose = FALSE)

# sample data
dt_people = data.table::copy(model_People)
dt_people = dt_people %>% dbCreateTable::add(2, "LastName2", "Chris",  31)
dt_people = dt_people %>% dbCreateTable::add(3, "LastName3", "Meldoy", 26)
dt_people = dt_people %>% dbCreateTable::add(4, "LastName4", "Tim",    21)

dbUpdateTable(db, "People", dt_people)

dt_people = dt_people %>% dbCreateTable::add(5, "LastName5", "Rich",   30)
dt_people[PersonID == 3, Age := 18]

dbUpdateTable(db, "People", dt_people)

RMySQL::dbRemoveTable(db, "People")
RMySQL::dbDisconnect(db)
