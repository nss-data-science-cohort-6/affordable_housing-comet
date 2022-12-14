library(shiny)
library(tidyverse)
library(shinydashboard)


data <- read.csv("data/filtered_ah_data.csv")
LIHTC_data <- read.csv("data/LIHTC_updated.csv")
barnes_data <- read.csv("data/barnes.csv") %>% 
  mutate(ID = c("B1","B2","B3","B4","B5","B6","B7","B8","B9"))

address <- c(LIHTC_data$PROJ_ADD, barnes_data$Street.Address)
ID <- c(LIHTC_data$HUD_ID, barnes_data$ID)

unique_ah_ids <- data %>%
              select(id) %>% 
              unique()

ah_address_and_ID <- tibble(address, ID) %>% 
                        filter(ID %in% unique_ah_ids$id)
                        
                      
                

