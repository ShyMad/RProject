library(shiny)
library(shinydashboard)
library(DT)
library(shinythemes)
library(utf8)
library(shinyjs)

options(encoding = "UTF-8")
shinyUI(
  
  dashboardPage(title = "Swim Run & Raid Application", skin = "red",
                dashboardHeader(title ="SwimRun & Raid Application",
                                titleWidth = 350,
                                tags$li(class = "dropdown",
                                        tags$a(href = "https://www.facebook.com/F.F.TRI", 
                                               target = "_blank", 
                                               tags$img(height = "15px", 
                                                        src = "fb.png")
                                        )
                                ),
                                
                                
                                tags$li(class = "dropdown",
                                        tags$a(href = "http://www.fftri.com/", 
                                               target = "_blank", 
                                               tags$img(height = "15px", 
                                                        src = "calais.jpg")
                                        )
                                )
                                
                               
                ),
                
                
              dashboardSidebar(
                sidebarMenu(
                  menuItem("Accueil",tabName="Home",icon=icon("home")),
                  menuItem("SwimRun",icon = icon("th"),
                           startExpanded = TRUE,
                           menuSubItem("Le SwimRun",tabName="swimRunHome"),
                           menuSubItem("Individuel", tabName = "Sindiv"),
                           menuSubItem("Clubs", tabName = "Sclubs")
                           
                  ),
                  menuItem("Raid",icon = icon("th"),
                           startExpanded = TRUE,
                           menuSubItem("Le Raid",tabName="raidHome"),
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
                  menuItem("Statistiques",tabName = "stats",icon=icon("th"))
                 
                 )
              ),
                
                
              dashboardBody(
                useShinyjs(),
                        tabItems(
                          tabItem(tabName = "Home",
                                  fluidPage(
                                    tags$head(
                                      tags$link(rel = "stylesheet", type = "text/css", href = "Darky.css")
                                    ),
                                   
                      fluidPage(class="apphome"),
                      fluidRow(class="homenav",
                        infoBoxOutput("out1"),
                        infoBoxOutput("out2")
                      )
                      )),
                      
                      tabItem(tabName = "swimRunHome",
                        fluidPage(
                          fluidRow(class="swimhome",
                                   tags$span(class="swimhomebox-title",
                                             tags$h1("Le SwimRun")
                                   ),
                            tags$div(class="swimhomebox",
                                         tags$div(class="swiminfo",
                                                  tags$div(class="text-container",
                                                      htmlOutput("swiminfos")
                                                      )
                                             
                                              )
                                    
                            )
                          ) 
                          ) ,
                        tags$div(class="swimnav",
                        
                        fluidRow(
                          
                          htmlOutput("out3")),
                        fluidRow(
                          
                          htmlOutput("out4"))
                       
                        )
                      
                                   
                      ),
                      tabItem(tabName = "raidHome",
                              fluidPage(
                                fluidRow(class="raidhome",
                                         tags$span(class="swimhomebox-title",
                                                   tags$h1("Le Raid")
                                         ),
                                         tags$div(class="swimhomebox",
                                                  tags$div(class="swiminfo",
                                                           tags$div(class="text-container-raid",
                                                                    htmlOutput("raidinfos")
                                                           )
                                                      )
                                                 )
                                ) 
                              ) ,
                              tags$div(class="swimnav",
                                       
                                       fluidRow(
                                         
                                         htmlOutput("out5")),
                                       fluidRow(
                                         
                                         htmlOutput("out6"))
                                       
                              )
                              
                              
                      ),
                    tabItem(tabName = "Sindiv", 
                            tags$div(class="competition"),
                            fluidRow(
                              box(title = "Score individuel",status = "danger",solidHeader = T,width = T,DTOutput("affichage_indiv"))
                            ),
                           fluidRow(
                              box(title = "Statistiques du sportif",status = "danger",solidHeader = T,width = T,htmlOutput("affichage_indiv_perso"),tableOutput("affichage_indiv_stats"))
                            ),
                           fluidRow(
                             box(title = "Graphics",status = "danger",solidHeader = T,width = T,plotOutput("affichage_indiv_perf_global"))
                           )
                    ),
                    tabItem(tabName = "Sclubs", 
                            tags$div(class="competition"),
                            fluidRow(
                              box(title = "Score Clubs",status = "danger",solidHeader = T,width = T,DTOutput("affichage_clubs"))
                            ),
                            fluidRow(
                              box(title = "Information sur le club",status = "danger",solidHeader = T,width = T,htmlOutput("affichage_clubs_info"),tableOutput("affichage_clubs_stats")),
                              box(title = "Statistique du Club",status = "danger",solidHeader = T,width = T,plotOutput("affichage_clubs_perf"))
                            )
                    ),
                    tabItem(tabName = "RclubsAdulte", 
                           
                            fluidRow(
                              box(title = "Score Clubs",status = "danger",solidHeader = T,width = T,DT::dataTableOutput("Sncludsbs"))
                            )
                    ),
                    tabItem(tabName = "Rpouss", 
                                
                                fluidRow(
                                  box(title = "Score individuel",status = "danger",solidHeader = T,width = T,DTOutput("Raid_Po"))
                                )
                    ),
                    tabItem(tabName = "Rpup", 
                            
                            fluidRow(
                              box(title = "Score individuel",status = "danger",solidHeader = T,width = T,DTOutput("Raid_Pu"))
                            )
                    ),
                    tabItem(tabName = "Rben", 
                            
                            fluidRow(
                              box(title = "Score individuel",status = "danger",solidHeader = T,width = T,DTOutput("Raid_Be"))
                            )
                    ),
                    tabItem(tabName = "Rcadet", 
                            
                            fluidRow(
                              box(title = "Score individuel",status = "danger",solidHeader = T,width = T,DTOutput("Raid_Ca"))
                            )
                    ),
                    tabItem(tabName = "RMinim", 
                            
                            fluidRow(
                              box(title = "Fichier Resultat",status = "danger",solidHeader = T,width = T,dataTableOutput("Raid_Mi"))
                            )
                    ),
                    tabItem(tabName = "Rjun", 
                            
                            fluidRow(
                              box(title = "Fichier Resultat",status = "danger",solidHeader = T,width = T,dataTableOutput("Raid_Ju"))
                            )
                    ),
                    tabItem(tabName = "stats",
                            
                        tags$div(class="stats"),
                        fluidRow(
                          status = "primary",
                          width = 12,
                          solidHeader = FALSE,
                          collapsible = FALSE,
                          valueBoxOutput("participants", width = 3),
                          valueBoxOutput("nbclubs", width = 3),
                          valueBoxOutput("nbfemmes", width = 3),
                          valueBoxOutput("nbhommes", width = 3)
                        ),
                     
                        fluidRow(
                         
                          box(title="Statistiques",status = "danger",solidHeader = T,width = T,htmlOutput("stats_ad"),plotOutput("stats_graph_ad"))
                        )
                    )
                    
                  )
                )
  )
)
