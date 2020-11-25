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



ui <- navbarPage("Tax Searchlight",
                tabPanel("Missing data", 
                         modalDialog(div(intro_text, style = "font-size:160%"),
                           title = "Welcome!",
                           footer = modalButton("Let's go!"),
                           size =  "l",
                           easyClose = FALSE,
                           fade = TRUE
                         ),
                          sidebarLayout(
                            setBackgroundColor(color = "#FFFFFF"),
                            fluidRow(
                              sidebarPanel(textInput("filter", "Filter", "2019")),
                              mainPanel(style = "color: #dbd1d2;",
                                     plotOutput("missing_plot", height = 1000, 
                                                hover = hoverOpts(id="plot_hover"))))
                          )
                 ),
                 tabPanel("Maps",
                          sidebarLayout(
                            setBackgroundColor(color = "#FFFFFF"),
                            fluidRow(
                              sidebarPanel(style = "color: #dbd1d2;",
                                           selectInput("focus", "Variable:", 
                                                     choices = names(Tax_to_map)),
                                           textInput("year", "Year:", "2018"),
                                           actionButton("show_maps", "Show my map")),
                              mainPanel(plotOutput("cartogram", height = 1000)))
                          )
                 ),
                 tabPanel("Normalization",
                          sidebarLayout(
                            setBackgroundColor(color = "#FFFFFF"),
                            fluidRow(
                              sidebarPanel(style = "color: #dbd1d2;",
                                           selectInput("parameter", "Parameter:", 
                                                       choices = c("Revenue", "Profit")),
                                           selectInput("taxtype", "Real of Effective Tax rate?", 
                                                       choices = c("Real", "Effective")),
                                           selectInput("year", "Year:", 
                                                       choices = c("2017", "2018", "2019", "2020")),
                                           actionButton("show_graphs", "Show me my graphs")),
                              mainPanel(plotOutput("normalplot"),
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
                    .navbar-default .navbar-nav > .active > a:hover {color: #E99688;background-color: #FFFFFF;}
                    .navbar-default .navbar-nav > li > a:hover {color: #C8470E;}")
                   ),
                
                tabPanel("About the data", 
                         fluidPage(
                           setBackgroundColor(color = "#FFFFFF"),
                           fluidRow(
                             column(1),
                             column(10, about_data, 
                                    style = "color: #05234F;"),
                             column(1)
                           )
                         )
                )
)


server <- function(input, output, 
                   session){
  ############################################## Missing data outputs ##########################################
  output$missing_plot <- renderPlot({
    missingPlot(input$filter)
    })
  
  
  
  
  
  
  
  ############################################## Cartogram outputs #############################################
  
  
  carto_gram <- eventReactive(input$show_maps, 
                         {
 #   carto_focus <- input$focus
  #  carto_year <- input$year
    carto_funct(input$focus, input$year)
  })

  
  output$cartogram <- renderPlot({carto_gram})
  
  
  
  
  
  
  
  ########################################### Normalisation outputs ############################################
  

  
  
  normalplot <- eventReactive(input$show_graphs, {    
    real_rev_plot <- prep_norm_data(Normal_rev, norm_rev, normal_real_tax, input$year,
                                    revenue_eur, tax_for_the_year_eur, "val")
    
    
    real_prof_plot <- prep_norm_data(Normal_prof, norm_prof, normal_real_tax, input$year, 
                                     pbt_eur, tax_for_the_year_eur, tax_or_val = "val")
    
    if(input$parameter == "Revenue"){
   Create_normal_graphs(real_rev_plot)
    }
    else {
      Create_normal_graphs(real_prof_plot)
    }
  })
  
  output$normalplot <- renderPlot({normalplot()})
    
    
   tax_plot <- eventReactive(input$show_graphs, { 
     real_rev_plot <- prep_norm_data(Normal_rev, norm_rev, normal_real_tax, input$year,
                                     revenue_eur, tax_for_the_year_eur, "tax")
     
     effect_rev_plot <-  prep_norm_data(Normal_rev, norm_rev, normal_tax, input$year,
                                        revenue_eur, tax_for_the_year_eur, "tax")
     
     real_prof_plot <- prep_norm_data(Normal_prof, norm_prof, normal_real_tax, input$year,
                                      pbt_eur, tax_for_the_year_eur, "tax")
     
     
     effect_prof_plot <- prep_norm_data(Normal_prof, norm_prof, normal_tax, input$year,
                                        pbt_eur, tax_for_the_year_eur, "tax")
     
     if(input$parameter =="Revenue" & input$taxtype == "Real"){
     
     Create_normal_graphs(real_rev_plot)
     }
     else if(input$parameter =="Revenue" & input$taxtype == "Effective"){
       
       Create_normal_graphs(effect_rev_plot)
     }
     else if(input$parameter =="Profit" & input$taxtype == "Real"){
       
      Create_normal_graphs(real_prof_plot)
     }
     else if(input$parameter =="Profit" & input$taxtype == "Effective"){
       
       Create_normal_graphs(real_rev_plot)
     }
     })
   
   output$tax_plot <- renderPlot({tax_plot()})
   
}

shinyApp(ui, server)