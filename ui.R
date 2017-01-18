library('dplyr')
library('ggplot2')
library('ggmap')
library('shiny')
library('leaflet')
source("data.R")

shinyUI(
  bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 150,
                sliderInput("date", "Date",
                            min(dataNoZLoc$DATE),
                            max(dataNoZLoc$DATE),
                            value = range(dataNoZLoc$DATE)
                )
  )
)
)