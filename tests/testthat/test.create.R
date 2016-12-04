model_People = data.table::data.table(
  PersonID = integer(0),
  LastName = character(0),
  FirstName = character(0),
  Age = numeric(0),
  key = c("PersonID", "LastName")
)

model_Test = data.table::data.table(
  a = character(0),
  c = integer(0),
  key = "a"
)

people_query = "CREATE TABLE IF NOT EXISTS People ( PersonID int, LastName varchar(255), FirstName varchar(255), Age decimal(10, 3), PRIMARY KEY(PersonID, LastName) );"
people_table_name = "CREATE TABLE IF NOT EXISTS People"
people_variables = "PersonID int, LastName varchar\\(255\\), FirstName varchar\\(255\\), Age decimal\\(10, 3\\),"
people_primary_key = "PRIMARY KEY\\(PersonID, LastName\\)"

test_query = "CREATE TABLE IF NOT EXISTS Test ( a varchar(255), c int, PRIMARY KEY(a) );"
test_table_name = "CREATE TABLE IF NOT EXISTS Test"
test_variables = "a varchar\\(255\\), c int,"
test_primary_key = "PRIMARY KEY\\(a\\)"

people_created_query = create(model_People, verbose = FALSE)
test_created_query = create(model_Test, verbose = FALSE)

context("Create People query")
test_that("the query is created correctly", {
  expect_true(stringr::str_detect(people_created_query, people_table_name))
  expect_true(stringr::str_detect(people_created_query, people_variables))
  expect_true(stringr::str_detect(people_created_query, people_primary_key))
  expect_equal(people_created_query, people_query)
})

context("Create Test query")
test_that("the query is created correctly", {
  expect_true(stringr::str_detect(test_created_query, test_table_name))
  expect_true(stringr::str_detect(test_created_query, test_variables))
  expect_true(stringr::str_detect(test_created_query, test_primary_key))
  expect_equal(test_created_query, test_query)
})
