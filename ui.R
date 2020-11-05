library(shiny)
library(shinythemes)
library(shinyWidgets)
library(extrafont)

font_import()

ui <- navbarPage("Website",
                tabPanel("Missing data", 
                          fluidPage(
                            setBackgroundColor(color = "#05234F"),
                            fluidRow(
                              column(8, "Missing data graphic",
                                     style = "color: #dbd1d2;"),
                              column(4, "sidey sidey side", 
                                     style = "background-color: #dbd1d2;"))
                          )
                 ),
                 tabPanel("Maps",
                          fluidPage(
                            setBackgroundColor(color = "#05234F"),
                            fluidRow(
                              column(8, "Maps go here",
                                     style = "color: #dbd1d2;"),
                              column(4, "sidey sidey side",
                                     style = "background-color: #dbd1d2;"))
                          )
                 ),
                 tabPanel("Normalization",
                          fluidPage(
                            setBackgroundColor(color = "#05234F"),
                            fluidRow(
                              column(8, "Normalism",
                                     style = "color: #dbd1d2;"),
                              column(4, "sidey sidey side",
                                     style = "background-color: #dbd1d2;"))
                          )
                 ),
                 
                 tags$style(HTML(" 
                    .navbar-default .navbar-brand {color: #05234F;}
                    .navbar-default .navbar-brand:hover {color: #05234F;}
                    .navbar { background-color: #79A9D7;}
                    .navbar-default .navbar-nav > li > a {color:#05234F;}
                    .navbar-default .navbar-nav > .active > a,
                    .navbar-default .navbar-nav > .active > a:focus,
                    .navbar-default .navbar-nav > .active > a:hover {color: #E99688;background-color: #05234F;}
                    .navbar-default .navbar-nav > li > a:hover {color: #C8470E;}")
                   ),
                
                tabPanel("About the data", 
                         # style = "background-color: #dbd1d2;",
                         fluidPage(
                           setBackgroundColor(color = "#05234F"),
                           fluidRow(
                             column(1),
                             column(10, about_data, 
                                    style = "background-color: #05234f;", 
                                    style = "color: #dbd1d2;"),
                             column(1)
                           )
                         )
                )
)


server <- function(input, output, 
                   session){
  
}

shinyApp(ui, server)