#' dbUpdateTable
#'
#' Update rows of a keyed table via DELETE + INSERT
#'
#' @param con A MySQL connection
#' @param name A MySQL table name
#' @param dt A keyed data.table with data to update in \code{name}
#' @param verbose Print brief progress messages
#'
#' @include dbDeleteRowByKey.R
#' @export

dbUpdateTable = function(con, name, dt, verbose = FALSE) {

  # Switches for dots
  # verbose = FALSE
  # dots = list(...)
  # if("verbose" %in% names(dots)) verbose = dots[["verbose"]]

  # Use transcation for failure tolerance
  DBI::dbWithTransaction(
    conn = con, code = {
      dbDeleteRowByKey(con, name, dt)
      if(verbose) message("Deleting row(s) from database")

      RMySQL::dbWriteTable(con, name, dt, row.names = FALSE, append = TRUE)
      if(verbose) message("Writing row(s) to database")
    }
  )

  TRUE
}
