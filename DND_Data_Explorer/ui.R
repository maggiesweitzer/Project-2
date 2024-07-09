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
             column(10, h3("Download the Data You Want to Explore!"),
                    br(),
                    h4("Here, you can choose the data you want to download and explore. Select monsters or spells, and then click the download button."),
                    h4("Please be patient! Data download can take up to a minute. When complete, a data table will be displayed in the space below. Then you are ready to explore the data!")),
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
                    DT::DTOutput("data")),
             column(1))
       ),
  tabPanel("Data Exploration-Monsters",
      fluidPage(
      titlePanel("Dungeons & Dragons Monsters"),
      
      # Sidebar with a slider input for number of bins
      sidebarLayout(
          sidebarPanel(
            fluidRow(h5("You can create different graphs to explore the characteristics of different types of monsters below."),
            radioButtons("plot", "Choose the Plot Type", choices = list("Bar graph of monster counts" = "bar", "Box plots of monster traits" = "box", "Scatterplot of associations between traits" = "scatter"), selected = "")
        ),
            fluidRow(conditionalPanel(
              condition = "input.plot == 'bar'",
              selectInput("factor", "Choose an additional factor to consider",
                      c("moral alignment" = "moral", "legal alignment" = 
                          "legal", "size")))),
            fluidRow(conditionalPanel(
              condition = "input.plot == 'box'",
              selectInput("trait", "Choose a trait to consider",
                      c("hit points", "intelligence", "charisma", 
                        "strength", "dexterity")))),
            fluidRow(conditionalPanel(
              condition = "input.plot == 'scatter'",
              selectInput("primary_trait", "Choose a primary trait to consider",
                      c("hit points" = "hit_points", "strength", "charisma"), 
                      selected = ""))),
            fluidRow(conditionalPanel(
              condition = "input.plot == 'scatter'", 
              selectInput("secondary_trait", 
                          "Choose a secondary trait to consider",
                          c("intelligence", "wisdom", "dexterity"))))),
         mainPanel(
          fluidRow(conditionalPanel(
            condition = "input.plot == 'bar'",
            plotOutput("bar"))),
          fluidRow(conditionalPanel(
            condition = "input.plot == 'box'",
            plotOutput("box"))),
          fluidRow(conditionalPanel(
            condition = "input.plot == 'scatter'",
            plotOutput("scatter"))),
          fluidRow(conditionalPanel(
            condition = "input.plot == 'scatter'",
            textOutput("cor_text")))
          )
      )
    )),
  tabPanel("Data Exploration-Spells",
         fluidPage(
           titlePanel("Dungeons & Dragons Spells"),
           sidebarLayout(
             sidebarPanel(
               fluidRow(h5("You can use tables or plots to explore requirements for spells of different levels"),
                        radioButtons("choice", "Choose the Data to Display", choices = list("Contingency table of spell count by character class" = "table", "Venn diagram of components needed for spell casting" = "venn", "Bar plots of spells at each level within each school" = "bar2"), selected = "")
               ),
             fluidRow(conditionalPanel(
               condition = "input.choice == 'table'",
               sliderInput("min",
                           "Select minimum spell level",
                           min = 0,
                           max = 10,
                           value = 0))),
             fluidRow(conditionalPanel(
               condition = "input.choice == 'venn'",
               sliderInput("min", 
                           "Select minimum spell level",
                           min = 0, 
                           max = 10, 
                           value = 0),
               sliderInput("max", 
                           "Select maximum spell level", 
                           min = 0, 
                           max = 10, 
                           value = 10))),
             fluidRow(conditionalPanel(
               condition = "input.choice == 'bar2'",
               selectInput("class",
                           "Choose a character class",
                           c("Bard", "Cleric", "Druid", "Paladin", "Ranger", 
                             "Sorcerer", "Warlock", "Wizard"))))),
           mainPanel(
               fluidRow(conditionalPanel(
                 condition = "input.choice == 'table'",
                 tableOutput("spells_table"))),
               fluidRow(conditionalPanel(
                 condition = "input.choice == 'venn'",
                 plotOutput("venn_plot"))),
               fluidRow(conditionalPanel(
                 condition = "input.choice == 'bar2'",
                 plotOutput("class_plot")))
              )
           )
         ))
)



