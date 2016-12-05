#' Get the primary key from a table

#' @export
dbGetKey = function(con, name, ...) {
  # Statement boilerplate to select keys from information schema
  query = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_SCHEMA = '%(db)s' 
             AND TABLE_NAME = '%(table)s'
             AND COLUMN_KEY = 'PRI';"
  
  # Get database name
  schema_name = DBI:::dbGetQuery(db, "SELECT DATABASE()")[, 1]
  # Construct parameters
  params = list(db = schema_name, table = name)
  # Dispatch statement
  DBI::dbGetQuery(con, query %format% params)[, "COLUMN_NAME"]
}
