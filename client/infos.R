
#Acceder à la page SwimRun
  output$out1 <- renderInfoBox({
    infoBox("Swim Run",
            a("Accéder a la page", onclick = "openTab('swimRunHome')"),
            tags$script(HTML("
        var openTab = function(tabName){
          $('a', $('.sidebar')).each(function() {
            if(this.getAttribute('data-value') == tabName) {
              this.click()
            };
          });
        }
      ")),
            icon = icon("check"), color = "black"
    )
  })
#Acceder à ma page Raid 
  output$out2 <- renderInfoBox({
    infoBox("Raid",
            a("Accéder a la page", onclick = "openTab('raidHome')"),
            tags$script(HTML("
                             var openTab = function(tabName){
                             $('a', $('.sidebar')).each(function() {
                             if(this.getAttribute('data-value') == tabName) {
                             this.click()
                             };
                             });
                             }
                             ")),
            icon = icon("check"), color = "blue"
            )
})
#Acceder au classement individuel SwimRun
  output$out3  <- renderUI({
    infoBox("SwimRun indivduel",
            a("Accéder a la page", onclick = "openTab('Sindiv')"),
            tags$script(HTML("
                             var openTab = function(tabName){
                             $('a', $('.sidebar')).each(function() {
                             if(this.getAttribute('data-value') == tabName) {
                             this.click()
                             };
                             });
                             }
                             ")),
            icon = icon("users"), color = "black"
            )
})
#Acceder au classement des clubs SwimRun
  output$out4 <- renderUI({
    infoBox("SwimRun Clubs",
            a("Accéder a la page", onclick = "openTab('Sclubs')"),
            tags$script(HTML("
                             var openTab = function(tabName){
                             $('a', $('.sidebar')).each(function() {
                             if(this.getAttribute('data-value') == tabName) {
                             this.click()
                             };
                             });
                             }
                             ")),
            icon = icon("cubes"), color = "black"
            )
    })
#Acceder au classement des clubs Raid pour les adultes 
  output$out5  <- renderUI({
    infoBox("Raid Adulte",
            a("Accéder a la page", onclick = "openTab('Radulte')"),
            tags$script(HTML("
                             var openTab = function(tabName){
                             $('a', $('.sidebar')).each(function() {
                             if(this.getAttribute('data-value') == tabName) {
                             this.click()
                             };
                             });
                             }
                             ")),
            icon=icon("users"),color = "blue"
            )
})
#Acceder au classement des clubs Raid pour les jeunes 
  output$out6 <- renderUI({
    infoBox("Raid Jeunes",
            a("Accéder a la page", onclick = "openTab('Rcadet')"),
            tags$script(HTML("
                             var openTab = function(tabName){
                             $('a', $('.sidebar')).each(function() {
                             if(this.getAttribute('data-value') == tabName) {
                             this.click()
                             };
                             });
                             }
                             ")),
            icon = icon("users"), color = "black"
    )
  })
#Information sur les disciplines
output$swiminfos <- renderUI({
  HTML("<p>Les Swim Run sont des manifestations enchaînant des parcours de natation et course à pied répétés, d’un minimum de trois segments.</p>
       <p>Les participant.e.s effectuent la course principalement en binôme.</p>
       <p>A la différence du triathlon qui possède des aires de transition permettant de changer de tenue/matériel, les swimrunners conservent leur tenue et leur matériel sur l’ensemble du parcours.</p>")
})
output$raidinfos <- renderUI({
  HTML("<p>Le raid est une discipline sportive composée d’au moins 3 sports de nature enchaînés ou à minima, deux activités linéaires et un atelier en terrain naturel varié, le tout non motorisé, réalisés par équipe.</p>
       <p>Tous sports de nature peut composer un raid. Vous ne vous ennuierez jamais grâce à l’enchaînement des activités, souvent conditionné par le terrain. Les activités de base sont : VTT, course à pied, et canoë avec ou sans orientation, mais d’autres activités ou ateliers peuvent rythmer l’épreuve : cordes, tir, stand up paddle, spéléo, etc…</p>
       ")
})