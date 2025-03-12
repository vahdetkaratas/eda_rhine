# Load necessary libraries
library(data.table)
library(ggplot2)
library(tidyr)
library(dplyr)
library(lubridate)
library(ggrepel)  # For better label placement

try(setwd("C:/Users/KARA/Documents/eda_rhine"), silent = TRUE)

# Create output directory if it doesn't exist
dir.create("results/assignments", showWarnings = FALSE, recursive = TRUE)

# Task 1: Create a data.table from runoff_stations
# Load the runoff stations data with error handling
runoff_stations <- try(readRDS("data/runoff_stations.rds"), silent = TRUE)
if(inherits(runoff_stations, "try-error")) {
  cat("Error loading runoff_stations.rds. Please check the file path.\n")
  quit(status = 1)
}

# Convert to data.table
stations_dt <- as.data.table(runoff_stations)

# Print the structure and column names to debug
cat("Column names in runoff_stations:", paste(names(stations_dt), collapse = ", "), "\n")


if("station" %in% names(stations_dt)) {
  station_col <- "station"
} else if("sname" %in% names(stations_dt)) {
  station_col <- "sname"
} else {
  # If neither exists, use the first column
  station_col <- names(stations_dt)[1]
  cat("Using", station_col, "as station identifier\n")
}

# Select the columns we need, using the identified station column
stations_dt <- stations_dt[, c(station_col, "area", "altitude", "lat", "lon"), with = FALSE]

# Rename the station column to 'station' for consistency
setnames(stations_dt, station_col, "station")

# Print the structure of the data
cat("Structure of stations_dt after selecting columns:\n")
print(str(stations_dt))

# Transform to tidy format
stations_tidy <- melt(stations_dt, 
                     id.vars = "station", 
                     measure.vars = c("area", "altitude", "lat", "lon"),
                     variable.name = "parameter", 
                     value.name = "value")

# Print the first few rows of the tidy data
cat("\nFirst rows of tidy data:\n")
print(head(stations_tidy))

# Task 2: Create a geom_point plot of area vs. altitude
plot1 <- ggplot(stations_dt, aes(x = area, y = altitude)) +
  geom_point(size = 4, color = "#1976D2") +  # Darker blue for better contrast
  labs(title = "Altitude vs. Area of Runoff Stations",
       x = "Area (km²)",
       y = "Altitude (m)") +
  theme_minimal() +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    text = element_text(color = "black", size = 12),
    axis.text = element_text(color = "black", size = 10),
    panel.grid.major = element_line(color = "#E0E0E0", size = 0.1),  # Lighter grid
    panel.grid.minor = element_blank(),  # Remove minor grid
    plot.title = element_text(size = 14, face = "bold", margin = margin(b = 20)),
    plot.margin = margin(20, 20, 20, 20)
  )

# Save the plot with error handling
try(ggsave("results/assignments/area_vs_altitude.png", plot1, width = 8, height = 6), silent = TRUE)
cat("Plot 1 created: area_vs_altitude.png\n")


# Graph 1: Area vs. Altitude with station names
plot2 <- ggplot(stations_dt, aes(x = area, y = altitude)) +
  geom_point(aes(size = area), color = "#1976D2") +
  geom_text_repel(aes(label = station), 
                  size = 3.5,
                  color = "black",
                  box.padding = 1,  # Increased padding
                  point.padding = 0.5,
                  force = 5,  # Increased force
                  max.overlaps = 20,  # Limit overlaps
                  min.segment.length = 0.1) +
  scale_size_continuous(name = "Area (km²)", range = c(3, 8)) +
  labs(title = "Station Locations by Area and Altitude",
       x = "Area (km²)", 
       y = "Altitude (m)") +
  theme_minimal() +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    text = element_text(color = "black", size = 12),
    axis.text = element_text(color = "black", size = 10),
    panel.grid.major = element_line(color = "#E0E0E0", size = 0.1),
    panel.grid.minor = element_blank(),
    legend.position = "right",
    plot.title = element_text(size = 14, face = "bold", margin = margin(b = 20)),
    plot.margin = margin(20, 20, 20, 20)
  )

# Save the plot with error handling
try(ggsave("results/assignments/area_vs_altitude_labeled.png", plot2, width = 8, height = 6), silent = TRUE)
cat("Plot 2 created: area_vs_altitude_labeled.png\n")

# Graph 2: Longitude vs. Latitude with color-coded altitude
plot3 <- ggplot(stations_dt, aes(x = lon, y = lat)) +
  geom_point(aes(color = altitude), size = 4) +
  geom_text_repel(aes(label = station),
                  size = 3.5,
                  color = "black",
                  box.padding = 1,
                  point.padding = 0.5,
                  force = 5,
                  max.overlaps = 20,
                  min.segment.length = 0.1) +
  scale_color_gradientn(
    colors = c("#4CAF50", "#FFC107", "#F44336"),  # Green to Yellow to Red
    name = "Altitude (m)"
  ) +
  labs(title = "Geographic Distribution of Stations",
       x = "Longitude", 
       y = "Latitude") +
  theme_minimal() +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    text = element_text(color = "black", size = 12),
    axis.text = element_text(color = "black", size = 10),
    panel.grid.major = element_line(color = "#E0E0E0", size = 0.1),
    panel.grid.minor = element_blank(),
    legend.position = "right",
    plot.title = element_text(size = 14, face = "bold", margin = margin(b = 20)),
    plot.margin = margin(20, 20, 20, 20)
  )

# Save the plot with error handling
try(ggsave("results/assignments/lon_vs_lat_altitude.png", plot3, width = 8, height = 6), silent = TRUE)
cat("Plot 3 created: lon_vs_lat_altitude.png\n")

# Task 4: Create a graph comparing periods of available data at each station
# Load the runoff data with error handling
runoff_data <- try(readRDS("data/runoff_day.rds"), silent = TRUE)
if(inherits(runoff_data, "try-error")) {
  cat("Error loading runoff_day.rds. Please check the file path.\n")
  quit(status = 1)
}

runoff_dt <- as.data.table(runoff_data)

# Print column names of runoff_data to debug
cat("Column names in runoff_data:", paste(names(runoff_dt), collapse = ", "), "\n")

# Ensure date is in Date format
runoff_dt[, date := as.Date(date)]

# Extract year from date
runoff_dt[, year := year(date)]

# Check what column is used for station in runoff_dt
if("station" %in% names(runoff_dt)) {
  runoff_station_col <- "station"
} else {
  # Try to find a column that might be the station identifier
  possible_cols <- c("sname", "id", "name")
  for(col in possible_cols) {
    if(col %in% names(runoff_dt)) {
      runoff_station_col <- col
      break
    }
  }
  if(!exists("runoff_station_col")) {
    runoff_station_col <- names(runoff_dt)[1]  # Use first column as fallback
  }
  cat("Using", runoff_station_col, "as station identifier in runoff_data\n")
}

# Get the range of years for each station
station_periods <- runoff_dt[, .(
  start_year = min(year),
  end_year = max(year)
), by = runoff_station_col]

# Rename the station column to 'station' for consistency
setnames(station_periods, runoff_station_col, "station")

# Merge with station names
station_periods <- merge(station_periods, 
                        stations_dt[, .(station, altitude)], 
                        by = "station", all.x = TRUE)

# Order stations by start_year
station_periods <- station_periods[order(start_year)]

# Create a data frame for the timeline plot
timeline_data <- data.table()
for (i in 1:nrow(station_periods)) {
  timeline_data <- rbind(timeline_data, 
                        data.table(
                          station = station_periods$station[i],
                          year = station_periods$start_year[i]:station_periods$end_year[i],
                          altitude = station_periods$altitude[i]
                        ))
}

# Create the timeline plot
plot4 <- ggplot(timeline_data, aes(x = year, y = station)) +
  geom_tile(aes(fill = altitude), color = "white", size = 0.2) +
  scale_fill_gradientn(
    colors = c("#4CAF50", "#FFC107", "#F44336"),  # Green to Yellow to Red
    name = "Altitude (m)"
  ) +
  labs(title = "Periods of Available Data at Each Station",
       x = "Year",
       y = "Station",
       fill = "Altitude (m)") +
  theme_minimal() +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    text = element_text(color = "black", size = 12),
    axis.text = element_text(color = "black"),
    axis.text.y = element_text(size = 10),
    axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
    panel.grid = element_blank(),
    plot.title = element_text(size = 14, face = "bold", margin = margin(b = 20)),
    plot.margin = margin(20, 20, 20, 20),
    legend.position = "right"
  )

# Save the plot with error handling
try(ggsave("results/assignments/station_data_periods.png", plot4, width = 10, height = 8), silent = TRUE)
cat("Plot 4 created: station_data_periods.png\n")

# Task 5: (Optional) Highlight years with missing data
# Check for missing values in each year for each station
missing_data <- runoff_dt[, .(
  missing_count = sum(is.na(value)),
  total_count = .N
), by = .(get(runoff_station_col), year)]

# Rename the station column
setnames(missing_data, "get", "station")

# Calculate missing percentage
missing_data[, missing_percentage := (missing_count / total_count) * 100]

# Create a data frame for the missing data plot
missing_plot_data <- merge(missing_data, 
                          data.table(station = unique(stations_dt$station)), 
                          by = "station", all.y = TRUE)

# Fill NA values with 0 (no missing data)
missing_plot_data[is.na(missing_percentage), missing_percentage := 0]

# Create the missing data plot
plot5 <- ggplot(missing_plot_data, aes(x = year, y = station)) +
  geom_tile(aes(fill = missing_percentage), color = "white", size = 0.2) +
  scale_fill_gradient2(
    low = "#4CAF50",  # Green for low missing
    mid = "#FFC107",  # Yellow for medium missing
    high = "#F44336", # Red for high missing
    midpoint = 50,
    name = "Missing Data (%)",
    limits = c(0, 100)
  ) +
  labs(title = "Missing Data by Year and Station",
       x = "Year",
       y = "Station") +
  theme_minimal() +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    text = element_text(color = "black", size = 12),
    axis.text = element_text(color = "black"),
    axis.text.y = element_text(size = 9),
    axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
    panel.grid = element_blank(),  # Remove grid lines for tile plot
    plot.title = element_text(size = 14, face = "bold"),
    plot.margin = margin(20, 20, 20, 20),
    legend.position = "right"
  )

# Save the plot with error handling
try(ggsave("results/assignments/missing_data_by_year.png", plot5, width = 10, height = 8), silent = TRUE)
cat("Plot 5 created: missing_data_by_year.png\n")

# Print a message indicating completion
cat("\nAll visualizations have been created and saved in the results/assignments directory.\n") 