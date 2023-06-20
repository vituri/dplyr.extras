# novas -------------------------------------------------------------------
vec_to_fun = function(.x) {
  if (is.function(.x)) {
    .f = .x
  } else {
    .f = function(x) {
      if (length(.x) == 1) {
        rep(.x, times = length(x))
      } else {
        .x
      }
    }
  }

  return(.f)
}

vec_all_true = function(.x) {
  if (purrr::is_empty(.x)) return(.x)

  rep(TRUE, length(.x))
}
