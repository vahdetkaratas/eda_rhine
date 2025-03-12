# Load necessary libraries
library(data.table)
library(ggplot2)
library(dplyr)
library(lubridate)

# Set working directory
try(setwd("C:/Users/KARA/Documents/eda_rhine"), silent = TRUE)

# Create output directory if it doesn't exist
dir.create("results/assignments/a5", recursive = TRUE, showWarnings = FALSE)

# Load precipitation data
precip_data <- readRDS("data/raw/precip_day.rds")
precip_dt <- as.data.table(precip_data)

# Load runoff data for comparison
runoff_data <- readRDS("data/runoff_day.rds")
runoff_dt <- as.data.table(runoff_data)

# Filter for selected stations
selected_stations <- c("DOMA", "BASR", "KOEL")
runoff_selected <- runoff_dt[sname %in% selected_stations]

# Add year and month columns to both datasets
precip_dt[, `:=`(
  year = year(date),
  month = month(date),
  month_name = factor(month(date), levels = 1:12, labels = month.abb),
  season = factor(ifelse(month(date) %in% c(6,7,8), "Summer", 
                 ifelse(month(date) %in% c(12,1,2), "Winter", "Other")))
)]

runoff_selected[, `:=`(
  year = year(date),
  month = month(date),
  month_name = factor(month(date), levels = 1:12, labels = month.abb),
  season = factor(ifelse(month(date) %in% c(6,7,8), "Summer", 
                 ifelse(month(date) %in% c(12,1,2), "Winter", "Other")))
)]

# Calculate monthly statistics
monthly_precip <- precip_dt[, .(
  mean_precip = mean(value, na.rm = TRUE),
  sd_precip = sd(value, na.rm = TRUE),
  cv_precip = sd(value, na.rm = TRUE) / mean(value, na.rm = TRUE)
), by = .(month_name, season)]

# Create custom theme
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

# Create seasonal precipitation boxplot
seasonal_precip_plot <- ggplot(precip_dt[season != "Other"], 
                              aes(x = season, y = value, fill = season)) +
  geom_boxplot(alpha = 0.7, outlier.size = 1) +
  scale_fill_manual(values = c("Summer" = "#E69F00", "Winter" = "#56B4E9")) +
  labs(title = "Seasonal Precipitation Distribution",
       x = "Season",
       y = "Precipitation (mm)") +
  custom_theme

# Save seasonal precipitation plot
ggsave("results/assignments/a5/seasonal_precip_boxplot.png", 
       seasonal_precip_plot, 
       width = 10, 
       height = 6,
       dpi = 300,
       bg = "white")

# Calculate trends for different periods
calc_trends <- function(data, start_year, end_year) {
  model <- lm(value ~ year, data = data[year >= start_year & year <= end_year])
  summary_stats <- summary(model)
  data.table(
    period = paste(start_year, end_year, sep = "-"),
    slope = coef(model)[2],
    r_squared = summary_stats$r.squared,
    p_value = summary_stats$coefficients[2,4]
  )
}

# Calculate trends for different periods
precip_trends <- rbindlist(list(
  calc_trends(precip_dt, 1950, 2016),
  calc_trends(precip_dt, 1950, 2010)
))

# Create precipitation-runoff comparison plot
monthly_data <- merge(
  # Monthly precipitation
  precip_dt[, .(precip = sum(value)), by = .(year, month)],
  # Monthly runoff by station
  runoff_selected[, .(runoff = mean(value)), by = .(sname, year, month)],
  by = c("year", "month")
)

# Calculate correlations for each station
correlations <- monthly_data[, .(
  correlation = cor(precip, runoff, use = "complete.obs"),
  correlation_lagged = cor(precip, shift(runoff, 1), use = "complete.obs")
), by = sname]

# Create precipitation-runoff scatter plot
precip_runoff_plot <- ggplot(monthly_data, aes(x = precip, y = runoff, color = sname)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE) +
  scale_color_manual(values = c("DOMA" = "#69b3a2", "BASR" = "#E69F00", "KOEL" = "#56B4E9")) +
  labs(title = "Precipitation-Runoff Relationship by Station",
       x = "Monthly Precipitation (mm)",
       y = "Monthly Runoff (m³/s)",
       color = "Station") +
  custom_theme

# Save precipitation-runoff plot
ggsave("results/assignments/a5/precip_runoff_relationship.png", 
       precip_runoff_plot, 
       width = 12, 
       height = 8,
       dpi = 300,
       bg = "white")

# Save statistics to file
sink("results/assignments/a5/precip_analysis_results.txt")
cat("\nMonthly Precipitation Statistics:\n")
print(monthly_precip)
cat("\n\nPrecipitation Trends:\n")
print(precip_trends)
cat("\n\nPrecipitation-Runoff Correlations by Station:\n")
print(correlations)

# Calculate seasonal statistics
seasonal_stats <- monthly_data[, .(
  mean_precip = mean(precip),
  mean_runoff = mean(runoff),
  precip_runoff_ratio = mean(precip)/mean(runoff)
), by = .(sname, season = factor(ifelse(month %in% c(6,7,8), "Summer", 
                                      ifelse(month %in% c(12,1,2), "Winter", "Other"))))]
seasonal_stats <- seasonal_stats[season != "Other"]

cat("\n\nSeasonal Precipitation-Runoff Relationships:\n")
print(seasonal_stats)
sink()

cat("\nPrecipitation analysis completed. Results saved in results/assignments/a5/\n") 