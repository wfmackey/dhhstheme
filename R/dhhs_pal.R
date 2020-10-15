#' Create a DHHS-appropriate palette for your chart.
#'
#' @param n Numeric. The number of levels in your colour scale. Minimum value is
#'   1, maximum is 10. Using more than 6 is not recommended. If you don't
#'   specify `n`, a five-colour palette will be used, which may not look right.
#'   Specify `n`.
#'
#'   By default, n = 2 will give you teal and red.
#' @param reverse Logical. FALSE by default. Setting to TRUE reverses the
#'   standard colour order. Standard colour order runs from light to dark. If
#'   you set reverse to TRUE, colours will run from dark to light.
#' @param faded Logical. FALSE by default. Setting to TRUE returns the faded
#'   variations of the standard colours.
#'
#' @examples
#' library(ggplot2)
#'
#' p <- ggplot(mtcars, aes(x = wt, y = mpg, col = factor(cyl))) +
#'     geom_point() +
#'     theme_dhhs() +
#'     scale_colour_manual(values = dhhs_pal(n = 3))
#'
#' p
#'
#' # Alternatively, use dhhs_colour_manual(), which is a wrapper
#' # around scale_colour_manual():
#'
#' p <- ggplot(mtcars, aes(x = wt, y = mpg, col = factor(cyl))) +
#'     geom_point() +
#'     theme_dhhs() +
#'     dhhs_colour_manual(n = 3)
#'
#' p
#'
#' @export

dhhs_pal <- function(n = 0, reverse = FALSE, faded = FALSE) {

  if (n == 0) {
    n <- 5
    "Your chart will probably look better if you specify n in dhhs_pal().\n Choosing default 5."
  }

  if (n > 6 & n <= 10) {
    warning("Using more than six colours is not recommended.")
  }

  if (n > 10) {
    stop(paste0("You've requested ", n,
                " colours; dhhs_pal() only supports up to 10."))
  }

  if (isFALSE(faded)) {
    palette <- regular_palette(n)
  }

  if (isTRUE(faded)) {
    palette <- faded_palette(n)
  }

  if (isTRUE(reverse)) {
    palette <- rev(palette)
  }

  palette
}

regular_palette <- function(n) {

  col1 <-  dhhstheme::dhhs_teal6
  col2 <-  dhhstheme::dhhs_pink6
  col3 <-  dhhstheme::dhhs_purple6
  col4 <-  dhhstheme::dhhs_blue6
  col5 <-  dhhstheme::dhhs_navy6
  col6 <-  dhhstheme::dhhs_green6
  col7 <-  dhhstheme::dhhs_orange6
  col8 <-  dhhstheme::dhhs_teal4
  col9 <-  dhhstheme::dhhs_pink4
  col10 <- dhhstheme::dhhs_purple4

  if (n <= 1) palette <- col1
  if (n <= 2) palette <- c(palette, col2)
  if (n <= 3) palette <- c(palette, col3)
  if (n <= 4) palette <- c(palette, col4)
  if (n <= 5) palette <- c(palette, col5)
  if (n <= 6) palette <- c(palette, col6)
  if (n <= 7) palette <- c(palette, col7)
  if (n <= 8) palette <- c(palette, col8)
  if (n <= 9) palette <- c(palette, col9)
  if (n <= 10) palette <- c(palette, col10)

  palette
}


faded_palette <- function(n) {

  col1 <-  dhhstheme::dhhs_teal4
  col2 <-  dhhstheme::dhhs_pink4
  col3 <-  dhhstheme::dhhs_purple4
  col4 <-  dhhstheme::dhhs_blue4
  col5 <-  dhhstheme::dhhs_navy4
  col6 <-  dhhstheme::dhhs_green4
  col7 <-  dhhstheme::dhhs_orange4
  col8 <-  dhhstheme::dhhs_teal3
  col9 <-  dhhstheme::dhhs_pink3
  col10 <- dhhstheme::dhhs_purple3

  if (n <= 1) palette <- col1
  if (n <= 2) palette <- c(palette, col2)
  if (n <= 3) palette <- c(palette, col3)
  if (n <= 4) palette <- c(palette, col4)
  if (n <= 5) palette <- c(palette, col5)
  if (n <= 6) palette <- c(palette, col6)
  if (n <= 7) palette <- c(palette, col7)
  if (n <= 8) palette <- c(palette, col8)
  if (n <= 9) palette <- c(palette, col9)
  if (n <= 10) palette <- c(palette, col10)


  palette
}
