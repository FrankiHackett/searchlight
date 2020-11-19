library(shiny)
library(shinythemes)
library(shinyWidgets)
library(extrafont)
library(shinyjs)

# font_import()

source("Data cleansing.R")
source("Cartogram functions.R")
source("missing data functions.R")
source("normalisatiion functions.R")
source("website_text.R")

ui <- navbarPage("Website",
                tabPanel("Missing data", 
                         modalDialog(div(intro_text, style = "font-size:160%"),
                           title = "Welcome!",
                           footer = modalButton("Let's go!"),
                           size =  "l",
                           easyClose = FALSE,
                           fade = TRUE
                         ),
                          sidebarLayout(
                            setBackgroundColor(color = "#05234F"),
                            fluidRow(
                              sidebarPanel(style = "background-color: #dbd1d2;",
                                           textInput("filter", "Filter", "2019")),
                              mainPanel(style = "color: #dbd1d2;",
                                     plotOutput("missing_plot", height = 1000, 
                                                hover = hoverOpts(id="plot_hover"))))
                          )
                 ),
                 tabPanel("Maps",
                          sidebarLayout(
                            setBackgroundColor(color = "#05234F"),
                            fluidRow(
                              sidebarPanel(style = "color: #dbd1d2;",
                                           selectInput("focus", "Variable:", 
                                                     choices = names(Tax_to_map)),
                                           textInput("year", "Year:", "2018")),
                              mainPanel(style = "background-color: #dbd1d2;",
                                        plotOutput("cartogram", height = 1000)))
                          )
                 ),
                 tabPanel("Normalization",
                          sidebarLayout(
                            setBackgroundColor(color = "#05234F"),
                            fluidRow(
                              sidebarPanel(style = "color: #dbd1d2;",
                                           selectInput("parameter", "Parameter:", 
                                                       choices = c("Revenue", "Profit")),
                                           selectInput("taxtype", "Real of Effective Tax rate?", 
                                                       choices = c("Real", "Effective")),
                                           selectInput("year", "Year:", 
                                                       choices = c("2017", "2018", "2019", "2020")),
                                           actionButton("show_graphs", "Show me my graphs")),
                              mainPanel(style = "background-color: #dbd1d2;",
                                           plotOutput("normalplot"),
                                        plotOutput("tax_plot"))
                          ))
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
  #######Missing data outputs
  output$missing_plot <- renderPlot({
    missingPlot(input$filter)
    })
  
  
  ######Cartogram outputs
  output$cartogram <- renderPlot({
    carto_funct(input$focus, input$year)
  })
  
  
  #####Normalisation outputs
  

  
  
  output$normalplot <- reactive(#input$show_graphs, 
                                {    
    real_rev_plot <- prep_norm_data(Normal_rev, norm_rev, normal_real_tax, input$year,
                                    revenue_eur, tax_for_the_year_eur, "val")
    
   # effect_rev_plot <-  prep_norm_data(Normal_rev, norm_rev, normal_tax, input$year,
   #                                    revenue_eur, tax_for_the_year_eur, "val")
    
    real_prof_plot <- prep_norm_data(Normal_prof, norm_prof, normal_real_tax, input$year,
                                     pbt_eur, tax_for_the_year_eur, "val")
    
    
  #  effect_prof_plot <- prep_norm_data(Normal_prof, norm_prof, normal_tax, input$year,
  #                                     pbt_eur, tax_for_the_year_eur, "val")
  
 #   if(input$parameter == "Revenue"){
      
    renderPlot({Create_normal_graphs(real_rev_plot)})
  #  }
  #  else if(input$parameter == "Profit"){
  #    renderPlot({Create_normal_graphs(real_prof_plot)})
  #  }
  })
    
    
   output$tax_plot <- eventReactive(input$show_graphs, { 
     real_rev_plot <- prep_norm_data(Normal_rev, norm_rev, normal_real_tax, input$year,
                                     revenue_eur, tax_for_the_year_eur, "val")
     
     effect_rev_plot <-  prep_norm_data(Normal_rev, norm_rev, normal_tax, input$year,
                                        revenue_eur, tax_for_the_year_eur, "val")
     
     real_prof_plot <- prep_norm_data(Normal_prof, norm_prof, normal_real_tax, input$year,
                                      pbt_eur, tax_for_the_year_eur, "tax")
     
     
     effect_prof_plot <- prep_norm_data(Normal_prof, norm_prof, normal_tax, input$year,
                                        pbt_eur, tax_for_the_year_eur, "tax")
     
   #  if(input$parameter =="Revenue" & input$taxtype == "Real"){
     
     renderPlot({Create_normal_graphs(real_rev_plot)})
   #  }
   #  else if(input$parameter =="Revenue" & input$taxtype == "Effective"){
       
   #    renderPlot({Create_normal_graphs(effect_rev_plot)})
   #  }
   #  else if(input$parameter =="Profit" & input$taxtype == "Real"){
       
   #    renderPlot({Create_normal_graphs(real_prof_plot)})
   #  }
   #  else if(input$parameter =="Profit" & input$taxtype == "Effective"){
       
   #    renderPlot({Create_normal_graphs(real_rev_plot)})
    # }
     })
   
}

shinyApp(ui, server)