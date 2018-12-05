library(shiny)
library(shinyWidgets)
library(rsconnect)

ui <- fluidPage(
  setBackgroundColor(
    color = "#336699"
  ),
  titlePanel("Crime vs Weather"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("date", "Date:",
                  min = 0, max = 1000,
                  value = 0),
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