# Project-2: DND_Data_Explorer 
The DND_Data_Explorer app will query a comprehensive data set of monsters and/or spells from the Dungeons and Dragons API and allow the user to create different plots and tables to explore numerical summaries of the data. For example, you can examine characteristics of different types of monsters, or available spells for different classes of characters at different levels.

Packages needed to run the app:
jsonlite
httr
tidyverse
purrr
eulerr
ggforce
shiny

Code to install needed packages: 
install.packages(c("jsonlite", "httr", "tidyverse", "purrr", "eulerr", "ggforce", "shiny"))

Code to run the app:
shiny::runGitHub("Project-2", "maggiesweitzer", subdir = "DND_Data_Explorer")