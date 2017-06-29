#' Custom classes, not part of base R that allow the user to more specifically declare column types
#' This class is just long text, that will inherit the SQL class varchar(300000)
#'
#' @export
long_text = function() {
  a        = character()
  class(a) = "long_text"
  a
}

#' It is not possible to create a null varibale of class POSIXt, with out forcable coersion
#'
#' @export
date_time = function() {
  a        = character()
  class(a) = "POSIXt"
  a
}
