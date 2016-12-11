context("dbWriteTable append does not add duplicate data when keyed")
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
dt_people = dt_people %>% dbCreateTable::add(2, "LastName3", "Chris",  65)
dt_people = dt_people %>% dbCreateTable::add(3, "LastName4", "Meldoy", 26)
dt_people = dt_people %>% dbCreateTable::add(4, "LastName5", "Tim",    21)

dt_people_edit = data.table::copy(dt_people)
data.table::set(dt_people_edit, 1L, 4L, 32)

test_that("Duplicate data was not added", {
  # initially add rows
  RMySQL::dbWriteTable(db, "People", dt_people, append = TRUE, row.names = FALSE)
  n_rows1 = suppressWarnings(nrow(RMySQL::dbReadTable(db, "People")))

  # add duplicate rows on key
  RMySQL::dbWriteTable(db, "People", dt_people, append = TRUE, row.names = FALSE)
  n_rows2 = suppressWarnings(nrow(RMySQL::dbReadTable(db, "People")))

  expect_equal(n_rows1, n_rows2)
})

test_that("Insert IGNORES on duplicate key", {
  RMySQL::dbWriteTable(db, "People", dt_people, append = TRUE, row.names = FALSE)
  dt_people_read = suppressWarnings(RMySQL::dbReadTable(db, "People"))

  expect_equal(dt_people, data.table::as.data.table(dt_people_read))
  expect_false(all(data.table::as.data.table(dt_people_edit) == data.table::as.data.table(dt_people_read)))
})

test_that("Preserved old data and adds new row", {
  new_row = list(6, "LastName6", "Rebecca", 21)
  dt_people_edit = dt_people_edit %>% dbCreateTable::add(new_row)

  RMySQL::dbWriteTable(db, "People", dt_people_edit, append = TRUE, row.names = FALSE)
  dt_people_read = suppressWarnings(RMySQL::dbReadTable(db, "People"))

  # Test original data unaltered
  expect_equal(dt_people, data.table::as.data.table(dt_people_read)[1:3])
  for(i in 1:length(new_row)) {
    # Test returned values are correct for newly added row
    expect_equal(new_row[[i]], as.list(data.table::as.data.table(dt_people_read)[4])[[i]])
  }
})

# clean up
RMySQL::dbRemoveTable(db, "People")
RMySQL::dbDisconnect(db)
