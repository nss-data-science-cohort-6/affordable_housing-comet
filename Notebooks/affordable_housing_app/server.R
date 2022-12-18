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
    data_filtered()
  })
  
  
  output$graph_1 <- renderPlot({
    
      data_filtered() %>% 
      group_by(ownerdate, group) %>% 
      summarise(median_amt = median(amount)) %>% 
      ggplot(aes(x = ownerdate, y = median_amt, color = group))+
        geom_line()+
        geom_point()
  })

  
  output$distPlot <- renderPlot({
    
    data_filtered() %>% 
      ggplot(aes(x = amount)) +
      geom_histogram(bins = input$bins) +
      labs(title = paste('Distribution of Home sale price for', input$ah_project_address))
    
  })
  
  output$plot <- renderPlot({
    data_filtered() %>% 
      ggplot(aes(x = ownerdate, y = amount, color = group)) + 
      scale_y_log10() + 
      geom_point() + 
      facet_wrap(~ prox) + 
      geom_smooth(method = lm)
  })
  
  output$mymap <- renderLeaflet({
    
    ### REPLACE LEAFLET CODE ###
    leaflet(options = leafletOptions(minZoom = 6)) %>%
      addProviderTiles(provider = "CartoDB.Positron") %>%
      setView(lng = -86.7816, lat = 36.1627, zoom = 10) %>%
      setMaxBounds(lng1 = -86.7816 + 1, 
                   lat1 = 36.1627 + 1, 
                   lng2 = -86.7816 - 1, 
                   lat2 = 36.1627 - 1) %>%
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
