library(shiny)
library(plotly)
library(dplyr)
library(lubridate)
library(ggplot2)
library(ggmap)
library(data.table)
library(ggrepel)
# library(rworldmap)
# library(rworldxtra)
library(maps)
library(mapdata)

source("process_data.R")
# View(crime)

# ---- SETTING UP WASHINGTON CRIME DATA ---- #
states <- map_data("state")
washington <- subset(states, region == "washington")
counties <- map_data("county")
wa_county <- subset(counties, region == "washington")

  washington_base <- ggplot(data = washington, mapping = aes(x = long, y = lat, group = group)) +
   geom_polygon(fill = "palegreen", color = "black") +
   coord_fixed(xlim = c(-122.36, -123.33), ylim = c(47,47.99), ratio = 1) +
   theme_nothing() +
   geom_polygon(data = wa_county, fill = NA, color = "white") +
   geom_polygon(color = "black", fill = NA) +
   geom_point(data = crime, mapping = aes(x = crime$Longitude, y = crime$Latitude),
              color = "red", inherit.aes = FALSE) #+
   # geom_tile(aes(fill = weather)) #+ 
   #scale_fill_gradient(low = "darkgreen", high = "lightgreen")


# ---- SETTING UP PIE CHARTS FOR SEASON ---- #

# Setting up the pie charts:
# create a new data frame for the purpose of the pie charts
crime_pie <- crime
# delete the year from all dates
crime_pie$Occurred.Date <- substring(crime_pie$Occurred.Date, 1, 5)
# change dates to Date format (automatically changes all years to 2018,
# so we can select by month & day only)
crime_pie$Occurred.Date <- as.Date(crime_pie$Occurred.Date, format = "%m/%d")
# separate data by season
spring <- crime_pie[crime_pie$Occurred.Date >= "2018-03-01" & crime_pie$Occurred.Date <= "2018-05-31",]
summer <- crime_pie[crime_pie$Occurred.Date >= "2018-06-01" & crime_pie$Occurred.Date <= "2018-08-31",]
autumn <- crime_pie[crime_pie$Occurred.Date >= "2018-09-01" & crime_pie$Occurred.Date <= "2018-11-30",]
winter <- crime_pie[crime_pie$Occurred.Date >= "2018-12-01" | crime_pie$Occurred.Date <= "2018-02-28",]

# create reusable function to make list of slice values for each season
make_slices <- function(df) {
  df <- aggregate(df, by = list(df$Crime.Subcategory), FUN = NROW)
  vector <- df[,3]
}

spring_slices <- make_slices(spring)
summer_slices <- make_slices(summer)
autumn_slices <- make_slices(autumn)
winter_slices <- make_slices(winter)

labels <- as.vector(unique(crime_pie$Crime.Subcategory))

# remove  labels for categories with less than 3-digit counts,
# to make pie chart more readable
labels[nchar(spring_slices) < 4] = NA
labels[nchar(summer_slices) < 4] = NA
labels[nchar(autumn_slices) < 4] = NA
labels[nchar(winter_slices) < 4] = NA

percentages <- round(spring_slices / sum(spring_slices) * 100)

# function to make pie 
make_pie <- function(df, string, input, output) {
  pie(df, labels = labels, col = rainbow(length(labels)),
      main = paste0(string, " Crimes Pie Chart"), cex = 1) 
  
  lower <- tolower(string)
  slices <- eval(as.name(paste0(lower, "_slices")))
  

  sum <- sum(slices)
  output$text <- renderText({
    result <- switch (input$pie,
      pickWinter = paste0("There were ", sum, " recorded crimes in ", lower, " from 1975 to 2018."),
      pickSpring = paste0("There were ", sum, " recorded crimes in ", lower, " from 1975 to 2018."),
      pickSummer = paste0("There were ", sum, " recorded crimes in ", lower, " from 1975 to 2018."),
      pickFall = paste0("There were ", sum, " recorded crimes in ", lower, " from 1975 to 2018."))})
}


# ---- SERVER FUNCTIONS ---- #
  
server <- function(input, output) {
  output$mapPlot <- renderPlot(washington_base)
  
  output$piePlot <- renderPlot({
    result <- switch(input$pie,
                     pickWinter = make_pie(winter_slices, "Winter", input, output),
                     pickSpring = make_pie(spring_slices, "Spring", input, output),
                     pickSummer = make_pie(summer_slices, "Summer", input, output),
                     pickFall = make_pie(autumn_slices, "Autumn", input, output))
    
  })
  
}


# hover to find percentages?

# output$event <- renderPrint({
#  d <- event_data("plotly_hover")
#  if (is.null(d)) "Hover on a point to get info about it!" else d
# })


shinyServer(server)
