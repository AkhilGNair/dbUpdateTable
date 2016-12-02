model_People = data.table(
  PersonID = numeric(0),
  LastName = character(0),
  FirstName = character(0),
  Age = numeric(0),
  key = c("PersonID", "LastName")
)

query = "CREATE TABLE IF NOT EXISTS People (PersonID int, LastName varchar(255), FirstName varchar(255), Age int, PRIMARY KEY(PersonID, LastName));"
table_name = "CREATE TABLE IF NOT EXISTS People"
variables = "PersonID int, LastName varchar\\(255\\), FirstName varchar\\(255\\), Age int,"
primary_key = "PRIMARY KEY\\(PersonID, LastName\\)"

created_query = create(model_People, verbose = FALSE)

context("Create query")
test_that("the query is created correctly", {
  expect_true(stringr::str_detect(created_query, table_name))
  expect_true(stringr::str_detect(created_query, variables))
  expect_true(stringr::str_detect(created_query, primary_key))
  expect_equal(created_query, query)
})
