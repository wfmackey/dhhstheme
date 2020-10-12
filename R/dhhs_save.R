#' A function to export ggplot2 objects in consistent DHHS style
#' @name dhhs_save
#' @param file_path Save to path, including a type suffix (e.g. ".png" or ".pdf").
#' @param plot_object ggplot2 object to plot. Defaults to
#' @param type Sets height and width to DHHS defaults. If more than one is
#' provided, a folder containing the plots will be created. "all" will export all.
#' The following chart types are available:
#' \itemize{
#' \item{"whole"}{ The default. Use for a plot covering the whole body of a
#' normal DHHS slide. Width: 32.74cm, height: 18.9cm.}
#' \item{"half"}{Use for a tall plot covering the full left or right side a normal DHHS slide.
#' Width: 15.65cm, height: 18.9cm.}
#' \item{"third"}{ The default. Use for a tall plot covering roughly one-third of the horizontal space on a normal DHHS slide.
#' Width: 10cm, height: 18.9cm.}
#' \item{"short-whole"}{ The default. Use for a short plot covering half the body of a
#' normal DHHS slide. Width: 32.74cm, height: 9.5cm.}
#' \item{"short-half"}{Use for a short plot covering half of the left or right side of a normal DHHS slide.
#' Width: 15.65cm, height: 9.5cm.}
#' \item{"short-third"}{ The default. Use for a short plot covering roughly one-third of the horizontal space on a normal DHHS slide.
#' Width: 10cm, height: 9.5cm.}
#' }
#' Set type = "all" to save your chart in all available sizes.
#' @param drop_labs Drops title, subtitle and caption. FALSE by default. Useful if you want to write your own in your export destination.
#' @param ... Other arguments passed to ggsave
#'
#' @importFrom dplyr
#' @export

dhhs_save <- function(file_path,
                      plot_object = ggplot2::last_plot(),
                      type = "whole",
                      drop_labs = FALSE) {

  chart_dir <- dirname(file_path)
  chart_name <- gsub("\\..*", "", basename(file_path))
  chart_ext <- gsub(chart_name, "", basename(file_path))

  inch_constant <- 0.393701

  all_chart_types <- tidyr::tribble(
    ~type, ~height_cm, ~width_cm,
    "whole", 18.9, 32.74,
    "half", 18.9, 15.65,
    "third", 18.9, 10,
    "short", 9.5,  32.74,
    "short-half", 9.5, 15.65,
    "short-third", 9.5, 10,
  )

  all_chart_types <- dplyr::mutate(all_chart_types,
      height = height_cm * inch_constant,
      width = width_cm * inch_constant)

  if (type == "all") {
    message("Saving all types in ", file.path(chart_dir, chart_name))
    chart_types <- all_chart_types
  } else {
    chart_types <- all_chart_types[all_chart_types$type %in% type, ]
  }

  if (nrow(chart_types) == 1) {
    chart_types <- dplyr::mutate(chart_types, path = file_path)
  } else {

    # create folder
    dir.create(file.path(chart_dir, chart_name),
               recursive = FALSE,
               showWarnings = FALSE)
    # update directory
    chart_dir <- file.path(chart_dir, chart_name)

    # add multiple paths
    chart_types <- dplyr::mutate(chart_types,
        path = file.path(chart_dir,
                         paste0(chart_name, "-", type, chart_ext)))
  }


  if (isTRUE(drop_labs)) {

    message("Removing title, subtitle and caption because drop_labs = TRUE")

    plot_object <- plot_object +
      ggplot2::theme(
        plot.title = ggplot2::element_blank(),
        plot.subtitle = ggplot2::element_blank(),
        plot.caption = ggplot2::element_blank())
  }


  # Export
  purrr::pwalk(
    list(chart_types$path,
         chart_types$height,
         chart_types$width),
    dhhs_save_one
  )

}

dhhs_save_one <- function(path, height, width, .plot_object = plot_object) {

  message("\t- saving ", path)

  ggplot2::ggsave(filename = path,
                  plot = .plot_object,
                  height = height,
                  width = width
  )
}