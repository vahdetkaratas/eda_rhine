
#Setup

install.packages("ggplot2") 
library(ggplot2)


# All in one command
# Produces plot output in viewer
# 
# Does not save plot
# 
# Save with Export menu in viewer
# Adding layers requires whole code for new plot

ggplot(data = mpg)+
  aes(x = displ,
      y = hwy)+
  geom_point()+
  geom_smooth()

# Saving as an object
# Saves your plot as an R object
# 
# Does not show in viewer
# 
# Execute the name of your object to see it
# Can add layers by calling the original plot name
# make and save plot
p <- ggplot(data = mpg)+
  aes(x = displ,
      y = hwy)+
  geom_point()
p # view plot
# add a layer

p + geom_smooth() # shows new plot
p <- p + geom_smooth() # saves and overwrites p
p2 <- p + geom_smooth() # saves as different object


ggplot(data = mpg)+
  aes(x = displ,
      y = hwy)+
  geom_point(aes(color = class))+
  geom_smooth()


#change the plot
ggplot(data = mpg)+
  aes(x = class,
      y = hwy)+
  geom_boxplot()


ggplot(data = mpg)+
  aes(x = class)+
  geom_bar()

ggplot(data = mpg)+
  aes(x = class,
      fill = drv)+
  geom_bar()


ggplot(data = mpg)+
  aes(x = class,
      fill = drv)+ 
  geom_bar(position = "dodge")



p <- ggplot(data = mpg)+
  aes(x = displ,
      y = hwy)+
  geom_point(aes(color = class))+
  geom_smooth()
p # show plot


p + facet_wrap(~year)
p + facet_grid(cyl~year)

p + facet_wrap(~year)+
  labs(x = "Engine Displacement (Liters)",
       y = "Highway MPG",
       title = "Car Mileage and Displacement",
       subtitle = "More Displacement Lowers Highway MPG",
       caption = "Source: EPA",
       color = "Vehicle Class")



ggplot(data = mpg)+
  aes(x = displ,
      y = hwy)+
  geom_point(aes(color = class))+
  geom_smooth()+
  facet_wrap(~year)+
  labs(x = "Engine Displacement (Liters)",
       y = "Highway MPG",
       title = "Car Mileage and Displacement",
       subtitle = "More Displacement Lowers Highway MPG",
       caption = "Source: EPA",
       color = "Vehicle Class")+
  scale_color_viridis_d()



ggplot(data = mpg)+
  aes(x = displ,
      y = hwy)+
  geom_point(aes(color = class))+
  geom_smooth()+
  facet_wrap(~year)+
  labs(x = "Engine Displacement (Liters)",
       y = "Highway MPG",
       title = "Car Mileage and Displacement",
       subtitle = "More Displacement Lowers Highway MPG",
       caption = "Source: EPA",
       color = "Vehicle Class")+
  scale_color_viridis_d()+
  theme_bw()


#adding different theme

ggplot(data = mpg)+
  aes(x = displ,
      y = hwy)+
  geom_point(aes(color = class))+
  geom_smooth()+
  facet_wrap(~year)+
  labs(x = "Engine Displacement (Liters)",
       y = "Highway MPG",
       title = "Car Mileage and Displacement",
       subtitle = "More Displacement Lowers Highway MPG",
       caption = "Source: EPA",
       color = "Vehicle Class")+
  scale_color_viridis_d()+
  theme_minimal()+
  theme(text = element_text(family = "Fira Sans"))


ggplot(data = mpg)+
  aes(x = displ,
      y = hwy)+
  geom_point(aes(color = class))+
  geom_smooth()+
  facet_wrap(~year)+
  labs(x = "Engine Displacement (Liters)",
       y = "Highway MPG",
       title = "Car Mileage and Displacement",
       subtitle = "More Displacement Lowers Highway MPG",
       caption = "Source: EPA",
       color = "Vehicle Class")+
  scale_color_viridis_d()+
  theme_minimal()+
  theme(text = element_text(family = "Fira Sans"))


#legend
ggplot(data = mpg)+
  aes(x = displ,
      y = hwy)+
  geom_point(aes(color = class))+
  geom_smooth()+
  facet_wrap(~year)+
  labs(x = "Engine Displacement (Liters)",
       y = "Highway MPG",
       title = "Car Mileage and Displacement",
       subtitle = "More Displacement Lowers Highway MPG",
       caption = "Source: EPA",
       color = "Vehicle Class")+
  scale_color_viridis_d()+
  theme_minimal()+
  theme(text = element_text(family = "Fira Sans"),
        legend.position="bottom")


# various theme from ggtheme

# library("ggthemes") 


ggplot(data = mpg)+
  aes(x = displ,
      y = hwy)+
  geom_point(aes(color = class))+
  geom_smooth()+
  facet_wrap(~year)+
  labs(x = "Engine Displacement (Liters)",
       y = "Highway MPG",
       title = "Car Mileage and Displacement",
       subtitle = "More Displacement Lowers Highway MPG",
       caption = "Source: EPA",
       color = "Vehicle Class")+
  scale_color_viridis_d()+
  theme_economist()+
  theme(text = element_text(family = "Fira Sans"),
        legend.position="bottom")



# different theme
ggplot(data = mpg)+
  aes(x = displ,
      y = hwy)+
  geom_point(aes(color = class))+
  geom_smooth()+
  facet_wrap(~year)+
  labs(x = "Engine Displacement (Liters)",
       y = "Highway MPG",
       title = "Car Mileage and Displacement",
       subtitle = "More Displacement Lowers Highway MPG",
       caption = "Source: EPA",
       color = "Vehicle Class")+
  scale_color_viridis_d()+
  theme_fivethirtyeight()+
  theme(text = element_text(family = "Fira Sans"),
        legend.position="bottom")


# be carefull
# first map
ggplot(data = mpg, aes(x = displ,
                       y = hwy,
                       color = class))+
  geom_point()+
  geom_smooth()

# second map


ggplot(data = mpg, aes(x = displ,
                       y = hwy))+
  geom_point(aes(color = class))+
  geom_smooth()


# first map
ggplot(data = mpg, aes(x = displ,
                       y = hwy))+
  geom_point(aes(color = class))+
  geom_smooth()

# sec map
ggplot(data = mpg, aes(x = displ,
                       y = hwy))+
  geom_point(aes(), color = "red")+
  geom_smooth(aes(), color = "blue")


#lets go crazy

library("rworldmap")
library("rworldxtra")
library(sf)
world <- getMap(resolution = "high")
class(world)

world <- st_as_sf(world)
ggplot(data = world) +
  geom_sf()


ggplot(data = world) +
  geom_sf(aes(fill = POP_EST)) +
  scale_fill_viridis_c(option = "plasma", trans = "sqrt")






library(dplyr)
require(maps)
require(viridis)
theme_set(
  theme_void()
)


city <- world.cities
#lets go more crazy!
world_map <- map_data("world")
ggplot(world.cities, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill="lightgray", colour = "white")


# Some EU Contries
some.eu.countries <- c(
  "Portugal", "Spain", "France", "Switzerland", "Germany",
  "Austria", "Belgium", "UK", "Netherlands",
  "Denmark", "Poland", "Italy", 
  "Croatia", "Slovenia", "Hungary", "Slovakia",
  "Czech republic"
)



# Retrievethe map data
some.eu.maps <- map_data("world", region = some.eu.countries)

# Compute the centroid as the mean longitude and lattitude
# Used as label coordinate for country's names
region.lab.data <- some.eu.maps %>%
  group_by(region) %>%
  summarise(long = mean(long), lat = mean(lat))


#lets plot
ggplot(some.eu.maps, aes(x = long, y = lat)) +
  geom_polygon(aes( group = group, fill = region))+
  geom_text(aes(label = region), data = region.lab.data,  size = 3, hjust = 0.5)+
  scale_fill_viridis_d()+
  theme_void()+
  theme(legend.position = "none")