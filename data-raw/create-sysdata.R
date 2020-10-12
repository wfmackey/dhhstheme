library(devtools)
library(dplyr)

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


use_data(all_chart_types,
         internal = FALSE,
         overwrite = TRUE)
