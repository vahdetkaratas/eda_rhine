# Load necessary libraries
library(data.table)
library(ggplot2)
library(dplyr)
library(lubridate)

# Set working directory
try(setwd("C:/Users/KARA/Documents/eda_rhine"), silent = TRUE)

# Create output directory if it doesn't exist
dir.create("results/assignments/a5", recursive = TRUE, showWarnings = FALSE)

# Load runoff data
runoff_data <- readRDS("data/runoff_day.rds")
runoff_dt <- as.data.table(runoff_data)

# Rename sname to station for consistency
setnames(runoff_dt, "sname", "station")

# Create custom theme for better readability
custom_theme <- theme_bw() +
  theme(
    plot.background = element_rect(fill = "white"),
    panel.background = element_rect(fill = "white"),
    axis.text = element_text(color = "black", size = 10),
    axis.title = element_text(color = "black", size = 12),
    plot.title = element_text(color = "black", size = 14, hjust = 0.5),
    plot.subtitle = element_text(color = "black", size = 10, hjust = 0.5),
    panel.grid.major = element_line(color = "grey80"),
    panel.grid.minor = element_line(color = "grey90"),
    legend.background = element_rect(fill = "white"),
    legend.text = element_text(color = "black"),
    strip.background = element_rect(fill = "white"),
    strip.text = element_text(color = "black", size = 12)
  )

# Filter for selected stations
selected_stations <- c("DOMA", "BASR", "KOEL")
selected_data <- runoff_dt[station %in% selected_stations]

# Add year and month columns
selected_data[, `:=`(
  year = year(date),
  month = month(date),
  month_name = factor(month(date), levels = 1:12, labels = month.abb),
  season = factor(ifelse(month(date) %in% c(6,7,8), "Summer", 
                 ifelse(month(date) %in% c(12,1,2), "Winter", "Other")))
)]

# Calculate comprehensive statistics
stats_summary <- selected_data[, .(
  mean_value = mean(value, na.rm = TRUE),
  median_value = median(value, na.rm = TRUE),
  sd_value = sd(value, na.rm = TRUE),
  cv = sd(value, na.rm = TRUE) / mean(value, na.rm = TRUE),
  q10 = quantile(value, 0.1, na.rm = TRUE),
  q90 = quantile(value, 0.9, na.rm = TRUE),
  mean_high = mean(value[value > quantile(value, 0.9, na.rm = TRUE)], na.rm = TRUE),
  mean_low = mean(value[value < quantile(value, 0.1, na.rm = TRUE)], na.rm = TRUE),
  high_days = sum(value > quantile(value, 0.9, na.rm = TRUE), na.rm = TRUE),
  low_days = sum(value < quantile(value, 0.1, na.rm = TRUE), na.rm = TRUE)
), by = .(station)]

# Calculate seasonal statistics
seasonal_stats <- selected_data[season != "Other", .(
  mean_value = mean(value, na.rm = TRUE),
  median_value = median(value, na.rm = TRUE),
  cv = sd(value, na.rm = TRUE) / mean(value, na.rm = TRUE)
), by = .(station, season)]

# Create annual boxplot
annual_boxplot <- ggplot(selected_data, aes(x = station, y = value, fill = station)) +
  geom_boxplot(alpha = 0.7, outlier.size = 1) +
  scale_fill_manual(values = c("DOMA" = "#69b3a2", "BASR" = "#E69F00", "KOEL" = "#56B4E9")) +
  labs(title = "Annual Runoff Distribution by Station",
       x = "Station",
       y = "Runoff (m³/s)") +
  custom_theme

# Save annual boxplot
ggsave("results/assignments/a5/annual_runoff_boxplot.png", 
       annual_boxplot, 
       width = 10, 
       height = 6,
       dpi = 300,
       bg = "white")

# Create monthly boxplot
monthly_boxplot <- ggplot(selected_data, aes(x = month_name, y = value, fill = station)) +
  geom_boxplot(alpha = 0.7, outlier.size = 1) +
  scale_fill_manual(values = c("DOMA" = "#69b3a2", "BASR" = "#E69F00", "KOEL" = "#56B4E9")) +
  facet_wrap(~station, scales = "free_y") +
  labs(title = "Monthly Runoff Distribution by Station",
       x = "Month",
       y = "Runoff (m³/s)") +
  custom_theme +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Save monthly boxplot
ggsave("results/assignments/a5/monthly_runoff_boxplot.png", 
       monthly_boxplot, 
       width = 12, 
       height = 8,
       dpi = 300,
       bg = "white")

# Function to calculate regression statistics
calc_regression_stats <- function(data, period_end) {
  model <- lm(value ~ year, data = data[year >= 1950 & year <= period_end])
  summary_stats <- summary(model)
  data.table(
    slope = coef(model)[2],
    r_squared = summary_stats$r.squared,
    p_value = summary_stats$coefficients[2,4]
  )
}

# Calculate regression statistics for both periods
regression_stats <- rbindlist(lapply(selected_stations, function(s) {
  station_data <- selected_data[station == s]
  stats_2016 <- calc_regression_stats(station_data, 2016)
  stats_2010 <- calc_regression_stats(station_data, 2010)
  data.table(
    station = s,
    slope_2016 = stats_2016$slope,
    r_squared_2016 = stats_2016$r_squared,
    p_value_2016 = stats_2016$p_value,
    slope_2010 = stats_2010$slope,
    r_squared_2010 = stats_2010$r_squared,
    p_value_2010 = stats_2010$p_value
  )
}))

# Create regression plots
create_regression_plot <- function(data, period_end) {
  ggplot(data[year >= 1950 & year <= period_end], aes(x = year, y = value)) +
    geom_point(alpha = 0.1, size = 1, color = "grey50") +
    geom_smooth(method = "loess", color = "#3366CC", se = TRUE, alpha = 0.2) +
    geom_smooth(method = "lm", color = "#CC3366", se = TRUE, alpha = 0.2) +
    facet_wrap(~station, scales = "free_y") +
    labs(title = paste("Runoff Trends 1950-", period_end),
         subtitle = "Blue: LOESS smoothing\nRed: Linear regression",
         x = "Year",
         y = "Runoff (m³/s)") +
    custom_theme
}

# Create and save regression plots
regression_2016 <- create_regression_plot(selected_data, 2016)
regression_2010 <- create_regression_plot(selected_data, 2010)

ggsave("results/assignments/a5/regression_2016.png", 
       regression_2016, 
       width = 15, 
       height = 8,
       dpi = 300,
       bg = "white")

ggsave("results/assignments/a5/regression_2010.png", 
       regression_2010, 
       width = 15, 
       height = 8,
       dpi = 300,
       bg = "white")

# Save statistics to file
sink("results/assignments/a5/analysis_results.txt")
cat("\nComprehensive Station Statistics:\n")
print(stats_summary)
cat("\nSeasonal Statistics:\n")
print(seasonal_stats)
cat("\nRegression Statistics:\n")
print(regression_stats)
sink()

cat("\nAnalysis completed. Results saved in results/assignments/a5/\n") 