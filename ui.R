library(shiny)
library(rsconnect)

ui <- fluidPage(
  
  titlePanel("Crime vs Weather"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("date", "Date:",
                  min = 0, max = 1000,
                  value = 0),
      sliderInput("zoom", "Zoom In/Out (%):",
                  min = 0, max = 100,
                  value = 100),
      selectInput("pie", "Select Season:",
        c("Winter" = "pickWinter", "Spring" = "pickSpring",
          "Summer" = "pickSummer", "Fall" = "pickFall"))),
    mainPanel(
      plotOutput("mapPlot"),
      plotOutput("piePlot"),
      textOutput("text")
    )
  )
)


shinyUI(ui)