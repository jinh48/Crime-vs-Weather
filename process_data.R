library(dplyr)
library("RSocrata")



# ---- WEATHER ----
source("keys.R")

# ---- WEATHER DATA ----


# ---- CRIME DATA ----
crime_data <- as.data.frame(read.csv("data/Crime_Data.csv"))

my_neigh_map <- as.data.frame(read.csv("data/My_Neighborhood_Map.csv"))

# capitalizing column Common.Name
my_neigh_map[,2] = toupper(my_neigh_map[,2])

# changing Common.Name to Neighborhood so that it will merge properly 
neigh_data <- my_neigh_map %>% rename(Neighborhood = Common.Name)

# mergign neighborhood data to crime data to get longitude and latitude
combined <- merge(x = crime_data, y = neigh_data, by = "Neighborhood", all.x = TRUE)

# filter out null values
crime <- combined %>% filter(!is.na(Longitude))


