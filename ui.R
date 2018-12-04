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
                  value = 100)),
    sideerInput(
      selectInput("color", "Select Color:", c("Regular" = "pickREG", "Rainbow" = "pickRAIN"))
    ),
    mainPanel(
      plotOutput("mapPlot")
    )
  )
)

shinyUI(ui)