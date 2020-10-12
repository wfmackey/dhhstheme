
# DHHS palette -----------------------------------------------------------------
# Sourced from DHHS 'Visual style guide for staff preparing Word documents and PowerPoint presentations'

library(tidyverse)

dhhs_palette <- tribble(
  ~name, ~r, ~g, ~b,
  "Navy", 32, 21, 71,
  "Purple", 135, 24, 157,
  "Blue", 0, 78, 168,
  "Green", 0, 123, 75,
  "Orange", 197, 81, 26,
  "Pink", 213, 0, 50,
  "Navy1", 222, 220, 227,
  "Navy2", 199, 197, 209,
  "Navy3", 177, 173, 191,
  "Navy4", 155, 150, 172,
  "Purple1", 241, 227, 243,
  "Purple2", 231, 209, 235,
  "Purple3", 219, 186, 226,
  "Purple4", 207, 163, 216,
  "Blue1", 224, 234, 245,
  "Blue2", 204, 220, 238,
  "Blue3", 179, 202, 229,
  "Blue4", 153, 184, 220,
  "Green1", 224, 239, 233,
  "Green2", 204, 229, 219,
  "Green3", 179, 215, 201,
  "Green4", 153, 202, 183,
  "Orange1", 248, 234, 228,
  "Orange2", 243, 220, 209,
  "Orange3", 238, 203, 186,
  "Orange4", 232, 185, 163,
  "Pink1", 250, 224, 230,
  "Pink2", 247, 204, 214,
  "Pink3", 242, 179, 194,
  "Pink4", 238, 153, 173,
  "Greyscale1", 221, 221, 222,
  "Greyscale2", 203, 204, 206,
  "Greyscale3", 186, 187, 189,
  "Greyscale4", 169, 171, 173,
  "Greyscale", 83, 86, 90) %>%
  mutate(hex = rgb(r, g, b, maxColorValue = 255)) %>%
  bind_rows(tribble(
    ~name, ~hex,
    "Teal", "#00A3B6",
    "Teal1", "#E5F5F7",
    "Teal2", "#CCECF0",
    "Teal3", "#99DAE1",
    "Teal4", "#66C8D3"
  ))


export_dhhs_palette <- function(.name) {
  d <- dhhs_palette %>%
    filter(name == .name)

  h <- d$hex
  n <- tolower(d$name) %>% paste0("dhhs_", .)
  assign(n, h, envir = .GlobalEnv)
}

purrr::walk(dhhs_palette$name, export_dhhs_palette)

save(dhhs_teal, file = "data/dhhs_teal.rda")
save(dhhs_navy, file = "data/dhhs_navy.rda")
save(dhhs_purple, file = "data/dhhs_purple.rda")
save(dhhs_blue, file = "data/dhhs_blue.rda")
save(dhhs_green, file = "data/dhhs_green.rda")
save(dhhs_orange, file = "data/dhhs_orange.rda")
save(dhhs_pink, file = "data/dhhs_pink.rda")
save(dhhs_greyscale, file = "data/dhhs_greyscale.rda")
save(dhhs_navy1, file = "data/dhhs_navy1.rda")
save(dhhs_navy2, file = "data/dhhs_navy2.rda")
save(dhhs_navy3, file = "data/dhhs_navy3.rda")
save(dhhs_navy4, file = "data/dhhs_navy4.rda")
save(dhhs_purple1, file = "data/dhhs_purple1.rda")
save(dhhs_purple2, file = "data/dhhs_purple2.rda")
save(dhhs_purple3, file = "data/dhhs_purple3.rda")
save(dhhs_purple4, file = "data/dhhs_purple4.rda")
save(dhhs_blue1, file = "data/dhhs_blue1.rda")
save(dhhs_blue2, file = "data/dhhs_blue2.rda")
save(dhhs_blue3, file = "data/dhhs_blue3.rda")
save(dhhs_blue4, file = "data/dhhs_blue4.rda")
save(dhhs_green1, file = "data/dhhs_green1.rda")
save(dhhs_green2, file = "data/dhhs_green2.rda")
save(dhhs_green3, file = "data/dhhs_green3.rda")
save(dhhs_green4, file = "data/dhhs_green4.rda")
save(dhhs_orange1, file = "data/dhhs_orange1.rda")
save(dhhs_orange2, file = "data/dhhs_orange2.rda")
save(dhhs_orange3, file = "data/dhhs_orange3.rda")
save(dhhs_orange4, file = "data/dhhs_orange4.rda")
save(dhhs_pink1, file = "data/dhhs_pink1.rda")
save(dhhs_pink2, file = "data/dhhs_pink2.rda")
save(dhhs_pink3, file = "data/dhhs_pink3.rda")
save(dhhs_pink4, file = "data/dhhs_pink4.rda")
save(dhhs_greyscale1, file = "data/dhhs_greyscale1.rda")
save(dhhs_greyscale2, file = "data/dhhs_greyscale2.rda")
save(dhhs_greyscale3, file = "data/dhhs_greyscale3.rda")
save(dhhs_greyscale4, file = "data/dhhs_greyscale4.rda")
save(dhhs_teal1, file = "data/dhhs_teal1.rda")
save(dhhs_teal2, file = "data/dhhs_teal2.rda")
save(dhhs_teal3, file = "data/dhhs_teal3.rda")
save(dhhs_teal4, file = "data/dhhs_teal4.rda")
