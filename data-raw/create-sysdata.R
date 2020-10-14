library(devtools)
library(dplyr)

inch_constant <- 0.393701
half_scale <- 15.65/32.74
third_scale <- 10/32.74
short_scale <- 9.5/18.9

all_chart_types <- tidyr::tribble(
  ~template, ~type, ~height_cm, ~width_cm,
  "large", "whole", 18.9, 32.74,
  "large", "half", 18.9, 32.74 * half_scale,
  "large", "third", 18.9, 32.74 * third_scale,
  "large", "short", 9.5,  32.74,
  "large", "short-half", 9.5, 32.74 * half_scale,
  "large", "short-third", 9.5, 32.74 * third_scale,

  "normal43", "whole", 13.49, 22.91,
  "normal43", "half", 13.49, 22.91 * half_scale,
  "normal43", "third", 13.49, 22.91 * third_scale,
  "normal43", "short", 13.49 * short_scale,  22.91,
  "normal43", "short-half", 13.49 * short_scale, 22.91 * half_scale,
  "normal43", "short-third", 13.49 * short_scale, 22.91 * third_scale,

  "normal169", "whole", 13.49, 26.5,
  "normal169", "half", 13.49, 26.5 * half_scale,
  "normal169", "third", 13.49, 26.5 * third_scale,
  "normal169", "short", 13.49 * short_scale,  26.5,
  "normal169", "short-half", 13.49 * short_scale, 26.5 * half_scale,
  "normal169", "short-third", 13.49 * short_scale, 26.5 * third_scale,
)

all_chart_types <- dplyr::mutate(all_chart_types,
                                 height = height_cm * inch_constant,
                                 width = width_cm * inch_constant)


use_data(all_chart_types,
         internal = TRUE,
         overwrite = TRUE)
