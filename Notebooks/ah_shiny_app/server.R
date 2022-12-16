shinyServer(function(input, output) {
  
  ah_filtered <- reactive({
    if (input$ah == 'All'){
      return(ah_info)
    }
    
    return(ah_info %>% 
             filter(id == input$ah)
           )
    
  })
  
  filtered_house <- reactive({
    if (input$ah == 'All'){
      return(filtered_ah %>% 
               select(apn, amount, date, tract, dist, group, tpost, age)
             )}
    return(filtered_ah %>% 
             filter(id == input$ah) %>% 
             select(apn, amount, date, tract, dist, group, tpost, age)
             )
  })
  
  output$filteredahTable <- renderDataTable({
    ah_filtered()
    })
  
  output$filteredhouseTable <- renderDataTable({
    filtered_house()
    })
  
  output$scatterPlot <- renderPlot({
    filtered_house() %>% 
      ggplot(aes(y = amount, x = date, col = group)) +
        geom_point()
  })
})