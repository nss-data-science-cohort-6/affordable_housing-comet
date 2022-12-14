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

    data_filtered <- data %>% 
      filter(id == ah_id)
    
  })
  
  output$filtered_table <- renderDataTable({
    data_filtered()
  })

})
