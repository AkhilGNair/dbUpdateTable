#' SQL classes without a directly analogous R class

#' character_long <=> VARCHAR(30000)
#'
#' @export
character_long = function() {
  str = character()
  class(str) = "character_long"
  str
}

#' text <=> text
#'
#' @export
text = function() {
  str = character()
  class(str) = "text"
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
