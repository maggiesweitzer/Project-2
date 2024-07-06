#######################################################
##Title: DND_Data_Explorers UI Script
##Author: Maggie Sweitzer
##Date: July 6, 2024
##Purpose: User-interface script for ST558 Project 2 Shiny App.
##This is the user-interface definition of a Shiny web application. You can
##run the application by clicking 'Run App' above.
########################################################

library(shiny)
library(shinyWidgets)

tabsetPanel(
  tabPanel("About",
           setBackgroundColor("lightgray"),
           fluidRow(img(src = "DND_Img.jpg")), 
           fluidRow(
              column(1),
              column(10, h3("Welcome to the DND Data Explorer!")),
              column(1)),
            fluidRow(
             column(1),
             column(10, h4("This app will allow you to query the Dungeons & Dragons API (https://api.open5e.com/v1/) to explore data on monsters or spells. First, choose which data you want to explore (monsters or spells) using the Data Download tab. This will query the selected API endpoint and store the resulting data set as a .csv file."), 
                    br(),
                    h4("Next, choose the corresponding Data Exploration tab to view the data!")),
           column(1))),
  tabPanel("Data Download",
           fluidRow(
             column(1),
             column(10, h3("Download the Data You Want to Explore!")),
             column(1)),
           br(),
           fluidRow(
             column(4),
             column(4,
             selectInput("data_type", "Choose a Dataset",
                          choices = c("Monsters", "Spells"))),
             column(4)),
             br(),
           fluidRow(
             column(4),
             column(4,
             actionButton("go", "Download")),
             column(4))
       ),
  tabPanel("Data Exploration",
      fluidPage(
      titlePanel("Old Faithful Geyser Data"),
      
      # Sidebar with a slider input for number of bins
      sidebarLayout(
        sidebarPanel(
          sliderInput("bins",
                      "Number of bins:",
                      min = 1,
                      max = 50,
                      value = 30)
        ),
        #conditionalPanel(condition = "input.bins == 5",
        #                selectInput("breaks", "Breaks",
        #                           c("Option1", "Option2", "custom")),
        #              conditionalPanel(
        #               condition = "input.breaks == 'custom'",
        #              sliderInput("breakCount", "Break Count", min =))),
        
        # Show a plot of the generated distribution
        mainPanel(
          plotOutput("distPlot")
        )
      )
    )
)
)

