# Load necessary libraries
library(data.table)
library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)

# Set working directory (adjust the path to your local repository)
try(setwd("C:/Users/KARA/Documents/eda_rhine"), silent = TRUE)

# Create output directory if it doesn't exist
dir.create("results/assignments", showWarnings = FALSE, recursive = TRUE)

# Load the runoff_stats data
runoff_stats <- try(readRDS("data/runoff_stats.rds"), silent = TRUE)
if(inherits(runoff_stats, "try-error")) {
  cat("Error loading runoff_stats.rds. Please check the file path.\n")
  quit(status = 1)
}

# Load the runoff data for daily analysis
runoff_data <- try(readRDS("data/runoff_day.rds"), silent = TRUE)
if(inherits(runoff_data, "try-error")) {
  cat("Error loading runoff_day.rds. Please check the file path.\n")
  quit(status = 1)
}

# Convert to data.table
runoff_stats_dt <- as.data.table(runoff_stats)
runoff_data_dt <- as.data.table(runoff_data)

# Print column names for debugging
cat("Column names in runoff_stats:", paste(names(runoff_stats_dt), collapse = ", "), "\n")
cat("Column names in runoff_data:", paste(names(runoff_data_dt), collapse = ", "), "\n")

# Rename sname to station in both datasets for consistency
if("sname" %in% names(runoff_stats_dt)) setnames(runoff_stats_dt, "sname", "station")
if("sname" %in% names(runoff_data_dt)) setnames(runoff_data_dt, "sname", "station")

# Print the structure of the data
cat("Structure of runoff_stats_dt:\n")
print(str(runoff_stats_dt))

# Task 1: Transform runoff_stats to tidy format
runoff_stats_tidy <- melt(runoff_stats_dt, 
                         id.vars = "station", 
                         measure.vars = c("mean_day", "sd_day", "min_day", "max_day"),
                         variable.name = "statistic", 
                         value.name = "runoff")

# Clean up the statistic names by removing "_day" suffix
runoff_stats_tidy[, statistic := gsub("_day", "", statistic)]

# Print the first few rows of the tidy data
cat("\nFirst rows of tidy runoff_stats_tidy:\n")
print(head(runoff_stats_tidy))

# Create a scatterplot with different colors and point types for each statistic
plot1 <- ggplot(runoff_stats_tidy, aes(x = reorder(station, -runoff), y = runoff, color = statistic, shape = statistic)) +
  geom_point(size = 3) +
  scale_color_brewer(palette = "Set1") +
  labs(title = "Runoff Statistics by Station",
       x = "Station",
       y = "Runoff (m³/s)",
       color = "Statistic",
       shape = "Statistic") +
  theme_light() +
  theme(
    plot.background = element_rect(fill = "white"),
    panel.background = element_rect(fill = "white"),
    text = element_text(color = "black"),
    axis.text = element_text(color = "black"),
    axis.text.x = element_text(angle = 45, hjust = 1, color = "black"),
    panel.grid.major = element_line(color = "#E0E0E0", linewidth = 0.1),
    panel.grid.minor = element_line(color = "#F0F0F0", linewidth = 0.1)
  )

# Save the plot
ggsave("results/assignments/runoff_stats_scatterplot.png", plot1, width = 10, height = 6)
cat("Plot 1 created: runoff_stats_scatterplot.png\n")

# Task 2: Calculate skewness and coefficient of variation by station
# Function to calculate skewness
calculate_skewness <- function(x) {
  n <- length(x)
  m <- mean(x, na.rm = TRUE)
  s <- sd(x, na.rm = TRUE)
  sum((x - m)^3, na.rm = TRUE) / (n * s^3)
}

# Function to calculate coefficient of variation
calculate_cv <- function(x) {
  sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE) * 100
}

# Calculate statistics by station
station_stats <- runoff_data_dt[, .(
  skewness = calculate_skewness(value),
  cv = calculate_cv(value)
), by = station]

# Print the statistics
cat("\nSkewness and CV by station:\n")
print(station_stats)

# Task 3: Create boxplots of monthly runoff
# Add month as a factor for better plotting
runoff_data_dt[, month_factor := factor(month(date), 
                                      levels = 1:12, 
                                      labels = month.abb)]

# Create runoff classes based on quantiles
runoff_data_dt[, runoff_class := cut(value, 
                                   breaks = quantile(value, probs = seq(0, 1, 0.25), na.rm = TRUE),
                                   labels = c("Low", "Medium-Low", "Medium-High", "High"),
                                   include.lowest = TRUE)]

# Create monthly boxplot
plot3 <- ggplot(runoff_data_dt, aes(x = month_factor, y = value, fill = runoff_class)) +
  geom_boxplot() +
  facet_wrap(~ station, scales = "free_y") +
  scale_fill_brewer(palette = "Blues", direction = 1) +
  labs(title = "Monthly Runoff by Station",
       x = "Month",
       y = "Runoff (m³/s)",
       fill = "Runoff Class") +
  theme_light() +
  theme(
    plot.background = element_rect(fill = "white"),
    panel.background = element_rect(fill = "white"),
    text = element_text(color = "black"),
    axis.text = element_text(color = "black"),
    axis.text.x = element_text(angle = 45, hjust = 1, color = "black"),
    strip.background = element_rect(fill = "#E0E0E0"),
    strip.text = element_text(color = "black"),
    panel.grid.major = element_line(color = "#E0E0E0", linewidth = 0.1),
    panel.grid.minor = element_line(color = "#F0F0F0", linewidth = 0.1)
  )

# Save the plot
ggsave("results/assignments/monthly_runoff_boxplot.png", plot3, width = 12, height = 8)
cat("Plot 3 created: monthly_runoff_boxplot.png\n")

# Task 4: Create boxplot of daily runoff by station
plot4 <- ggplot(runoff_data_dt, aes(x = reorder(station, value, FUN = median), y = value)) +
  geom_boxplot(outlier.color = "#E53935", outlier.size = 2) +
  labs(title = "Daily Runoff by Station",
       x = "Station",
       y = "Runoff (m³/s)") +
  theme_light() +
  theme(
    plot.background = element_rect(fill = "white"),
    panel.background = element_rect(fill = "white"),
    text = element_text(color = "black"),
    axis.text = element_text(color = "black"),
    axis.text.x = element_text(angle = 45, hjust = 1, color = "black"),
    panel.grid.major = element_line(color = "#E0E0E0", linewidth = 0.1),
    panel.grid.minor = element_line(color = "#F0F0F0", linewidth = 0.1)
  )

# Save the plot
ggsave("results/assignments/daily_runoff_boxplot.png", plot4, width = 10, height = 6)
cat("Plot 4 created: daily_runoff_boxplot.png\n")

# Task 5: Create area and altitude classes
# Load the runoff stations data
runoff_stations <- try(readRDS("data/runoff_stations.rds"), silent = TRUE)
if(inherits(runoff_stations, "try-error")) {
  cat("Error loading runoff_stations.rds. Please check the file path.\n")
  quit(status = 1)
}

# Convert to data.table and select only needed columns
stations_dt <- as.data.table(runoff_stations)[, .(station = sname, area, altitude)]

# Calculate mean daily runoff for each station
mean_runoff <- runoff_data_dt[, .(mean_day = mean(value, na.rm = TRUE)), by = station]

# Merge with stations data
stations_with_mean <- merge(stations_dt, mean_runoff, by = "station")

# Create area classes
stations_with_mean[, area_class := cut(area, 
                                     breaks = c(0, 50000, 100000, Inf),
                                     labels = c("small", "medium", "large"),
                                     include.lowest = TRUE)]

# Create altitude classes
stations_with_mean[, alt_class := cut(altitude, 
                                    breaks = c(0, 200, 400, Inf),
                                    labels = c("low", "medium", "high"),
                                    include.lowest = TRUE)]

# Create scatter plot
plot5 <- ggplot(stations_with_mean, aes(x = mean_day, y = area, color = area_class, size = alt_class)) +
  geom_point(alpha = 0.7) +
  scale_color_manual(values = c("small" = "#4CAF50", "medium" = "#FFC107", "large" = "#F44336")) +
  scale_size_manual(values = c("low" = 3, "medium" = 5, "high" = 7)) +
  labs(title = "Mean Daily Runoff vs Area by Classes",
       x = "Mean Daily Runoff (m³/s)",
       y = "Area (km²)",
       color = "Area Class",
       size = "Altitude Class") +
  theme_light() +
  theme(
    plot.background = element_rect(fill = "white"),
    panel.background = element_rect(fill = "white"),
    text = element_text(color = "black"),
    axis.text = element_text(color = "black"),
    panel.grid.major = element_line(color = "#E0E0E0", linewidth = 0.1),
    panel.grid.minor = element_line(color = "#F0F0F0", linewidth = 0.1)
  )

# Save the plot
ggsave("results/assignments/area_altitude_classes.png", plot5, width = 10, height = 6)
cat("Plot 5 created: area_altitude_classes.png\n")

# Print completion message
cat("\nAll analyses have been completed and plots saved in the results/assignments directory.\n") 