# R program for LD_F2 macro
#
#   Input:   
#               var: a vector of variable of interest
#               time1: a vector of the first time variable
#               time2: a vector of the second time variable
#               subject: a vector of independent subjects
#               time1.name: time1 factor name. Default is set to Time_C
#               time2.name: time2 factor names. Default is set to Time_T
#               description: description of the output. Default is set to TRUE (show description)
#   Output:
#             list of relative treatment effects, test results, covariance matrix
#  
ld.f2 <- function(var, time1, time2, subject, time1.name = "TimeC", time2.name = "TimeT", description=TRUE) 
{
#        For model description see Brunner et al. (2002)
#    
#        Author: Karthinathan Thangavelu (kthanga@gwdg.de)
#                     Department of Medical Statistics, Goettingen, Germany
#
#         Version:  01-01
#         Date: March 1, 2003
#
#
#        Editied by: Kimihiro Noguchi
#         Version:  01-02
#         Date: August 14, 2009
#
#    Key Variables:
#                time1: time1 factor
#                time2: time2 factor
#                C: number of levels of time1
#                T: number of levels of time2
#                CTcount: number of levels of time1 times number of levels of time2
#                RD: ranks of the observations
#                N: total number of subject
#                sort1: sort unique time 1 factors
#                sort2: sort unique time 2 factors
#                uvector: numbering of the unique combination of factors
#                Rs: matrix of the ranks sorted by time2 factors
#                Rsl: matrix of the indicators sorted by time2 factors
#                Rr: matrix of the ranks sorted by time1 factors
#                Rrl: matrix of the indicators sorted by time1 factors
#                origRmat: Matrix of the observations by different factors
#                Lamda: indicator of whether the observations are made (0=missing, 1=observed)
#                NN: total number of observations
#                Lamdamat: Matrix of the Lamda indicator by different factors
#                Rmat: Matrix of the observations by different factors, where missing observations=0
#                Ni: number of observations per factor
#                RMeans: rank means of each unique factor combinations and each factor
#                DatRMeans: rank means of each unique factor combinations

#    check whether the input variables are entered correctly

	   if(is.null(var)||is.null(time1)||is.null(time2)||is.null(subject)) 
		stop("At least one of the input parameters (var, time1, time2, or subject) is not found.")
	   
           sublen<-length(subject)
	   varlen<-length(var)
	   tim1len<-length(time1)
	   tim2len<-length(time2)
	   
	   if((sublen!=varlen)||(sublen!=tim1len)||(sublen!=tim2len))
		stop("At least one of the input parameters (var, time1, time2, or subject) has a different length.")



	library(MASS)
	time1 <- factor(time1)
	time2 <- factor(time2)
	C <- nlevels(time1)
	T <- nlevels(time2)
	CTcount <- C*T
	RD <- rank(var)
	N <- length(unique(subject))
        sort1<-sort(unique(time1))
        sort2<-sort(unique(time2))
        uvector <- double(length(RD)) 

	for(i in 1:length(RD))
        {
         uvector[i]<-T*which(sort1==time1[i])+which(sort2==time2[i])-T
        }

        Lamda <- 1-as.numeric(is.na(var))
        RMeans<-tapply(RD*Lamda,uvector,sum)/tapply(Lamda,uvector,sum)
        Nobs<-tapply(Lamda,uvector,sum)

        origRmat<-matrix(nrow=N, ncol=CTcount) 
        Lamdamat<-matrix(nrow=N, ncol=CTcount)            
        for(i in 1:CTcount)
        {
         origRmat[,i]<-RD[which(uvector==i)]
         Lamdamat[,i]<-Lamda[which(uvector==i)]
        }

        Rs<-matrix(nrow=N*C, ncol=T)
        Rsl<-matrix(nrow=N*C, ncol=T)
        for(i in 1:T)
        {
         Rs[,i]<-RD[which(time2==sort2[i])]
         Rsl[,i]<-Lamda[which(time2==sort2[i])]
        }
        Rs<-Rs*Rsl

        Rr<-matrix(nrow=N*T, ncol=C)
        Rrl<-matrix(nrow=N*T, ncol=C)
        for(i in 1:C)
        {
         Rr[,i]<-RD[which(time1==sort1[i])]
         Rrl[,i]<-Lamda[which(time1==sort1[i])]
        }
        Rr<-Rr*Rrl

	origRmat <- matrix(RD, N, CTcount)
	NN <- sum(Lamda)
	Lamdamat <- matrix(Lamda, N, CTcount)
	Rmat <- origRmat * Lamdamat
	Ni <- apply(Lamdamat, 2, sum) 

	DatRMeans <- RMeans 

     	if(description==TRUE)
     	{
           cat(" LD F2 Model ") 
           cat("\n ----------------------- ")
	   cat("\n Total number of observations : ", NN)
	   cat("\n Total Number of subjects ", N)
	   cat("\n Total Number of missing observations : ", (N*CTcount - NN), "\n")
           cat("\n Class level information ")
           cat("\n ----------------------- ")
	   cat("\n Levels of", time1.name, "(sub-plot factor time1) : ", C)
	   cat("\n Levels of", time2.name, "(sub-plot factor time2) : ", T,"\n")
           cat("\n Abbreviations ")
           cat("\n ----------------------- \n")
           cat(" RankMeans = Rank means\n")
           cat(" Nobs = Number of observations\n")
           cat(" RTE = Relative treatment effect\n")
           cat(" Wald.test = Wald-type test statistic\n")
           cat(" ANOVA.test = ANOVA-type test statistic\n")
           cat(" covariance = Covariance matrix","\n")
           cat(" Note: The description output above will disappear by setting description=FALSE in the input. See the help file for details.","\n\n")
      	}

        Rmeanstime1<-tapply(RD*Lamda,time1,sum)/tapply(Lamda,time1,sum)
        Nobstime1<-tapply(Lamda,time1,sum)  
        Rmeanstime2<-tapply(RD*Lamda,time2,sum)/tapply(Lamda,time2,sum)
        Nobstime2<-tapply(Lamda,time2,sum)  

	RMeans <- c(RMeans,Rmeanstime1,Rmeanstime2) 
        Nobs <- c(Nobs, Nobstime1, Nobstime2)

	RTE <- (RMeans - 0.5)/NN

	time1.vec  <- c(paste(time1.name, sort1,sep=""))
	time2.vec <- c(paste(time2.name, sort2,sep=""))

	fn.nice.out <- function(n1, n2) 
	{
		SOURCE <- rep(0,0)
		for(j in 1:n1)
		for(i in 1:n2)
		SOURCE <- c(SOURCE, paste(time1.vec[j], ":", time2.vec[i],sep=""))

		for(i in 1:n1) SOURCE <- c(SOURCE, paste(time1.vec[i])) 
		for(i in 1:n2) SOURCE <- c(SOURCE, paste(time2.vec[i]))

		return(SOURCE)
	}

	SOURCE <- fn.nice.out(C, T)

	PRes1 <- data.frame(RankMeans=RMeans, Nobs, RTE) 
	rd.PRes1 <- round(PRes1, Inf)
        rownames(rd.PRes1)<-SOURCE

	RTE <- RTE[1:CTcount]

	fn.contT <- function(mat, mat1) 
	{
		I <- diag(1, ncol(mat), ncol(mat))
		J <- matrix((1/ ncol(mat)), ncol(mat), ncol(mat))
		C <- I - J
		C1mat <- matrix((1/ncol(mat1)), 1, ncol(mat1))
		C <- kronecker(C1mat, C)
		return(C)
	}

	fn.contCC <- function(mat, mat1) 
	{
		I <- diag(1, ncol(mat), ncol(mat))
		J <- matrix((1/ ncol(mat)), ncol(mat), ncol(mat))
		C <- I - J
		T1mat <- matrix((1/ncol(mat1)), 1, ncol(mat1))
		C <- kronecker(C, T1mat)
		return(C)
	}

	fn.contC <- function(mat, mat1) 
	{
		I <- diag(1, ncol(mat), ncol(mat))
		J <- matrix((1/ ncol(mat)), ncol(mat), ncol(mat))
		I1 <- diag(1, ncol(mat1), ncol(mat1))
		J1 <- matrix((1/ ncol(mat1)), ncol(mat1), ncol(mat1))	
		C <- kronecker((I - J), (I1 - J1))
		return(C)
	}

	fn.covr<-function(N,d,NN,Ni,Rmat,DatRMeans,Lamdamat)
	{
		V<-matrix(0,d,d);
		for(s in 1:d) 
		{
			for(sdash in 1:d) 
			{
	      			if(s==sdash) 
				{
					temp<-(Rmat[,s]-DatRMeans[s])*(Rmat[,s]-DatRMeans[s]); 	
		    			V[s,sdash]<-V[s,sdash]+N*(Lamdamat[,s]%*%temp)/(NN^2*Ni[s]*(Ni[s]-1));
				}	

	      			if(s!=sdash) 
				{
		   			temp<-(Rmat[,s]-DatRMeans[s])*(Rmat[,sdash]-DatRMeans[sdash]);
		   			temp1<-Lamdamat[,s]*Lamdamat[,sdash];
		   			ks<-(Ni[s]-1)*(Ni[sdash]-1)+Lamdamat[,s]%*%Lamdamat[,sdash]-1;
		   			V[s,sdash]<-V[s,sdash]+N*(temp1%*%temp)/(NN^2*ks);
	       			} 	
	   		}
		}
		return(V);  
	}

	V <- fn.covr(N, C*T, NN, Ni, Rmat, DatRMeans, Lamdamat)

	SING.COV <- FALSE
	if(qr(V)$rank < C*T) SING.COV <- TRUE
	if(SING.COV) 
	{
		cat("\n Warning(s):\n")
		cat(" The covariance matrix is singular. \n")
	}

	if(((C > 1) && (T > 1))) 
	{
		CC <- fn.contCC(Rr, Rs)
		CT <- fn.contT(Rs, Rr)
		CCT <- fn.contC(Rr, Rs)

		### Wald type statistics computed here

		WC <- N*t(CC%*%RTE)%*%ginv(CC%*%V%*%t(CC))%*%(CC%*%RTE)
		WT <- N*t(CT%*%RTE)%*%ginv(CT%*%V%*%t(CT))%*%(CT%*%RTE)
		WCT <- N*t(CCT%*%RTE)%*%ginv(CCT%*%V%*%t(CCT))%*%(CCT%*%RTE)

		dfWC <- qr(CC)$rank
		dfWT <- qr(CT)$rank
		dfWCT <- qr(CCT)$rank

		if((!is.na(WC)) && WC > 0) pWC <- 1 - pchisq(WC, dfWC)
		else pWC <- NA

		if((!is.na(WT)) && WT > 0) pWT <- 1 - pchisq(WT, dfWT)
		else pWT <- NA

		if((!is.na(WCT)) && WCT > 0) pWCT <- 1 - pchisq(WCT, dfWCT)
		else pWCT <- NA

		W <- rbind(WC,WT,WCT)
		pW <- rbind(pWC,pWT,pWCT)
		dfW <- rbind(dfWC,dfWT,dfWCT)

		WaldType <- data.frame(W, dfW, pW)
		rd.WaldType <- round(WaldType, Inf)
		Wdesc <- rbind(time2.name, time1.name, paste(time2.name,":", time1.name, sep=""))
		colnames(rd.WaldType) <- c("Statistic", "df", "p-value")
		rownames(rd.WaldType) <- Wdesc

		### Box (ANOVA) type statistics computed here

		fn.tr <- function(mat) 
		{
			return(sum(diag(mat)))
		}

		BtC <- t(CC)%*%(ginv(CC%*%t(CC)))%*%CC
		BtT <- t(CT)%*%(ginv(CT%*%t(CT)))%*%CT
		BtCT <- t(CCT)%*%(ginv(CCT%*%t(CCT)))%*%CCT

		TVC <- BtC%*%V
		BC <- (N/fn.tr(TVC)) * ((t(RTE)) %*% BtC %*% (RTE))
		BCf <- ((fn.tr(BtC%*%V))^2)/(fn.tr(BtC%*%V%*%BtC%*%V))

		if((!is.na(BC))&&(!is.na(BCf))&&(BC >= 0)&&(BCf > 0)) BCp <- 1 - pf(BC, BCf, 100000)
		else BCp <- NA

		TVT <- BtT%*%V
		BT <- (N/fn.tr(TVT)) * ((t(RTE)) %*% BtT %*% (RTE))
		BTf <- ((fn.tr(BtT%*%V))^2)/(fn.tr(BtT%*%V%*%BtT%*%V))

		if((!is.na(BT))&&(!is.na(BTf))&&(BT >= 0)&&(BTf > 0)) BTp <- 1 - pf(BT, BTf, 100000)
		else BTp <- NA

		TVCT <- BtCT%*%V
		BCT <- (N/fn.tr(TVCT)) * ((t(RTE)) %*% BtCT %*% (RTE))
		BCTf <- ((fn.tr(BtCT%*%V))^2)/(fn.tr(BtCT%*%V%*%BtCT%*%V))

		if((!is.na(BCT))&&(!is.na(BCTf))&&(BCT >= 0)&&(BCTf > 0)) BCTp <- 1 - pf(BCT, BCTf, 100000)
		else BCTp <- NA

		B <- rbind(BC,BT,BCT)
		pB <- rbind(BCp,BTp,BCTp)
		dfB <- rbind(BCf,BTf,BCTf)

		BoxType <- data.frame(B, dfB, pB)
		rd.BoxType <- round(BoxType, Inf)
		Bdesc <- rbind(time2.name, time1.name, paste(time2.name,":", time1.name, sep=""))
		colnames(rd.BoxType) <- c("Statistic", "df", "p-value")
		rownames(rd.BoxType) <- Bdesc
   
	}

            out.ld.f2 <- list(RTE=rd.PRes1,Wald.test=rd.WaldType,ANOVA.test=rd.BoxType, covariance=V) 
            return(out.ld.f2)
}