#' SQL classes without a directly analogous R class

#' Long text <=> VARCHAR(30000)
#'
#' @export
long_text = function() {
  str = character()
  class(str) = "long_text"
  str
}

#' POXISt <=> DATETIME
#' An empty POSIXt is otherwise classed as a character
#'
#' @export
date_time = function() {
  str = character()
  class(str) = "POSIXt"
  str
}
