#' A function to create a query to create keyed data.tables into a MySQL database

#' @export
dbSyncTable = function(con, model, ...) {
  create_query = dbCreateTable::create(model_People, ...)
  DBI::dbGetQuery(con, create_query)
  TRUE
}

#' @include get_sql_type.R
#' @include utils.R
#' @export
create = function(model, verbose = TRUE, ...) {

  # Carry debug flag forward
  dots = list(...)
  if("verbose" %in% names(dots)) verbose = dots[["verbose"]]

  # Get model name
  str_name = deparse(substitute(model))
  # Check is model name conforms to name that can be parsed, and db inserted
  if (!stringr::str_detect(str_name, "^model_")) {
    stop("Model object name must be prefixed with 'model_', e.g. 'model_People'")
  }
  # Get table name to insert
  str_table_name = stringr::str_extract(str_name, "(?<=model_)[[:alpha:]]+")

  # Get variables
  # Parse data.table to creat CREATE TABLE query
  str_structure = vapply(model, class, FUN.VALUE = character(1))
  dt_structure = data.table(colname = names(str_structure), type = str_structure)
  dt_structure[, type := get_sql_type(type)]
  # Push table structure into string query format
  str_variables = dt_structure %>% get_query_variables()

  # Get the primary key
  str_pk = model %>% get_pk()

  # Construct insert statement
  statement = "CREATE TABLE IF NOT EXISTS %(table_name)s ( %(variables)s PRIMARY KEY(%(primary_key)s) );"
  params = list(table_name  = str_table_name,
                variables   = str_variables,
                primary_key = str_pk)
  # Insert constructe values
  statement = statement %format% params

  if(verbose) {
    console_log = statement
    console_log = stringr::str_replace(console_log, " \\( ", "\n\\(\n  ")
    console_log = stringr::str_replace_all(console_log, ", (?=[A-Z].+PRIMARY)", ",\n  ")
    console_log = stringr::str_replace(console_log, ", PRIMARY KEY", ",\n  PRIMARY KEY")
    console_log = stringr::str_replace(console_log, " \\);", "\n\\);")
    writeLines(console_log)
  }

  # return
  statement
}

get_query_variables = function(dt, sep = " ", spacer = "") {
  if(sep == "\n") spacer = "  "
  str = dt[, paste0(spacer, colname, " ", type, ",", collapse = sep)]
  if(str == " ,") stop("No columns in model")
  str
}

get_pk = function(dt, spacer = " ") {
  str_pk = paste0(data.table::key(dt), collapse = ", ")
  # str_pk = sprintf(statement_key, str_pk)
  if (str_pk == "") stop("Model has no primary key")
  str_pk
}
