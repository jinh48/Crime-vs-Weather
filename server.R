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

states <- map_data("state")
washington <- subset(states, region == "washington")
counties <- map_data("county")
wa_county <- subset(counties, region == "washington")

  washington_base <- ggplot(data = washington, mapping = aes(x = long, y = lat, group = group)) +
   geom_polygon(fill = "palegreen", color = "black") +
   coord_fixed(xlim = c(-123, -121), ylim = c(47,48), ratio = 1.3) +
   theme_nothing() +
   geom_polygon(data = wa_county, fill = NA, color = "white") +
   geom_polygon(color = "black", fill = NA) +
   geom_point(data = crime, mapping = aes(x = crime$Longitude, y = crime$Latitude),
              color = "red", inherit.aes = FALSE) # +
  # CHANGE WEATHER FILE NAME: geom_tile(aes(fill = weather_df)) + 
  # scale_fill_gradient(low = "darkgreen", high = "lightgreen")

server <- function(input, output) {
  output$mapPlot <- renderPlot(washington_base)

  output$plot <- renderPlotly({
    # creates main 3d plot
    plot_ly( crime,
            x = crime$Crime.Subcategory, y = crime$Neighborhood, z = crime$Occurred.Date, 
            type = "scatter3d", mode="markers", text = crime$Primary.Offense.Description,
            marker = list(
              size = 10,
              color = "rgba(63, 191, 191, .9)",
              line = list(
                color = "rgba(152, 0, 0, 1)",
                width = 2
              )
            )
    ) %>% # creates title line
      layout(
        title = "Crime Data of Washington ",
        yaxis = list(zeroline = FALSE),
        xaxis = list(zeroline = FALSE)
      )
  })
  
  # adds in hovering info
  output$event <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) "Hover on a point to get info about it!" else d
  })
}

# Setting up the pie charts:
# create a new data frame for the purpose of the pie charts
crime_pie <- crime
# delete the year from all dates
crime_pie$Occurred.Date <- substring(crime_pie$Occurred.Date, 1, 5)
# change dates to Date format (automatically changes all years to 2018)
crime_pie$Occurred.Date <- as.Date(crime_pie$Occurred.Date, format = "%m/%d")
# separate data by season
spring <- crime_pie[crime_pie$Occurred.Date >= "2018-03-01" & crime_pie$Occurred.Date <= "2018-05-31",]
summer <- crime_pie[crime_pie$Occurred.Date >= "2018-06-01" & crime_pie$Occurred.Date <= "2018-09-01",]
autumn <- crime_pie[crime_pie$Occurred.Date >= "2018-10-01" & crime_pie$Occurred.Date <= "2018-11-30",]
winter <- crime_pie[crime_pie$Occurred.Date >= "2018-12-01" | crime_pie$Occurred.Date <= "2018-02-28",]
# create reusable function to make list of slice values for each season
make_slices <- function(df) {
  df <- aggregate(df, by = list(df$Crime.Subcategory), FUN = NROW)
  vector <- df[,3]
}

spring_slices <- make_slices(spring)
summer_slices <- make_slices(summer)
autumn_slices <- make_slices(spring)
winter_slices <- make_slices(winter)

# remove labels for small categories to make pie chart more readable
labels <- unique(crime_pie$Crime.Subcategory)
if (labels[])

percentages <- round(spring_slices / sum(spring_slices) * 100)
lbls <- paste(labels, percentages) # add percents to labels 
lbls <- paste(labels, "%", sep="") # add % to labels 
pie(spring_slices, labels = labels, col = rainbow(length(labels)),
    main="Spring Crimes Pie Chart")

?pie

shinyServer(server)
