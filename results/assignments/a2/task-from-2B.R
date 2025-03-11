# Load necessary libraries
library(data.table)

# Set working directory (adjust the path to your local repository)
setwd("C:/Users/KARA/Documents/eda_rhine")

# Load the runoff data from the .rds file
runoff_data <- readRDS("C:/Users/KARA/Documents/eda_rhine/data/runoff_day.rds")

# Convert to a data.table for efficient processing
runoff_dt <- as.data.table(runoff_data)

# Ensure the date column is in Date format
runoff_dt[, date := as.Date(date)]

# Extract month and year from the date
runoff_dt[, `:=`(month = month(date), year = year(date))]

# Filter data for January, February, and March
winter_months_dt <- runoff_dt[month %in% 1:3]

# Calculate mean runoff for each month
mean_runoff <- winter_months_dt[, .(mean_runoff = mean(value, na.rm = TRUE)), by = month]

# Sort by month to ensure correct order for percentage calculation
setorder(mean_runoff, month)

# Calculate percentage change between consecutive months
# Using a more explicit approach to avoid the error
if (nrow(mean_runoff) > 1) {
  # Initialize pct_change column with NA
  mean_runoff[, pct_change := NA_real_]
  
  # Calculate percentage change for months after the first one
  for (i in 2:nrow(mean_runoff)) {
    current <- mean_runoff[i, mean_runoff]
    previous <- mean_runoff[i-1, mean_runoff]
    mean_runoff[i, pct_change := (current - previous) / previous * 100]
  }
}

# Print the results
print(mean_runoff)

# First create a copy with the numeric values
mean_runoff_text <- copy(mean_runoff)
# Convert pct_change to character type for all rows
mean_runoff_text[, pct_change := as.character(pct_change)]
# Now replace NA with text
mean_runoff_text[is.na(pct_change), pct_change := "No previous month"]
# Save
fwrite(mean_runoff_text, "results/assignments/a2/mean_runoff_changes.csv")
