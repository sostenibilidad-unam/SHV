###Generar proporciones inundación/ encharcamiento
doublecoupling <- function (rate,n,cc){
po <- n
K <- cc
r<- rate
t <- seq(1,40,by=1)
encha_s <- rep(0,length(t))
inund_s <- rep(0,length(t))

for (i in 1:length(t)){ 
pt <- (r*po)*(1-po/K)
pf <- po+pt
po <- pf
encha_s[i]<- ceiling(pf)
inund_s[i]<- ceiling(100-pf)
}
return(list(encha_s=encha_s,inund_s=inund_s))
}

a<-doublecoupling(0.05,25,90)

plot(a$inund_s)
lines(a$encha_s)

