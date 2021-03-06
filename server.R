# library packages to use
library(shiny)
library(plotly)
library(dplyr)
library(lubridate)
library(ggplot2)
library(ggmap)
library(data.table)
library(ggrepel)
library(maps)
library(mapdata)
library(googleway)

# sourcing our data from different files
source("process_data.R")
source("key.R")

# ---- SETTING UP PIE CHARTS FOR SEASON ---- #

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

# function to make pie 
make_pie <- function(df, string, input, output) {
  pie(df, labels = labels, col = rainbow(length(labels)),
      main = paste0(string, " Crimes Pie Chart"), cex = 1) 
  lower <- tolower(string)
  slices <- eval(as.name(paste0(lower, "_slices")))
  sum <- sum(slices)
  output$text <- renderText({
    result <- switch (input$pie,
      pickWinter = paste0("There were ", sum, " recorded crimes in ", lower, " from 2002 to 2017."),
      pickSpring = paste0("There were ", sum, " recorded crimes in ", lower, " from 2002 to 2017."),
      pickSummer = paste0("There were ", sum, " recorded crimes in ", lower, " from 2002 to 2017."),
      pickFall = paste0("There were ", sum, " recorded crimes in ", lower, " from 2002 to 2017."))})
}


# ---- Make Google Heatmap ---- #

# creates function for making google map
make_map <- function(string) {
  df <- eval(as.name(string))
  df <- df[sample(nrow(df),1000),] # takes random sample of 1000 to lessen computing load
  google_map(data = df) %>%
    add_heatmap(lat = "Latitude", lon = "Longitude", option_radius = 0.05)
}


# ---- Make Bar Charts ---- #

# creates function for creating the bar plots
make_graph <- function(df, string) {
  plot_ly(df, x = ~Crime.Subcategory,
               y = ~n,
               name = paste0("Number of Crime for ", string),
               type = "bar") %>%
    layout(title = 'Number of Crime',
           xaxis = list(title = 'Crime Type'),
           yaxis = list(title = 'Number of Occurred'))
  }


# ---- SERVER FUNCTIONS ---- #
  
server <- function(input, output) {

  # output for rendering the google map
  output$mapPlot <- renderGoogle_map({
    result <- switch(input$pie,
                     pickWinter = make_map("winter"),
                     pickSpring = make_map("spring"),
                     pickSummer = make_map("summer"),
                     pickFall = make_map("autumn"))
    
  })
  
  # output to render the pie chart
  output$piePlot <- renderPlot({
    result <- switch(input$pie,
                     pickWinter = make_pie(winter_slices, "Winter", input, output),
                     pickSpring = make_pie(spring_slices, "Spring", input, output),
                     pickSummer = make_pie(summer_slices, "Summer", input, output),
                     pickFall = make_pie(autumn_slices, "Autumn", input, output))
    
  })
  
  # output to render the 3D plot
   output$plot3d <- renderPlotly({
    p <- plot_ly(crime_rain, x = ~Air.Temperature, y = ~values, z = ~x, text = ~date, colors = "#BF382A") %>% #text = ~date,
      # add_markers() %>%
      layout(scene = list(xaxis = list(title = 'Air Temperature'),
                          yaxis = list(title = 'Rain Percipitation'),
                          zaxis = list(title = 'Number of Crimes')))

  })
   # output to render the bar graphs
   output$graph <- renderPlotly({
     result <- switch(input$pie,
                      pickWinter = make_graph(sum_one, "winter"),
                      pickSpring = make_graph(sum_two, "spring"),
                      pickSummer = make_graph(sum_three, "summer"),
                      pickFall = make_graph(sum_four, "autumn"))})

}


shinyServer(server)
