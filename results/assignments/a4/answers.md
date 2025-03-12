# Explorer's Questions - Rhine River Analysis

## 1. Which is the difference between the median and the 0.5 quantile?

There is no difference between the median and the 0.5 quantile - they are mathematically equivalent measures. Both represent the middle value in a sorted dataset where:
- 50% of the values fall below this point
- 50% of the values fall above this point

This can be seen in our analysis where we used quantiles to create runoff classes, with the 0.5 quantile serving as the median point between "Medium-Low" and "Medium-High" classes.

## 2. Why the median and mean are not the same in Rhine runoff?

The median and mean differ in the Rhine runoff data due to the asymmetric distribution of flow values. Our analysis shows:

1. All stations exhibit positive skewness:
   - DOMA: 2.19 (highest)
   - LOBI: 2.10
   - KOEL: 2.09
   - REES: 2.04
   - RHEI: 0.96 (lowest)

2. High coefficient of variation (CV):
   - DOMA: 82.86%
   - DIER: 72.59%
   - Most other stations: 40-52%

This indicates that:
- The distribution is right-skewed (tail extends to the right)
- Extreme high flow events (floods) pull the mean higher than the median
- There is significant variability in the flow regime
- Natural lower bounds on minimum flow but no upper bounds on maximum flow contribute to this asymmetry

## 3. Do you notice something strange regarding the location of the stations LOBI and REES?

Yes, there are two notable observations:

1. REES characteristics:
   - Highest mean daily runoff (2,251 m³/s)
   - High skewness (2.04)
   - High CV (49.41%)
   - Shows very high runoff despite not being the most downstream station

2. LOBI characteristics:
   - Very high skewness (2.10)
   - High CV (51.14%)
   - Shows unusual variability compared to nearby stations

Possible explanations:
- REES might be located after a major tributary confluence, explaining its unexpectedly high runoff
- LOBI's unusual patterns might be due to:
  - Proximity to regulated tributaries
  - Influence of upstream water management structures (dams/reservoirs)
  - Local geographical features affecting flow patterns
  - Position relative to major tributary inputs

## 4. Which were the months, seasons, years with highest/lowest runoff at each location?

Based on our analysis of the monthly runoff patterns:

### Highest Runoff
- **Months**: February-March
- **Season**: Winter/Early Spring
- **Characteristics**: 
  - Consistent pattern across stations
  - Likely influenced by snowmelt and winter precipitation
  - Highest variability in winter months

### Lowest Runoff
- **Months**: September-October
- **Season**: Late Summer/Early Autumn
- **Characteristics**:
  - More consistent low flows
  - Less variability than high flow periods
  - Pattern consistent across stations

### Station-specific Patterns
- DOMA and DIER show the highest seasonal variability (CV > 70%)
- Most stations show similar seasonal patterns but with different magnitudes
- The timing of extremes is relatively consistent across stations, suggesting regional climate control

## 5. (Optional) Which is the average distance between each station in km?

This question cannot be answered with the available data, as the dataset does not include geographical coordinates (latitude/longitude) of the stations. To calculate distances between stations, we would need:
- Spatial coordinates for each station
- A method to calculate great-circle distances or river channel distances
- Information about the river network structure

Note: A more complete analysis of station distances would ideally consider both straight-line distances and actual river channel distances, as these can differ significantly in meandering river systems.
