#' A function to create a query to create keyed data.tables into a MySQL database

#' @export
create = function(model, verbose = TRUE) {

  # Get model name
  str_name = deparse(substitute(model))
  # Check is model name conforms to name that can be parsed, and db inserted
  if (!stringr::str_detect(str_name, "^model_")) {
    stop("Model object name must be prefixed with 'model_', e.g. 'model_People'")
  }
  # Get table name to insert
  str_name = stringr::str_extract(str_name, "(?<=model_)[[:alpha:]]+")

  # Parse data.table to creat CREATE TABLE query
  str_structure = vapply(model, class, FUN.VALUE = character(1))
  dt_structure = data.table(colname = names(str_structure), type = str_structure)
  dt_structure[, type := get_sql_type(type)]
  # Push table structure into string query format
  str_variables = dt_structure %>% get_query_variables()

  # Get the primary key
  str_pk = get_pk(model)

  if(verbose) {
    writeLines(create_statement(statement_start, "\n"))
    writeLines(dt_structure %>% get_query_variables(sep = "\n"))
    writeLines(get_pk(model, "  "))
    writeLines(create_statement(statement_end))
  }

  # Add query boiler plate
  paste0(create_statement(statement_start), str_variables, str_pk, create_statement(statement_end))
}

create_statement = function(statement, sep = " ", spacer = "") {
  if(sep == "\n") spacer = "  "
  sprintf(statement, sep, spacer)
}

get_query_variables = function(dt, sep = " ", spacer = "") {
  if(sep == "\n") spacer = "  "
  str = dt[, paste0(spacer, colname, " ", type, ",", collapse = sep)]
  if(str == " ,") stop("No columns in model")
  str
}

get_pk = function(dt, spacer = " ") {
  str_pk = paste0(data.table::key(dt), collapse = ", ")
  str_pk = sprintf(statement_key, str_pk)
  if (str_pk == "PRIMARY KEY()") stop("Model has no primary key")
  paste0(spacer, str_pk)
}

statement_start = "CREATE TABLE IF NOT EXISTS People%s(%s"
statement_end = ");"
statement_key = "PRIMARY KEY(%s)"
