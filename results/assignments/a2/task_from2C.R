# Load necessary libraries
library(data.table)
library(lubridate)

# Set working directory (adjust the path to your local repository)
setwd("C:/Users/KARA/Documents/eda_rhine")

# Create an output file to capture results
output_file <- "results/assignments/task_from2C_output.txt"
sink(output_file)

# Task 1: Create atomic vector of extreme runoff drought years in Europe (EIR panel)
# Years extracted from the rightmost plot in the bottom panel (EIR runoff)
eur_runoff <- c(1921, 1922, 1949, 1954, 1959, 1963, 1976, 1990, 2003, 2015)
cat("Original eur_runoff vector:\n")
print(eur_runoff)

# Sort from latest to most recent using sort()
eur_runoff_sorted <- sort(eur_runoff, decreasing = TRUE)
cat("\nSorted using sort():\n")
print(eur_runoff_sorted)

# Sort from latest to most recent using order()
eur_runoff_ordered <- eur_runoff[order(eur_runoff, decreasing = TRUE)]
cat("\nSorted using order():\n")
print(eur_runoff_ordered)

# Task 2: Create a list of all drought years by type
all_droughts <- list(
  precipitation = c(1921, 1945, 1954, 1959, 1976, 2003, 2015),
  runoff = c(1921, 1922, 1949, 1954, 1959, 1963, 1976, 1990, 2003, 2015),
  soil_moisture = c(1921, 1922, 1954, 1959, 1976, 2003, 2015)
)
cat("\nAll droughts list:\n")
print(all_droughts)

# Task 3: Calculate average interval between droughts for each type
calculate_avg_interval <- function(years) {
  sorted_years <- sort(years)
  intervals <- diff(sorted_years)
  return(mean(intervals))
}

avg_intervals <- lapply(all_droughts, calculate_avg_interval)
cat("\nAverage intervals between droughts (years):\n")
print(avg_intervals)

# Task 4: Create data frame for precipitation droughts in CEU
prcp_droughts_ceu <- data.frame(
  year = c(1858, 1863, 1893, 1904, 1911, 1921, 1934, 1947, 1976, 2003, 2015),
  region = rep("CEU", 11),
  severity = c(3.8, 3.5, 3.6, 3.5, 3.4, 4.2, 3.7, 3.8, 3.5, 2.8, 2.5),  # Estimated from y-axis
  area = c(40, 35, 45, 60, 65, 55, 75, 70, 60, 45, 40)  # Estimated from x-axis (%)
)

# Explore the structure
cat("\nStructure of prcp_droughts_ceu:\n")
str(prcp_droughts_ceu)

# Task 5: Filter years after 1900
years_vector <- prcp_droughts_ceu$year
years_after_1900 <- years_vector[years_vector > 1900]
cat("\nYears after 1900:\n")
print(years_after_1900)

# Task 6: Split years into 50-year intervals
int_50 <- cut(prcp_droughts_ceu$year, 
              breaks = seq(1760, 2010, by = 50),
              include.lowest = TRUE, 
              right = FALSE)
cat("\n50-year intervals:\n")
print(table(int_50))

# Task 7: Calculate days since last drought
last_drought_date <- as.Date("2015-08-15")  # Assuming August 15, 2015 for the 2015 drought
days_since_last_drought <- as.numeric(difftime(Sys.Date(), last_drought_date, units = "days"))
cat("\nDays since last drought:", round(days_since_last_drought), "\n")

# Close the output file
sink()

# Task 8: Plot severity versus area
# Save the plot directly to a file
png("results/assignments/ceu_drought_severity_area.png", 
    width = 800, height = 600)
plot(prcp_droughts_ceu$area, prcp_droughts_ceu$severity,
     main = "Severity vs Area for CEU Precipitation Droughts",
     xlab = "Area (%)",
     ylab = "Severity",
     pch = 19,
     col = "darkred")

# Add year labels to points
text(prcp_droughts_ceu$area, prcp_droughts_ceu$severity,
     labels = prcp_droughts_ceu$year,
     pos = 4,
     cex = 0.8)
dev.off()