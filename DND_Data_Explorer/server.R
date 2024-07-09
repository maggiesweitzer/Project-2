#######################################################
##Title: DND_Data_Explorers Server Script
##Author: Maggie Sweitzer
##Date: July 9, 2024
##Purpose: Server script for ST558 Project 2 Shiny App.
##This is the server logic of a Shiny web application. You can run the
##application by clicking 'Run App' above.
#######################################################

source("helpers.R")

shinyServer(function(input, output, session) {
  #download selected data type in response to user pressing "download" button
  #Note download_data function is specified in helper.R script and includes data cleaning
   data_tbl <- eventReactive(input$go, {
     download_data(input$data_type)
     })
  
  #render a data table of the selected data once download is complete  
   output$data <- DT::renderDataTable({
     data_tbl()
     })
   
##Rendering plots for Data Exploration - Monsters tab
   #render bar plot if user selects this, with fill = user selection of factor
   output$bar <- renderPlot({
     if(input$plot == "bar"){
       g_bar <- ggplot(data_tbl()) + geom_bar() +
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
     } 
     })
   
   #render box plot if user selects this, with y axis selected by user
   output$box <- renderPlot({
     if(input$plot == "box"){ 
       g_box <- ggplot(data_tbl()) + geom_boxplot(aes(x = type)) +
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
     } 
     })
   
   #render scatter plot if user selects this, with x and y axes selected by user
   #Note-inefficient code written before figuring out how to directly reference user input within the ggplot function
   output$scatter <- renderPlot({
     if(input$plot == "scatter"){
       g_scatter <- ggplot(data_tbl()) + geom_point() + 
         geom_smooth(method = "lm") +
         labs(title = "Associations Between Monster Traits")
       if(input$primary_trait == "hit_points"){
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
   
   #create line stating correlation for selected variables to display with scatterplot
   output$cor_text <- renderText({
     if(input$plot == "scatter"){
       cor_val <- data_tbl() |>
         ungroup(alignment) |>
         select("hit_points", "strength", "charisma", "intelligence", 
                "wisdom", "dexterity") |>
         summarize(cor_val = cor(.data[[input$primary_trait]],
                                 .data[[input$secondary_trait]]))
       paste0("The correlation between ", input$primary_trait, " and ",
                    input$secondary_trait, " = ", round(cor_val, 2))
     }
   })

##Rendering plots for Data Exploration - Spells tab
   #render contingency table, with user input for minimum spell level to filter by
  output$spells_table <- renderTable({
      if(input$choice == "table"){
        level_min <- input$min
        summary <- data_tbl() |>
        filter(spell_level > (level_min-1)) |>
        group_by(school) |>
        summarize(across(where(is.logical), 
                         list("sum" = ~ sum(.x, na.rm = TRUE)), 
                         .names = "{.col}"))
      summary
   }
  })
  
  #render venn diagram plot referencing code from helper function
  output$venn_plot <- renderPlot({
     if(input$choice == "venn"){
       level_min <- input$min
       level_max <- input$max
       filtered_data <- data_tbl() |> 
          filter(spell_level > (level_min-1),
              spell_level < (level_max+1)) |>
       group_by(components_recode) |>
       summarize(count = n())
     components_vec <- deframe(filtered_data)
     venn_diagram <- ggeulerr(components_vec)
     print(venn_diagram)
   }   
})
  #render faceted bar plot from summarized data with user selected filter for character class
  output$class_plot <- renderPlot({
    if(input$choice == "bar2"){
     
      class_tbl <- data_tbl() |>
        group_by(spell_level, school) |>
        summarize(across(where(is.logical),
                         list("sum" = ~ sum(.x, na.rm = TRUE)),
                         .names = "{.col}"))
      
      ggplot(class_tbl) + geom_bar(stat = "identity") +
        aes(x = as.factor(spell_level), y = .data[[input$class]]) + 
        labs(title = paste0("Count of Spells Available for ", input$class, "s at Each Level Within Each School"), 
             y = "Number of Spells", x = "Spell Level") +
        facet_wrap(~ school)
     }
  })
})
