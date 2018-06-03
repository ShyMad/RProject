# Calcul stats 
nb_adults <- nrow(affichage)
nb_adults_clubs <- nrow(affichage_club)
# nb_youngs <- nrow(challenge2)
# nb_youngs_clubs <- nrow(challenge2_clubs)
nb_woman_adult <- count(affichage, c(4))["1", "freq"]
# nb_woman_young <- count(challenge2, c(5))["1", "freq"]
ad_se <- count(affichage, c(5))["1", "freq"]
ad_ve <- count(affichage, c(5))["2", "freq"]

# jn_be <- count(challenge2, c(6))["1", "freq"]
# jn_ca <- count(challenge2, c(6))["2", "freq"]
# jn_ju <- count(challenge2, c(6))["3", "freq"]
# jn_mi <- count(challenge2, c(6))["4", "freq"]
# jn_po <- count(challenge2, c(6))["5", "freq"]
# jn_pu <- count(challenge2, c(6))["6", "freq"]


mean_ad_pt <- round(mean(affichage$Total),2)
# mean_jn_pt <- round(mean(challenge2$TOTAL),2)
mean_ad_club <- round(mean(affichage_club$Total),2)
# mean_jn_club <- round(mean(challenge2_clubs$TOTAL),2)

nbcourse_adulte <- ncol(affichage) - 11
# nbcourse_jeunes <- ncol(challenge2) - 7


# Affichage stats
output$stats_ad <- renderUI({
  ad <- "<b>Adultes</b><br/>"
  courses_ad <- paste("Il y a <b>", nbcourse_adulte, "</b> courses dans le challenge.")
  str1 <- paste("Il y a <b>",nb_adults, "</b> participant(e)s appartenant à <b>",nb_adults_clubs, "</b> clubs.")
  ad_cat <- paste("Par catégorie, ils sont <b>", ad_se, "</b> en senior et <b>", ad_ve, '</b> en vétéran.')
  str2 <- paste("Il y a <b>", nb_woman_adult, '</b> femmes et <b>', nb_adults - nb_woman_adult, "</b> hommes.")
  pt_ad <- paste("La moyenne des points est de <b>", mean_ad_pt,"</b> par sportif et de <b>", mean_ad_club, "</b> par club.")

  HTML(paste(ad,courses_ad, str1, str2, ad_cat, pt_ad, sep = '<br/>'))

})
output$participants <- renderValueBox({
    valueBox(nb_adults,"Total des Participants",icon = icon("users"), color = 'green') })
output$nbclubs <- renderValueBox({
    valueBox(nb_adults_clubs,"Total des Clubs",icon = icon("flag-o"), color = 'blue') })
output$nbfemmes <- renderValueBox({
    valueBox(nb_woman_adult,"Femmes",icon = icon("user"), color = 'red') })
output$nbhommes <- renderValueBox({
    valueBox(nb_adults - nb_woman_adult,"Hommes",icon = icon("user"), color = 'purple') })

output$stats_graph_ad <- renderPlot({
  y1 = c(nb_woman_adult, nb_adults - nb_woman_adult)
  y2 = c(ad_se, ad_ve)
  par(mfcol = c(1,2), mfrow = c(1,2))
  pie(y1, labels = c("Femme","Homme"), col=c('red','lightcoral'))
  pie(y2, labels = c("Senior","Vétéran"), col=c('blue','lightblue'))
})

# output$stats_jn <- renderUI({
#   jn <- "<b>Jeunes</b><br/>"
#   courses_jn <- paste("Il y a <b>", nbcourse_jeunes, "</b> courses dans le challenge.")
#   str3 <- paste("Il y a <b>",nb_youngs, "</b> participant(e)s appartenant à <b>",nb_youngs_clubs, "</b> clubs.")
#   jn_cat <- paste("Par catégorie, ils sont <b>", jn_be, "</b> en benjamin, <b>", jn_ca, "</b> en cadet, <b>", jn_ju, "</b> en junior, <b>", jn_mi, "</b> en minime, <b>", jn_po, "</b> en poussin et <b>", jn_pu, "</b> en pupille.")
#   str4 <- paste("Il y a <b>", nb_woman_young, '</b> femmes et <b>', nb_youngs - nb_woman_young, "</b> hommes.")
#   pt_jn <- paste("La moyenne des points est de <b>", mean_jn_pt, "</b> par sportif et de <b>", mean_jn_club, "</b> par club.")
#   
#   HTML(paste(jn,courses_jn, str3, str4, jn_cat, pt_jn, sep = '<br/>'))
#   
# })

# output$stats_graph_jn <- renderPlot({
#   y1 = c(nb_woman_young, nb_youngs - nb_woman_young)
#   y2 = c(jn_pu, jn_po,jn_mi,jn_ju,jn_ca,jn_be)
#   par(mfcol = c(1,2), mfrow = c(1,2))
#   pie(y1, labels = c("Femme","Homme"), col=c('orange','lightgreen'))
#   pie(y2, labels = c("Pupille","Poussin","Minime","Junior","Cadet","Benjamin"), col=c('red','lightblue','green','pink','blue','orange'))
# })
