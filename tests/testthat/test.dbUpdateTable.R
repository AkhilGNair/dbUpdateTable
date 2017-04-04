context("dbUpdate table will Update a table, and write over rows")
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
dt_people = dt_people %>% dbUpdateTable::add(2, "LastName2", "Chris",  31)
dt_people = dt_people %>% dbUpdateTable::add(3, "LastName3", "Meldoy", 26)
dt_people = dt_people %>% dbUpdateTable::add(4, "LastName4", "Tim",    21)

dbUpdateTable(db, "People", dt_people)

test_that("Update Table can populate a table", {
  test_1 = suppressWarnings(RMySQL::dbReadTable(db, "People")) %>%
    data.table::setDT(.) %>%
    data.table::setkeyv(., dbUpdateTable::dbGetKey(db, "People"))

  expect_equal(dt_people, test_1)
})

dt_people = dt_people %>% dbUpdateTable::add(5, "LastName5", "Rich",   30)
dbUpdateTable(db, "People", dt_people)

test_that("Update Table can add data to a table", {
  test_2 = suppressWarnings(RMySQL::dbReadTable(db, "People")) %>%
    data.table::setDT(.) %>%
    data.table::setkeyv(., dbUpdateTable::dbGetKey(db, "People"))

  expect_equal(dt_people, test_2)
})

dt_people[PersonID == 3, Age := 18]
dbUpdateTable(db, "People", dt_people)

test_that("Update Table can replace data in a table", {
  test_3 = suppressWarnings(RMySQL::dbReadTable(db, "People")) %>%
    data.table::setDT(.) %>%
    data.table::setkeyv(., dbUpdateTable::dbGetKey(db, "People"))

  expect_equal(dt_people, test_3)
})

dt_people[PersonID == 2, Age := Age + 1]
dt_people_one_row = dt_people[PersonID == 2]
dbUpdateTable(db, "People", dt_people_one_row)

test_that("Update Table can replace data just one row in a table", {
  test_4 = suppressWarnings(RMySQL::dbReadTable(db, "People")) %>%
    data.table::setDT(.) %>%
    data.table::setkeyv(., dbUpdateTable::dbGetKey(db, "People"))

  expect_equal(dt_people, test_4)
})

####### Tes the ability of transaction
test_that("Update Table can replace data just one row in a table", {
  dt_wrong = data.table::copy(dt_people)[PersonID == 2, Age := Age + 1000000]

  # This will not finish runnign and kill the connection db
  expect_error(
    dbUpdateTable(db, "People", dt_people_one_row, test_kill = TRUE)
  )

  # Reinsate db
  db = RMySQL::dbConnect(RMySQL::MySQL(), group = "MySQL")

  # Insure nothing on the db has changed
  test_4 = suppressWarnings(RMySQL::dbReadTable(db, "People")) %>%
    data.table::setDT(.) %>%
    data.table::setkeyv(., dbUpdateTable::dbGetKey(db, "People"))

  expect_equal(dt_people, test_4)
})




dt_people = dt_people %>% dbUpdateTable::add(5, "LastName5", "Rich",   30)
dt_people[PersonID == 3, Age := 18]

dbUpdateTable(db, "People", dt_people)

RMySQL::dbRemoveTable(db, "People")
RMySQL::dbDisconnect(db)
