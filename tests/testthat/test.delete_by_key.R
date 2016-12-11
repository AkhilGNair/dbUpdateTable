# Login details at ~/.my.cnf
db = RMySQL::dbConnect(RMySQL::MySQL(), group = "MySQL")

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

ptm = proc.time()
dt_letters = data.table::CJ(key1 = letters,
                            key2 = LETTERS,
                            key3 = month.name,
                            key4 = month.abb)
dbWriteTable(db, "Letters", dt_letters, row.names = FALSE, append = TRUE)
write_time = proc.time() - ptm

ptm = proc.time()
dbDeleteRowByKey(db, "Letters", dt_letters[sample(1:.N, 50000)])
delete_time = proc.time() - ptm

dbRemoveTable(db, "Letters")
dbDisconnect(db)
