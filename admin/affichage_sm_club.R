#Script pour l'affichage des clubs du Swinrun
#importer le tableau
affichage_club = read.xlsx2("Stockage.xlsx",2,stringsAsFactors = FALSE,check.names=FALSE)
ind<-which(affichage_club$CLUB=="")
clubVide<-"NON AFFILIE"
affichage_club[ind,"CLUB"]<-clubVide
affichage_club$CLUB<-as.character(affichage_club$CLUB)
affichage_club$Total <- as.numeric(as.character(affichage_club$Total))
for (i in 3:ncol(affichage_club)){
  affichage_club[,i] <- as.numeric(as.character(affichage_club[,i]))
}
affichage_club$Courses = rowSums(affichage_club[,-c(1:2)] > 0)
setcolorder(affichage_club, moveColumn(names(affichage_club), "Courses after Total"))
affichage_club<-affichage_club[ order(-affichage_club$Total), ]
affichage_club$Classement<-c(1:nrow(affichage_club))
setcolorder(affichage_club,moveColumn(names(affichage_club),"Classement before Total"))
affichage1_club<-affichage_club[1:4]
affichage1_club<-affichage1_club[ order(affichage1_club$Classement), ]
#Affichage du classement
output$affichage_clubs <- DT::renderDataTable({
  datatable(affichage1_club,
            extensions = 'Buttons',
            selection = 'multiple',
            filter = 'top',
            options = list( 
              columnDefs = list(list(className = 'dt-center', targets = "_all")),
              pageLength = 25,
              order = list(1, 'asc'),
              dom = 'Bfrtip',
              buttons = 
                list( list(
                  extend = 'collection',
                  buttons = c('csv', 'excel', 'pdf'),
                  text = 'Télécharger'
                )),
              class = 'cell-border stripe',
              language = list(url = 'French.json'),
              rowCallback = JS(
                "function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {",
                "$('td', nRow).css('cursor', 'pointer');",
                "}")),
            rownames = FALSE
  )
})

#afficher les données du club
output$affichage_clubs_info <-  renderUI({
  if (length(input$affichage_clubs_rows_selected) == 1 ){
    club <- affichage1_club[input$affichage_clubs_rows_selected,];
    
    nb_inscription <- affichage[affichage$CLUB == club[,"CLUB"], c(9:ncol(affichage))]
    
    nb_inscription <- colSums(nb_inscription > 0)
    nb_inscription <- sum(nb_inscription)
    
    HTML(paste("<h2>",club[,"CLUB"],"</h2></br>Points totaux :", club[,"Total"],"</br>Courses réalisées :", club["Courses"],"</br>Nombre d'inscriptions aux courses :",nb_inscription,  sep =' '))
  }
})

#Afficher les statistiques des clubs
output$affichage_clubs_stats <-  renderTable({
  
  if (length(input$affichage_clubs_rows_selected) == 1){#Si sélection d'un seul club
    resultat <- affichage_club[input$affichage_clubs_rows_selected,];
    row.names(resultat) <- c(1:nrow(resultat))
    resultat <- resultat[, colSums(resultat != 0) > 0];
    resultat <- subset(resultat, select = 5:NCOL(resultat))
  }
  else if(length(input$affichage_clubs_rows_selected) > 1 ){#Si sélection de plusieurs clubs
    resultat <- affichage_club[input$affichage_clubs_rows_selected,];
    row.names(resultat) <- c(1:nrow(resultat))
    resultat <- resultat[, colSums(resultat != 0) > 0];
    resultat <- subset(resultat, select = c(1,5:NCOL(resultat)))
  }
},striped = TRUE, hover = TRUE, bordered = TRUE, include.rownames = TRUE)

#Afficher les performances des clubs
output$affichage_clubs_perf <-  renderPlot({
  if (!is.null(input$affichage_clubs_rows_selected)){#Si sélection d'un club, calcul de sa perf
    if (affichage_club[input$affichage_clubs_rows_selected,"Courses"] > 0){
      resultat <- affichage_club[input$affichage_clubs_rows_selected,];
      resultat <- resultat[, colSums(resultat != 0) > 0];
      resultat <- subset(resultat, select = c(5:NCOL(resultat)))
      
      Performance <- resultat
      for(row in rownames(resultat)){
        for(name in colnames(resultat)){
          total_course <- sum(affichage_club[,name] > 0)
          dessus_course <- sum(affichage_club[,name] >= resultat[row,name])
          Performance[row,name] <- 100 - (dessus_course / total_course) * 100
        }
      }
      if(length(input$affichage_clubs_rows_selected) == 1){
        if (affichage_club[input$affichage_clubs_rows_selected,"Courses"] > 1){#Comparaison graphique 
          
          Courses <- 1:ncol(Performance)
          matplot(t(Performance),xaxt="n", ylim = c(0,100), col=c("red"),sub="(Le classement relatif se calcule comme suit : Classement relatif = (Classement personnel) / (Nombre de participants) * 100.)",ylab="Classement relatif (%)", pch = 16,type= "b",main = "Classement relatif")
          axis(1, at = Courses,panel.first=grid(),labels =colnames(resultat)) 
        }
      }else if(length(input$affichage_clubs_rows_selected) > 1){
        
        row.names(Performance) <- c(1:nrow(Performance))
        Courses <- 1:ncol(Performance)
        matplot(t(Performance),xaxt="n", ylim = c(0,100), col=c("red","blue","chartreuse3","navy","darkorange","black"),sub="(Le classement relatif se calcule comme suit : Classement relatif = (Classement personnel) / (Nombre de participants) * 100.)",ylab="Classement relatif (%)", type= "b",main = "Classement relatif")
        axis(1, at = Courses,panel.first=grid(),labels =colnames(resultat)) 
        
      }
    }
  }
})