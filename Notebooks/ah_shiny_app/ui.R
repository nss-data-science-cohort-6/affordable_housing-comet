shinyUI(
  dashboardPage(
    
    dashboardHeader(
      title = "Affordable Housing Data"
    ),
    
    dashboardSidebar(),
    
    dashboardBody(
      
      fluidRow(
        dataTableOutput('filteredTable')
      )
    )
  )
)