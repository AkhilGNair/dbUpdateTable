context("query creation")
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

# TODO: Make this model_CustomClasses to check all custom types parse fine
model_Comment = data.table::data.table(
  CommentID    = integer(),
  PersonID     = integer(),
  data_time    = date_time(),
  comment_long = character_long(),
  comment_text = text(),
  make_public  = logical(),
  key = "CommentID"
)

people_query = "CREATE TABLE IF NOT EXISTS People ( PersonID int, LastName varchar(255), FirstName varchar(255), Age decimal(10, 3), PRIMARY KEY(PersonID, LastName) );"
people_table_name = "CREATE TABLE IF NOT EXISTS People"
people_variables = "PersonID int, LastName varchar\\(255\\), FirstName varchar\\(255\\), Age decimal\\(10, 3\\),"
people_primary_key = "PRIMARY KEY\\(PersonID, LastName\\)"

test_query = "CREATE TABLE IF NOT EXISTS Test ( a varchar(255), c int, PRIMARY KEY(a) );"
test_table_name = "CREATE TABLE IF NOT EXISTS Test"
test_variables = "a varchar\\(255\\), c int,"
test_primary_key = "PRIMARY KEY\\(a\\)"

comment_query       = "CREATE TABLE IF NOT EXISTS Comment ( CommentID int, PersonID int, data_time DATETIME, comment_long varchar(30000), comment_text text, make_public TINYINT, PRIMARY KEY(CommentID) );"
comment_table_name  = "CREATE TABLE IF NOT EXISTS Comment"
comment_variables   = "CommentID int, PersonID int, data_time DATETIME, comment_long varchar\\(30000\\), comment_text text, make_public TINYINT, PRIMARY KEY\\(CommentID\\)"
comment_primary_key = "PRIMARY KEY\\(CommentID\\)"


people_created_query  = create(model_People, verbose = FALSE)
test_created_query    = create(model_Test, verbose = FALSE)
comment_created_query = create(model_Comment, verbose = FALSE)

test_that("People query is created correctly", {
  expect_true(stringr::str_detect(people_created_query, people_table_name))
  expect_true(stringr::str_detect(people_created_query, people_variables))
  expect_true(stringr::str_detect(people_created_query, people_primary_key))
  expect_equal(people_created_query, people_query)
})

test_that("Another query is created correctly", {
  expect_true(stringr::str_detect(test_created_query, test_table_name))
  expect_true(stringr::str_detect(test_created_query, test_variables))
  expect_true(stringr::str_detect(test_created_query, test_primary_key))
  expect_equal(test_created_query, test_query)
})

test_that("Another query is created correctly", {
  expect_true(stringr::str_detect(comment_created_query, comment_table_name))
  expect_true(stringr::str_detect(comment_created_query, comment_variables))
  expect_true(stringr::str_detect(comment_created_query, comment_primary_key))
  expect_equal(comment_created_query, comment_query)
})
