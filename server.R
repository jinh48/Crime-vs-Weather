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


shinyServer(server)
