library(shiny)


shinyUI(fluidPage(
  titlePanel("Epic App"),
  
  fluidRow(
    column(4,
           fileInput("TextBestand", label = h4("Upload de transactiedata"),
                     accept=c('text/csv',
                              'text/comma-seperated-values,text/plain',
                              '.csv')))
    
  
  ),
  fluidRow(
    column(1,
           selectInput("Klantgroep",label=h6("Selecteer een klantgroep"),choices=c("Kleine Klanten"="KlKl",
                                                                                   "Midden Klanten"="MiKl",
                                                                                   "Grote Klanten"="GrKl",
                                                                                   "Alle klanten"="AKl"
           ),selected="AKl"),
           h5("Definieer klantgroepen"),
           numericInput("MaxKlKl",label=h6("Max. waarde Kleine klanten"),value=""),
           numericInput("MinMiKl",label=h6("Min. waarde Midden klanten"),value=""),
           numericInput("MaxMiKl",label=h6("Max. waarde Midden klanten"),value=""),
           numericInput("MinGrKl",label=h6("Min. waarde Grote klanten"),value=""),
           
           br()),
  
    
    column(2,
           h3("Statistieken"),
           tableOutput("summaryTKB"),
           h6("Gemiddeldes"),
           tableOutput("Means"),
           br(),
           h6("Aantal kleine klanten"),
           textOutput("lengthK"),
           h6("Waarde kleine klanten"),
           textOutput("valueK"),
           h6("Aantal midden klanten"),
           textOutput("lengthM"),
           h6("Waarde midden klanten"),
           textOutput("valueM"),
           h6("Aantal grote klanten"),
           textOutput("lengthG"),
           h6("Waarde grote klanten"),
           textOutput("valueG")
           ),
    
    column(5,
           h3("Klantgroep informatie"),
           br(),
           dataTableOutput("KleineKlanten"),
           dataTableOutput("MiddenKlanten"),
           dataTableOutput("GroteKlanten"),
           dataTableOutput("AlleKlanten")
           ),
    
    column(2,
           h3("Totale waarde"),
           br(),
           textOutput("totalValue"),
           h5("Aantal klanten"),
           br(),
           textOutput("All"),
           h5("Gemiddelde klantwaarde"),
           br(),
           textOutput("meanKlant")
           
           
           
           )
    ),
  fluidRow(
    column(5,
           h6("Omzet per dag"),
           plotOutput("plotOmzet")
           )
    )
  
  
  ))
