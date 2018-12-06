library(shiny)
library(shinyWidgets)
library(rsconnect)

ui <- fluidPage(
  setBackgroundColor(
    color = "#f9f1f1"
  ),
  
  headerPanel(HTML("<center><em>Crime VS Weather</em></center>")),
  titlePanel(HTML("<center>Rachel Kisela, Jin Ning Huang, Nikolai Liang</center>")),
  
  fixedPanel(
    selectInput("pie", "Select Season:",
                c("Winter" = "pickWinter", "Spring" = "pickSpring",
                  "Summer" = "pickSummer", "Fall" = "pickFall")), draggable = T),
  
  
 sidebarLayout(
   sidebarPanel(
     # sliderInput("date", "Date:",
     #             min = 0, max = 1000,
     #             value = 0),
     selectInput("pie", "Select Season:",
       c("Winter" = "pickWinter", "Spring" = "pickSpring",
        "Summer" = "pickSummer", "Fall" = "pickFall"))),
    mainPanel(
      h4("The link between crime and precipitation is 
         almost ubiquitously agreed upon in the world of criminology. 
         If the relationship between crime and weather is determined to a sufficient degree of 
         accuracy, police resources can be allocated in a predictive manner throughout the year, saving time, 
         taxpayer money, and possibly even lives. In Seattle, a city with an extremely uneven distribution of 
         crime, any predictions we can make about where and when to send police resources is valuable information.", style = "background-color:white"),
      google_mapOutput(outputId = "mapPlot"),
      plotOutput("piePlot"),
      h2(textOutput("text")),
      plotlyOutput("plot3d")
    )
  )
)


shinyUI(ui)