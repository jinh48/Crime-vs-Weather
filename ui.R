# library packages to use
library(shiny)
library(shinyWidgets)
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



# creating the ui 
ui <- fluidPage(
  
  # setting the background color
  setBackgroundColor(
    color = "#f9f1f1"
  ),
  
  # creates our header 
  headerPanel(HTML("<center><em>Crime VS Weather</em></center>")),
  titlePanel(HTML("<center>Rachel Kisela, Jin Ning Huang, Nikolai Liang</center>")),
  
  # creates our sidebar for widgets and main panel
  sidebarLayout(
   sidebarPanel(
     # makes draggable and moveable widget
     fixedPanel(
       # creates input to change between seasons
       selectInput("pie", h4(HTML("<center>Select Season (Drag Me Around):</center>")), width = "80%",
                   c("Winter" = "pickWinter", "Spring" = "pickSpring",
                     "Summer" = "pickSummer", "Fall" = "pickFall")), draggable = T, cursor = c("auto",
                                                                                               "move", "default", "inherit"),
       tags$head(tags$style(HTML(".selectize-input {height: 60px; width: 200px; font-size: 30px;}")))),
     
     # adds a paragraph description
     HTML("<br><br><br><br><br><br><br>
          <strong>Notes on statistical analysis:</strong><br>
          Using our pie chart results of the total crimes for each season, we've statistically compared
          the difference in means using R.<br>
          First, we assumed both summer & winter populations are normally distributed:<br>
          <code> summer_normal_dist <- rnorm(97689)<br>
          winter_normal_dist <- rnorm(89726)</code><br>
          Then, we performed a Welch's t-test for two populations with unknown variances:<br>
          <code>t.test(summer_normal_dist, winter_normal_dist)</code><br>
          This returned a 95% confidence interval of (-0.0007, 0.01748). Because this confidence interval
          includes zero, we <strong>cannot</strong> definitively conclude that there is a difference in population 
          means of total crime between winter and summer in Seattle. <em>However</em>, the confidence interval
          is skewed - a 92% confidence interval of the same test type produces (0.0002, 0.01642).
          We think that the link between weather and crime, although not conclusive, warrants 
          further investigation, especially after researching about its previous studies in academia.
          <br><br><br><br>
          <em>Check the README file for information on where this data comes from!</em>")),
   
    # creates the main panel where plots will be displayed
    mainPanel(
      # creates paragraph
      h4(HTML("The link between crime and precipitation is 
         almost ubiquitously agreed upon in the world of criminology. 
         If the relationship between crime and weather is determined to a sufficient degree of 
         accuracy, police resources can be allocated in a predictive manner throughout the year, saving time, 
         taxpayer money, and possibly even lives. In Seattle, a city with an extremely uneven distribution of 
         crime, any predictions we can make about where and when to send police resources is valuable information.
         <br><br>
         <center><em>This is the area of Seattle that we will be examining:</em></center>"), style = "background-color:white"),
      
      # outputting the google map plot
      google_mapOutput(outputId = "mapPlot"),
      
      # outputting the pie plot
      plotOutput("piePlot"),
      
      # outputting the dynamic text depending on the input
      h3(textOutput("text")),
      
      # outputting another description paragraph for 3D plot
      h4(HTML("<center><em>Drag the 3D Plot around to get different views. Hover over the dot to get more info.<em><center>")),
      
      # outputting the 3D plot
      plotlyOutput("plot3d"),
      h3(HTML("<center>While there are changes between seasons in number of crimes, the type of crime does not fluctuate, 
              as seen below:</center>")),
      h4(HTML("<center><em>Click through the seasons to see the changing in type of crime.</em></center>")),
      
      # outputting the bar graphs
      plotlyOutput("graph")
    )
  )
)


shinyUI(ui)