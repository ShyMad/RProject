#' Repositionner les colonnes
#'
#' @param invec un dataframe
#' @param movecommand une chaine de caractères
#' @return  le dataframe \code{invec} rearanger selon la chaine de caractère \code{movecommand} .
#' @examples
#'resultats <- data.frame(taille=c(185,178,165,150,162),
#' poids=c(82,81,55,65,68), QI=c(110,108,125,99,124),
#' sexe=c("M","M","F","F","F"), row.names=c("Paul","Matthieu","Camille","Mireille","Capucine"))
#' moveColumn(names(resultats),"QI before taille")
#'[1] "QI"     "taille" "poids"  "sexe"
moveColumn <- function (invec, movecommand) {
  movecommand <- lapply(strsplit(strsplit(movecommand, ";")[[1]],
                                 ",|\\s+"), function(x) x[x != ""])
  movelist <- lapply(movecommand, function(x) {
    Where <- x[which(x %in% c("before", "after", "first",
                              "last")):length(x)]
    ToMove <- setdiff(x, Where)
    list(ToMove, Where)
  })
  myVec <- invec
  for (i in seq_along(movelist)) {
    temp <- setdiff(myVec, movelist[[i]][[1]])
    A <- movelist[[i]][[2]][1]
    if (A %in% c("before", "after")) {
      ba <- movelist[[i]][[2]][2]
      if (A == "before") {
        after <- match(ba, temp) - 1
      }
      else if (A == "after") {
        after <- match(ba, temp)
      }
    }
    else if (A == "first") {
      after <- 0
    }
    else if (A == "last") {
      after <- length(myVec)
    }
    myVec <- append(temp, values = movelist[[i]][[1]], after = after)
  }
  myVec
}
