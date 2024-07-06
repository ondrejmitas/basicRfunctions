## correlogram

library(corrgram)

dat_subset <- dat[c("myvariable1", "myvariable2",…)]

# basic
corrgram(dat_subset, lower.panel=panel.conf, upper.panel=panel.pie,
         diag.panel=panel.hist, text.panel=panel.txt)



# Fully customized panel function with bold text for significant correlations
custom_panel_conf <- function(x, y, cex = 2, ...) {
  # Check for sufficient non-missing data
  valid_data <- complete.cases(x, y)
  if (sum(valid_data) < 2) {  # Ensure there are at least two points to calculate a correlation
    text(0.5, 0.5, "Insufficient data", cex = cex, col = "red")
    return()
  }
  
  # Proceed with calculations using non-missing data
  x <- x[valid_data]
  y <- y[valid_data]
  cor_xy <- cor(x, y)
  
  # Calculate confidence interval
  stderr <- sqrt((1 - cor_xy^2) / (length(x) - 2))
  ci_lower <- cor_xy - 1.96 * stderr
  ci_upper <- cor_xy + 1.96 * stderr
  
  # Set up the plotting area
  usr <- par("usr")
  on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  
  # Determine if text should be bold
  text_font <- if (ci_lower > 0 || ci_upper < 0) 2 else 1
  
  # Draw the correlation coefficient and confidence interval
  text(0.5, 0.75, labels = sprintf("%.2f", cor_xy), cex = cex, font = text_font)
  text(0.5, 0.25, labels = sprintf("[%.2f, %.2f]", ci_lower, ci_upper), cex = cex, font = text_font)
  
  # Draw circles based on correlation strength
  if (!is.na(cor_xy)) {
    radius <- abs(cor_xy) / 2
    symbols(0.5, 0.5, circles = radius, inches = 0.5, add = TRUE, fg = if(cor_xy > 0) "blue" else "red")
  }
}



# better version
corrgram(behavior_sust, lower.panel=custom_panel_conf, upper.panel=panel.pie,
         diag.panel=panel.hist, text.panel=panel.txt, cex.labels = 1.5)
