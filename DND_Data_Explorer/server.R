#######################################################
##Title: DND_Data_Explorers Server Script
##Author: Maggie Sweitzer
##Date: July 6, 2024
##Purpose: Server script for ST558 Project 2 Shiny App.
##This is the server logic of a Shiny web application. You can run the
##application by clicking 'Run App' above.
#######################################################

source("helpers.R")

function(input, output, session) {

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')

    })

}
