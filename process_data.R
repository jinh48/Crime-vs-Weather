library("dplyr")
library("tidyr")

# weather <- read.csv("data/weather.csv", header = TRUE, stringsAsFactors = FALSE)
crime <- read.csv("data/crime.csv", header = TRUE, stringsAsFactors = FALSE)
rain <- read.csv("data/rain.csv", header = TRUE, stringsAsFactors = FALSE)
# include only years 2002-2017, to match up with weather data
crime <- filter(crime, grepl('2002|2003|2004|2005|2006|2007|2008|2009|2010|2011|
                             2012|2013|2014|2015|2016|2017', Occurred.Date))



# ---- DATA FOR 3D PLOT ---- #
rain_df <- read.csv("data/rain.csv", header = TRUE, stringsAsFactors = FALSE)
crime_df <- crime <- read.csv("data/crime.csv", header = TRUE, stringsAsFactors = FALSE)
weather_df <- read.csv("data/weather.csv", header = TRUE, stringsAsFactors = FALSE)
# turning crime into date
crime_df$Occurred.Date <- as.Date(crime_df$Occurred.Date, format = "%m/%d/%Y")
weather_df$Date <- as.Date(weather_df$Date, format = "%m/%d/%Y")

# turn crime into months
crime_x  <- format(crime_df, format="%m-%Y")
weather_x <- format(weather_df, format = "%m-%Y")

# group by month and count how many crimes by rows
crime_monthly <- aggregate(crime_x[,7], list(crime_x$Occurred.Date), FUN = length) %>% as.data.frame()

# change to date column for merge
names(crime_monthly)[names(crime_monthly) == 'Group.1'] <- 'date'

names(weather_x)[names(weather_x) == 'Date'] <- 'date'

# change rain to date
rain_df$date <- as.Date(rain_df$date, format = "%m/%d/%Y")

# change rain to month
rain_x <- format(rain_df, format= "%m-%Y")

# combine rain and crime
combine_rain_crime <- merge(x = crime_monthly, y = rain_x, by = "date", all.x = TRUE)

combine_temp <- merge(x = combine_rain_crime, y = weather_x, by = "date", all.x = TRUE)

df <- na.omit(combine_temp)

write.csv(df, "data/crime_rain.csv", row.names = FALSE)

crime_rain <- read.csv("data/crime_rain.csv", header = TRUE, stringsAsFactors = FALSE)





# ----- DATA FOR BAR GRAPHS ----- #

crime_names <- read.csv("data/crime.csv", header = TRUE, stringsAsFactors = FALSE)
select_names <- crime_names %>% group_by(Crime.Subcategory) %>% select(Occurred.Date, Crime.Subcategory) %>% 
  summarise(n = n())

crime_names$Occurred.Date <- as.Date(crime_names$Occurred.Date, format = "%m/%d/%Y")

qone <- crime_names[crime_names$Occurred.Date >= "2018-03-01" & crime_names$Occurred.Date <= "2018-05-31",]
qtwo <- crime_names[crime_names$Occurred.Date >= "2018-06-01" & crime_names$Occurred.Date <= "2018-08-31",]
qthree <- crime_names[crime_names$Occurred.Date >= "2018-09-01" & crime_names$Occurred.Date <= "2018-11-30",]
qfour <- crime_names[crime_names$Occurred.Date >= "2018-12-01" | crime_names$Occurred.Date <= "2018-02-28",]

sum_one <- qone %>% group_by(Crime.Subcategory) %>% select(Occurred.Date, Crime.Subcategory) %>% 
  summarise(n = n()) %>% as.data.frame()
sum_two <- qtwo %>% group_by(Crime.Subcategory) %>% select(Occurred.Date, Crime.Subcategory) %>% 
  summarise(n = n()) %>% as.data.frame()
sum_three <- qthree %>% group_by(Crime.Subcategory) %>% select(Occurred.Date, Crime.Subcategory) %>% 
  summarise(n = n()) %>% as.data.frame()
sum_four <- qfour %>% group_by(Crime.Subcategory) %>% select(Occurred.Date, Crime.Subcategory) %>% 
  summarise(n = n()) %>% as.data.frame()

quarters <- c(sum_one, sum_two, sum_three, sum_four)



# ----- MODIFIYING RAIN FILE TO SUIT OUR PROCESSING ------
#rain <- stack(rain)
#   store all dates in a vector
#dates <- rain[1:175,1]
#   replicate dates for each set of measurements
#rain$date <- rep_len(dates, length.out = 3150)
#   delete first 175 rows - only contain dates, no data
#rain = rain[-1:-175,]
#   reset row names to 1
#row.names(rain) <- NULL
#   replace rain gauge # with its corresponding lat/long
#rain$ind <- sub("RG01", "47.725033 -122.341384", rain$ind)
#rain$ind <- sub("RG02", "47.684385 -122.260105", rain$ind)
#rain$ind <- sub("RG03", "47.657997 -122.317634", rain$ind)
#rain$ind <- sub("RG04", "47.692621 -122.314398", rain$ind)
#rain$ind <- sub("RG05", "47.508121 -122.387062", rain$ind) # no RG06
#rain$ind <- sub("RG07", "47.699242 -122.370607", rain$ind)
#rain$ind <- sub("RG08", "47.668468 -122.386092", rain$ind)
#rain$ind <- sub("RG09", "47.674222 -122.355418", rain$ind)
#rain$ind <- sub("RG10_30", "47.518854 -122.266914", rain$ind)
#rain$ind <- sub("RG11", "47.618028 -122.358532", rain$ind)
#rain$ind <- sub("RG12", "47.643205 -122.393554", rain$ind) # no RG13
#rain$ind <- sub("RG14", "47.583939 -122.382968", rain$ind)
#rain$ind <- sub("RG15", "47.565439 -122.339688", rain$ind)
#rain$ind <- sub("RG16", "47.527203 -122.304678", rain$ind)
#rain$ind <- sub("RG17", "47.516310 -122.318071", rain$ind)
#rain$ind <- sub("RG18", "47.545982 -122.268642", rain$ind) # no RG19
#rain$ind <- sub("RG20_25", "47.614766 -122.294049", rain$ind)

#   separate lat/long into 2 different columns
#rain <- separate(rain, ind, c("lat", "long"), sep = " ", convert = TRUE, as.is = TRUE)
#   coverting rainfall to numeric 
#rain <- rain %>% mutate(values = as.numeric(values))

# delete the year from all dates
rain$date <- substring(rain$date, 1, 5)
# change dates to Date format (automatically changes all years to 2018,
# so we can select by month & day only)
rain$date <- as.Date(rain$date, format = "%m/%d")
# remove na values
rain <- na.omit(rain)

# separate data by season
spring_rain <- rain[rain$date >= "2018-03-01" & rain$date <= "2018-05-31",]
summer_rain <- rain[rain$date >= "2018-06-01" & rain$date <= "2018-08-31",]
autumn_rain <- rain[rain$date >= "2018-09-01" & rain$date <= "2018-11-30",]
winter_rain <- rain[rain$date >= "2018-12-01" | rain$date <= "2018-02-28",]

# grouping the data by location, and finding the mean rainfall for each
spring_rain_averages <- aggregate(spring_rain, list(spring_rain$lat), mean) %>% as.data.frame()
summer_rain_averages <- aggregate(summer_rain, list(summer_rain$lat), mean) %>% as.data.frame()
autumn_rain_averages <- aggregate(autumn_rain, list(autumn_rain$lat), mean) %>% as.data.frame()
winter_rain_averages <- aggregate(winter_rain, list(winter_rain$lat), mean) %>% as.data.frame()
# delete unnecessary rows
spring_rain_averages <- spring_rain_averages[,-1]
spring_rain_averages <- spring_rain_averages[,-4]
summer_rain_averages <- summer_rain_averages[,-1]
summer_rain_averages <- summer_rain_averages[,-4]
autumn_rain_averages <- autumn_rain_averages[,-1]
autumn_rain_averages <- autumn_rain_averages[,-4]
winter_rain_averages <- winter_rain_averages[,-1]
winter_rain_averages <- winter_rain_averages[,-4]

# ---- WEATHER DATA TRANSFORMATION ----

### reading in 2gb file of raw data
# weather_data <- data.table::fread("data/Road_Weather_Information_Stations.csv", header = TRUE, stringsAsFactors = FALSE)

### selecting only Station Location, Air Temperature, DateTime columns
# select_loc_air <- select(weather_data, StationLocation, AirTemperature, DateTime)

### separating latitude and longitude single column numbers into two columns 
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



