# Create DHHS palette sets

# Assume more/higher is better; and better is yellow (can be reversed with reverse = TRUE)

dhhs_palette_set <- list(
  `teal`  = c(dhhs_teal1,
              dhhs_teal2,
              dhhs_teal3,
              dhhs_teal4,
              dhhs_teal),

  `blue`  = c(dhhs_blue1,
              dhhs_blue2,
              dhhs_blue3,
              dhhs_blue4,
              dhhs_blue),

  `pink`  = c(dhhs_pink1,
              dhhs_pink2,
              dhhs_pink3,
              dhhs_pink4,
              dhhs_pink),


  `green`  = c(dhhs_green1,
              dhhs_green2,
              dhhs_green3,
              dhhs_green4,
              dhhs_green),


  `navy`  = c(dhhs_navy1,
              dhhs_navy2,
              dhhs_navy3,
              dhhs_navy4,
              dhhs_navy),


  `purple`  = c(dhhs_purple1,
              dhhs_purple2,
              dhhs_purple3,
              dhhs_purple4,
              dhhs_purple),


  `orange`  = c(dhhs_orange1,
              dhhs_orange2,
              dhhs_orange3,
              dhhs_orange4,
              dhhs_orange),

  `diverging` = c(dhhs_pink, dhhs_pink2,
                  "white",
                  dhhs_teal2, dhhs_teal),

  `diverging2` = c(dhhs_pink, dhhs_pink2,
                  "white",
                  dhhs_navy2, dhhs_navy),

  `grey`  = c(dhhs_greyscale1,
              dhhs_greyscale2,
              dhhs_greyscale3,
              dhhs_greyscale4,
              dhhs_greyscale)
)


save(dhhs_palette_set, file = "data/dhhs_palette_set.rda")
