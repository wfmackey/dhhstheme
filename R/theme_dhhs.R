#' A ggplot2 theme consistent with DHHS style.
#' @name theme_dhhs
#' @param base_size Size for text elements. Defaults to 14.
#' @param base_colour Colour scheme for titles and axes. One of "navy" (default), "pink", "blue", "green", "orange".
#' @param background "white" by default. Set to a different DHHS colour.
#' @param legend "right" by default. Set to "none", "bottom", "left", "right" or "top" as
#'   desired, or a two element numeric vector such as c(0.9, 0.1).
#' @param panel_borders One of `"axes"` (default), "border", "none". Sets the border to a darker colour.
#' @param include_minor_gridlines If "none" (the default), minor gridlines are not included.
#' Use "x" or "y" to include minor gridlines for x or y axes, or "both" for both axes.
#' @import ggrepel
#' @importFrom ggplot2 %+replace%
#' @export


theme_dhhs <- function(base_size = 14,
                       base_colour = dhhs_navy,
                       background = "white",
                       legend = "right",
                       panel_borders = "axes",
                       include_minor_gridlines = "none") {

  # address global variable warning
  '%+replace%' <- ggplot2::'%+replace%'

  half_line <- base_size / 2

  # dark_colour <- dhhstheme::dhhs_greyscale
  # light_colour <- dhhstheme::dhhs_greyscale1
  # title_colour <- dhhstheme::dhhs_navy

  base_colour_string <- deparse(substitute(base_colour))

  title_colour <- get(paste0(base_colour_string))
  dark_colour <- get(paste0(base_colour_string, "4"))
  light_colour <- get(paste0(base_colour_string, "1"))

  # Settings
  base_line_size <- points_to_mm(0.75)
  base_rect_size <- points_to_mm(1)
  base_family = "sans"

  ret <-
    ggplot2::theme(
        line = ggplot2::element_line(
        colour = dark_colour,
        size = base_line_size,
        linetype = 1,
        lineend = "butt"
      ),
      rect = ggplot2::element_rect(
        fill = background,
        colour = dark_colour,
        size = base_rect_size,
        linetype = 0
      ),
      text = ggplot2::element_text(
        colour = dark_colour,
        family = base_family,
        face = "plain",
        hjust = 0.5,
        vjust = 0.5,
        angle = 0,
        lineheight = 0.9,
        debug = FALSE,
        margin = ggplot2::margin(),
        size = base_size
      ),
      axis.line = ggplot2::element_blank(),
      axis.line.x = NULL,
      axis.line.y = NULL,
      axis.text = ggplot2::element_text(size = ggplot2::rel(1)),
      axis.text.x = ggplot2::element_text(margin = ggplot2::margin(t = base_size / 5,
                                                 unit = "pt"),
                                 vjust = 1),
      axis.text.x.top = ggplot2::element_text(margin = ggplot2::margin(b = base_size / 5),
                                     vjust = 0),
      axis.text.y = ggplot2::element_text(margin = ggplot2::margin(r = base_size / 5),
                                 hjust = 1),
      axis.text.y.right = ggplot2::element_text(margin = ggplot2::margin(l = base_size / 5),
                                       hjust = 0),
      axis.ticks = ggplot2::element_line(colour = dark_colour),
      axis.ticks.length = ggplot2::unit(half_line / 2, "pt"),
      axis.ticks.length.x = NULL,
      axis.ticks.length.x.top = NULL,
      axis.ticks.length.x.bottom = NULL,
      axis.ticks.length.y = NULL,
      axis.ticks.length.y.left = NULL,
      axis.ticks.length.y.right = NULL,
      axis.title = ggplot2::element_text(size = ggplot2::rel(1)),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = half_line / 2),
                                  vjust = 1),
      axis.title.x.top = ggplot2::element_text(margin = ggplot2::margin(b = half_line / 2),
                                      vjust = 0),
      axis.title.y = ggplot2::element_text(
        angle = 90,
        margin = ggplot2::margin(r = half_line /
                          2),
        vjust = 1
      ),
      axis.title.y.right = ggplot2::element_text(
        angle = -90,
        margin = ggplot2::margin(l = half_line /
                          2),
        vjust = 0
      ),
      legend.background = ggplot2::element_rect(colour = NA),
      legend.spacing = ggplot2::unit(half_line, "pt"),
      legend.spacing.x = NULL,
      legend.spacing.y = NULL,
      legend.margin = ggplot2::margin(),
      legend.key = ggplot2::element_rect(fill = "white",
                                colour = "white"),
      legend.key.size = ggplot2::unit(1, "lines"),
      legend.key.height = NULL,
      legend.key.width = NULL,
      legend.text = ggplot2::element_text(size = ggplot2::rel(1),
                                 margin = ggplot2::margin(l = 0,
                                                 r = base_size / 4, unit = "pt")),
      # legend.text.align = 0,
      # legend.title = ggplot2::element_blank(),
      # legend.title.align = NULL,
      legend.position = legend,
      # legend.direction = "horizontal",
      # legend.justification = "center",
      # legend.box = "vertical",
      legend.box.margin = ggplot2::margin(0, 0,
                                 0, 0, "cm"),
      legend.box.background = ggplot2::element_blank(),
      legend.box.spacing = ggplot2::unit( half_line, "pt"),
      panel.background = ggplot2::element_rect(colour = NA),
      panel.border = ggplot2::element_blank(),
      panel.grid = ggplot2::element_line(colour = light_colour),
      panel.grid.minor.x = ggplot2::element_blank(),
      panel.grid.minor.y = ggplot2::element_blank(),
      panel.spacing = ggplot2::unit(1,
                           "lines"),
      panel.spacing.x = NULL,
      panel.spacing.y = NULL,
      panel.ontop = FALSE,
      strip.background = ggplot2::element_rect(),
      strip.text = ggplot2::element_text(
        size = ggplot2::rel(1),
        margin = ggplot2::margin(0.8 * half_line,
                        0.8 * half_line, 0.8 * half_line, 0.8 * half_line)
      ),
      strip.text.x = NULL,
      strip.text.y = ggplot2::element_text(angle = -90),
      strip.placement = "inside",
      strip.placement.x = NULL,
      strip.placement.y = NULL,
      strip.switch.pad.grid = ggplot2::unit(half_line / 2,
                                   "pt"),
      strip.switch.pad.wrap = ggplot2::unit(half_line / 2,
                                   "pt"),
      plot.background = ggplot2::element_rect(),
      plot.title.position = "plot",
      plot.caption.position = "plot",
      plot.title = ggplot2::element_text(
        size = ggplot2::rel(1.3),
        hjust = 0,
        vjust = 1,
        colour = title_colour,
        face = "bold",
        margin = ggplot2::margin(b = half_line)
      ),
      plot.subtitle = ggplot2::element_text(
        colour = dark_colour,
        hjust = 0,
        vjust = 1,
        margin = ggplot2::margin(t = 0,
                        r = 0,
                        b = base_size * .75,
                        l = 0,
                        unit = "pt")
      ),
      plot.caption = ggplot2::element_text(
        family = base_family,
        size = ggplot2::rel(0.555),
        hjust = 1,
        vjust = 1,
        colour = dark_colour,
        face = "italic",
        margin = ggplot2::margin(t = 15)
      ),
      plot.tag = ggplot2::element_text(
        size = ggplot2::rel(1.2),
        hjust = 0.5,
        vjust = 0.5
      ),
      plot.tag.position = "topleft",
      # plot margin: top, right, bottom, left
      plot.margin = ggplot2::unit(c(0.5, 0, 0.1, 0), "lines"),
      complete = TRUE
    )

  # add panel borders if the user requests them
  if (panel_borders == "border") {
    ret <- ret %+replace%
      ggplot2::theme(panel.border = ggplot2::element_rect(
        linetype = 1,
        size = points_to_mm(2),
        colour = dark_colour,
        fill = NA
      ))
  } else if (panel_borders %in% c("axis", "axes")) {
    ret <- ret %+replace%
      ggplot2::theme(
        axis.line = ggplot2::element_line(
          size = points_to_mm(1),
          colour = dark_colour
      ))
  }

  if (include_minor_gridlines %in% c("x", "both")) {
    ret <- ret %+replace%
      ggplot2::theme(
        panel.grid.minor.x = ggplot2::element_line(colour = light_colour)
      )
  }

  if (include_minor_gridlines %in% c("y", "both")) {
    ret <- ret %+replace%
      ggplot2::theme(
        panel.grid.minor.y = ggplot2::element_line(colour = light_colour)
      )
  }


  if (background == "orange" |  background == "box") {
    ret <- ret +
      ggplot2::theme(rect = ggplot2::element_rect(
        fill = background))

  }

  ret

}
