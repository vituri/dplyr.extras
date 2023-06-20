#' Apply a function to a data.frame and bind the result rows to it
#' @param .df A data.frame
#' @param .f A function do apply on `.df`
#' @export
map_then_bind_rows = function(.df, .f) {
  bind_rows(.df, .f(.df))
}

#' Apply a function to a data.frame and bind the result columns to it
#' @param .df A data.frame
#' @param .f A function do apply on `.df`
#' @export
map_then_bind_cols = function(.df, .f) {
  bind_cols(.df, .f(.df))
}

#' Apply a function to a data.frame and join the results in it.
#' @param .df A data.frame
#' @param .f A function do apply on `.df`
#' @param .join_by The columns to join, as passed to `left_join`
#' @param join_function The function used in the join
#' @export
map_then_join = function(.df, .f, .join_by = NULL, join_function){
  y = .f(.df)

  # to silence the join_by message:
  if (is.null(.join_by)) {
    .join_by = base::intersect(names(.df), names(y))
  }

  join_function(
    .df
    ,.f(.df)
    ,by = .join_by
  )

}

#' @export
map_then_left_join = function(.df, .f, .join_by = NULL) {
  map_then_join(.df = .df, .f = .f, .join_by = .join_by, join_function = dplyr::left_join)
}

#' @export
map_then_right_join = function(.df, .f, .join_by = NULL) {
  map_then_join(.df = .df, .f = .f, .join_by = .join_by, join_function = dplyr::right_join)
}

#' @export
map_then_inner_join = function(.df, .f, .join_by = NULL) {
  map_then_join(.df = .df, .f = .f, .join_by = .join_by, join_function = dplyr::inner_join)
}

\() {
  df = iris %>% as_tibble()

  df %>%
    map_then_bindrow(. %>% summarise(Soma = sum(Sepal.Length)))

  df %>%
    add_count(Species)

  df %>%
    map_then_left_join(. %>% summarise(Qtd = n(), .by = Species), .join_by = 'Species')

}
