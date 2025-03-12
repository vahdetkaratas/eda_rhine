# Calculation of runoff increase from rainfall over Rhine catchment
# Parameters
catchment_area_km2 <- 185000  # Rhine catchment area in km²
rainfall_rate_mm_per_hour <- 0.5  # Rainfall rate in mm/hour
rainfall_duration_hours <- 24  # Duration of rainfall in hours

# Convert catchment area to m²
catchment_area_m2 <- catchment_area_km2 * 1000000  # 1 km² = 1,000,000 m²

# Calculate total rainfall volume
# Rainfall in mm = m³ of water per 1000 m² of area
total_rainfall_mm <- rainfall_rate_mm_per_hour * rainfall_duration_hours
total_rainfall_m <- total_rainfall_mm / 1000  # Convert mm to m
total_water_volume_m3 <- total_rainfall_m * catchment_area_m2

# Calculate increase in river runoff
# Assuming all water ends up in the river
# Convert to m³/s (cubic meters per second, standard unit for river discharge)
seconds_in_day <- 24 * 60 * 60
runoff_increase_m3_per_s <- total_water_volume_m3 / seconds_in_day

# Print results
cat("Rhine catchment area:", catchment_area_km2, "km²\n")
cat("Rainfall rate:", rainfall_rate_mm_per_hour, "mm/hour for", 
    rainfall_duration_hours, "hours\n")
cat("Total rainfall volume:", format(total_water_volume_m3, scientific = FALSE), 
    "m³\n")
cat("Increase in river runoff:", round(runoff_increase_m3_per_s, 2), 
    "m³/s\n")

# Compare to average Rhine discharge
avg_rhine_discharge_m3_per_s <- 2200  # Approximate average at Rhine mouth
percentage_increase <- (runoff_increase_m3_per_s / avg_rhine_discharge_m3_per_s) * 100
cat("This represents approximately", round(percentage_increase, 1), 
    "% of the average Rhine discharge of", avg_rhine_discharge_m3_per_s, "m³/s\n") 