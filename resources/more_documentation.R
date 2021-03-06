# Create sample
J<-3
initial <- rep(1/J,J)
P <- matrix(c(.8,.5,.1,0.05,.2,.5,.15,.3,.4),nrow=J)
b <- list(mu=c(-3,0,2),sigma=c(2,1,.5))
model <- hmmspec(init=initial, trans=P, parms.emission=b,dens.emission=dnorm.hsmm)
model

train <- simulate(model, nsim=300, seed=1234, rand.emis=rnorm.hsmm)
plot(train,xlim=c(0,100))

init0 <- rep(1/J,J)
P0 <- matrix(1/J,nrow=J,ncol=J)
b0 <- list(mu=c(-3,1,3),sigma=c(1,1,1))
startval <- hmmspec(init=init0, trans=P0,parms.emission=b0,dens.emission=dnorm.hsmm) 
h1 = hmmfit(train,startval,mstep=mstep.norm)

plot(h1$loglik,type='b',ylab='Log-likelihood',xlab='Iteration')
summary(h1)

#proportion of incorrect states
mean(train$s!=predict(h1,train)$s)

#simulate a new test set 
test <- simulate(model, nsim=c(300), seed=1234,rand.emis=rnorm.hsmm)
mean(test$s!=predict(h1,test)$s)




yhat <- numeric(length(test$s))
for (i in 1:length(test$s)) {
  state <- predict(h1,test)$s[i]
  mu <- h1[["model"]][["parms.emission"]][["mu"]][state]
  sigma <- h1[["model"]][["parms.emission"]][["sigma"]][state]
  yhat[i] <- rnorm(1, mu, sigma)
}

scorer::rmse(test$x, yhat)
scorer::mae(test$x, yhat)




last_state <- train$s[300]
draw <- runif(1)
h1[["model"]][["transition"]][1, ]


