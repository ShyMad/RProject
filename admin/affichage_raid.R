#Script pour l'affichage des jeunes Raid 
affichage_raid = read.xlsx2("Stockage.xlsx",1,stringsAsFactors = FALSE,check.names=FALSE)
affichage_raid<-affichage_raid[which (affichage_raid$Cat=="Pu" | affichage_raid$Cat=="Po" |affichage_raid$Cat=="Be"|
                                        affichage_raid$Cat=="Ca"|affichage_raid$Cat=="Ju"|
                                        affichage_raid$Cat=="Mi")|affichage_raid$Cat=="Mp",]
affichage_raid$CLUB<-as.character(affichage_raid$CLUB)
affichage_raid$Total <- as.numeric(as.character(affichage_raid$Total))
for (i in 10:ncol(affichage_raid)){
  affichage_raid[,i] <- as.numeric(as.character(affichage_raid[,i]))
}
affichage_raid$Courses = rowSums(affichage_raid[,-c(1:9)] > 0)
setcolorder(affichage_raid, moveColumn(names(affichage_raid), "Courses after Total"))
ind<-which(affichage_raid$CLUB=="")
clubVide<-"NON AFFILIE"
affichage_raid[ind,"CLUB"]<-clubVide
affichage_raid<-affichage_raid[ order(-affichage_raid$Total), ]
affichage_raid$Classement<-c(1:nrow(affichage_raid))
setcolorder(affichage_raid,moveColumn(names(affichage_raid),"Classement before Total"))
#Jeunes Poussins
affichage_Po<-affichage_raid[which (affichage_raid$Cat=="Po"),]
clubs_po<-data.frame(subset(affichage_Po, select = c(CLUB,Total,11:ncol(affichage_Po))),stringsAsFactors = FALSE)
clubs_po$Total<-as.numeric(as.character(clubs_po$Total))
for (i in 3:ncol(clubs_po)){
  clubs_po[,i]<-as.numeric(as.character(clubs_po[,i]))
}
clubs_po[is.na(clubs_po)]<-0
affichage_Po<-aggregate(. ~ CLUB,clubs_po,sum)
#Jeunes Pupilles
affichage_Pu<-affichage_raid[which (affichage_raid$Cat=="Pu"),]
clubs_pu<-data.frame(subset(affichage_Pu, select = c(CLUB,Total,11:ncol(affichage_Pu))),stringsAsFactors = FALSE)
clubs_pu$Total<-as.numeric(as.character(clubs_pu$Total))
for (i in 3:ncol(clubs_pu)){
  clubs_pu[,i]<-as.numeric(as.character(clubs_pu[,i]))
}
clubs_pu[is.na(clubs_pu)]<-0
affichage_Pu<-aggregate(. ~ CLUB,clubs_pu,sum)
#Jeunes Mini poussins
affichage_Mp<-affichage_raid[which (affichage_raid$Cat=="Mp"),]
clubs_mp<-data.frame(subset(affichage_Mp, select = c(CLUB,Total,11:ncol(affichage_Mp))),stringsAsFactors = FALSE)
clubs_mp$Total<-as.numeric(as.character(clubs_mp$Total))
for (i in 3:ncol(clubs_mp)){
  clubs_mp[,i]<-as.numeric(as.character(clubs_mp[,i]))
}
clubs_mp[is.na(clubs_mp)]<-0
affichage_Mp<-aggregate(. ~ CLUB,clubs_mp,sum)
#Jeunes Minimes
affichage_Mi<-affichage_raid[which (affichage_raid$Cat=="Mi"),]
clubs_mi<-data.frame(subset(affichage_Mi, select = c(CLUB,Total,11:ncol(affichage_Mi))),stringsAsFactors = FALSE)
clubs_mi$Total<-as.numeric(as.character(clubs_mi$Total))
for (i in 3:ncol(clubs_mi)){
  clubs_mi[,i]<-as.numeric(as.character(clubs_mi[,i]))
}
clubs_mi[is.na(clubs_mi)]<-0
affichage_Mi<-aggregate(. ~ CLUB,clubs_mi,sum)
#Jeunes Junior
affichage_Ju<-affichage_raid[which (affichage_raid$Cat=="Ju"),]
clubs_ju<-data.frame(subset(affichage_Ju, select = c(CLUB,Total,11:ncol(affichage_Ju))),stringsAsFactors = FALSE)
clubs_ju$Total<-as.numeric(as.character(clubs_ju$Total))
for (i in 3:ncol(clubs_ju)){
  clubs_ju[,i]<-as.numeric(as.character(clubs_ju[,i]))
}
clubs_ju[is.na(clubs_ju)]<-0
affichage_Ju<-aggregate(. ~ CLUB,clubs_ju,sum)
#Jeunes Benjamins
affichage_Be<-affichage_raid[which (affichage_raid$Cat=="Be"),]
clubs_be<-data.frame(subset(affichage_Be, select = c(CLUB,Total,11:ncol(affichage_Be))),stringsAsFactors = FALSE)
clubs_be$Total<-as.numeric(as.character(clubs_be$Total))
for (i in 3:ncol(clubs_be)){
  clubs_be[,i]<-as.numeric(as.character(clubs_be[,i]))
}
clubs_be[is.na(clubs_be)]<-0
affichage_Be<-aggregate(. ~ CLUB,clubs_be,sum)
#Jeunes Cadets
affichage_Ca<-affichage_raid[which (affichage_raid$Cat=="Ca"),]
clubs_ca<-data.frame(subset(affichage_Ca, select = c(CLUB,Total,11:ncol(affichage_Ca))),stringsAsFactors = FALSE)
clubs_ca$Total<-as.numeric(as.character(clubs_ca$Total))
for (i in 3:ncol(clubs_ca)){
  clubs_ca[,i]<-as.numeric(as.character(clubs_ca[,i]))
}
clubs_ca[is.na(clubs_ca)]<-0
affichage_Ca<-aggregate(. ~ CLUB,clubs_ca,sum)

############################################################################
#Affichage Raid Jeunes
#Affichage du classement
output$Raid_Mp <- DT::renderDataTable({
  datatable(affichage_Mp,
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
#Minime
output$Raid_Mi <- DT::renderDataTable({
  datatable(affichage_Mi,
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
#Poussin
output$Raid_Po <- DT::renderDataTable({
  datatable(affichage_Po,
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
#Pupille
output$Raid_Pu <- DT::renderDataTable({
  datatable(affichage_Pu,
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
#Benjamin
output$Raid_Be <- DT::renderDataTable({
  datatable(affichage_Be,
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
#Cadet
output$Raid_Ca <- DT::renderDataTable({
  datatable(affichage_Ca,
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
#Junior 
output$Raid_Ju <- DT::renderDataTable({
  datatable(affichage_Ju,
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