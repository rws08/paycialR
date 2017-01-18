library('dplyr')
library('ggplot2')
library('ggmap')
library('shiny')
library('leaflet')

shinyServer(
  function(input, output, session) {
  filteredDataPay <- reactive({
    dataPayLoc[dataPayLoc$DATE >= input$date[1] & dataPayLoc$DATE <= input$date[2],]
  })
  
  filteredDataCheck <- reactive({
    dataCheckLoc[dataCheckLoc$DATE >= input$date[1] & dataCheckLoc$DATE <= input$date[2],]
  })
  
  output$map <- renderLeaflet({
    leaflet(dataNoZLoc) %>% 
      setView(lng = seoulLonLat[1], lat = seoulLonLat[2], zoom = 11) %>% 
      addProviderTiles("CartoDB.Positron") %>%
      addProviderTiles("Stamen.TonerLines",
                       options = providerTileOptions(opacity = 0.35)
      ) %>%
      addLayersControl(
        overlayGroups = c("Pay", "CheckIn"),
        options = layersControlOptions(collapsed = FALSE)
      )
  })
  
  observe({
    leafletProxy("map") %>%
      clearShapes() %>%
      addCircles(data = filteredDataCheck(), lng = ~LONGITUDE, lat = ~LATITUDE, 
                 popup = ~paste(REG_ID, "(", DATE, ")"), group = "CheckIn") %>%
      addCircles(data = filteredDataPay(), lng = ~LONGITUDE, lat = ~LATITUDE, 
                 popup = ~paste(REG_ID, "(", DATE, ")"), color = "#FF0000", group = "Pay")
  })
}
)