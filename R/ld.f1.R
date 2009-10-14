# R program for LD_F1 macro
#
#   Input:   
#               var: a vector of variable of interest
#               time: a vector of time variable
#               subject: a vector of independent subjects
#   Optional Input:
#               w.pat: pattern for the pattern alternatives
#		time.name: name of the time vector. "Time" is set as default.
#               description: description of the output. Default is set to TRUE (show description)
#   Output:
#             list of relative treatment effects, test results, pattern results, covariance matrix
#  
ld.f1 <- function(var, time, subject, w.pat=NULL, time.name="Time", description=TRUE)
{
#        For model description see Brunner et al. (2002)
#    
#        Author: Mahbub Latif (mlatif@gwdg.de)
#                     Department of Medical Statistics, Goettingen, Germany
#
#         Version:  01-01
#         Date: December 2, 2002
#
#        changed multiple option from the macro /mahbub
#
#        Editied by: Kimihiro Noguchi
#         Version:  01-02
#         Date: August 14, 2009
#
#    Key Variables:
#                time: time factor
#                t: number of levels of time
#                N: total number of observations + missing observations
#                ind: indicator of whether there exists a missing observation (0=Yes,1=No)
#                Nmiss: total number of missing observations
#                subject: total number of subject
#                rankvar: ranks of the variable of interest
#                rankmean: mean rank for each level of time
#                Nobs: total number of observations for each level of time
#                RTE: relative treatment effects
#                Q: Wald-type Statistic
#                pvQ: p-value for the Wald-type Statistic
#                F: Hotelling's T^2 Statistic
#                pvQ: p-value for the Hotelling's T^2 Statistic
#                A: ANOVA-type Statistic
#                pvA: p-value for the ANOVA-type Statistic
#                Tn: Tn statistic for testing equality of marginal distributions for t = 2
#                TnB: Tn statistic for testing equality of marginal distributions for t = 2 
#                     in the nonparametric Behrens-Fisher situation
#                Kn: Kn statistic for testing equality of marginal distributions for t = 2
#                pvN: p-value for the Tn, TnB, or Kn statistic with normal distribution
#                pvT: p-value for the Tn, TnB, or Kn statistic with Student's T distribution

#    check whether the input variables are entered correctly

	   if(is.null(var)||is.null(time)||is.null(subject)) 
		stop("At least one of the input parameters (var, time, or subject) is not found.")
	   
           sublen<-length(subject)
	   varlen<-length(var)
	   timlen<-length(time)
	   
	   if((sublen!=varlen)||(sublen!=timlen))
		stop("At least one of the input parameters (var, time, or subject) has a different length.")

#    initialize parameters

           library(MASS)
           time <- factor(time)
           t <- nlevels(time)
           N <- length(var)
           ind <- 1-is.na(var)
           Nmiss <- N-sum(ind)
           n <- length(unique(subject))

#    Output for the number of observations, missing observations, and subject

           rankvar <- rank(var,na.last=TRUE)
           ### Rank Means ### 
           rankvar <- rankvar*ind

#    Calculation of the mean rank for each level of time
               junk1 <- sapply(split(rankvar,factor(time):factor(subject)),sum)
               junk2 <- sapply(split(ind,factor(time):factor(subject)),sum)
               mean.time.subj <- matrix(junk1/junk2, n, t)
       
               mind <- is.finite(mean.time.subj)
               rankmean <- apply(mean.time.subj,2,function(x){mean(x,na.rm=TRUE)})

           Nobs <- sapply(split(ind, factor(time)), sum)
           RTE <- (rankmean-.5)/sum(ind)

#    Output for the description of the model and tests

     if(description==TRUE)
     {
           cat(" LD F1 Model ") 
           cat("\n ----------------------- \n")
           cat(" Total number of observations: ",sum(ind),"\n") 
           cat(" Total number of subjects:  " , n,"\n")
           cat(" Total number of missing observations: ",Nmiss,"\n") 
           cat("\n Class level information ")
           cat("\n ----------------------- \n")
           cat(" Levels of factor:   ", t,"\n")
           cat("\n Abbreviations ")
           cat("\n ----------------------- \n")
           cat(" RankMeans = Rank means\n")
           cat(" Nobs = Number of observations\n")
           cat(" RTE = Relative treatment effect\n")
           cat(" Wald.test = Wald-type test statistic\n")
           cat(" Hotelling.test = Hotelling's F (T^2) test statistic\n")
           cat(" ANOVA.test = ANOVA-type test statistic\n")
           cat(" two.sample.test = Two-sample test statistic (if no observation missing) \n")
           cat(" two.sample.bf.test = Two-sample test statistic for Behrens-Fisher situation (if no observation missing) \n")
           cat(" N = Standard Normal Distribution N(0,1)\n")
           cat(" T = Student's T distribution with", n-1, "degrees of freedom\n")
           if(!is.null(w.pat))
           {
            pattern.string<-w.pat
           }
           else
           {
            pattern.string<-"no pattern specified"
           }           
           cat(" pattern.test = Test against patterned alternatives (",pattern.string,")","\n")
           cat(" covariance = Covariance matrix","\n")
           cat(" Note: The description output above will disappear by setting description=FALSE in the input. See the help file for details.","\n\n")
      }
           utimetemp<-unique(time)
           utime<-utimetemp
           ulength<-length(utime)
           SOURCE<-double(ulength)
           for(i in 1:ulength)
           {
            SOURCE[i]<-paste(time.name,utime[i],sep="")
           }

           out <- data.frame(RankMeans=rankmean,Nobs,RTE)
           rownames(out)<-SOURCE

# Program for covariance matrix for LD_F1 macro
#
#    Input:
#                   t : Number of time points
#                   n: Number of subjects
#                   mvar: matrix of order n x t of the variable of interest
#                   mind: matrix of order n x t of the missing indicators  
#                   rmean: rankmeans for each time pont
#
#    For missing completely at random observation, see 7.2.8.

covr <- function(mvar, mind, rmean, t){
      V <- matrix(0, t, t)
      lam <- apply(mind,2,sum)
      mvarvec<-c(mvar)
      mvarvec<-replace(mvarvec,which(is.na(mvarvec)),0)
      mvar<-matrix(mvarvec,ncol=t)
       for(i in 1:t)
       {
        V[i,i] <- t(mind)[i,]%*%((mvar[,i]-rmean[i])^2)/(lam[i]*(lam[i]-1))
        if( i<t)
        {
         j <- i+1	
         for(j in (i+1):t)
         {
          Lam <- t(mind)[i,]%*%mind[,j]
          Lam2<-sum(t(mind)[i,]*t(mind)[j,])
          K <- (lam[i]-1)*(lam[j]-1)+Lam-1
          V[i,j] <- (1/K)*(t(mind)[i,]*t(mind)[j,])%*%((mvar[,i]-rmean[i])*(mvar[,j]-rmean[j]))   
          V[j,i] <- V[i,j]
         }
        }
       }
      return(V)
}    


           ### covariance matrix ####
	       V <- (n/(sum(ind)^2))*covr(mean.time.subj,mind,rankmean,t)

           ### initializing test variables ####
	       wald.test <- NULL
	       hotelling.test <- NULL
	       anova.test <- NULL
               two.sample.test <- NULL
               two.sample.bf.test <- NULL
               pattern.test <- NULL
 
           # IF t > 1, where t is the number of levels of time, the following output will be produced  
           if(t > 1){	

	       #### Wald test ####
	       C <- diag(t)-matrix(1/t,t,t)
	       CVC <- C%*%V%*%C
	       p <- matrix(RTE,t,1)
	       cp <- C%*%p
	       Q <- n*t(cp)%*%ginv(CVC)%*%cp 
	       dfq <- sum(diag(CVC%*%ginv(CVC)))
	       if((!is.na(Q))&&(!is.na(dfq))&&(Q > 0)&&(dfq > 0)) pvQ <- 1-pchisq(Q, dfq)
	       else pvQ<-NA
	       wald.test <- data.frame(Statistic=Q, df=dfq, P.value=pvQ)
	       colnames(wald.test) <- c("Statistic", "df", "p-value")
               rownames(wald.test) <- time.name

	       ##### Hotelling T^2 ###
	       F <- Q*(n-t+1)/((t-1)*(n-1))
	       dff1 <- t -1
	       dff2 <- n-t+1
               if((!is.na(F))&&(!is.na(dff1))&&(!is.na(dff2))&&(F > 0)&&(dff1 > 0)&&(dff2 > 0)) 
	       {
	       	pvF <- 1-pf(F, dff1, dff2)
	       	hotelling.test <- data.frame(Statistic=F, df1=dff1, df2=dff2, P.value=pvF)
	       	colnames(hotelling.test) <- c("Statistic", "df1", "df2", "p-value")
               	rownames(hotelling.test) <- time.name
               }

	       ###### ANOVA type #####
	       T <- C%*%ginv(C%*%C)%*%C
	       f <- (sum(diag(T%*%V)))^2/sum(diag(T%*%V%*%T%*%V))
	       A <- n*t(p)%*%T%*%p/sum(diag(T%*%V))
	       if((!is.na(A))&&(!is.na(f))&&(A > 0)&&(f > 0)) pvA <-1-pchisq(A*f, f)
	       else pvA <- NA
	       anova.test <- data.frame(Statistic=A, df=f, P.value=pvA)
	       colnames(anova.test) <- c("Statistic", "df", "p-value")
               rownames(anova.test) <- time.name
            }

            # IF t = 2, where t is the number of levels of time, and there is no missing observation, 
            # the following output will be produced         
            if(t==2 && Nmiss==0) {
               # See 7.1.1
               mat.var <- sapply(split(rankvar, time),matrix)
               mean.var <- apply(mat.var, 2, mean)
               junk <- t(t(mat.var) - mean.var)
               # equation 7.1
               Sn2 <- sum(((apply(junk,1,diff))^2))/(n-1)
               # equation 7.2 
               Tn <- sqrt(n)*(mean.var[2] - mean.var[1])/sqrt(Sn2)
               pvN <- 2*(1-pnorm(abs(Tn)))
               pvT <- 2*(1-pt(abs(Tn), (n-1)))
               two.sample.test <- data.frame(Statistics=Tn, NN=pvN, df=n-1, tt=pvT)
               colnames(two.sample.test) <- c("Statistic", "p-value(N)", "df", "p-value(T)")
               rownames(two.sample.test) <- time.name
               
               # Behrens-Fisher Situation (See 7.1.3)
               mat.var.rank <- apply(sapply(split(var, time), rank),1,diff)   
               Sn2B <- sum((apply(junk,1,diff) - mat.var.rank)^2)/(n-1)
               TnB <- sqrt(n)*(mean.var[2] - mean.var[1])/(2*sqrt(Sn2B))
               pvN <- 2*(1-pnorm(abs(TnB)))
               pvT <- 2*(1-pt(abs(TnB),(n-1)))
               #out.test <- rbind(out.test, c(TnB,pvN,pvT))
               nn <- c("H_0^F (F1=F2)", "H_0^p (p1=p2)")
               #out.test <- data.frame(out.test, row.names=nn)
               two.sample.bf.test <- data.frame(Statistics=TnB, NN=pvN, df=n-1, tt=pvT)
               colnames(two.sample.bf.test) <- c("Statistic", "p-value(N)", "df","p-value(T)")
               rownames(two.sample.bf.test) <- time.name   
            }	

            #### Patterned Alternatives #####
            if(!is.null(w.pat)){
               # See 5.6
	       C <- diag(t)-matrix(1/t,t,t)
	       CVC <- C%*%V%*%C
	       p <- matrix(RTE,t,1)
	       cp <- C%*%p
               junk <- matrix(w.pat,t,1)
               sigma2 <- t(junk)%*%CVC%*%junk 
               Kn <- round(sqrt(n)*t(junk)%*%cp/sqrt(sigma2),Inf)	
               pvN <- 1-pnorm(Kn)
               pvT <- 1-pt(Kn, n-1)
               pattern.test <- data.frame(Statistics=Kn, NN=pvN, df=n-1, tt=pvT)
               colnames(pattern.test) <- c("Statistic", "p-value(N)", "df","p-value(T)")
               rownames(pattern.test) <- time.name
            }
            else pattern <- NULL

	    SING.COV <- FALSE
	    if(qr(V)$rank < t) SING.COV <- TRUE
	    if(SING.COV) 
	    {
		cat("\n Warning(s):\n")
		cat(" The covariance matrix is singular. \n")
	    }

            ## OUTPUT ##
            out.ld.f1 <- list(RTE=out,Wald.test=wald.test, Hotelling.test=hotelling.test, 
            ANOVA.test=anova.test, two.sample.test=two.sample.test, two.sample.BF.test=two.sample.bf.test, 
            pattern.test=pattern.test, covariance=V) 
            return(out.ld.f1)
}

