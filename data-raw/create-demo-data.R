# Create demo data for package

library(tidyverse)
library(lubridate)

owid_raw <- read_csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv")

export_countries <- c(
  "Australia",
  "Sweden",
  "Japan",
  "France",
  "South Korea",
  "United States"
)

owid_sample <- owid_raw %>%
  select(country = location, continent, date,
         new_cases, new_deaths, new_cases_per_million, new_deaths_per_million,
         total_cases, total_deaths, total_cases_per_million, total_deaths_per_million) %>%
  filter(country %in% export_countries) %>%
  mutate(start_of_month = mday(date) == 1 & date > "2020-03-01")

usethis::use_data(owid_sample,
                  internal = FALSE,
                  overwrite = TRUE,
                  compress = "xz")
