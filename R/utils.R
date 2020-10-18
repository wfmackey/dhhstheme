points_to_mm <- function(points) {
  as.numeric(grid::convertX(ggplot2::unit(points, "points"), "mm"))[1]
}


extract_base_colour_from_text <- function(colour_text) {
  gsub("1|2|3|4|5|6", "", colour_text)
}

extract_tint_level_from_text <- function(colour_text) {
  tint <- suppressWarnings(
    as.numeric(
      substring(colour_text, nchar(colour_text))
    )
  )
}
