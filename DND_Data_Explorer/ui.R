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
             column(10, h4("This app will allow you to query the", a(href="https://api.open5e.com/v1/", "Dungeons & Dragons API"), "to explore data on monsters or spells. First, choose which data you want to explore (monsters or spells) using the Data Download tab. This will query the selected API endpoint and store the resulting data set as a .csv file."), 
                    br(),
                    h4("Then, choose the corresponding Data Exploration tab to view the data!")),
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
                          choices = c("monsters", "spells"))),
             column(4)),
           br(),
           fluidRow(
             column(4),
             column(4,
             actionButton("go", "Download")),
             column(4)),
           br(),
           fluidRow(
             column(11, 
                    tableOutput("data")),
             column(1))
       ),
  tabPanel("Data Exploration-Monsters",
      fluidPage(
      titlePanel("Dungeons & Dragons Monsters"),
      
      # Sidebar with a slider input for number of bins
      #sidebarLayout(
        sidebarPanel(
          h5("You can create different graphs to explore the characteristics of different types of monsters below."),
          radioButtons("plot", "Choose the Plot Type", choices = list("Bar graph of monster counts" = "bar", "Box plots of monster traits" = "box", "Scatterplot of associations between traits" = "scatter"), selected = "")
        ),
      conditionalPanel(
          condition = "input.plot == 'bar'",
          selectInput("factor", "Choose an additional factor to consider",
                      c("moral alignment" = "moral", "legal alignment" = 
                          "legal", "size"))),
      conditionalPanel(
          condition = "input.plot == 'box'",
          selectInput("trait", "Choose a trait to consider",
                      c("hit points" = "hit_points", "intelligence", "charisma", 
                        "strength", "dexterity"))),
      conditionalPanel(
          condition = "input.plot == 'scatter'",
          selectInput("primary_trait", "Choose a primary trait to consider",
                      c("hit points" = "hit_points", "strength", "charisma"), 
                      selected = "")),
          conditionalPanel(
            condition = "input.plot == 'scatter'", 
            selectInput("secondary_trait", "Choose a secondary trait to consider",
            c("intelligence", "wisdom", "dexterity"))),
          #h4("You can find the ")
          #sliderInput("bins",
           #           "Number of bins:",
            #          min = 1,
             #         max = 50,
              #        value = 30)
        #),
        #conditionalPanel(condition = "input.bins == 5",
         #               selectInput("breaks", "Breaks",
          #                         c("Option1", "Option2", "custom")),
        #              conditionalPanel(
        #               condition = "input.breaks == 'custom'",
        #              sliderInput("breakCount", "Break Count", min =))),
        
        # Show a plot of the generated distribution
        mainPanel()
          #plotOutput("distPlot"))
      )
    ),
  tabPanel("Data Exploration-Spells",
         fluidPage(
           titlePanel("Old Faithful Geyser Data"),
           
           # Sidebar with a slider input for number of bins
           sidebarLayout(
             sidebarPanel(
               sliderInput("bins",
                           "Number of bins:",
                           min = 1,
                           max = 50,
                           value = 30)),
             mainPanel(
               plotOutput("distPlot"))
           )
         ))
)


