vecteurScore<-function(x){
  if (x<=150){
    score_max<-x
  }
  else {
    score_max<-150
  }
  pts<-c(score_max:1,rep(1,x-score_max))
  return(pts)
  
}