library(shiny)
 

shinyServer(function(input,output,session){

Data<-reactive({
  textFile <- input$textFile
  if(is.null(textFile)) return (NULL)
  data<-read.table(textFile$datapath,header=FALSE)
  data.df<-as.data.frame(data)
  names(data.df)<-c("Customer","Date","Quantity","Amount")
  data.df
})





output$Means<-renderTable({
  if(is.null(Data())) return(NULL)
  MA<-mean(Data()$Amount)
  MQ<-mean(Data()$Quantity)
  MA.df<-as.data.frame(MA)
  MQ.df<-as.data.frame(MQ)
  Means<-cbind(MA.df,MQ.df)
  Means.df<-as.data.frame(Means)
  names(Means.df)<-c("Average Amount","Average Quantity")
  Means.df 
})

TCA<-reactive({
  TotalCustomerAmount<-aggregate(Data()$Amount~Data()$Customer,Data(),sum)
  TCA.df<-as.data.frame(TotalCustomerAmount)
  names(TCA.df)<-c("Customer","Value")
  TCA<-TCA.df
  TCA
})

output$summaryTCA<-renderTable({
  if(is.null(Data())) return(NULL)
  summary.df<-as.data.frame(summary(TCA()))
  names(summary.df)<-c("","Var","Value")
  summary.df[7:12,]
})

SmallCustomers<-reactive({
  SmallCustomers<-TCA()[which(TCB()$Waarde<=input$MaxSC),]
  SmallCustomers.df<-as.data.frame(SmallCustomers)
  names(SmallCustomers.df)<-c("S_Customer","Value")
  SmallCustomers.df
})

output$lengthS<-renderText({
  if(is.null(Data())) return()
  length(SmallCustomers()$S_Customer) 
})

output$SmallCustomers<-renderDataTable({
  if(is.null(Data())) return(NULL)
  if(input$CustomerGroup=="SC")
    return(SmallCustomers())  
})

output$valueS<-renderText({
  if(is.null(Data())) return()
  sum(SmallCustomers()$Value) 
})

MediumCustomers<-reactive({
  MediumCustomers<-TCA()[which(TCA()$Value>input$MinSC & TCA()$Value<=input$MaxSC),]
    MediumCustomers.df<-as.data.frame(MediumCustomers)
    names(MediumCustomers.df)<-c("M_Customer","Value")
    MediumCustomers.df
})

output$lengthM<-renderText({
  if(is.null(Data())) return()
  length(MediumCustomers()$M_Customer) 
})

output$MiddenKlanten<-renderDataTable({
  if(is.null(Data())) return(NULL)
  if(input$Klantgroep=="MiKl")
    return(MiddenKlanten())  
})

output$valueM<-renderText({
  if(is.null(Data())) return()
  sum(MiddenKlanten()$Waarde) 
})

GroteKlanten<-reactive({
  GroteKlanten<-TKB()[which(TKB()$Waarde>input$MinGrKl),]
  GroteKlanten.df<-as.data.frame(GroteKlanten)
  names(GroteKlanten.df)<-c("G_Klant","Waarde")
  GroteKlanten.df  
})

output$lengthG<-renderText({
  if(is.null(Data())) return()
  length(GroteKlanten()$G_Klant) 
})

output$valueG<-renderText({
  if(is.null(Data())) return()
  sum(GroteKlanten()$Waarde) 
})


output$GroteKlanten<-renderDataTable({
  if(is.null(Data())) return(NULL)
  if(input$Klantgroep=="GrKl")
  return(GroteKlanten())  
})


output$AlleKlanten<-renderDataTable({
  if(is.null(Data())) return(NULL)
  if(input$Klantgroep=="AKl")
    return(TKB())   
})

output$totalValue<-renderText({
  if(is.null(Data())) return(NULL)
  if(input$Klantgroep=="KlKl")
    return(sum(KleineKlanten()$Waarde))
  if(input$Klantgroep=="MiKl")
    return(sum(MiddenKlanten()$Waarde))
  if(input$Klantgroep=="GrKl")
    return(sum(GroteKlanten()$Waarde))
  if(input$Klantgroep=="AKl")
    return(sum(TKB()$Waarde))
  else
    return()
})
  
output$All<-renderText({
  if(is.null(Data())) return(NULL)
  if(input$Klantgroep=="KlKl")
    return(length(KleineKlanten()$Waarde))
  if(input$Klantgroep=="MiKl")
    return(length(MiddenKlanten()$Waarde))
  if(input$Klantgroep=="GrKl")
    return(length(GroteKlanten()$Waarde))
  if(input$Klantgroep=="AKl")
    return(length(TKB()$Waarde))
  else
    return()
})

output$meanKlant<-renderText({
  if(is.null(Data())) return(NULL)
  if(input$Klantgroep=="KlKl")
    return(mean(KleineKlanten()$Waarde))
  if(input$Klantgroep=="MiKl")
    return(mean(MiddenKlanten()$Waarde))
  if(input$Klantgroep=="GrKl")
    return(mean(GroteKlanten()$Waarde))
  if(input$Klantgroep=="AKl")
    return(mean(TKB()$Waarde))
  else
    return()  
})

#Omzetten en datums

Omzet<-reactive({
  Data=Data()
  Data$Datum<-as.Date(as.character(Data$Datum),'%Y%m%d')
  Omzet<-aggregate(Data$Bedrag~Data$Datum,Data,sum)
  names(Omzet)<-c("Datum","T_Omzet")
  Omzet 
})

output$plotOmzet<-renderPlot({
  if(is.null(Data())) return()
  attach(Omzet())
  plot(Datum,T_Omzet,type="l",lwd="3",col="blue") 
})    

#Omzetten en datums

#KKN<-reactive({
#  KleineKlanten()$K_Klant
#})

#MKN<-reactive({
#  MiddenKlanten()$M_Klant
#})

#GKN<-reactive({
#  GroteKlanten()$G_Klant
#})

#KKD<-reactive({
#  subset(Data(),Data()$Klant %in% KKN)
#})

#MKD<-reactive({
#  subset(Data(),Data()$Klant %in% MKN)
#})

#GKD<-reactive({
#  GKD<-subset(Data(),Data()$Klant %in% GKN)
#  GKD
#})



#output$Omzet2<-renderTable({
#  head(GKD(),n=10)
#})

#output$text<-renderText({
#  head(GKN())
#})

#output$text2<-renderText({
#  head(Data()$Klant)
#})


})








  
 
  





  
