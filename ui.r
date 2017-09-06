library(shiny)


shinyUI(fluidPage(
  titlePanel("Shiny Transactions Dashboard"),
  
# Row 1: File input  
  fluidRow(
    column(4, align="center",
           fileInput("textFile", label = h4("Upload the transaction data"),
                     accept=c('text/csv',
                              'text/comma-seperated-values,text/plain',
                              '.csv')))
    
  
  ),
  fluidRow(
    column(3,
           selectInput("Customer Group",label=h6("Select a customer group"),choices=c("Small customers"="KlKl",
                                                                                   "Medium customers"="MiKl",
                                                                                   "Large customers"="GrKl",
                                                                                   "All customers"="AKl"
           ),selected="AKl"),
           h5("Define customer groups"),
           numericInput("MaxKlKl",label=h6("Max. value small customers"),value=""),
           numericInput("MinMiKl",label=h6("Min. value medium customers"),value=""),
           numericInput("MaxMiKl",label=h6("Max. value medium"),value=""),
           numericInput("MinGrKl",label=h6("Min. value large customers"),value=""),
           
           br()),
  
    
    column(3,
           h3("Statistics"),
           tableOutput("summaryTKB"),
           h6("Means"),
           tableOutput("Means"),
           br(),
           h6("Amount of small customers"),
           textOutput("lengthK"),
           h6("Value of small customers"),
           textOutput("valueK"),
           h6("Amount of medium customers"),
           textOutput("lengthM"),
           h6("Value of medium customers"),
           textOutput("valueM"),
           h6("Amount of large customers"),
           textOutput("lengthG"),
           h6("Value of large customers"),
           textOutput("valueG")
           ),
    

    
    column(3,
           h3("Totale value"),
           br(),
           textOutput("totalValue"),
           h5("Number of customers"),
           br(),
           textOutput("All"),
           h5("Mean customer value"),
           br(),
           textOutput("meanKlant")
           ),
    column(3,
           h6("Daily turnover"),
           plotOutput("plotOmzet")
    )
    ),
  
  fluidRow(
    column(12,
           h3("Customer group information"),
           br(),
           dataTableOutput("KleineKlanten"),
           dataTableOutput("MiddenKlanten"),
           dataTableOutput("GroteKlanten"),
           dataTableOutput("AlleKlanten")
    )
  )
  
  
  ))
