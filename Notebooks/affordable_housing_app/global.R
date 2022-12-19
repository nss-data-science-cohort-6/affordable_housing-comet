library(shiny)
library(tidyverse)
library(shinydashboard)
library(leaflet)
library(sf)
options(scipen = 10000)

# data <- read.csv("data/filtered_ah_data.csv")
data <- readRDS("data/nearli_sales.rds")
LIHTC_data <- read.csv("data/LIHTC_updated.csv")
barnes_data <- read.csv("data/barnes.csv") %>% 
  mutate(ID = c("B1","B2","B3","B4","B5","B6","B7","B8","B9"))

#Match columns for code 
data <- data %>% 
  rename(id = li_id)

data <- data %>%
  mutate(prox = 
           case_when(
             group == "pre" | group == "mid" | group == "post" ~ "near",
             group == "outside" ~ "far",
             TRUE ~ "other"
           )
  )


address <- c("All", LIHTC_data$PROJ_ADD, barnes_data$Street.Address)
ID <- c("All", LIHTC_data$HUD_ID, barnes_data$ID)

unique_ah_ids <- data %>%
              select(id) %>% 
              unique()

ah_address_and_ID <- tibble(address, ID) %>% 
  filter(ID %in% c("All", unique_ah_ids$id))


prop_near_dev <- readRDS("data/properties.rds")
prop_near_dev <- prop_near_dev %>% mutate(across('HUD_ID', str_replace, 'BARNES00', 'B'))

dev <- readRDS("data/dev.rds")
dev <- dev %>% mutate(across('HUD_ID', str_replace, 'BARNES00', 'B'))%>%
  filter(HUD_ID %in% (prop_near_dev%>%
                        pull(HUD_ID)%>%
                        unique()))


sf_circles <- st_buffer(dev, dist = 804.5)
sf_circles <- sf_circles %>% 
  mutate(across('HUD_ID', str_replace, 'BARNES00', 'B'))%>%
  filter(HUD_ID %in% (prop_near_dev%>%
           pull(HUD_ID)%>%
           unique()))

ah_address_and_ID <- prop_near_dev%>%
  select(ID = HUD_ID)%>%
  distinct()%>%
  inner_join(ah_address_and_ID)%>%
  add_row(ID = "All", address = "All", .before = 1)
