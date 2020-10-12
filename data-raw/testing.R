devtools::load_all()
library(tidyverse)

mtcars %>%
  ggplot(aes(hp, wt)) +
  geom_point(aes(colour = factor(gear)),
             size = 6) +
  theme_dhhs(background = "transparent",
             panel_borders = FALSE) +
  dhhs_colour_manual(5) +
  labs(title = "This is the title of the plot",
       subtitle = "y-axis title",
       y = NULL,
       x = "x-axis title")




mtcars %>%
  ggplot(aes(hp, wt)) +
  geom_point(aes(colour = gear),
             size = 6) +
  theme_dhhs(background = "transparent",
             legend = "right") +
  dhhs_colour_manual(discrete = FALSE) +
  labs(title = "This is the title of the plot",
       subtitle = "y-axis title",
       y = NULL,
       x = "x-axis title")

