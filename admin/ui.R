library(shiny)
library(shinydashboard)
library(DT)
library(shinythemes)
options(encoding = "UTF-8")
shinyUI(
 
  dashboardPage(title = "Swim & Run Application", skin = "green",
    dashboardHeader(title ="SwimRun & Raid Administration",
                    titleWidth = 400
                    
                    ),
    
    
    dashboardSidebar(
      sidebarMenu(
       
        menuItem("SwimRun",icon = icon("th"),
                 startExpanded = TRUE,
                 menuSubItem("Individuel", tabName = "Sindiv"),
                 menuSubItem("Clubs", tabName = "Sclubs")
                 
        ),
        menuItem("Raid",icon = icon("th"),
                 startExpanded = TRUE,
                 menuSubItem("Clubs Adultes", tabName = "RclubsAdulte"),
                 menuItem("Clubs Jeunes", startExpanded = TRUE,
                          menuSubItem("Poussin", tabName = "Rpouss"),
                          menuSubItem("Pupille", tabName = "Rpup"),
                          menuSubItem("Minime", tabName = "RMinim"),
                          menuSubItem("benjamin", tabName = "Rben"),
                          menuSubItem("Cadet", tabName = "Rcadet"),
                          menuSubItem("Junior", tabName = "Rjun")
                 )
                 ),
        menuItem("Ajouter une course",tabName = "ajouter", icon = icon("plus"))
     
      )
    ),
   
    
    dashboardBody(
      tabItems(
        tabItem(tabName = "ajouter",
                fluidPage(
                  theme = shinytheme("yeti"),
                  navbarPage("Ajout de course",
                             tabPanel("",
                                      fluidRow(
                                        column(5,textInput("nameRace", label = h3("Nom de la course"), value = ""),
                                              
                                               selectInput("class", label = h3("Catégorie"), 
                                                           choices = list("Adultes","Jeunes"), 
                                                           selected = 1),
                                               selectInput("nbrParEquipe", label = h3("Nombre de participants/équipe"), 
                                                           choices = list("2","3","4"), 
                                                           selected = 1),
                                               fileInput("raceFile","Sélectionnez une course", multiple = FALSE)
                                        ),
                                        column(4,selectInput("discipline", label = h3("Discipline"), 
                                                             choices = list("Swim & run", "Raid"), 
                                                             selected = 1),
                                               
                                               selectInput("distance", label = h3("Distance"), 
                                                           choices = list("XS", "S", "M", "L", "XL","XXL"), 
                                                           selected = 1),
                                               dateInput('dateRace',
                                                         label = h3('Date de la course'),
                                                         value = Sys.Date()
                                               ))
                                       # tags$img(src="2-1.jpg",height="300",width="300")
                                        
                                      ),
                                      actionButton("checkRace", label = "Vérifier la course"),
                                      
                                      textOutput("errorRace"),
                                      
                                      DT::dataTableOutput("clubs"),
                                      textOutput("courseValide")
                             )
                  )
                )
               
#                 tags$img(src="2-1.jpg",height="300",width="300"),
#                 fluidPage(
# 
# box(width=T,htmlOutput("BG")),               
# infoBoxOutput("out1")   )
                
),
        tabItem(tabName = "Sindiv", 
                tags$div(class="competition"),
                fluidRow(
                  box(title = "Score individuel",status = "success",solidHeader = T,width = T,DTOutput("affichage_indiv"))
                ),
                fluidRow(
                  box(title = "Statistiques du sportif",status = "success",solidHeader = T,width = T,htmlOutput("affichage_indiv_perso"),tableOutput("affichage_indiv_stats"))
                ),
                fluidRow(
                  box(title = "Graphics",status = "success",solidHeader = T,width = T,plotOutput("affichage_indiv_perf_global"))
                )
        ),
          tabItem(tabName = "Sclubs", 
                  tags$div(class="competition"),
                  fluidRow(
                    box(title = "Score Clubs",status = "success",solidHeader = T,width = T,DTOutput("affichage_clubs"))
                  ),
                  fluidRow(
                    box(title = "Information sur le club",status = "success",solidHeader = T,width = T,htmlOutput("affichage_clubs_info"),tableOutput("affichage_clubs_stats")),
                    box(title = "Statistique du Club",status = "success",solidHeader = T,width = T,plotOutput("affichage_clubs_perf"))
                  )
          ),
        tabItem(tabName = "Rpouss", 
               
                fluidRow(
                  box(title = "Score individuel",status = "success",solidHeader = T,width = T,DTOutput("Raid_Po"))
                )
      ),
      tabItem(tabName = "Rpup", 
              
              fluidRow(
                box(title = "Score individuel",status = "success",solidHeader = T,width = T,DTOutput("Raid_Pu"))
              )
      ),
      tabItem(tabName = "Rben", 
              
              fluidRow(
                box(title = "Score individuel",status = "success",solidHeader = T,width = T,DTOutput("Raid_Be"))
              )
      ),
      tabItem(tabName = "Rcadet", 
              
              fluidRow(
                box(title = "Score individuel",status = "success",solidHeader = T,width = T,DTOutput("Raid_Ca"))
              )
      ),
      tabItem(tabName = "RMinim", 
            
              fluidRow(
                box(title = "Fichier Resultat",status = "success",solidHeader = T,width = T,dataTableOutput("Raid_Mi"))
              )
      ),
    tabItem(tabName = "Rjun", 
            
            fluidRow(
              box(title = "Fichier Resultat",status = "success",solidHeader = T,width = T,dataTableOutput("Raid_Ju"))
            )
    )
 
      
      )
    )
  )
)
