model_People = data.table::data.table(
  PersonID = integer(0),
  LastName = character(0),
  FirstName = character(0),
  Age = numeric(0),
  key = c("PersonID", "LastName")
)

dt_people = data.table::copy(model_People)

# dt_people = dt_people %>% dbUpdateTable::add(1, "LastName1", "Akhil")

# Add one, all unnamed variables, ordered
test1 = dt_people %>% dbUpdateTable::add(2, "LastName3", "Chris",  65)
expected_test1 = data.table::data.table(PersonID = 2, LastName = "LastName3", FirstName = "Chris", Age = 65,
                                        key = c("PersonID", "LastName"))

# Add one, all named variables, unordered
test2 = dt_people %>% dbUpdateTable::add(PersonID = 3, FirstName = "Melody", LastName = "LastName4", Age = 26)
expected_test2 = data.table::data.table(PersonID = 3, LastName = "LastName4", FirstName = "Melody", Age = 26,
                                        key = c("PersonID", "LastName"))

# Add one, not all variables, names
test3 = dt_people %>% dbUpdateTable::add(PersonID = 4, LastName = "LastName5", Age = 21)
expected_test3 = data.table::data.table(PersonID = 4, LastName = "LastName5", FirstName = NA_character_, Age = 21,
                                        key = c("PersonID", "LastName"))

# Add one by list, all variables, unnamed
test4 = dt_people %>% dbUpdateTable::add(list(6, "LastName6", "Tom", 30))
expected_test4 = data.table::data.table(PersonID = 6, LastName = "LastName6", FirstName = "Tom", Age = 30,
                                        key = c("PersonID", "LastName"))

# Add multiple, not all variables, named
test5 = dt_people %>% dbUpdateTable::add(list(PersonID = c(1, 7), LastName = c("LastName1", "LastName7")))
expected_test5  = data.table::data.table(PersonID = c(1, 7),
                                         LastName = c("LastName1", "LastName7"),
                                         FirstName = c(NA_character_, NA_character_),
                                         Age = c(NA_real_, NA_real_),
                                         key = c("PersonID", "LastName"))

context("data.table inserts work correctly")
test_that("Can add ordered unnamed variables", {
  expect_equal(test1, expected_test1)
})

test_that("Can add unordered named variables", {
  expect_equal(test2, expected_test2)
})

test_that("Can named variables when not all are present", {
  expect_equal(test3, expected_test3)
})

test_that("Can add ordered variables via a list", {
  expect_equal(test4, expected_test4)
})

test_that("Can add multiple, named, unordered variables via a list", {
  expect_equal(test5, expected_test5)
})

