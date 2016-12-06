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

context("sync to database preserves key when read")
# read back column names and key to check correct syncing
dt = suppressWarnings(RMySQL::dbReadTable(db, "People"))
col_names = colnames(dt)
pk = dbGetKey(db, "People")

test_that("Column names can be read from database", {
  expect_equal(names(model_People), col_names)
})

test_that("Table key is preserved", {
  expect_equal(data.table::key(model_People), pk)
})

# clean up
RMySQL::dbRemoveTable(db, "People")
RMySQL::dbDisconnect(db)
