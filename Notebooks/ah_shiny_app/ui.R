shinyUI(
  dashboardPage(
    
    dashboardHeader(
      title = "Affordable Housing Data"
    ),
    
    dashboardSidebar(
      selectInput(
        "ah",
        "Select an Affordable Housing Unit",
        choices = c('All',
                    ah_info %>% 
                      pull(id) %>% 
                      unique() %>% 
                      sort()
                    )
        )
    ),
    
    dashboardBody(
      
      fluidRow(
        dataTableOutput('filteredahTable')
      ),
      fluidRow(
        dataTableOutput('filteredhouseTable')
      ),
      fluidRow(
        plotOutput('scatterPlot')
      )
    )
  )
)