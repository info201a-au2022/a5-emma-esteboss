#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(rsconnect)
source("https://raw.githubusercontent.com/info201a-au2022/a5-emma-esteboss/main/A5/app_ui.R")
source("https://raw.githubusercontent.com/info201a-au2022/a5-emma-esteboss/main/A5/app_server.R")

# Run the application 
shinyApp(ui = ui, server = server)
