#' Add
#'
#' Add a row to a data.table - mainly for internal use and testing
#'
#' @param dt a \code{data.table} to add a row to
#' @param ... Versatile handler for the row, a list or multiple parameters
#'
#' @import data.table
#' @export

add = function(dt, ...) {
  # Init return param to catch exceptions
  dt_bound = NULL

  row_struct = as.list(dt[0])
  row = list(...)

  # If a list is passed, unnest it
  if(class(row[[1]]) == "list") row = row[[1]]

  names_row_struct = names(row_struct)
  names_list = names(row)

  # Ordered parameters supplied
  if(is.null(names_list) & (length(row) == length(names_row_struct))) {
    names(row) = names_row_struct
    dt_bound = rbind(dt, as.data.table(row))
  }

  # Named parameters supplied
  if(sum(names_list %in% names_row_struct) > 0) {
    dt_bound = rbind(dt, as.data.table(row), fill = TRUE)
  }

  if(is.null(dt_bound)) stop("Unexpected columns supplied")

  data.table::setkeyv(dt_bound, data.table::key(dt))

  return(dt_bound)
}

#' Current implemented datatype handling
#' @importFrom magrittr "%>%"
hash_datatypes = tibble::tribble(
  ~r_type    ,         ~sql_type,
  "Date"     ,            "date",
  "character",    "varchar(255)",
  "integer"  ,             "int",
  "logical"  ,         "TINYINT",
  "numeric"  ,  "decimal(10, 3)",
  "POSIXt"   ,        "DATETIME",
  "long_text",   "varchar(30000)"
) %>%
  data.table::setDT(.) %>%
  data.table::setkey("r_type")


#' get_sql_type
#'
#' Internal switch between R types and MySQL types
#'
#' @param type The R data type to switch to a MySQL data type
#' @param dt The hash table of types
get_sql_type = function(type, dt = hash_datatypes) {
  dt[type, eval(substitute(sql_type))]
}
