#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# Define UI for application that draws a histogram
shinyUI(
  
  dashboardPage(
    
    dashboardHeader(title = "Affordable Housing Anaylsis"),
    
    dashboardSidebar(
      
      selectInput(
        "ah_project_address",
        "Select an AH project:",
        choices = ah_address_and_ID$address
      ),
      
      sliderInput("bins",
                  "Number of bins for home price histogram:",
                  min = 1,
                  max = 50,
                  value = 30)
      
    ),
    
    
    dashboardBody(
      #geom_smooth for scatter of home prices, vertical line to show when ah project was put up 
      
      fluidRow(
        column(
          width = 6,
          plotOutput("graph_1")
        ),
        column(
          width = 6,
          plotOutput("distPlot")
          
        )
      ),
      
      fluidRow(
        dataTableOutput("filtered_table")
        )
    )
  )
  
)
