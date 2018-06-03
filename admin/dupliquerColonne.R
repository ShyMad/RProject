#' duplication d'une colonne.
#'
#' @param x une colonne.
#' @param y un nombre.
#' @return duplication d'une colonne \code{x} , \code{y} fois.
#' @examples
#' resultats <- data.frame(taille=c(185,178,165,150,162),
#' poids=c(82,81,55,65,68), QI=c(110,108,125,99,124),
#' sexe=c("M","M","F","F","F"), row.names=c("Paul","Matthieu","Camille","Mireille","Capucine"))
#'  resultats
#'              taille poids  QI    sexe
#'  Paul        185    82     110   M
#'  Matthieu    178    81     108   M
#'  Camille     165    55     125   F
#'  Mireille    150    65     99    F
#'  Capucine    162    68     124   F
#'
#'  x <-dupliquerColonne(resultats$QI,3)
#'
#'  x
#'  [1] 110 108 125  99 124 110 108 125  99 124 110 108 125  99 124 110 108 125  99
#'  [20] 124

dupliquerColonne<-function(x,y){
  a<-x
  for (i in 2:y-1){
    x<-c(x,a)
  }
  return(x)
}