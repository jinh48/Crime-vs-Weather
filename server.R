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
#View(crime)

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
             color = "red", inherit.aes = FALSE)

three_d <- ploy_ly(crime, x = crime$Longitude, y = crime$Latitude, z = crime$Reported.Time)

server <- function(input, output) {
  output$mapPlot <- renderPlot(washington_base)
  outout$threeDplot <- renderPlot()
}


shinyServer(server)