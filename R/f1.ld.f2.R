# R program for F1_LD_F2 macro
#
#   Input:   
#               var: a vector of variable of interest
#               group: a vector of group variable
#               time1: a vector of the time1 variable
#               time2: a vector of the time2 variable
#               subject: a vector of independent subjects
#               time1.name: time1 factor name. Default is set to TimeC
#               time2.name: time2 factor name. Default is set to TimeT
#               group.name: whole plot factor names. Default is set to GroupA
#               description: description of the output. Default is set to TRUE (show description)
#   Output:
#             list of relative treatment effects, test results, covariance matrix
#  
f1.ld.f2 <- function(var, time1, time2, group, subject, time1.name = "TimeC", 
time2.name = "TimeT", group.name = "GroupA", description=TRUE) {
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
#         Date: August 25, 2009
#
#    Key Variables:
#                FAC: whole plot factor
#                time1: time1 factor
#                time2: time2 factor
#                subject: subject factor
#                D: variable of interest
#                Lamda: indicator of whether the data are present (0=missing, 1=observed)
#                levs: whole plot factor levels
#                A: number of levels of whole plot factor
#                N: total number of subject
#                C: number of levels of time1 factor
#                T: number of levels of time2 factor
#                CTcount: number of different combinations of the time factor levels
#                RD: ranks of the observations
#                uvector: number assigned to each unique combination of the factor levels
#                sort1: sorted time1 factor levels
#                sort2: sorted time2 factor levels
#                Rmat: Matrix of the observations by different factors, where missing observations=0
#                Lamdamat: Matrix of the Lamda indicator by different times
#                NN: total number of observations
#                RMeans: rank means of each unique factor combinations and each factor
#                Ni: number of observations at each level

#    check whether the input variables are entered correctly

	   if(is.null(var)||is.null(time1)||is.null(time2)||is.null(group)||is.null(subject)) 
		stop("At least one of the input parameters (var, time1, time2, group, or subject) is not found.")
	   
           sublen<-length(subject)
	   varlen<-length(var)
	   tim1len<-length(time1)
	   tim2len<-length(time2)
	   grolen<-length(group)
	   
	   if((sublen!=varlen)||(sublen!=tim1len)||(sublen!=tim2len)||(sublen!=grolen))
		stop("At least one of the input parameters (var, time1, time2, group, or subject) has a different length.")


	library(MASS)
	factor<-group
	factor.name<-group.name
	FAC<-factor(factor)
	time1<-factor(time1)
	time2<-factor(time2)
	subject<-factor(subject)
	D<-var
	Lamda <- 1-as.numeric(is.na(D)) 
	levs <- levels(FAC)
	A <- nlevels(FAC)
	N <- nlevels(subject)
	C <- nlevels(time1)
	T <- nlevels(time2)
	CTcount <- C*T
	RD <- rank(D)
	uvector <- double(N)
	sort1 <- unique(time1)
	sort2 <- unique(time2)
	Rmat <- matrix(NA, N, CTcount)
	Lamdamat <- matrix(NA, N, CTcount)

	for(i in 1:(N*C*T))
	{
	 	uvector[i] <- T*which(sort1==time1[i])+which(sort2==time2[i])-T
 		Rmat[subject[i],uvector[i]]<-RD[i]
 		Lamdamat[subject[i],uvector[i]]<-Lamda[i]
	}

	NN <- sum(Lamda) 
	Rmat <- Rmat * Lamdamat 
	RMeans <- rep(0, (A + C + T + (A*C) + (C*T) + (T*A) + (A*C*T)))

	### This order is important ie, A, C, T, (A*C), (C*T), (T*A), (A*C*T) 

	Ni <- apply(Lamdamat, 2, sum) 

	fn.collapse.day <- function(mat, n, n.c, n.t) 
	{
		res <- matrix(0, nrow=n.t*n, ncol=n.c)
		for(i in 1:n.c) 
		{
			for(j in 1:n.t) 
			{
				res[(((j-1)*n+1):((j-1)*n+n)), i] <- mat[, ((i-1)*n.t + j)]
			}
		}
		return(res)
	}

	Rr <- fn.collapse.day(Rmat, N, C, T)
	R1r <- fn.collapse.day(Lamdamat, N, C, T)

	fn.collapse.time <- function(mat, n, n.c, n.t) 
	{
		res <- matrix(0, nrow=n.c*n, ncol=n.t)
		for(i in 1:n.t) 
		{
			for(j in 1:n.c) 
			{
				res[(((j-1)*n+1):((j-1)*n+n)), i] <- mat[, ((j-1)*n.t + i)]
			}
		}
		return(res)
	}

	Rs <- fn.collapse.time(Rmat, N, C, T)
	R1s <- fn.collapse.time(Lamdamat, N, C, T)

	fn.fact.manip <- function(fullRmat, n, n.a, n.c, n.t) 
	{
		res.list <- list(0)
		res.A <- matrix(0, nrow = (n/n.a)*n.c*n.t, ncol = n.a)
		res.AC <- array(0, dim = c(n.a, (n/n.a)*n.t, n.c))
		res.AT <- array(0, dim = c(n.a, (n/n.a)*n.c, n.t))
		res.ACT <- array(0, dim = c(n.a, (n/n.a), n.c*n.t))
		temp.Rmat <- matrix(0, nrow=n/n.a, ncol=n.c*n.t)
	
		for(i in 1:n.a) 
		{
			temp.Rmat <- fullRmat[(((n/n.a)*(i-1)) + 1) : (((n/n.a)*(i-1)) + (n/n.a)), ]
			res.A[,i] <- c(temp.Rmat)
			res.AC[i,,] <- fn.collapse.day(temp.Rmat, n/n.a, n.c, n.t)
			res.AT[i,,] <- fn.collapse.time(temp.Rmat, n/n.a, n.c, n.t)
			res.ACT[i,,] <- temp.Rmat
		}

		res.list[[1]] <- res.A
		res.list[[2]] <- res.AC
		res.list[[3]] <- res.AT
		res.list[[4]] <- res.ACT

		return(res.list)
	}

	Ra.list <- fn.fact.manip(Rmat, N, A, C, T)
	R1a.list <- fn.fact.manip(Lamdamat, N, A, C, T)

	RMeans[1 : A] <- (apply(Ra.list[[1]], 2, sum) / apply(R1a.list[[1]], 2, sum))
	RMeans[(A + 1) : (A + C)] <- (apply(Rr, 2, sum) / apply(R1r, 2, sum))
	RMeans[(A + C + 1) : (A + C + T)] <- (apply(Rs, 2, sum) / apply(R1s, 2, sum))

	for(i in 1:A) 
	{
		RMeans[(A + C + T + (i-1)*C + 1) : (A + C + T + (i-1)*C + C)] <- 
		(apply(Ra.list[[2]][i,,], 2, sum) / apply(R1a.list[[2]][i,,], 2, sum))
	}

	RMeans[(A + C + T + C*A + 1) : (A + C + T + C*A + C*T)] <- 
	(apply(Rmat, 2, sum) / apply(Lamdamat, 2, sum))

	for(i in 1:A) 
	{
		RMeans[(A + C + T + C*A + C*T + (i-1)*T + 1) : (A + C + T + C*A + C*T + (i-1)*T + T)] <- 
		(apply(Ra.list[[3]][i,,], 2, sum) / apply(R1a.list[[3]][i,,], 2, sum))
	}

	for(i in 1:A) 
	{
		RMeans[(A + C + T + C*A + C*T + T*A + (i-1)*C*T + 1) : (A + C + T + C*A + C*T + T*A + (i-
		1)*C*T + C*T)] <- (apply(Ra.list[[4]][i,,], 2, sum) / apply(R1a.list[[4]][i,,], 2, sum))
	}

	RTE <- (RMeans - 0.5) / NN 

	time1.vec <- c(paste(time1.name, sort1, sep=""))
	time2.vec <- c(paste(time2.name, sort2, sep=""))

	fn.nice.out <- function(A, C, T) 
	{
		SOURCE <- rep(0,0)

		for(i in 1:A)
			SOURCE <- c(SOURCE, paste(factor.name, levs[i], sep=""))
		for(i in 1:C)
			SOURCE <- c(SOURCE, paste(time1.vec[i], sep=""))
		for(i in 1:T)
			SOURCE <- c(SOURCE, paste(time2.vec[i], sep=""))
		for(i in 1:A)
			for(j in 1:C)
				SOURCE <- c(SOURCE, paste(factor.name, levs[i], ":", time1.vec[j], sep=""))
		for(i in 1:C)
			for(j in 1:T)
				SOURCE <- c(SOURCE, paste(time1.vec[i], ":", time2.vec[j], sep=""))
		for(i in 1:A)
			for(j in 1:T)
				SOURCE <- c(SOURCE, paste(factor.name, levs[i], ":", time2.vec[j], sep=""))
		for(i in 1:A)
			for(j in 1:C)
				for(k in 1:T)
					SOURCE <- c(SOURCE, paste(factor.name, levs[i], ":", time1.vec[j], ":", time2.vec[k], sep=""))

		return(SOURCE)
	}

	SOURCE <- fn.nice.out(A, C, T)

	Nobs <- rep(0, (A + C + T + (A*C) + (C*T) + (T*A) + (A*C*T)))
	Nobs[1 : A] <- (apply(R1a.list[[1]], 2, sum))
	Nobs[(A + 1) : (A + C)] <- (apply(R1r, 2, sum))
	Nobs[(A + C + 1) : (A + C + T)] <- (apply(R1s, 2, sum))

	for(i in 1:A) 
	{
		Nobs[(A + C + T + (i-1)*C + 1) : (A + C + T + (i-1)*C + C)] <- 
		(apply(R1a.list[[2]][i,,], 2, sum))
	}

	Nobs[(A + C + T + C*A + 1) : (A + C + T + C*A + C*T)] <- (apply(Lamdamat, 2, sum))

	for(i in 1:A) 
	{
		Nobs[(A + C + T + C*A + C*T + (i-1)*T + 1) : (A + C + T + C*A + C*T + (i- 1)*T + T)] <- 
		(apply(R1a.list[[3]][i,,], 2, sum))
	}

	for(i in 1:A) 
	{
		Nobs[(A + C + T + C*A + C*T + T*A + (i-1)*C*T + 1) : (A + C + T + C*A + C*T + T*A + 
		(i-1)*C*T + C*T)] <- (apply(R1a.list[[4]][i,,], 2, sum))
	}

	PRes1 <- data.frame(RankMeans=RMeans, Nobs, RTE) 
	rd.PRes1 <- round(PRes1, Inf)
	rownames(rd.PRes1)<-SOURCE

     	if(description==TRUE)
     	{
           cat(" F1 LD F2 Model ") 
           cat("\n ----------------------- ")
	   cat("\n Total number of observations : ", NN)
	   cat("\n Total Number of subjects ", N)
	   cat("\n Total Number of missing observations : ", (N*CTcount - NN), "\n")
           cat("\n Class level information ")
           cat("\n ----------------------- ")
	   cat("\n Levels of", factor.name, "(whole-plot factor group) : ", A)
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

	fn.P.mat <- function(arg1) 
	{
		I <- diag(1, arg1, arg1)
		J <- matrix((1/arg1), arg1, arg1)
		return(I - J)
	}


	PA <- fn.P.mat(A)
	PC <- fn.P.mat(C)
	PT <- fn.P.mat(T)

	A1 <- matrix((1/A), 1, A)
	C1 <- matrix((1/C), 1, C)
	T1 <- matrix((1/T), 1, T)

	CA <- kronecker(PA, kronecker(C1, T1))
	CC <- kronecker(A1, kronecker(PC, T1))
	CT <- kronecker(A1, kronecker(C1, PT))
	CAC <- kronecker(PA, kronecker(PC, T1))
	CCT <- kronecker(A1, kronecker(PC, PT))
	CAT <- kronecker(PA, kronecker(C1, PT))
	CACT <- kronecker(PA, kronecker(PC, PT))

	fn.covr<-function(N,d,NN,Ni,Rmat,DatRMeans,Lamdamat, A, C, T)
	{
		V<-matrix(0,d,d);
		temp.mat <- matrix(0, N/A, N/A);
		fn.covr.block.mats <- function(N,d,NN,Ni,Rmat,DatRMeans,Lamdamat) 
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


		for(i in 1:A) 
		{

			Ni <- apply(Lamdamat[(((i-1)*(N/A) + 1) : ((i-1)*(N/A) + (N/A))), (1: (C*T))], 2, sum)
			temp.mat <- fn.covr.block.mats(N/A, C*T, NN, Ni, Rmat[(((i-1)*(N/A) + 1) : 
			((i-1)*(N/A) + (N/A))), (1: (C*T))],  DatRMeans[(((i-1)*(C*T) + 1) : ((i-1)*
			(C*T) + C*T))], Lamdamat[(((i-1)*(N/A) + 1) : ((i-1)*(N/A) + (N/A))), (1: (C*T))])

			V[(((i-1)*(C*T) + 1) : ((i-1)*(C*T) + C*T)), (((i-1)*(C*T) + 1) : ((i-1)*
			(C*T) + C*T))]  <-  A*temp.mat
		}

		return(V);

	}


	V <- fn.covr(N, A*C*T, NN, Ni, Rmat, RMeans[(A + C + T + C*A + C*T + T*A + 1) : 
	(A + C + T + C*A + C*T + T*A + A*C*T)],  Lamdamat, A, C, T)

	SING.COV <- FALSE
	if(qr(V)$rank < (A*C*T)) SING.COV <- TRUE

	pvec <- RTE[(A + C + T + C*A + C*T + T*A + 1) : (A + C + T + C*A + C*T + T*A + A*C*T)]

	if(((C > 1) && (T > 1))) 
	{

		### Wald type statistics computed here

		WA <- N*t(CA%*%pvec)%*%ginv(CA%*%V%*%t(CA))%*%(CA%*%pvec)
		WC <- N*t(CC%*%pvec)%*%ginv(CC%*%V%*%t(CC))%*%(CC%*%pvec)
		WT <- N*t(CT%*%pvec)%*%ginv(CT%*%V%*%t(CT))%*%(CT%*%pvec)
		WAC <- N*t(CAC%*%pvec)%*%ginv(CAC%*%V%*%t(CAC))%*%(CAC%*%pvec)
		WCT <- N*t(CCT%*%pvec)%*%ginv(CCT%*%V%*%t(CCT))%*%(CCT%*%pvec)
		WAT <- N*t(CAT%*%pvec)%*%ginv(CAT%*%V%*%t(CAT))%*%(CAT%*%pvec)
		WACT <- N*t(CACT%*%pvec)%*%ginv(CACT%*%V%*%t(CACT))%*%(CACT%*%pvec)

		dfWA <- qr(CA%*%V%*%t(CA))$rank
		dfWC <- qr(CC%*%V%*%t(CC))$rank
		dfWT <- qr(CT%*%V%*%t(CT))$rank
		dfWAC <- qr(CAC%*%V%*%t(CAC))$rank
		dfWCT <- qr(CCT%*%V%*%t(CCT))$rank
		dfWAT <- qr(CAT%*%V%*%t(CAT))$rank	
		dfWACT <- qr(CACT%*%V%*%t(CACT))$rank

		if(!is.na(WA) && WA > 0) pWA <- 1 - pchisq(WA, dfWA)
		else pWA <- NA
		if(!is.na(WC) && WC > 0) pWC <- 1 - pchisq(WC, dfWC)
		else pWC <- NA
		if(!is.na(WT) && WT > 0) pWT <- 1 - pchisq(WT, dfWT)
		else pWT <- NA
		if(!is.na(WAC) && WAC > 0) pWAC <- 1 - pchisq(WAC, dfWAC)
		else pWAC <- NA
		if(!is.na(WCT) && WCT > 0) pWCT <- 1 - pchisq(WCT, dfWCT)
		else pWCT <- NA
		if(!is.na(WAT) && WAT > 0) pWAT <- 1 - pchisq(WAT, dfWAT)
		else pWAT <- NA
		if(!is.na(WACT) && WACT > 0) pWACT <- 1 - pchisq(WACT, dfWACT)
		else pWACT <- NA

		W <- rbind(WA, WC, WT, WAC, WCT, WAT, WACT)
		pW <- rbind(pWA, pWC, pWT, pWAC, pWCT, pWAT, pWACT)
		dfW <- rbind(dfWA, dfWC, dfWT, dfWAC, dfWCT, dfWAT, dfWACT)

		WaldType <- data.frame(W, dfW, pW)
		rd.WaldType <- round(WaldType, Inf)
		Wdesc <- rbind(factor.name, time1.name, time2.name, paste(factor.name,":", time1.name, sep="") , 
		paste(time2.name, ":", time1.name, sep=""), paste(factor.name, ":", time2.name, sep=""), paste(factor.name, 
		":", time1.name, ":", time2.name, sep=""))
		colnames(rd.WaldType) <- c("Statistic", "df","p-value")
		rownames(rd.WaldType) <- Wdesc

		fn.tr <- function(mat) 
		{
			return(sum(diag(mat)))
		}

		RTE.B <- RTE[(A + C + T + C*A + C*T + T*A + 1) : (A + C + T + C*A + C*T + T*A + A*C*T)]

		### Box type statistics computed here

		BtA <- t(CA)%*%(ginv(CA%*%t(CA)))%*%CA
		BtC <- t(CC)%*%(ginv(CC%*%t(CC)))%*%CC
		BtT <- t(CT)%*%(ginv(CT%*%t(CT)))%*%CT
		BtAC <- t(CAC)%*%(ginv(CAC%*%t(CAC)))%*%CAC
		BtCT <- t(CCT)%*%(ginv(CCT%*%t(CCT)))%*%CCT
		BtAT <- t(CAT)%*%(ginv(CAT%*%t(CAT)))%*%CAT
		BtACT <- t(CACT)%*%(ginv(CACT%*%t(CACT)))%*%CACT

		TVA <- BtA%*%V
		BA <- (N/fn.tr(TVA)) * ((t(RTE.B)) %*% BtA %*% (RTE.B))
		BAf <- ((fn.tr(BtA%*%V))^2)/(fn.tr(BtA%*%V%*%BtA%*%V))
		if((!is.na(BA))&&(!is.na(BAf))&&(BA > 0)&&(BAf > 0)) BAp <- 1 - pf(BA, BAf, 100000)
		else BAp <- NA

		TVC <- BtC%*%V
		BC <- (N/fn.tr(TVC)) * ((t(RTE.B)) %*% BtC %*% (RTE.B))
		BCf <- ((fn.tr(BtC%*%V))^2)/(fn.tr(BtC%*%V%*%BtC%*%V))
		if((!is.na(BC))&&(!is.na(BCf))&&(BC > 0)&&(BCf > 0)) BCp <- 1 - pf(BC, BCf, 100000)
		else BCp <- NA

		TVT <- BtT%*%V
		BT <- (N/fn.tr(TVT)) * ((t(RTE.B)) %*% BtT %*% (RTE.B))
		BTf <- ((fn.tr(BtT%*%V))^2)/(fn.tr(BtT%*%V%*%BtT%*%V))
		if((!is.na(BT))&&(!is.na(BTf))&&(BT > 0)&&(BTf > 0)) BTp <- 1 - pf(BT, BTf, 100000)
		else BTp <- NA

		TVAC <- BtAC%*%V
		BAC <- (N/fn.tr(TVAC)) * ((t(RTE.B)) %*% BtAC %*% (RTE.B))
		BACf <- ((fn.tr(BtAC%*%V))^2)/(fn.tr(BtAC%*%V%*%BtAC%*%V))
		if((!is.na(BAC))&&(!is.na(BACf))&&(BAC > 0)&&(BACf > 0)) BACp <- 1 - pf(BAC, BACf, 100000)
		else BACp <- NA

		TVCT <- BtCT%*%V
		BCT <- (N/fn.tr(TVCT)) * ((t(RTE.B)) %*% BtCT %*% (RTE.B))
		BCTf <- ((fn.tr(BtCT%*%V))^2)/(fn.tr(BtCT%*%V%*%BtCT%*%V))
		if((!is.na(BCT))&&(!is.na(BCTf))&&(BCT > 0)&&(BCTf > 0)) BCTp <- 1 - pf(BCT, BCTf, 100000)
		else BCTp <- NA

		TVAT <- BtAT%*%V
		BAT <- (N/fn.tr(TVAT)) * ((t(RTE.B)) %*% BtAT %*% (RTE.B))
		BATf <- ((fn.tr(BtAT%*%V))^2)/(fn.tr(BtAT%*%V%*%BtAT%*%V))
		if((!is.na(BAT))&&(!is.na(BATf))&&(BAT > 0)&&(BATf > 0)) BATp <- 1 - pf(BAT, BATf, 100000)
		else BATp <- NA

		TVACT <- BtACT%*%V
		BACT <- (N/fn.tr(TVACT)) * ((t(RTE.B)) %*% BtACT %*% (RTE.B))
		BACTf <- ((fn.tr(BtACT%*%V))^2)/(fn.tr(BtACT%*%V%*%BtACT%*%V))
		if((!is.na(BACT))&&(!is.na(BACTf))&&(BACT > 0)&&(BACTf > 0)) BACTp <- 1 - pf(BACT, BACTf, 100000)
		else BACTp <- NA


		B <- rbind(BA, BC, BT, BAC, BCT, BAT, BACT)
		pB <- rbind(BAp, BCp, BTp, BACp, BCTp, BATp, BACTp)
		dfB <- rbind(BAf, BCf, BTf, BACf, BCTf, BATf, BACTf)

		BoxType <- cbind(B, dfB, pB)
		rd.BoxType <- round(BoxType, Inf)
		Bdesc <- rbind(factor.name, time1.name, time2.name, paste(factor.name,":", time1.name, sep=""), 
		paste(time2.name, ":", time1.name, sep=""), paste(factor.name, ":", time2.name, sep=""), 
		paste(factor.name, ":", time1.name, ":", time2.name, sep=""))
		colnames(rd.BoxType) <- c("Statistic", "df", "p-value")
		rownames(rd.BoxType) <- Bdesc
	}

	if(SING.COV) 
	{
		cat("\n Warning(s):\n")
		cat(" The covariance matrix is singular. \n")
	}

	if(!((C > 1) && (T > 1))) cat("Wald-type and Anova-type statistics cannot be computed, since either C or T is 1")

	out.f1.ld.f2 <- list(RTE=rd.PRes1,Wald.test=rd.WaldType,ANOVA.test=rd.BoxType, covariance=V) 
	return(out.f1.ld.f2)
}