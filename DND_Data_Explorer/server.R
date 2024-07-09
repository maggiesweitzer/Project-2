#######################################################
##Title: DND_Data_Explorers Server Script
##Author: Maggie Sweitzer
##Date: July 6, 2024
##Purpose: Server script for ST558 Project 2 Shiny App.
##This is the server logic of a Shiny web application. You can run the
##application by clicking 'Run App' above.
#######################################################

source("helpers.R")

#data_tbl <- read_csv("data.csv")

shinyServer(function(input, output, session) {
   data_tbl <- eventReactive(input$go, {
     download_data(input$data_type)
     })
   
   output$data <- renderTable({
     data_tbl()
     })
   
   output$plot <- renderPlot({
     
     g <- ggplot(data_tbl())  
     
     if(input$plot == "bar"){
       g_bar <- g + geom_bar() +
         aes(x = type) +
         theme(axis.text.x = element_text(angle = 45))+
         labs(
           title = "Count of Monsters by Type and Trait",
           x = "Monster Type", y = "Number of Monsters")
       if(input$factor == "moral"){
         g_bar + aes(fill = moral)+
           labs(fill = "Moral Alignment")
       } else if(input$factor == "legal"){
         g_bar + aes(fill = legal)+
           labs(fill= "Legal Alignment")
       } else if(input$factor == "size"){
         g_bar + aes(fill = size)+
           labs(fill = "Size")
       }
     } else if(input$plot == "box"){ 
       g_box <- g + geom_boxplot(aes(x = type)) +
         theme(axis.text.x = element_text(angle = 45))+
         labs(
           title = "Boxplot of Monster Traits by Monster Type",
           x = "Monster Type")
            if(input$trait == "hit points"){
              g_box + aes(y = hit_points) +
                labs(y = "Hit Points")
            } else if(input$trait == "intelligence"){
              g_box + aes(y = intelligence) +
                labs(y = "Intelligence")
            } else if(input$trait == "strength") {
              g_box + aes(y = strength) +
                labs(y = "Strength")
            } else if(input$trait == "charisma") {
              g_box + aes(y=charisma) +
                labs(y = "Charisma")
            } else if(input$trait == "dexterity") {
              g_box + aes(y=dexterity) +
                labs(y = "Dexterity")
            }
     } else if(input$plot == "scatter"){
       g_scatter <- g + geom_point() + geom_smooth(method = "lm")+
         labs(title = "Associations Between Monster Traits")
       if(input$primary_trait == "hit points"){
         g_x <- g_scatter + aes(x = hit_points) +
           labs(x = "Hit Points")
         if(input$secondary_trait == "intelligence"){
           g_x + aes(y = intelligence) +
             labs(y = "Intelligence")
         } else if(input$secondary_trait == "wisdom"){
           g_x + aes(y = wisdom) +
             labs(y = "Wisdom")
         } else if(input$secondary_trait == "dexterity"){
           g_x + aes(y = dexterity) +
             labs(y = "Dexterity")
         }
       } else if(input$primary_trait == "strength") {
         g_x <- g_scatter + aes(x = strength) + 
           labs(x = "Strength")
         if(input$secondary_trait == "intelligence"){
           g_x + aes(y = intelligence) +
             labs(y = "Intelligence")
         } else if(input$secondary_trait == "wisdom"){
           g_x + aes(y = wisdom) +
             labs(y = "Wisdom")
         } else if(input$secondary_trait == "dexterity"){
           g_x + aes(y = dexterity) +
             labs(y = "Dexterity")
         }
       } else if(input$primary_trait == "charisma") {
         g_x <- g_scatter + aes(x = charisma) +
           labs(x = "Charisma")
         if(input$secondary_trait == "intelligence"){
           g_x + aes(y = intelligence) +
             labs(y = "Intelligence")
         } else if(input$secondary_trait == "wisdom"){
           g_x + aes(y = wisdom) +
             labs(y = "Wisdom")
         } else if(input$secondary_trait == "dexterity"){
           g_x + aes(y = dexterity) +
             labs(y = "Dexterity")
         }
       }
     }
   })
})
        # generate bins based on input$bins from ui.R
        #x    <- faithful[, 2]
       # bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
       # hist(x, breaks = bins, col = 'darkgray', border = 'white',
             #xlab = 'Waiting time to next eruption (in mins)',
             #main = 'Histogram of waiting times')

   # })

#}
