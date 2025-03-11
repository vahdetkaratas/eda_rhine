# Define vectors using lowercase and meaningful variable names
temperatures <- c(3, 6, 10, 14)
weights <- c(1, 0.8, 1.2, 1)

# Load required library
library(data.table)

# Define a function with proper spacing
multiply_values <- function(x, y) {
  x * y
}

# Compute results
results <- multiply_values(temperatures, weights)
print(results)
