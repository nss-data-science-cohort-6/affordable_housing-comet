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
  
  navbarPage(title = "Affordable Housing Anaylsis",
             
             tabPanel(title = "Graphs",
                      
                      
                      dashboardSidebar(
                        
                        selectInput(
                          "ah_project_address",
                          "Select an AH project:",
                          choices = ah_address_and_ID$address
                        )
                      ),
                      
                      dashboardBody(
                        #geom_smooth for scatter of home prices, vertical line to show when ah project was put up 
                        
                        fluidRow(
                         
                          column(
                            width = 12,
                            plotOutput("plot")
                            
                          )
                        ),
                        
                        fluidRow(
                          dataTableOutput("filtered_table"),style = "height:500px; overflow-y: scroll;overflow-x: scroll;"
                        )
                      )
             ),
             tabPanel(title = "Map",
                      
                      dashboardBody(
                        # tags$style(type = "text/css", "html, body {width:100%; height:100%}"),
                  
                        leafletOutput("mymap")
                        
                      )
             )
  )
  
  
)
