context("dhhs_theme runs")
library(testthat)
library(ggplot2)
# library(dhhstheme)

base_p <- ggplot(mtcars,
         aes(hp, wt)) +
  geom_point(aes(colour = factor(gear)),
             size = 6) +
  labs(title = "This is the title of the plot",
       subtitle = "y-axis title",
       y = NULL,
       x = "x-axis title")


test_that("no error",
 expect_error(base_p + theme_dhhs(), NA)
)


