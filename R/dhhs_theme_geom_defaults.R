#' @importFrom ggplot2 update_geom_defaults .pt

dhhs_theme_geom_defaults <- function(default_colour) {
  # Define defaults for individual geoms in a DHHS style consistent way

  # Note: looks as if update_geom_defaults() may be deprecated in a
  # future ggplot2
  # release (see https://github.com/tidyverse/ggplot2/pull/2749)
  #in favour of a new
  # way to update geom defaults; when this happens, replace the code below
  update_geom_defaults("point",
                       list(colour = default_colour,
                            size = 6 / .pt))
  update_geom_defaults("bar",
                       list(colour = "white",
                            fill = default_colour,
                            size = 0.75 / .pt))
  update_geom_defaults("col",
                       list(colour = "white",
                            fill = default_colour,
                            size = 0.75 / .pt))
  update_geom_defaults("line",
                       list(colour = default_colour,
                            size = 3 / .pt))
  update_geom_defaults("text",
                       list(colour = "black",
                            size = 18 / .pt))
  update_geom_defaults("smooth",
                       list(colour = default_colour,
                            fill = default_colour))

  update_geom_defaults("path",
                       list(colour = default_colour,
                            size = 3 / .pt))

  update_geom_defaults(ggrepel::GeomTextRepel,
                       list(size = 18 / .pt,
                            colour = "black"))

  update_geom_defaults(ggrepel::GeomLabelRepel,
                       list(size = 18 / .pt,
                            fill = "white",
                            colour = default_colour))

  update_geom_defaults("label",
                       list(size = 18 / .pt,
                            fill = "white",
                            colour = default_colour))

  update_geom_defaults("area",
                       list(fill = default_colour,
                            col = default_colour))

  update_geom_defaults("density",
                       list(fill = default_colour,
                            col = default_colour))

  update_geom_defaults("dotplot",
                       list(fill = default_colour,
                            col = default_colour))

  update_geom_defaults("polygon",
                       list(fill = default_colour,
                            col = default_colour))

  update_geom_defaults("path",
                       list(col = default_colour))

  update_geom_defaults("ribbon",
                       list(fill = default_colour,
                            col = default_colour))

  update_geom_defaults("rect",
                       list(fill = default_colour,
                            col = default_colour))

  update_geom_defaults("boxplot",
                       list(fill = default_colour,
                            col = default_colour))

  update_geom_defaults("crossbar",
                       list(fill = default_colour,
                            col = default_colour))

  update_geom_defaults("errorbar",
                       list(col = default_colour))

  update_geom_defaults("linerange",
                       list(col = default_colour))

  update_geom_defaults("pointrange",
                       list(col = default_colour))

  update_geom_defaults("tile",
                       list(col = "white",
                            fill = default_colour))
}
