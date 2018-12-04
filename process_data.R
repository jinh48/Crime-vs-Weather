library("dplyr")
library("tidyr")

weather <- read.csv("data/weather.csv", header = TRUE, stringsAsFactors = FALSE)
crime <- read.csv("data/crime.csv", header = TRUE, stringsAsFactors = FALSE)


# ---- WEATHER DATA TRANSFORMATION ----

### reading in 2gb file of raw data
# weather_data <- data.table::fread("data/Road_Weather_Information_Stations.csv", header = TRUE, stringsAsFactors = FALSE)

### selecting only Station Location, Air Temperature, DateTime columns
# select_loc_air <- select(weather_data, StationLocation, AirTemperature, DateTime)

### separating latitude and longitude singlue column numbers into two columns 
# weather_selected <- separate(select_loc_air, StationLocation, c("Latitude", "Longitude"), sep = ",")

### separating DateTime column into two columns: Date & Time
# weather_date_split <- separate(weather_selected, DateTime, c("Date", "Time"), sep = " ", convert = TRUE, as.is = TRUE)

### removing characters "(" & ")" from latitude and longitude data
# weather_date_split[] <- lapply(weather_date_split, gsub, pattern = "\\(|\\)", replace = "")

### coverting AirTemperature to numeric 
# weather1 <- weather_date_split %>% mutate(temp = as.numeric(AirTemperature))

### grouping the data by Date, and finding the mean of air temperature for every day
# weather2 <- aggregate(weather1[,6], list(weather1$Date), mean) %>% as.data.frame()

### renaming the columns to Date & Temperature
# names(weather2)[names(weather2) == 'Group.1'] <- 'Date'
# names(weather2)[names(weather2) == 'x'] <- 'Air Temperature'

### writing the data to csv file
# write.csv(weather2, "data/weather.csv", row.names = FALSE)



# ---- CRIME DATA TRANSFORMATION ----

### reading in the crime raw data
# crime_data <- as.data.frame(read.csv("data/Crime_Data.csv", header = TRUE, stringsAsFactors = FALSE))

### converting to data frame 
# my_neigh_map <- as.data.frame(read.csv("data/My_Neighborhood_Map.csv"))

### capitalizing column Common.Name
# my_neigh_map[,2] = toupper(my_neigh_map[,2])

### changing Common.Name to Neighborhood so that it will merge properly 
# neigh_data <- my_neigh_map %>% rename(Neighborhood = Common.Name)
 
### mergign neighborhood data to crime data to get longitude and latitude
# combined <- merge(x = crime_data, y = neigh_data, by = "Neighborhood", all.x = TRUE)

### filter out null values
#crime2 <- combined %>% filter(!is.na(Longitude))

### writing data to csv file
#write.csv(crime2, "data/crime.csv", row.names = FALSE)



