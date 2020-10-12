#' Convenient functions to set DHHS-appropriate palettes
#'
#' @param n Numeric. The number of levels in your colour scale. Minimum value is
#'   1, maximum is 7. Passed to \code{grattan_pal}; see ?grattan_pal for more
#'   information.
#'
#' @param reverse Logical. FALSE by default. Setting to TRUE reverses the
#'   standard colour order.
#'
#' @param faded Logical. FALSE by default. Setting to TRUE returns faded
#'   variations of the standard colours.
#'
#' @param discrete Logical. TRUE by default. Setting to FALSE generates a
#'   continuous colour scale.
#'
#' @param palette Sets the colours that will form the continuous palette when
#'   discrete = FALSE. One of:
#'
#'#' A list of DHHS colour sets
#'
#'
#' \itemize{
##' \item{"teal"}{from light teal to dark teal}
##' \item{"blue"}{from light blue to dark blue}
##' \item{"pink"}{from light pink to dark pink}
##' \item{"green"}{from light green to dark green}
##' \item{"navy"}{from light navy to dark navy}
##' \item{"purple"}{from light purple to dark purple}
##' \item{"orange"}{from light orange to dark orange}
##' \item{"diverging"}{pink, faded pink, white, faded teal, teal}
##' \item{"diverging2"}{pink, faded pink, white, faded navy, navy}
##' \item{"grey"}{from light greyscale to dark greyscale}
##'}
#'
#' @param ... arguments passed to ggplot2 scales
#'
#' @examples
#'
#' library(ggplot2)
#'
#' ggplot(data = mtcars, aes(x = wt, y = mpg, col = factor(cyl))) +
#'    geom_point() +
#'    dhhs_colour_manual(n = 3) +
#'    theme_dhhs()
#'
#' @name dhhs_scale
#' @aliases NULL
NULL

#' @rdname dhhs_scale
#' @import ggplot2
#' @export


dhhs_colour_manual <- function(n = 0,
                                  reverse = FALSE,
                                  discrete = TRUE,
                                  faded = FALSE,
                                  palette = "teal", ...) {
  if (discrete) {
    return(
      ggplot2::scale_colour_manual(...,
                                   values = dhhstheme::dhhs_pal(
                                     n = n,
                                     reverse = reverse,
                                     faded = faded))
    )
  }

  if (!discrete) {
    pal <- dhhs_palette(palette = palette, reverse = reverse)
    return(ggplot2::scale_color_gradientn(colours = pal(256), ...))
  }


}

#' @rdname dhhs_scale
#' @import ggplot2
#' @export

dhhs_fill_manual <- function(n = 0,
                             reverse = FALSE,
                             discrete = TRUE,
                             faded = FALSE,
                             palette = "teal", ...) {
  if (discrete) {
    return(
      ggplot2::scale_fill_manual(...,
                                 values = dhhs_pal(
                                   n = n,
                                   reverse = reverse,
                                   faded = faded))
    )
  }

  if (!discrete) {
    pal <- dhhs_palette(palette = palette, reverse = reverse)
    return(ggplot2::scale_fill_gradientn(colours = pal(256), ...))
  }

}


# # Generates a full palette
dhhs_palette <- function(palette = "teal", reverse = FALSE, ...) {

  pal <- dhhstheme::dhhs_palette_set[[palette]]

  if (reverse) pal <- rev(pal)

  grDevices::colorRampPalette(pal, ...)
}
