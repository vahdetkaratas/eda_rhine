# Calculation of travel time for a raindrop from Alpine Rhine to the ocean
# This is an approximation based on average flow velocities

# Parameters
total_river_length_km <- 1230  # Total length of Rhine from source to mouth
alpine_section_start_km <- 0    # Distance from source
alpine_section_end_km <- 400    # Approximate end of Alpine section

# Estimated flow velocities for different sections (m/s)
# These are approximations and vary with discharge, season, and location
velocity_alpine_section <- 2.0   # Faster in steep mountain sections
velocity_middle_section <- 1.5   # Middle Rhine
velocity_lower_section <- 1.0    # Lower Rhine, slower in flatter areas

# Calculate distances for each section
alpine_section_length_km <- alpine_section_end_km - alpine_section_start_km
middle_section_length_km <- 800 - alpine_section_end_km
lower_section_length_km <- total_river_length_km - 800

# Convert distances to meters
alpine_section_length_m <- alpine_section_length_km * 1000
middle_section_length_m <- middle_section_length_km * 1000
lower_section_length_m <- lower_section_length_km * 1000

# Calculate travel time for each section (seconds)
time_alpine_section_s <- alpine_section_length_m / velocity_alpine_section
time_middle_section_s <- middle_section_length_m / velocity_middle_section
time_lower_section_s <- lower_section_length_m / velocity_lower_section

# Total travel time
total_time_s <- time_alpine_section_s + time_middle_section_s + time_lower_section_s

# Convert to more readable units
total_time_hours <- total_time_s / 3600
total_time_days <- total_time_hours / 24

# Print results
cat("Estimated travel time for a water particle from Alpine Rhine to the ocean:\n")
cat("Alpine section (", alpine_section_length_km, "km): ", 
    round(time_alpine_section_s/3600, 1), "hours\n", sep="")
cat("Middle section (", middle_section_length_km, "km): ", 
    round(time_middle_section_s/3600, 1), "hours\n", sep="")
cat("Lower section (", lower_section_length_km, "km): ", 
    round(time_lower_section_s/3600, 1), "hours\n", sep="")
cat("Total time: ", round(total_time_hours, 1), "hours (", 
    round(total_time_days, 1), "days)\n", sep="")

# Note: This is a simplified calculation
cat("\nNote: This is a simplified calculation that assumes:\n")
cat("1. Constant flow velocities within each section\n")
cat("2. No delays in lakes or reservoirs\n")
cat("3. No influence of tides in the lower Rhine\n")
cat("4. Direct path following the main channel\n") 