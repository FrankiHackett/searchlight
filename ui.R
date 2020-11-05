library(shiny)


ui <- navbarPage("Website",
                 tabPanel("Introduction", 
                          fluidPage(
                            fluidRow(
                              column(8, "texty texty text"),
                              column(4, "sidey sidey side"))
                          )
                 ),
                 tabPanel("Missing data", 
                          fluidPage(
                            fluidRow(
                              column(8, "texty texty text"),
                              column(4, "sidey sidey side"))
                          )
                 ),
                 tabPanel("Maps",
                          fluidPage(
                            fluidRow(
                              column(8, "texty texty text"),
                              column(4, "sidey sidey side"))
                          )
                 ),
                 tabPanel("Normalization",
                          fluidPage(
                            fluidRow(
                              column(8, "texty texty text"),
                              column(4, "sidey sidey side"))
                          )
                 )
                 
)

server <- function(input, output, 
                   session){
  
}

shinyApp(ui, server)