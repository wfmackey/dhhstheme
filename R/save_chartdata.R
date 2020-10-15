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
#' @param add_vars A character vector of variables to include as well as
#' the variables in \code{export_vars}.
#'
#'@param cover_page 'TRUE' by default. If exporting multiple charts, this adds a cover page with the DHHS logo and title (if specified, see \code{cover_title}).
#'@param cover_title Set the title for the cover page if exporting multiple charts.
#'@param cover_date If 'TRUE', print the export date. If a date is provided, that date will be printed. If 'FALSE', no date will be printed.
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
                           add_vars = NULL,
                           cover_page = TRUE,
                           cover_title = NULL,
                           cover_date = TRUE) {

  if (tools::file_ext(filename) != "xlsx") {
    stop(filename, " is not a valid filename; filename must end in .xlsx")
  }

  # Get type of `object`:
  if (inherits(object, "ggplot")) {
    object_type <- "isplot"
  } else if (is.list(object)) {
    object_type <- "islist"

      if (!all(purrr::map_lgl(object, inherits, what = "ggplot"))) {
        warning("Not all of the objects in this list are ggplot objects, so expect an error down the line")
      }

  } else {
    stop("`object` is not a ggplot object nor a list of ggplot objects")
  }


  # Create workbook and add content
  wb <- openxlsx::createWorkbook()

  # If multiple plots, add a cover page
  if (object_type == "islist") {
    openxlsx::addWorksheet(wb,
                           sheetName = "Cover",
                           gridLines = FALSE)

    openxlsx::insertImage(wb = wb,
                          sheet = 1,
                          startRow = 1,
                          startCol = 1,
                          file = file.path("data-raw", "dhhs-logo.png"),
                          width = 20,
                          height = 8,
                          units = "cm",
                          dpi = 320)

    if (cover_date != FALSE) {

      print_date <- ifelse(cover_date == TRUE, Sys.Date(), cover_date)

      openxlsx::writeData(wb = wb,
                          sheet = 1,
                          x = paste("This file was created on", print_date),
                          startCol = 1,
                          startRow = 19)
    }

    if (!is.null(cover_title)) {
    openxlsx::writeData(wb = wb,
                        sheet = 1,
                        x = cover_title,
                        startCol = 1,
                        startRow = 17)
    }



  }

  # For each object provided, create a sheet
  add_sheet <- function(object, sheet_num = 1, name = NULL) {

    # check inputs
    if (!inherits(object, "ggplot")) {
      stop("`object` is not a ggplot2 object")
    }

    if (!is.null(name)) {
      if (name == "") {
        obj_name <- sheet_num
      } else {
        obj_name <- name
      }
    } else if (is.null(name)) {
      obj_name <- sheet_num
    }

    # Expand height of graph if not set manually & labels are present
    labels_present <- ifelse(!is.null(object$labels$caption) |
                             !is.null(object$labels$title) |
                             !is.null(object$labels$subtitle),
                             TRUE,
                             FALSE)

    # Save graph
    temp_image_location <- file.path(tempdir(),
                                     paste0("chart_data_image", sheet_num, ".png"))

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
        vars_used <- c(vars_used, names(object$facet$params$facets))
        vars_used <- gsub("~", "", vars_used)
        # strip common in-aes adjustments
        vars_used <- gsub(".*\\((.*)\\)", "\\1", vars_used) # "factor(x)", etc
        vars_used <- gsub(".*\\((.*),.*\\)", "\\1", vars_used) # "reorder(x, y)"

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


    openxlsx::addWorksheet(wb,
                           sheetName = obj_name,
                           gridLines = FALSE)

    plot_subtitle <- object$labels$subtitle
    plot_caption <- object$labels$caption
    # Remove everything before "Source:" in caption
    plot_caption <- gsub(".+?(?=Source:)", "", plot_caption, perl = TRUE)

    openxlsx::writeData(wb = wb,
                        sheet = sheet_num,
                        x = plot_subtitle,
                        startCol = 2,
                        startRow = 1)

    openxlsx::writeData(wb = wb,
                        sheet = sheet_num,
                        x = plot_caption,
                        startCol = 2,
                        startRow = 5 + data_rows)


    openxlsx::writeData(wb,
                        sheet = sheet_num,
                        x = chart_data,
                        startCol = 2,
                        startRow = 3)

    openxlsx::insertImage(wb = wb,
                          sheet = sheet_num,
                          startRow = 3,
                          startCol = data_columns + 3,
                          file = temp_image_location,
                          width = all_chart_types$width_cm[all_chart_types$export_type == type][1],
                          height = all_chart_types$height_cm[all_chart_types$export_type == type][1],
                          units = "cm",
                          dpi = 320)


    # Change font of entire sheet
    dhhs_font_style <- openxlsx::createStyle(fontName = "Arial",
                                             fontSize = 11,
                                             halign = "right",
                                             fontColour = "#000000")

    openxlsx::addStyle(wb, sheet_num, dhhs_font_style, cols = 1:100, rows = 1:2000,
             gridExpand = TRUE)

    # Bold title

    dhhs_title_style <- openxlsx::createStyle(textDecoration = "bold",
                                              halign = "left",
                                              fontSize = 12)

    openxlsx::addStyle(wb, sheet_num, dhhs_title_style, cols = 2, rows = 1, stack = TRUE)

    # Orange fill for table

    dhhs_table_style <- openxlsx::createStyle(fgFill = dhhstheme::dhhs_navy1,
                                                 bgFill = dhhstheme::dhhs_navy1,
                                                 wrapText = TRUE)

    openxlsx::addStyle(wb, sheet_num,
             dhhs_table_style,
             cols = 2:(data_columns + 1),
             rows = 3:(data_rows + 3),
             stack = TRUE,
             gridExpand = TRUE)

    # Italicise caption

    dhhs_caption_style <- openxlsx::createStyle(textDecoration = c("italic",
                                                                   "underline"),
                                                halign = "left")

    openxlsx::addStyle(wb, sheet_num,
             dhhs_caption_style,
             rows = 5 + data_rows,
             cols = 2,
             stack = TRUE)

    # Bold header

    dhhs_heading_style <- openxlsx::createStyle(textDecoration = "bold")

    openxlsx::addStyle(wb, sheet_num,
             dhhs_heading_style,
             rows = 3,
             cols = 2:(data_columns + 1),
             stack = TRUE)

    # Add borders

    dhhs_border <- function(border,
                               border_colour = dhhstheme::dhhs_navy,
                               border_style = "thick") {

      openxlsx::createStyle(border = border,
                            borderColour = border_colour,
                            borderStyle = border_style)
    }


    openxlsx::addStyle(wb, sheet_num,
                       dhhs_border("left"),
                       rows = 3:(data_rows + 3),
                       cols = 2,
                       stack = TRUE)

    openxlsx::addStyle(wb, sheet_num,
                       dhhs_border("right"),
                       rows = 3:(data_rows + 3),
                       cols = data_columns + 1,
                       stack = TRUE)
    openxlsx::addStyle(wb, sheet_num,
                       dhhs_border("top"),
                       rows = 3,
                       cols = 2:(data_columns + 1),
                       stack = TRUE)

    openxlsx::addStyle(wb, sheet_num,
                       dhhs_border("bottom"),
                       rows = data_rows + 3,
                       cols = 2:(data_columns + 1),
                       stack = TRUE)

    # Resize first column
    openxlsx::setColWidths(wb, sheet_num,
                           cols = 1,
                           widths = 0.45)

    # Resize data columns
    openxlsx::setColWidths(wb, sheet_num,
                           cols = 2:(data_columns + 1),
                           widths = 15)

  }

  # # If a single ggplot object:
  if (inherits(object, "ggplot")) {

    add_sheet(object)

  } else if (is.list(object) & is.null(names(object))) {

    purrr::walk2(object, 2:(length(object)+1), add_sheet)

  } else if (is.list(object) & !is.null(names(object))) {

    purrr::pwalk(
      list(object,
           2:(length(object)+1),
           names(object)),
      add_sheet)

  }

  # Save workbook ----
  # Use minimal compression, for speed
  user_option <- getOption("openxlsx.compressionlevel")
  options("openxlsx.compressionlevel" = 1)

  openxlsx::saveWorkbook(wb, file = filename, overwrite = TRUE)

  # Restore previous value for compression level
  options("openxlsx.compressionlevel" = user_option)

}
