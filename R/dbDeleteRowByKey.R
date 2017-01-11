#' Delete rows of a keyed table
#'
#' Helper function for dbUpdateTable
#'
#' @param con A database connection
#' @param name The name of the MySQL table to delete rows from
#' @param dt A \code{data.table} containing paired keys to delete

dbDeleteRowByKey = function(con, name, dt) {
  # Construct main statement
  query = "DELETE FROM %(name)s WHERE (%(pk)s) IN (%(tups)s) ;"

  # Statement boilerplate to select keys from information schema
  pk = dbGetKey(con, name)
  str_pk = paste0(pk, collapse = ", ")

  # Get tuple keys to delete from dt
  delete_keys = dt[, pk, with = FALSE]
  # Wrap string types with quotes to be passed as string to query
  delete_keys = quote_string_cols(delete_keys)

  # Format keys to insert into query
  str_delete_keys = delete_keys[, .id := 1:.N][, .(tup = paste0(.SD, collapse = ", ")), by = .id][, tup]
  str_delete_keys = paste0("(", paste0(str_delete_keys, collapse = "), ("), ")")

  # Insert parameters into query
  query = query %format% list(name = name, pk = str_pk, tups = str_delete_keys)
  # Dispatch query
  DBI::dbGetQuery(con, query)
  TRUE
}

quote_string_cols = function(dt) {
  col_types = vapply(dt, FUN = class, FUN.VALUE = character(1))
  col_str_types = col_types[col_types == "character"]

  # Only run if there is a character column being keyed by
  # i.e. if length(col_str_types) != 0
  if(length(col_str_types) != 0){
    dt[, (names(col_str_types)) := lapply(.SD, quote_string), .SDcols = names(col_str_types)]
  }
  dt
}

quote_string = function(x) {
  paste0("'", x, "'")
}
