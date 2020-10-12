#' Save a ggplot2 chart as a properly-formatted "chart data" Excel spreadsheet
#'
#' This function takes a ggplot2 object and creates a single-sheet Excel workbook
#' with the chart data and chart. If your ggplot2 object has a subtitle and
#' caption, those will be properly displayed in the spreadsheet.
#'
#' @name save_chartdata
#'
#' @param filename filename of the Excel workbook you wish to create. Can be a
#' file path, but the directory must already exist.
#' @param object ggplot2 chart to create chart data from. If left blank,
#' \code{ggplot2::last_plot()} is used to get the last plot displayed.
#' @param type type of plot. Default is "normal". See \code{?dhhs_save} for
#' full list of types.
#' @param export_vars Which variables to export data for. Defaults to "used",
#' which will only export variables used in the plot. Input "all" to include all
#' variables in the data. Otherwise provide a character vector of variable names.
#'
#' @param add_vars A character vector of variables to include \textit{as well as}
#' the variables in \code{export_vars}.
#'
#' @export
#' @importFrom openxlsx createWorkbook addWorksheet writeData insertImage
#' @importFrom openxlsx createStyle addStyle setColWidths saveWorkbook
#' @importFrom ggplot2 last_plot
#'
#' @examples
#'
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
#'      geom_point() +
#'      theme_dhhs() +
#'      labs(title = "Title",
#'           subtitle = "Subtitle",
#'           caption = "Caption")
#'
#' \dontrun{save_chartdata("my_chartdata.xlsx", p)}
#'

save_chartdata <- function(filename,
                           object = ggplot2::last_plot(),
                           type = "whole",
                           export_vars = "used",
                           add_vars = NULL) {

  if (tools::file_ext(filename) != "xlsx") {
    stop(filename, " is not a valid filename; filename must end in .xlsx")
  }

  # check inputs
  if (!inherits(object, "ggplot")) {
    stop("`object` is not a ggplot2 object")
  }

  obj_name <- deparse(substitute(object))

  if (obj_name == "ggplot2::last_plot()") {
    obj_name <- "plot"
  }



  # Expand height of graph if not set manually & labels are present
  labels_present <- ifelse(!is.null(object$labels$caption) |
                           !is.null(object$labels$title) |
                           !is.null(object$labels$subtitle),
                           TRUE,
                           FALSE)

  # Save graph
  temp_image_location <- file.path(tempdir(), "chart_data_image.png")

  dhhs_save(temp_image_location,
            object,
            "whole",
            mute_messages = TRUE)

  # Get chart data
  chart_data <- object$data

  if (export_vars != "all") {

    # Only keep variables used in the plot
    if (export_vars == "used") {
      vars_used <- as.character(object$mapping)
      vars_used <- gsub("~", "", vars_used)
    }

    if (!is.null(add_vars)) {
      vars_used <- c(vars_used, add_vars)
    }

    chart_data <- dplyr::select(chart_data, dplyr::all_of(vars_used))

  }

  # To ensure that dates are correctly-formatted, save as strings
  for (col in seq_along(chart_data)) {
    if (inherits(chart_data[[col]], "Date")) {
      chart_data[[col]] <- as.character(chart_data[[col]])
    }
  }

  names(chart_data) <- tools::toTitleCase(names(chart_data))

  data_columns <- ncol(chart_data)
  data_rows <- nrow(chart_data)

  # Create workbook and add content
  wb <- openxlsx::createWorkbook()

  openxlsx::addWorksheet(wb,
                         sheetName = obj_name,
                         gridLines = FALSE)

  plot_subtitle <- object$labels$subtitle
  plot_caption <- object$labels$caption
  # Remove everything before "Source:" in caption
  plot_caption <- gsub(".+?(?=Source:)", "", plot_caption, perl = TRUE)

  openxlsx::writeData(wb = wb,
                      sheet = 1,
                      x = plot_subtitle,
                      startCol = 2,
                      startRow = 1)

  openxlsx::writeData(wb = wb,
                      sheet = 1,
                      x = plot_caption,
                      startCol = 2,
                      startRow = 5 + data_rows)


  openxlsx::writeData(wb,
                      sheet = 1,
                      x = chart_data,
                      startCol = 2,
                      startRow = 3)

  openxlsx::insertImage(wb = wb,
                        sheet = 1,
                        startRow = 3,
                        startCol = data_columns + 3,
                        file = temp_image_location,
                        width = dhhstheme::all_chart_types$width_cm[dhhstheme::all_chart_types$type == type],
                        height = dhhstheme::all_chart_types$height_cm[dhhstheme::all_chart_types$type == type],
                        units = "cm",
                        dpi = 320)


  # Change font of entire sheet
  dhhs_font_style <- openxlsx::createStyle(fontName = "Arial",
                                           fontSize = 11,
                                           halign = "center",
                                           fontColour = "#000000")

  openxlsx::addStyle(wb, 1, dhhs_font_style, cols = 1:100, rows = 1:2000,
           gridExpand = TRUE)

  # Bold title

  dhhs_title_style <- openxlsx::createStyle(textDecoration = "bold",
                                            halign = "left",
                                            fontSize = 12)

  openxlsx::addStyle(wb, 1, dhhs_title_style, cols = 2, rows = 1, stack = TRUE)

  # Orange fill for table

  dhhs_table_style <- openxlsx::createStyle(fgFill = dhhstheme::dhhs_blue4,
                                               bgFill = dhhstheme::dhhs_blue4,
                                               wrapText = TRUE)

  openxlsx::addStyle(wb, 1,
           dhhs_table_style,
           cols = 2:(data_columns + 1),
           rows = 3:(data_rows + 3),
           stack = TRUE,
           gridExpand = TRUE)

  # Italicise caption

  dhhs_caption_style <- openxlsx::createStyle(textDecoration = c("italic",
                                                                 "underline"),
                                              halign = "left")

  openxlsx::addStyle(wb,
           1,
           dhhs_caption_style,
           rows = 5 + data_rows,
           cols = 2,
           stack = TRUE)

  # Bold header

  dhhs_heading_style <- openxlsx::createStyle(textDecoration = "bold")

  openxlsx::addStyle(wb,
           1,
           dhhs_heading_style,
           rows = 3,
           cols = 2:(data_columns + 1),
           stack = TRUE)

  # Add borders

  dhhs_border <- function(border,
                             border_colour = dhhstheme::dhhs_blue,
                             border_style = "thick") {

    openxlsx::createStyle(border = border,
                          borderColour = border_colour,
                          borderStyle = border_style)
  }


  openxlsx::addStyle(wb, 1,
                     dhhs_border("left"),
                     rows = 3:(data_rows + 3),
                     cols = 2,
                     stack = TRUE)

  openxlsx::addStyle(wb, 1,
                     dhhs_border("right"),
                     rows = 3:(data_rows + 3),
                     cols = data_columns + 1,
                     stack = TRUE)
  openxlsx::addStyle(wb, 1,
                     dhhs_border("top"),
                     rows = 3,
                     cols = 2:(data_columns + 1),
                     stack = TRUE)

  openxlsx::addStyle(wb, 1,
                     dhhs_border("bottom"),
                     rows = data_rows + 3,
                     cols = 2:(data_columns + 1),
                     stack = TRUE)

  # Resize first column

  openxlsx::setColWidths(wb, 1,
                         cols = 1,
                         widths = 0.45)

  # Save workbook ----
  # Use minimal compression, for speed
  # Only way to modify openxlsx compression level seems to be through an option
  user_option <- getOption("openxlsx.compressionlevel")
  options("openxlsx.compressionlevel" = 1)

  tempfile <- wb$saveWorkbook()

  file.copy(from = tempfile, to = filename, overwrite = TRUE)

  unlink(tempfile)
  unlink(temp_image_location)

  # Restore previous value for compression level
  options("openxlsx.compressionlevel" = user_option)

}

