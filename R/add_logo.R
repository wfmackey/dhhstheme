#' Assemble a chart featuring the Grattan logo and navy line
#'
#' Takes a ggplot2 object and formats it as a presentable slide with DHHS logo.
#'
#' @param plot A ggplot2 plot
#' @param type Optional. See \code{?dhhs_save} for available types.
#' @param ppt_size Optional. See \code{?dhhs_save} for available types.
#'
#' @return An object of class "patchwork".
#'
#' @examples
#'
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
#'     geom_point() +
#'     labs(title = "My title",
#'          subtitle = "My subtitle",
#'          caption = "My caption") +
#'     theme_dhhs()
#'
#' # Create an image that includes the Grattan logo
#'
#' p_logo <- add_dhhs_logo(p)
#'
#'
#' @export
#' @importFrom patchwork wrap_plots wrap_elements plot_spacer plot_annotation
#' @import grid

add_dhhs_logo <- function(plot = last_plot(),
                          type,
                          ppt_size = "large") {

  # Check inputs and define plot borders ----

  if (!inherits(plot, "ggplot")) {
    stop(deparse(substitute(plot)), " is not a ggplot2 object.")
  }

    top_border <- 0.15
    right_border <- 0.15
    bottom_border <- 0.05
    left_border = 0.15

  # Create title and subtitle -----
  p <- plot

  labs <- extract_labs(p)

  p <- replace_labs(p,
                    labs = list(title = NULL,
                                subtitle = NULL,
                                caption = labs$caption))


  stored_title <- labs$title
  stored_subtitle <- labs$subtitle

  title_font_size <- 18

  toptitle <- grid::grid.text(label = stored_title,
                              x = unit(0, "npc"),
                              y = unit(0.1, "npc"),
                              just = c("left", "bottom"),
                              draw = FALSE,
                              gp = grid::gpar(col = "black",
                                        fontsize = title_font_size,
                                        fontface = "bold",
                                        lineheight = 0.9,
                                        fontfamily = "sans"))

  topsubtitle <- grid::grid.text(label = stored_subtitle,
                                 x = unit(0, "npc"),
                                 y = unit(0.925, "npc"),
                                 draw = F,
                                 just = c("left", "top"),
                                 gp = grid::gpar(col = "black",
                                           fontsize = 18,
                                           lineheight = 0.9,
                                           fontfamily = "sans"))


  # Define additional grobs -----
  blank_grob <- grid::rectGrob(gp = grid::gpar(lwd = 0))

  navy_line <- grid::grid.lines(y = c(0.5, 0.5),
                            draw = FALSE,
                            gp = grid::gpar(col = dhhstheme::dhhs_navy, lwd = 1))

  navy_line_height <- 0.08

  logo_height <- 1.1
  logo_width <- 4
  logo_padding <- 0.1

  layout <- "
    T#L
    OOO
    SSS
    PPP
    "

  patchwork::wrap_plots(
    T = patchwork::wrap_elements(full = toptitle),
    L = patchwork::wrap_elements(full = logogrob),
    O = patchwork::wrap_elements(full = navy_line),
    S = patchwork::wrap_elements(full = topsubtitle),
    P = patchwork::wrap_elements(full = p),
    design = layout,
    heights = unit(c(logo_height,
                     0.001,
                     logo_height,
                     1),
                   c("cm",
                     "cm",
                     "cm",
                     "null")),
    widths = unit(c(1,
                    logo_padding,
                    logo_width),
                  c("null",
                    "cm",
                    "cm"))
  ) +
    patchwork::plot_annotation(
      theme = theme(plot.margin = margin(top_border,
                                         right_border,
                                         bottom_border,
                                         left_border,
                                         "cm"))
      )
}
