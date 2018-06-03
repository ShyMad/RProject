#Script pour l'affichage des individuels SwimRun pour un simple utilisateur 
affichage = read.xlsx2("Stockage.xlsx",1,stringsAsFactors = FALSE,check.names=FALSE)

affichage<-affichage[which (affichage$Cat=="Se" | affichage$Cat=="Ve"),]
affichage$CLUB<-as.character(affichage$CLUB)
affichage$Total <- as.numeric(as.character(affichage$Total))
for (i in 10:ncol(affichage)){
  affichage[,i] <- as.numeric(as.character(affichage[,i]))
}
affichage$Courses = rowSums(affichage[,-c(1:9)] > 0)
setcolorder(affichage, moveColumn(names(affichage), "Courses after Total"))
ind<-which(affichage$CLUB=="")
clubVide<-"NON AFFILIE"
affichage[ind,"CLUB"]<-clubVide
affichage<-affichage[ order(-affichage$Total), ]
affichage$Classement<-c(1:nrow(affichage))
setcolorder(affichage,moveColumn(names(affichage),"Classement before Total"))
affichage1<-affichage[1:9]
affichage1<-affichage1[ order(affichage1$Classement), ]
#Affichage des adultes indivi.
output$affichage_indiv <- renderDT(server = FALSE, {
  datatable(affichage1,
            extensions = 'Buttons',
            selection = 'single',
            filter = 'top',
            options = list( 
              columnDefs = list(list(className = 'dt-center', targets = "_all")),
              pageLength = 25,
              order = list(5, 'asc'),
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
            colnames = c('Points' = 'Total', 'Catégorie' = 'Cat','Courses réalisées' = 'Courses'),
            rownames = FALSE
  )
})
# Afficher les informations d'un sportif.
output$affichage_indiv_perso <-  renderUI({
  if (length(input$affichage_indiv_rows_selected) != 0){
    
    sportif <- affichage[input$affichage_indiv_rows_selected,];
    
    if (sportif[,"Courses"] != 0){
      sportif <- sportif[, colSums(sportif != 0) > 0];
      if (sportif[,"Courses"] == 1){ #Si 1 seule course réalisée, affichage en conséquence
        nb_courses = "</br>Course réalisée : <b>1</b> "
      }else{#Sinon affichage du nombre de courses
        nb_courses = paste("</br>Courses réalisées : <b>",sportif[,"Courses"],"</b>")
      }
      
      if(sportif[,"Sexe"] == "M"){#Affichage de l'icône de sexe
        img <- "<img src='man.ico' height='40' width='40'></img>"
      }else{
        img <- "<img src='woman.ico' height='40' width='40'></img>"
      }
      
      HTML(paste("<h2>",sportif[,"Nom"], sportif[,"Prénom"], "</h2>", img, "</br>","Catégorie : <b>",sportif[,"Cat"],"</b></br>Classement au sein de la catégorie : <b>",sportif[,"Classement"],"</b></br>Points totaux :<b>", sportif[,"Total"],"</b>",nb_courses,  sep =' '))
    }
  }
})

#Afficher les statistiques courses
output$affichage_indiv_stats <-  renderTable({
  if (length(input$affichage_indiv_rows_selected) == 1){
    if(affichage[input$affichage_indiv_rows_selected,"Courses"] > 1){
      resultat <- affichage[input$affichage_indiv_rows_selected,]
      resultat <- resultat[, colSums(resultat != 0) > 0]
      resultat <- resultat[,12:NCOL(resultat)]
    }
  }
},striped = TRUE, hover = TRUE, bordered = TRUE)

# Affichage du graphique de classement relatif global
output$affichage_indiv_perf_global <-  renderPlot({
  if (length(input$affichage_indiv_rows_selected) == 1 ){
    if(affichage[input$affichage_indiv_rows_selected,"Courses"] > 1){
      sportif <- affichage[input$affichage_indiv_rows_selected,]
      resultat <- affichage[input$affichage_indiv_rows_selected,]
      resultat <- resultat[, colSums(resultat != 0) > 0];
      resultat <- resultat[,12:NCOL(resultat)]
      
      Performance <- resultat
      
      for(name in colnames(resultat)){
        total_course <- sum(affichage[,name] > 0)
        dessus_course <- sum(affichage[,name] >= resultat[,name])
        Performance[1,name] <- 100 - (dessus_course / total_course) * 100
      }
      
      Courses <- 1:length(Performance)
      matplot(t(Performance),xaxt="n",col=c("red"),pch = 16,sub="(Classement relatif = (Classement personnel) / (Nombre de participants global) * 100)",ylab="Classement relatif (%)", type= "b", ylim = c(0,100),main = paste("Classement relatif global de", sportif[,"Prénom"], sportif[,"Nom"], sep=' '))
      axis(1, at = Courses,panel.first=grid(),labels =colnames(Performance)) 
    }
  }
})