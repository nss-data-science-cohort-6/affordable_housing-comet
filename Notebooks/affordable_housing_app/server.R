#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  data_filtered <- reactive({
    
    ah_id <- ah_address_and_ID %>% 
      filter(address == input$ah_project_address) %>% 
      select(ID)
    if (ah_id == 'All'){
      data_filtered <- data
    }
    else {
      
      data_filtered <- data %>% 
        filter(id == ah_id[[1,1]])}
    
  })
  
  dev_filtered <- reactive({
    
    ah_id <- ah_address_and_ID %>% 
      filter(address == input$ah_project_address) %>% 
      select(ID)
    
    if (ah_id == 'All'){
      dev_filtered <- dev
    }
    else {
      
      dev_filtered <- dev %>% 
        filter(HUD_ID == ah_id[[1,1]])}
    
  })
  sf_circles_filtered <- reactive({
    
    ah_id <- ah_address_and_ID %>% 
      filter(address == input$ah_project_address) %>% 
      select(ID)
    if (ah_id == 'All'){
      sf_circles_filtered <- sf_circles
    }
    else {
      
      sf_circles_filtered <- sf_circles %>% 
        filter(HUD_ID == ah_id[[1,1]])}
    
  })
  prop_near_dev_filtered <- reactive({
    
    ah_id <- ah_address_and_ID %>% 
      filter(address == input$ah_project_address) %>% 
      select(ID)
    if (ah_id == 'All'){
      prop_near_dev_filtered <- prop_near_dev
    }
    else {
      
      prop_near_dev_filtered <- prop_near_dev %>% 
        filter(HUD_ID == ah_id[[1,1]])}
    
  })
  
  output$filtered_table <- renderDataTable({
    data_filtered() %>% 
      select(-amount, -id, -prox) %>% 
      rename(`Sale Date` = ownerdate,
             `Sale Group` = group)
  })
  
  
  
  output$plot <- renderPlot({
    data_filtered() %>% 
      ggplot(aes(x = as.Date(ownerdate), y = amount, color = group)) + 
      xlab("Date of Home Sale")+
      ylab("Sell Price ($)")+
      scale_y_log10() + 
      geom_point() + 
      facet_wrap(~ prox) +
      geom_smooth(method = lm)+
      scale_x_date(date_labels = "%Y %b %d")+
      theme(axis.text.x = element_text(angle = 45, vjust = .5))
    
  })
  
  r_zoom <- reactive({
    if (input$ah_project_address == 'All') {
      return(10)
    }
    
    else {
      return(13)
    }
  })
  
  output$mymap <- renderLeaflet({
    
    ### REPLACE LEAFLET CODE ###
    leaflet(options = leafletOptions(minZoom = 6)) %>%
      addProviderTiles(provider = "CartoDB.Positron") %>%
      setView(lng = mean(prop_near_dev_filtered()$lon),
              lat = mean(prop_near_dev_filtered()$lat)+.01,
              zoom = r_zoom()) %>%
      setMaxBounds(lng1 = max(prop_near_dev_filtered()$lon) + 1,
                   lat1 = max(prop_near_dev_filtered()$lat) + 1,
                   lng2 = min(prop_near_dev_filtered()$lon) - 1,
                   lat2 = min(prop_near_dev_filtered()$lat) - 1) %>%
      # 
      #  setView(lng = -86.7816, lat = 36.1627, zoom = 10) %>%
      # setMaxBounds(lng1 = -86.7816 + 1, 
      #              lat1 = 36.1627 + 1, 
      #              lng2 = -86.7816 - 1, 
      #              lat2 = 36.1627 - 1) %>%
      addPolygons(data = sf_circles_filtered(), 
                  weight = 1, 
                  opacity = 0.5)%>%
      addCircleMarkers(data = dev_filtered(),
                       radius = 1,
                       color = "white",
                       weight = 0.25,
                       fillColor = "red",
                       fillOpacity = 0.75,
                       label = ~label)%>%
      addCircleMarkers(data = prop_near_dev_filtered(),
                       radius = 1,
                       color = "white",
                       weight = 0.25,
                       fillColor = "green",
                       fillOpacity = 0.75,
                       label = ~label)
    
    
  })
})