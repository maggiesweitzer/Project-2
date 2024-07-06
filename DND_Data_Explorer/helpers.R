#######################################################
##Title: DND_Data_Explorer Helpers Script
##Author: Maggie Sweitzer
##Date: July 6, 2024
##Purpose: Helper script for ST558 Project 2 Shiny App
#######################################################

#Load necessary libraries
library(jsonlite)
library(httr)
library(tidyverse)
library(purrr)
library(eulerr)
library(ggforce)
library(shiny)

#Function to query monsters or spell data from DND API depending on user input
get_dnd_api <- function(category = "monsters"){
  urls <- list()
  base_url <- paste0(
    "https://api.open5e.com/v1/", category, "/?format=json&page=")
  
  ifelse(category %in% c("monsters"), 
         n <- 57, 
         n <- 29)
  
  for (i in 1:n){
    urls[[i]] <- paste0(base_url, i)
  }
  get_url <- function(url){
    dnd_return <- httr::GET(url) 
    dnd_parsed <- fromJSON(rawToChar(dnd_return$content))
    dnd_tbl <- as_tibble(dnd_parsed$results)
    dnd_binded_tbl <- bind_rows(dnd_tbl)
  }
  dnd_binded_tbl <- map_df(urls, get_url)
}

#Function to clean monsters data and save csv


#Function to clean spells data and save csv
