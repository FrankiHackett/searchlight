library(shiny)
library(shinythemes)


ui <- navbarPage("Website",
                 tabPanel("Introduction", 
                          style = "background-color: #dbd1d2;",
                          fluidPage(
                            fluidRow(
                              column(8, "Intro text you know", 
                                     style = "background-color: #05234f;", 
                                     style = "color: #dbd1d2;"),
                              column(4, "sidey sidey side",
                                     style = "background-color: #dbd1d2;",
                                     style = "color: #05234f;"))
                          )
                 ),
                 tabPanel("Missing data", 
                          fluidPage(
                            fluidRow(
                              column(8, "Missing data graphic"),
                              column(4, "sidey sidey side"))
                          )
                 ),
                 tabPanel("Maps",
                          fluidPage(
                            fluidRow(
                              column(8, "Maps go here"),
                              column(4, "sidey sidey side"))
                          )
                 ),
                 tabPanel("Normalization",
                          fluidPage(
                            fluidRow(
                              column(8, "Normalism"),
                              column(4, "sidey sidey side"))
                          )
                 ),
                 tags$style(type = 'text/css', 
                            '.navbar { background-color: #79A9D7;}',
                            '.navbar-default .navbar-brand{color: #05234F;}',
                            '.tab-panel{ background-color: #05234F; color: #DBD1D2;}'
                 )
)

server <- function(input, output, 
                   session){
  
}

shinyApp(ui, server)