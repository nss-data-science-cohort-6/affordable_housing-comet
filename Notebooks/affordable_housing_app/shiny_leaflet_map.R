library(shiny)
library(leaflet)
library(sf)

### READ IN RDS FILES ###
dev <- readRDS("dev.rds")
prop_near_dev <- readRDS("prop_near_dev.rds")

ui <- fluidPage(
  leafletOutput("mymap")
)

server <- function(input, output, session) {
  
  output$mymap <- renderLeaflet({
    
    ### REPLACE LEAFLET CODE ###
    leaflet(options = leafletOptions(minZoom = 6)) %>%
      addProviderTiles(provider = "CartoDB.Positron") %>%
      setView(lng = -86.7816, lat = 36.1627, zoom = 10) %>%
      setMaxBounds(lng1 = -86.7816 + 1, 
                   lat1 = 36.1627 + 1, 
                   lng2 = -86.7816 - 1, 
                   lat2 = 36.1627 - 1) %>%
      addPolygons(data = sf_circles, 
                  weight = 1, 
                  opacity = 0.5)%>%
      addCircleMarkers(data = dev,
                       radius = 1,
                       color = "white",
                       weight = 0.25,
                       fillColor = "red",
                       fillOpacity = 0.75,
                       label = ~label)%>%
      addCircleMarkers(data = prop_near_dev,
                       radius = 1,
                       color = "white",
                       weight = 0.25,
                       fillColor = "green",
                       fillOpacity = 0.75,
                       label = ~ownerdate)
    
    
  })
}

shinyApp(ui, server)