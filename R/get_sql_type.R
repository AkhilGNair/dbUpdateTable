#' Add a row to a data.table
#' @import data.table
add = function(dt, ...) {
  row_struct = as.list(dt[0])
  row = list(...)
  names(row) = names(row_struct)
  rbind(dt, row)
}

#' Current implemented datatype handling
#' @importFrom magrittr "%>%"
hash_datatypes = data.table::data.table(r_type = character(0), sql_type = character(0))
hash_datatypes = hash_datatypes %>% add("numeric"  , "int")
hash_datatypes = hash_datatypes %>% add("character", "varchar(255)")

data.table::setkey(hash_datatypes, "r_type")

#' @export
get_sql_type = function(type, dt = hash_datatypes) {
  dt[type, sql_type]
}
