# Load necessary libraries
library(data.table)
library(ggplot2)
library(dplyr)

# Set working directory
try(setwd("C:/Users/KARA/Documents/eda_rhine"), silent = TRUE)

# Load the data
runoff_stations <- readRDS("data/runoff_stations.rds")
runoff_data <- readRDS("data/runoff_day.rds")

# Convert to data.tables
stations_dt <- as.data.table(runoff_stations)
runoff_dt <- as.data.table(runoff_data)

# Print column names for debugging
cat("\nColumns in stations_dt:", paste(names(stations_dt), collapse = ", "), "\n")
cat("Columns in runoff_dt:", paste(names(runoff_dt), collapse = ", "), "\n\n")

# Calculate average catchment area
avg_area <- mean(stations_dt$area, na.rm = TRUE)
cat("\nAverage catchment area:", round(avg_area, 2), "km²\n")

# Calculate average runoff
avg_runoff <- mean(runoff_dt$value, na.rm = TRUE)
cat("Average runoff:", round(avg_runoff, 2), "m³/s\n")

# Identify the station column name in runoff_dt
if ("station" %in% names(runoff_dt)) {
    station_col <- "station"
} else if ("sname" %in% names(runoff_dt)) {
    station_col <- "sname"
} else if ("name" %in% names(runoff_dt)) {
    station_col <- "name"
} else {
    stop("Could not find station identifier column in runoff data")
}

cat("\nUsing column '", station_col, "' as station identifier\n", sep="")

# Calculate average runoff by station using the identified column
station_avg_runoff <- runoff_dt[, .(
    avg_runoff = mean(value, na.rm = TRUE),
    sd_runoff = sd(value, na.rm = TRUE)
), by = .(station = get(station_col))]

# Create a bar plot of average runoff by station
plot_avg_runoff <- ggplot(station_avg_runoff, aes(x = reorder(station, -avg_runoff), y = avg_runoff)) +
    geom_bar(stat = "identity", fill = "#1976D2") +
    geom_errorbar(aes(ymin = avg_runoff - sd_runoff, ymax = avg_runoff + sd_runoff), 
                  width = 0.2, color = "#0D47A1") +
    labs(title = "Average Runoff by Station",
         x = "Station",
         y = "Average Runoff (m³/s)") +
    theme_minimal() +
    theme(
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA),
        text = element_text(color = "black", size = 12),
        axis.text = element_text(color = "black", size = 10),
        axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid.major = element_line(color = "#E0E0E0", size = 0.1),
        panel.grid.minor = element_blank(),
        plot.title = element_text(size = 14, face = "bold", margin = margin(b = 20)),
        plot.margin = margin(20, 20, 20, 20)
    )

# Save the plot
ggsave("results/assignments/average_runoff_by_station.png", plot_avg_runoff, width = 12, height = 6)

# Analyze relationship between altitude and area
correlation <- cor(stations_dt$altitude, stations_dt$area, use = "complete.obs")
cat("\nCorrelation between altitude and area:", round(correlation, 3))

# Print summary statistics
cat("\n\nSummary of catchment areas:\n")
print(summary(stations_dt$area))

cat("\nSummary of runoff values:\n")
print(summary(runoff_dt$value)) 