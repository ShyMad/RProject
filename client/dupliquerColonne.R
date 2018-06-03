dupliquerColonne<-function(x,y){
  a<-x
  for (i in 2:y-1){
    x<-c(x,a)
  }
  return(x)
}