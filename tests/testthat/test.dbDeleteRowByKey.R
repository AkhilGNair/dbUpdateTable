context("dbDeleteRowByKey")
# Login details at ~/.my.cnf
db = RMySQL::dbConnect(RMySQL::MySQL(), group = "dbUpdateTable")

# define model
model_Letters = data.table::data.table(
  key1 = character(0),
  key2 = character(0),
  key3 = character(0),
  key4 = character(0),
  key = c("key1", "key2", "key3", "key4")
)

# sync model to db
dbSyncTable(db, model_Letters, verbose = FALSE)

dt_letters = data.table::CJ(key1 = letters,
                            key2 = LETTERS,
                            key3 = month.name,
                            key4 = month.abb)

RMySQL::dbWriteTable(db, "Letters", dt_letters, row.names = FALSE, append = TRUE)

n_delete = 50000
dbDeleteRowByKey(db, "Letters", dt_letters[sample(1:.N, n_delete, replace = FALSE)])

test_that("Exactly 50000 rows are deleted", {

  expect_equal(nrow(dt_letters) - n_delete, nrow(RMySQL::dbReadTable(db, "Letters")))

})

RMySQL::dbRemoveTable(db, "Letters")
RMySQL::dbDisconnect(db)
