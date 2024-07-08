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

#Function to query monsters or spell data from DND API depending on user input. #First it initializes a list to store multiple urls. Then it creates a "base" url that contains everything except page numbers. Next, an ifelse statement determines the number of pages needing to be pulled depending on whether monsters or spells were selected. A for loop then pastes together the base_url with numbers 1:n, thereby creating a url and adding it to the list for each page. We then create another function called "get_url" that takes a url input and then goes through the steps of pulling data from the API and reformatting this to a tibble. Finally, we use the map_df function to apply this function across all of the urls contained in the url list, and to store these all in the dnd_binded_tbl.

get_dnd_api <- function(category){
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

#Function to clean monsters data.
#This function will: 1) change alignments to all lowercase to reduce number of categories; 2) convert size, and alignment to factors; 3) select the subset of relevant columns; 4) group by alignment and then filter out alignment factors with fewer than 30 monsters; 5) create new variables representing what we call the "moral" and "legal" aspects of alignment.

clean_monsters <- function(dnd_binded_tbl){
  dnd_binded_tbl$alignment <- tolower(dnd_binded_tbl$alignment)
  dnd_binded_tbl$type <- tolower(dnd_binded_tbl$type)
  dnd_monsters_tbl <- dnd_binded_tbl |>
    mutate(size = as.factor(size),
           alignment = as.factor(alignment)) |>
    select(name, size, type, alignment, hit_points, strength, 
           dexterity, constitution, intelligence, wisdom, charisma) |>
    group_by(alignment) |>
    filter(n() > 30) |>
    mutate(legal = ifelse(
        alignment %in% c("lawful good", "lawful neutral", "lawful evil"), "lawful",         ifelse(alignment %in% c("neutral good", "neutral", "neutral evil"), 
             "neutral",
             ifelse(alignment %in% c("chaotic good", "chaotic neutral",
                          "chaotic evil"), "chaotic", "unaligned")))) |>
    mutate(moral = ifelse(
      alignment %in% c("chaotic good", "lawful good", "neutral good"), "good",
      ifelse(alignment %in% c("chaotic neutral", "lawful neutral", "neutral"), 
             "neutral",
             ifelse(alignment %in% c("chaotic evil", "lawful evil", "neutral evil"
                                      ), "evil", "unaligned")))) 
}

#Function to clean spells data.
#This function will change schools to all lowercase to reduce redundancy, convert school and components variables to factors, create separate columns for each character class with TRUE/FALSE indicator of whether or not they can perform theat spell, and select relevant columns.

clean_spells <- function(dnd_binded_tbl){
  dnd_binded_tbl$school <- tolower(dnd_binded_tbl$school)
  dnd_spells_tbl <- dnd_binded_tbl |>
    mutate(school = as.factor(school),
        componentsM = gsub('M', 'Material', components),
        componentsMS = gsub('S', 'Somatic', componentsM),
        componentsMSV = gsub('V', 'Verbal', componentsMS),
        components_recode = gsub(', ', '&', componentsMSV),
        Bard = ifelse(grepl("Bard", dnd_class), TRUE, FALSE),
        Cleric = ifelse(grepl("Cleric", dnd_class), TRUE, FALSE),
        Druid = ifelse(grepl("Druid", dnd_class), TRUE, FALSE),
        Paladin = ifelse(grepl("Paladin", dnd_class), TRUE, FALSE),
        Ranger = ifelse(grepl("Ranger", dnd_class), TRUE, FALSE),
        Sorcerer = ifelse(grepl("Sorcerer", dnd_class), TRUE, FALSE),
        Warlock = ifelse(grepl("Warlock", dnd_class), TRUE, FALSE),
        Wizard = ifelse(grepl("Wizard", dnd_class), TRUE, FALSE)) |>
    select(name, school, spell_level, dnd_class, components, Bard, Cleric, 
           Druid, Paladin, Ranger, Sorcerer, Warlock, Wizard, components_recode)
}

#Combined Function: The "download_data" wrapper function first calls the get_dnd_api function with user input of category, storing this temporarily as "result". An if statement then executes one of two different cleaning scripts depending on which category was selected. Finally, the output is returned as "dnd_data_tbl".

download_data <- function(category = "monsters") {
  result <- get_dnd_api(category) 
    if(category == "monsters"){
      dnd_data_tbl <- clean_monsters(result)
    } else {
      dnd_data_tbl <- clean_spells(result)
    }
  return(dnd_data_tbl)
  #write.csv(dnd_data_tbl, "data.csv")
}

