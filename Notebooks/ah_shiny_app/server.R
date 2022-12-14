shinyServer(function(input, output) {
  
  output$filteredTable <- renderDataTable({
    filtered_ah
  })
})