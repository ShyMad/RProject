library(shiny)
library(shinythemes)
library(shinydashboard)
library(markdown)
library(DT)
library(xlsx)
library(data.table)
source("coefMulti.R")
source("moveColumn.R")
source("dupliquerColonne.R")
source("vecteurScore.R")

if(!require("xlsx")){
  install.packages("xlsx",repos="http://cran.irsn.fr")
  require("xlsx")
}
# Chargement du package "sm" si nécessaire
if(!require("sm")){
  install.packages("sm",repos="http://cran.irsn.fr")
  require("sm")
}
options(encoding = "UTF-8")
options(java.parameters = "-Xmx16384m")
shinyServer(function(input, output){
  #affichage individuel 
  source("affichage_sm_indiv.R",  encoding="UTF-8",  local = TRUE)
  #affichage clubs
  source("affichage_sm_club.R",  encoding="UTF-8",  local = TRUE)
  #affichage clubs Raid
  source("affichage_raid.R",  encoding="UTF-8",  local = TRUE)
  # Course Page
  
  observeEvent(input$checkRace, {
    if (input$nameRace == ""){
      output$errorRace <- renderText({"Vous devez nommer la course !"})
      return(NULL)
    }else if(is.null(input$raceFile)){
      output$errorRace <- renderText({"Vous devez entrer un fichier course !"})
      return(NULL)
    }else{
      course <- read.xlsx2(input$raceFile$datapath, 1,stringsAsFactors = FALSE,check.names=FALSE)
      course<-course[,-c(ncol(course))]
      reference <- read.xlsx2("Reference.xlsx",1)
      #creer dtFrame pour notre stockage
      # Total<-rep(0,nrow(Reference))
      # Stockage<-cbind(Reference,Total)
      # Stockage<-Stockage[,moveColumn(names(Stockage),"Total before CLUB")]
      Stockage<-read.xlsx2("Stockage.xlsx",1,stringsAsFactors = FALSE,check.names=FALSE)
      reference$Date.nais.<-as.numeric(as.character(reference$Date.nais.))
      reference$Date.nais.<-format(as.Date(reference$Date.nais.,origin='1899-12-30'),"%d/%m/%Y")
      # Stockage$Total<-as.numeric(Stockage$Total)
      # Stockage[,c(ncol(Stockage))]<-as.numeric(Stockage[,c(ncol(Stockage))])
      Stockage$`Date nais.`<-as.numeric(as.character(Stockage$`Date nais.`))
      Stockage$`Date nais.`<-format(as.Date(Stockage$`Date nais.`,origin='1899-12-30'),"%d/%m/%Y")
      reference$Homonyme<-NULL
      # course<-subset(course,course$Classement!="")
      # course<-course[course$Classement!=0,]
      # On récupére tout les paramétres.
      name <- input$nameRace
      discipline <- input$discipline
      distance <- input$distance
      date <- input$dateRace
      class <- input$class
      nbrParEquipe<-input$nbrParEquipe
      
      if(nrow(course) == 0){
        output$errorRace <- renderText({"Le fichier course est vide !"})
        return(NULL)
      }
      # 
      # course$NOM<-gsub("(^\\s+|\\s+$|(?<=\\s)\\s)","",course$NOM, perl=T)
      # course$Prénom<-gsub("(^\\s+|\\s+$|(?<=\\s)\\s)","",course$Prénom, perl=T)
      # reference$NOM<-gsub("(^\\s+|\\s+$|(?<=\\s)\\s)","",reference$NOM, perl=T)
      # reference$Prénom<-gsub("(^\\s+|\\s+$|(?<=\\s)\\s)","",reference$Prénom, perl=T)
      
      #Garder les informations relatives à la course
      
      disc<-as.character(course[1,"Epreuve"])
      ville<-as.character(course[2,"Epreuve"])
      type<-as.character(course[3,"Epreuve"])
      date_tmp<-as.numeric(as.character(course[4,"Epreuve"]))
      dat<-format(as.Date(date_tmp,origin='1899-12-30'),"%d/%m/%Y")
      
      coefficientMulti<-coefMulti(distance)
      
      nbrEquipe<-nrow(course)
      
      course$Epreuve<-NULL
      course$Classement<-as.numeric(as.character((course$Classement)))
      nouveauClassement<-dupliquerColonne(course$Classement,nbrParEquipe)
    
      
      #Instanciation du nouveau tableau avec comme colonnes Identifiant,Nom,Prénom et Classement 
      #en fonction du nombre de joueur pr equipe
      if(nbrParEquipe==2){
        course_nv<-data.frame(Identifiant=c(as.character(course$`Identifiant 1`),as.character(course$`Identifiant 2`)),
                              Nom=c(as.character(course$`Nom 1`),as.character(course$`Nom 2`)),
                              Prénom=c(as.character(course$`Prénom 1`),as.character(course$`Prénom 2`)),
                              Classement=c(nouveauClassement))
      }else if (nbrParEquipe==3){
        course_nv<-data.frame(Identifiant=c(as.character(course$`Identifiant 1`),as.character(course$`Identifiant 2`),as.character(course$`Identifiant 3`)),
                              Nom=c(as.character(course$`Nom 1`),as.character(course$`Nom 2`),as.character(course$`Nom 3`)),
                              Prénom=c(as.character(course$`Prénom 1`),as.character(course$`Prénom 2`),as.character(course$`Prénom 3`)),
                              Classement=c(nouveauClassement))
      }else {
        course_nv<-data.frame(Identifiant=c(as.character(course$`Identifiant 1`),as.character(course$`Identifiant 2`),as.character(course$`Identifiant 3`),as.character(course$`Identifiant 4`)),
                              Nom=c(as.character(course$`Nom 1`),as.character(course$`Nom 2`),as.character(course$`Nom 3`),as.character(course$`Nom 4`)),
                              Prénom=c(as.character(course$`Prénom 1`),as.character(course$`Prénom 2`),as.character(course$`Prénom 3`),as.character(course$`Prénom 4`)),
                              Classement=c(nouveauClassement))
      }
      
      #case Jeunes Raid 
      if (disc=="Raid" & class=="Jeunes"){
        #Fusionner la Reference avec la course
        course_nv<-merge(course_nv,reference,by=c("Identifiant","Nom","Prénom"),sort=F)
        
        #Classement par categorie 
        
        course_Mi<-course_nv[which (course_nv$Cat=="Mi"),]
        course_Pu<-course_nv[which (course_nv$Cat=="Pu"),]
        course_Ca<-course_nv[which (course_nv$Cat=="Ca"),]
        course_Be<-course_nv[which (course_nv$Cat=="Be"),]
        course_Po<-course_nv[which (course_nv$Cat=="Po"),]
        course_Ju<-course_nv[which (course_nv$Cat=="Ju"),]
        course_Mp<-course_nv[which (course_nv$Cat=="Mp"),]
        #Tri des nouveaux tableaux 
        # course_Mi<-course_Mi[ order(course_Mi$Classement), ]
        # course_Pu<-course_Pu[ order(course_Pu$Classement), ]
        # course_Be<-course_Be[ order(course_Be$Classement), ]
        # course_Ca<-course_Ca[ order(course_Ca$Classement), ]
        # course_Po<-course_Po[ order(course_Po$Classement), ]
        # course_Ju<-course_Ju[ order(course_Ju$Classement), ]
        # course_Mp<-course_Mp[ order(course_Mp$Classement), ]
        #attribution de score
        score<-vecteurScore(nbrEquipe)
        course_Mi$Score<-dupliquerColonne(score[1:(nrow(course_Mi)/nbrParEquipe)],nbrParEquipe)
        course_Pu$Score<-dupliquerColonne(score[1:(nrow(course_Pu)/nbrParEquipe)],nbrParEquipe)
        course_Ca$Score<-dupliquerColonne(score[1:(nrow(course_Ca)/nbrParEquipe)],nbrParEquipe)
        course_Be$Score<-dupliquerColonne(score[1:(nrow(course_Be)/nbrParEquipe)],nbrParEquipe)
        course_Po$Score<-dupliquerColonne(score[1:(nrow(course_Po)/nbrParEquipe)],nbrParEquipe)
        course_Mp$Score<-dupliquerColonne(score[1:(nrow(course_Mp)/nbrParEquipe)],nbrParEquipe)
        course_Ju$Score<-dupliquerColonne(score[1:(nrow(course_Ju)/nbrParEquipe)],nbrParEquipe)
        #mise du score des DNF a 1
        one<-1
        ind<-which(is.na(course_Pu$Classement))
        course_Pu[ind,"Score"]<-one
        ind<-which(is.na(course_Mi$Classement))
        course_Mi[ind,"Score"]<-one
        ind<-which(is.na(course_Be$Classement))
        course_Be[ind,"Score"]<-one
        ind<-which(is.na(course_Po$Classement))
        course_Po[ind,"Score"]<-one
        ind<-which(is.na(course_Mp$Classement))
        course_Mp[ind,"Score"]<-one
        ind<-which(is.na(course_Ju$Classement))
        course_Ju[ind,"Score"]<-one
        ind<-which(is.na(course_Ca$Classement))
        course_Ca[ind,"Score"]<-one
        #Multiplication des scores des participantes par 1.2
        ind<-which(course_Be$Sexe =="F")
        course_Be[ind,"Score"]<-course_Be[ind,"Score"]*1.2
        ind<-which(course_Pu$Sexe =="F")
        course_Pu[ind,"Score"]<-course_Pu[ind,"Score"]*1.2
        ind<-which(course_Po$Sexe =="F")
        course_Po[ind,"Score"]<-course_Po[ind,"Score"]*1.2
        ind<-which(course_Mi$Sexe =="F")
        course_Mi[ind,"Score"]<-course_Mi[ind,"Score"]*1.2
        ind<-which(course_Ca$Sexe =="F")
        course_Ca[ind,"Score"]<-course_Ca[ind,"Score"]*1.2
        ind<-which(course_Mp$Sexe =="F")
        course_Mp[ind,"Score"]<-course_Mp[ind,"Score"]*1.2
        ind<-which(course_Ju$Sexe =="F")
        course_Ju[ind,"Score"]<-course_Ju[ind,"Score"]*1.2
        # #Multiplication par le coefficient Multiplicateur (selon difficulté)
        course_Be$Score<-course_Be$Score*coefficientMulti
        course_Mp$Score<-course_Mp$Score*coefficientMulti
        course_Ca$Score<-course_Ca$Score*coefficientMulti
        course_Mi$Score<-course_Mi$Score*coefficientMulti
        course_Ju$Score<-course_Ju$Score*coefficientMulti
        course_Po$Score<-course_Po$Score*coefficientMulti
        course_Pu$Score<-course_Pu$Score*coefficientMulti
        #Ajouter les scores a Stockage
        for (i in 1:nrow(course_Be)){
          ind<-which(as.character(Stockage$Identifiant)==course_Be[i,"Identifiant"])
          val <- as.numeric(Stockage[ind,"Total"]) + as.numeric(course_Be[i,"Score"])
          Stockage[ind,"Total"] <- as.numeric(val)
        }
        for (i in 1:nrow(course_Ca)){
          ind<-which(as.character(Stockage$Identifiant)==course_Ca[i,"Identifiant"])
          val <- as.numeric(Stockage[ind,"Total"]) + as.numeric(course_Ca[i,"Score"])
          Stockage[ind,"Total"] <- as.numeric(val)
        }
        for (i in 1:nrow(course_Ju)){
          ind<-which(as.character(Stockage$Identifiant)==course_Ju[i,"Identifiant"])
          val <- as.numeric(Stockage[ind,"Total"]) + as.numeric(course_Ju[i,"Score"])
          Stockage[ind,"Total"] <- as.numeric(val)
        }
        for (i in 1:nrow(course_Mi)){
          ind<-which(as.character(Stockage$Identifiant)==course_Mi[i,"Identifiant"])
          val <- as.numeric(Stockage[ind,"Total"]) + as.numeric(course_Mi[i,"Score"])
          Stockage[ind,"Total"] <- as.numeric(val)
        }
        for (i in 1:nrow(course_Mp)){
          ind<-which(as.character(Stockage$Identifiant)==course_Mp[i,"Identifiant"])
          val <- as.numeric(Stockage[ind,"Total"]) + as.numeric(course_Mp[i,"Score"])
          Stockage[ind,"Total"] <- as.numeric(val)
        }
        for (i in 1:nrow(course_Po)){
          ind<-which(as.character(Stockage$Identifiant)==course_Po[i,"Identifiant"])
          val <- as.numeric(Stockage[ind,"Total"]) + as.numeric(course_Po[i,"Score"])
          Stockage[ind,"Total"] <- as.numeric(val)
        }
        for (i in 1:nrow(course_Pu)){
          ind<-which(as.character(Stockage$Identifiant)==course_Pu[i,"Identifiant"])
          val <- as.numeric(Stockage[ind,"Total"]) + as.numeric(course_Pu[i,"Score"])
          Stockage[ind,"Total"] <- as.numeric(val)
        }
        #ajouter une nouvelle colonne avec le nom de la course
        newColumn<-paste(name,distance,date,sep=" ")
        Stockage$X<-rep(0,nrow(Stockage))
        setnames(Stockage, "X", newColumn)
        #remplir la colonne de la course
        for (i in 1:nrow(course_Be)){
          ind<-which(Stockage$Identifiant==course_Be[i,"Identifiant"])
          Stockage[ind,ncol(Stockage)]<-course_Be[i,"Score"]
        }
        for (i in 1:nrow(course_Ju)){
          ind<-which(Stockage$Identifiant==course_Ju[i,"Identifiant"])
          Stockage[ind,ncol(Stockage)]<-course_Ju[i,"Score"]
        }
        for (i in 1:nrow(course_Ca)){
          ind<-which(Stockage$Identifiant==course_Ca[i,"Identifiant"])
          Stockage[ind,ncol(Stockage)]<-course_Ca[i,"Score"]
        }
        for (i in 1:nrow(course_Mp)){
          ind<-which(Stockage$Identifiant==course_Mp[i,"Identifiant"])
          Stockage[ind,ncol(Stockage)]<-course_Mp[i,"Score"]
        }
        for (i in 1:nrow(course_Mi)){
          ind<-which(Stockage$Identifiant==course_Mi[i,"Identifiant"])
          Stockage[ind,ncol(Stockage)]<-course_Mi[i,"Score"]
        }
        for (i in 1:nrow(course_Po)){
          ind<-which(Stockage$Identifiant==course_Po[i,"Identifiant"])
          Stockage[ind,ncol(Stockage)]<-course_Po[i,"Score"]
        }
        for (i in 1:nrow(course_Pu)){
          ind<-which(Stockage$Identifiant==course_Pu[i,"Identifiant"])
          Stockage[ind,ncol(Stockage)]<-course_Pu[i,"Score"]
        }
        
      }
      #Case Swimrun et Adultes Raid
      else{
      course_nv$Score<-dupliquerColonne(vecteurScore(nbrEquipe),nbrParEquipe)
      
      #fusion de la reference et de notre course
      
      course_final<-merge(course_nv,reference,by=c("Identifiant","Nom","Prénom"),sort=F)
      
      course_final<-course_final[,moveColumn(names(course_final),"Sexe before Score")]
      
      
      #Multiplication des scores des participantes par 1.2
      
      ind<-which(course_final$Sexe =="F")
      course_final[ind,"Score"]<-course_final[ind,"Score"]*1.2
      
      # #Multiplication par le coefficient Multiplicateur (selon difficulté)
      #
      course_final$Score<-course_final$Score*coefficientMulti
      # Ajouter les scores a Stockage
      for (i in 1:nrow(course_final)){
        ind<-which(as.character(Stockage$Identifiant)==course_final[i,"Identifiant"])
        val <- as.numeric(Stockage[ind,"Total"]) + as.numeric(course_final[i,"Score"])
        Stockage[ind,"Total"] <- as.numeric(val)
      }
      
      #
      # #write.xlsx2(course_final, file = "course.xlsx",row.names = FALSE,col.names = TRUE)
      newColumn<-paste(name,distance,date,sep=" ")
      Stockage$X<-rep(0,nrow(Stockage))
      setnames(Stockage, "X", newColumn)
      
      
      #remplir la colonne de la course
      for (i in 1:nrow(course_final)){
        ind<-which(Stockage$Identifiant==course_final[i,"Identifiant"])
        Stockage[ind,ncol(Stockage)]<-course_final[i,"Score"]
      }
      }
      #selectionner les clubs 
      clubs_all <-data.frame(subset(Stockage, select = c(CLUB,Total,10:ncol(Stockage))),stringsAsFactors = FALSE)
      clubs_all$Total<-as.numeric(as.character(clubs_all$Total))
      for (i in 3:ncol(clubs_all)){
        clubs_all[,i]<-as.numeric(as.character(clubs_all[,i]))
      }
      clubs_all[is.na(clubs_all)]<-0
      #creation du tableau de clubs + Total de points 
      stockage_club<-aggregate(. ~ CLUB,clubs_all,sum)
      
      output$clubs <- DT::renderDataTable(stockage_club)
      
      # if (file.exists("Stockage.xlsx")){
      #   file.remove("Stockage.xlsx")
      # }
      #Creer un fichier exel contenant le resultat de l'ajout 
      write.xlsx2(Stockage,"Stockage_new.xlsx",row.names=FALSE,sheetName="Indiv",col.names=TRUE, append=FALSE,check.names=FALSE)
      write.xlsx2(stockage_club,"Stockage_new.xlsx",sheetName="Clubs",append=TRUE,row.names=FALSE,check.names=FALSE)
      
      output$courseValide <- renderText(as.character("Le nouveau fichier Stockage est disponible dans le répétroire"))
      # 
      # output$courseValide <- renderText(as.character(val))
      
      
      
      
    }
    
    
    
    
    
    
  })
  
  
}) 