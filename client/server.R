library(shiny)
library(shinythemes)
library(xlsx)
library(plyr)
library(stats)
library(shinydashboard)
library(readxl)
library(data.table)
library(DT)
source("coefMulti.R")
source("dupliquerColonne.R")
source("moveColumn.R")
source("vecteurScore.R")
#source("fct.R")

options(encoding = "UTF-8")
options(java.parameters = "-Xmx16384m")
shinyServer(function(input,output){
  addClass(selector = "body", class = "sidebar-collapse")

############################### afficher le classement du SwimRun ###########################
  source("affichage_sm_indiv_view.R",  encoding="UTF-8",  local = TRUE)
  source("affichage_sm_club.R",encoding = "UTF-8",local=TRUE)
############################### afficher le classement du Raid ###########################
  source("affichage_raid.R",encoding = "UTF-8",local=TRUE)
############################### afficher les statistiques  ###########################
  source("stats.R",encoding = "UTF-8",local=TRUE)
############################### accueil  ###########################
  source("infos.R",encoding = "UTF-8",local=TRUE)

})