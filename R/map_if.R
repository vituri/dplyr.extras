#' Apply functions depending on a condition
#' @param .x An object
#' @param condition TRUE or FALSE
#' @param .f_if_true Function to apply when `condition` is `TRUE`
#' @param .f_if_false Function to apply when `condition` is not `TRUE`
#' @param .f Function to apply
#' @return `.x` or a function applied to `.x`, depending on `condition`
#' @name mutate-if

NULL

#' @export
#' @rdname mutate-if
map_if_condition = function(.x, condition, .f_if_true = identity, .f_if_false = identity) {
  if (condition %in% TRUE) {
    .f_if_true(.x)
  } else {
    .f_if_false(.x)
  }
}

#' @export
#' @rdname mutate-if
map_if_true = function(.x, condition, .f = identity) {
  if (condition %in% TRUE) {
    .f(.x)
  } else {
    .x
  }
}

#' @export
#' @rdname mutate-if
map_if_false = function(.x, condition, .f = identity) {
  if (condition %in% TRUE) {
    .x
  } else {
    .f(.x)
  }
}
