library("dplyr")
library("tidyr")


# ---- WEATHER ----

# weather_data <- data.table::fread("data/Road_Weather_Information_Stations.csv", header = TRUE, stringsAsFactors = FALSE)
# 
# select_loc_air <- select(weather_data, StationLocation, AirTemperature, DateTime)
# 
# weather_selected <- separate(select_loc_air, StationLocation, c("Latitude", "Longitude"), sep = ",")
# 
# weather_date_split <- separate(weather_selected, DateTime, c("Date", "Time"), sep = " ", convert = TRUE, as.is = TRUE)
# 
# weather_date_split[] <- lapply(weather_date_split, gsub, pattern = "\\(|\\)", replace = "")
# 
# weather_date_aggregate <- aggregate(weather_date_split, by = list(weather_data_split$Date), FUN = mean)
# 
# weather_date_aggregate2 <- weather_date_split %>% 
#   group_by(Date) %>% 
#   summarise(AirTemperature = mean(AirTemperature))
# 
# write.csv(weather, "data/millions.csv")

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


