coefMulti<-function(distance){
  coef_multi<-switch(as.character(distance),
                     XS=1,
                     S=2,
                     M=3,
                     L=4,
                     XL=5,
                     XXL=6)
  return (coef_multi)
}