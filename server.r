library(shiny)
 

shinyServer(function(input,output,session){

Data<-reactive({
  TextBestand<-input$TextBestand
  if(is.null(TextBestand)) return (NULL)
  data<-read.table(TextBestand$datapath,header=FALSE)
  data.df<-as.data.frame(data)
  names(data.df)<-c("Klant","Datum","Aantal","Bedrag")
  data.df
})





output$Means<-renderTable({
  if(is.null(Data())) return(NULL)
  MB<-mean(Data()$Bedrag)
  MA<-mean(Data()$Aantal)
  MB.df<-as.data.frame(MB)
  MA.df<-as.data.frame(MA)
  Means<-cbind(MB.df,MA.df)
  Means.df<-as.data.frame(Means)
  names(Means.df)<-c("Gemiddeld Bedrag","Gemiddeld Aantal")
  Means.df 
})

TKB<-reactive({
  TotaalKlantBedrag<-aggregate(Data()$Bedrag~Data()$Klant,Data(),sum)
  TKB.df<-as.data.frame(TotaalKlantBedrag)
  names(TKB.df)<-c("Klant","Waarde")
  TKB<-TKB.df
  TKB
})

output$summaryTKB<-renderTable({
  if(is.null(Data())) return(NULL)
  summary.df<-as.data.frame(summary(TKB()))
  names(summary.df)<-c("","Var","Waarde in euro's")
  summary.df[7:12,]
})

KleineKlanten<-reactive({
  KleineKlanten<-TKB()[which(TKB()$Waarde<=input$MaxKlKl),]
  KleineKlanten.df<-as.data.frame(KleineKlanten)
  names(KleineKlanten.df)<-c("K_Klant","Waarde")
  KleineKlanten.df
})

output$lengthK<-renderText({
  if(is.null(Data())) return()
  length(KleineKlanten()$K_Klant) 
})

output$KleineKlanten<-renderDataTable({
  if(is.null(Data())) return(NULL)
  if(input$Klantgroep=="KlKl")
    return(KleineKlanten())  
})

output$valueK<-renderText({
  if(is.null(Data())) return()
  sum(KleineKlanten()$Waarde) 
})

MiddenKlanten<-reactive({
    MiddenKlanten<-TKB()[which(TKB()$Waarde>input$MinMiKl & TKB()$Waarde<=input$MaxMiKl),]
    MiddenKlanten.df<-as.data.frame(MiddenKlanten)
    names(MiddenKlanten.df)<-c("M_Klant","Waarde")
    MiddenKlanten.df
})

output$lengthM<-renderText({
  if(is.null(Data())) return()
  length(MiddenKlanten()$M_Klant) 
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








  
 
  





  
