# R program for F2_LD_F1 macro
#
#   Input:   
#               var: a vector of variable of interest
#               group1: a vector of factor1 variable
#               group2: a vector of factor2 variable
#               time: a vector of the time variable
#               subject: a vector of independent subjects
#               time.name: time factor name. Default is set to Time
#               group1.name: group1 factor names. Default is set to GroupA
#               group2.name: group2 factor names. Default is set to GroupB
#               description: description of the output. Default is set to TRUE (show description)
#   Output:
#             list of relative treatment effects, test results, covariance matrix
#  
f2.ld.f1 <- function(var, time, group1, group2, subject, time.name = "Time", 
group1.name = "GroupA", group2.name = "GroupB", description=TRUE) 
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
#         Date: August 21, 2009
#
#    Key Variables:
#                time: time factor
#                FAC.1: factor 1 factor
#                FAC.2: factor 2 factor
#                facs.1: sorted factor 1 factor levels
#                facs.2: sorted factor 2 factor levels
#                tlevel: sorted time factor levels
#                varL: indicator of whether the observations are made (0=missing, 1=observed)
#                T: number of levels of time
#                A: number of levels of factor1
#                B: number of levels of factor2
#                vmat(D): Matrix of the observations by different times
#                Lamdamat: Matrix of the Lamda indicator by different times
#                RD: ranks of the observations
#                N: total number of subject
#                NN: total number of observations
#                Rmat: Matrix of the observations by different factors, where missing observations=0
#                RMeans: rank means of each unique factor combinations and each factor

#    check whether the input variables are entered correctly

	   if(is.null(var)||is.null(time)||is.null(group1)||is.null(group2)||is.null(subject)) 
		stop("At least one of the input parameters (var, time, group1, group2, or subject) is not found.")
	   
           sublen<-length(subject)
	   varlen<-length(var)
	   timlen<-length(time)
	   gro1len<-length(group1)
	   gro2len<-length(group2)
	   
	   if((sublen!=varlen)||(sublen!=timlen)||(sublen!=gro1len)||(sublen!=gro2len))
		stop("At least one of the input parameters (var, time, group1, group2, or subject) has a different length.")

	library(MASS)
	factor1<-group1
	factor2<-group2
	factor1.name<-group1.name
	factor2.name<-group2.name
	time<-factor(time)
	FAC.1<-factor(factor1)
	FAC.2<-factor(factor2)
	facs.1 <- sort(levels(FAC.1))
	facs.2 <- sort(levels(FAC.2))
	tlevel <- sort(levels(time))
	varL <- 1-is.na(var)

	T<-nlevels(time)
	A<-nlevels(factor1)
	B<-nlevels(factor2)

	vmat<-matrix(ncol=T, nrow=length(var)/T)
	Lamdamat<-matrix(ncol=T, nrow=length(var)/T)

	for(i in 1:T)
	{

		tempV<-var[which(time==tlevel[i])]
		tempL<-varL[which(time==tlevel[i])]
		subj<-subject[which(time==tlevel[i])]
		ordering<-order(subj)

		if(i==1)
		{
			fact1<-factor1[which(time==tlevel[i])]
			fact2<-factor2[which(time==tlevel[i])]
			FAC.1<-fact1[ordering]
			FAC.2<-fact2[ordering]
		}
 		vmat[,i]<-tempV[ordering]
 		Lamdamat[,i]<-tempL[ordering]
	}

	D <- vmat
	colnames(D) <- NULL
	rownames(D) <- NULL

	N <- length(D[,1])
	RD <- rank(c(D))

	Rmat <- matrix(RD, nrow=N, ncol=T) 
	NN <- sum(varL)
	Rmat <- Rmat * Lamdamat
	RMeans <- rep(0, (A + B + T + (A*B) + (A*T) + (B*T) + (A*B*T)))

	### This order is important ie, A + B + T + (A*B) + (A*T) + (B*T) + (A*B*T) 

	Ni <- apply(Lamdamat, 2, sum) 
	Rmat.fac <- cbind(FAC.1, FAC.2, Rmat)
	colnames(Rmat.fac) <- NULL
	Lamdamat.fac <- cbind(FAC.1, FAC.2, Lamdamat) 
	colnames(Lamdamat.fac) <- NULL


	### fn.fact.manip transforms the Rmat matrix to different dimensions according to factors and time.

	fn.fact.manip <- function(fullRmat, n, n.a, n.b, n.t, A.ni, B.ni) 
	{
		res.list <- list(0) 
		res.list.A <- list(0)
		res.A <- list(0)
		res.AB <- list(0)
		res.AT <- list(0)

	### this part divides the matrix into groups that beling to the same factor A
		for(i in 1:n.a) 
		{
			temp.Rmat <- matrix(0, nrow=A.ni[i], ncol=(n.t+1))
			temp.Rmat <- fullRmat[(fullRmat[,1]==i),-1]
			res.A[[i]] <- c(temp.Rmat[,-1])
			res.AB[[i]] <- list(0)	
			for(j in 1:n.b)	res.AB[[i]][[j]] <- temp.Rmat[(temp.Rmat[,1]==j),-1]
			res.AT[[i]] <- temp.Rmat[,-1]
		}


		res.list.A[[1]] <- res.A
		res.list.A[[2]] <- res.AB
		res.list.A[[3]] <- res.AT

		res.list.B <- list(0)
		res.B <- list(0)
		res.BT <- list(0)

		for(i in 1:n.b) 
		{
			temp.Rmat <- matrix(0, nrow=B.ni[i], ncol=(n.t+1))
			temp.Rmat <- fullRmat[(fullRmat[,2]==i),-2]
			res.B[[i]] <- c(temp.Rmat[,-1])
			res.BT[[i]] <- temp.Rmat[,-1]
		}

		res.list.B[[1]] <- res.B
		res.list.B[[2]] <- res.BT
		res.list[[1]] <- res.list.A
		res.list[[2]] <- res.list.B

		return(res.list)
	}


	### Ra.list and R1a.list are the list of transformed matrices of Rmat and Lamdamat

	Ra.list <- fn.fact.manip(Rmat.fac, N, A, B, T, as.vector(summary(FAC.1)), as.vector(summary(FAC.2)))
	R1a.list <- fn.fact.manip(Lamdamat.fac, N, A, B, T, as.vector(summary(FAC.1)), as.vector(summary(FAC.2)))

	### RMeans calculations

	for(i in 1:A) RMeans[i] <- (sum(Ra.list[[1]][[1]][[i]]) / sum(R1a.list[[1]][[1]][[i]]))

	ric <- A

	for(i in 1:B) RMeans[(ric + i)] <- (sum(Ra.list[[2]][[1]][[i]]) / sum(R1a.list[[2]][[1]][[i]]))

	ric <- ric + B
	RMeans[(ric + 1) : (ric + T)] <- (apply(Rmat, 2, sum) / apply(Lamdamat, 2, sum))
	ric <- ric + T 
	ric.l <- ric + (A*B) + (A*T) + (B*T)

	for(i in 1:A) 
	{
		for(j in 1:B) 
		{
			RMeans[(ric + (i-1)*B + j)] <- (sum(Ra.list[[1]][[2]][[i]][[j]]) / sum(R1a.list[[1]][[2]][[i]][[j]]))
			RMeans[(ric.l + ((i-1)*B + (j-1))*T + 1) : (ric.l + ((i-1)*B + (j-1))*T + T)] <- apply(
			Ra.list[[1]][[2]][[i]][[j]], 2, sum) / apply(R1a.list[[1]][[2]][[i]][[j]], 2, sum) 
		}
	}

	rm(ric.l)
	ric <- ric + A*B

	for(i in 1:A) RMeans[(ric + (i-1)*T + 1): (ric + (i-1)*T + T)] <- apply(Ra.list[[1]][[3]][[i]],2, sum) / apply(
	R1a.list[[1]][[3]][[i]], 2, sum) 

	ric <- ric + A*T

	for(i in 1:B) RMeans[(ric + (i-1)*T + 1): (ric + (i-1)*T + T)] <- apply(Ra.list[[2]][[2]][[i]], 
	2, sum) / apply(R1a.list[[2]][[2]][[i]], 2, sum) 

	### Calculation of RTE

	RTE <- (RMeans - 0.5) / NN 

	time.vec <- tlevel

	### fn.nice.out creates the list of sources for RTE output

	fn.nice.out <- function(A, B, T) 
	{
		SOURCE <- rep(0,0)
		for(i in 1:A) SOURCE <- c(SOURCE, paste(factor1.name, facs.1[i],sep=""))
		for(i in 1:B) SOURCE <- c(SOURCE, paste(factor2.name, facs.2[i],sep="")) 
		for(i in 1:T) SOURCE <- c(SOURCE, paste(time.name, time.vec[i],sep=""))
		for(i in 1:A) 
			for(j in 1:B) 
				SOURCE <- c(SOURCE, paste(factor1.name,facs.1[i],":",factor2.name,facs.2[j],sep=""))
		for(i in 1:A)
			for(j in 1:T)
				SOURCE <- c(SOURCE, paste(factor1.name,facs.1[i],":",time.name,time.vec[j],sep=""))
		for(i in 1:B)
			for(j in 1:T)
				SOURCE <- c(SOURCE, paste(factor2.name,facs.2[i],":",time.name,time.vec[j],sep=""))
		for(i in 1:A)
			for(j in 1:B)
				for(k in 1:T)
					SOURCE <- c(SOURCE, paste(factor1.name,facs.1[i],":",factor2.name,facs.2[j],":",time.name,time.vec[k],sep=""))

		return(SOURCE) 
	}

	SOURCE <- fn.nice.out(A, B, T)
	Nobs <- rep(0, (A + B + T + (A*B) + (A*T) + (B*T) + (A*B*T)))
	for(i in 1:A) Nobs[i] <- sum(R1a.list[[1]][[1]][[i]])

	ric <- A

	for(i in 1:B) Nobs[(ric + i)] <- sum(R1a.list[[2]][[1]][[i]])

	ric <- ric + B
	Nobs[(ric + 1) : (ric + T)] <- apply(Lamdamat, 2, sum)
	ric <- ric + T 
	ric.l <- ric + (A*B) + (A*T) + (B*T)

	for(i in 1:A) 
	{
		for(j in 1:B) 
		{
			Nobs[(ric + (i-1)*B + j)] <- sum(R1a.list[[1]][[2]][[i]][[j]])
			Nobs[(ric.l + ((i-1)*B + (j-1))*T + 1) : (ric.l + ((i-1)*B + (j-1))*T + T)] <- 
			apply(R1a.list[[1]][[2]][[i]][[j]], 2, sum) 
		}
	}

	rm(ric.l)
	ric <- ric + A*B
	for(i in 1:A) Nobs[(ric + (i-1)*T + 1): (ric + (i-1)*T + T)] <- apply(R1a.list[[1]][[3]][[i]], 2, sum) 
	ric <- ric + A*T
	for(i in 1:B) Nobs[(ric + (i-1)*T + 1): (ric + (i-1)*T + T)] <- apply(R1a.list[[2]][[2]][[i]], 2, sum) 

	### Elaboration of the RTE output

	PRes1 <- data.frame(RankMeans=RMeans, Nobs, RTE) 
	rd.PRes1 <- round(PRes1, Inf)
	rownames(rd.PRes1)<-SOURCE

	### Description output

	if(description==TRUE)
	{
		cat(" F2 LD F1 Model ")
           	cat("\n ----------------------- \n")
           	cat(" Total number of observations: ",NN,"\n") 
           	cat(" Total number of subjects:  " , N,"\n")
           	cat(" Total number of missing observations: ",(N*T - NN),"\n") 
           	cat("\n Class level information ")
           	cat("\n ----------------------- \n")
		cat(" Levels of", time.name, "(sub-plot factor time):", T, "\n")
		cat(" Levels of", factor1.name, "(whole-plot factor group1):", A,"\n")
		cat(" Levels of", factor2.name, "(whole-plot factor group2):", B,"\n")
           	cat("\n Abbreviations ")
           	cat("\n ----------------------- \n")
           	cat(" RankMeans = Rank means\n")
           	cat(" Nobs = Number of observations\n")
           	cat(" RTE = Relative treatment effect\n")
           	cat(" Wald.test = Wald-type test statistic\n")
           	cat(" ANOVA.test = ANOVA-type test statistic with Box approximation\n")
           	cat(" ANOVA.test.mod.Box = modified ANOVA-type test statistic with Box approximation\n")
           	cat(" covariance = Covariance matrix","\n")
           	cat(" Note: The description output above will disappear by setting description=FALSE in the input. See the help file for details.","\n\n")
	}

	### Statistics calculation

	fn.P.mat <- function(arg1) 
	{
		I <- diag(1, arg1, arg1)
		J <- matrix((1/arg1), arg1, arg1)
		return(I - J)
	}

	PA <- fn.P.mat(A)
	PB <- fn.P.mat(B)
	PT <- fn.P.mat(T)

	A1 <- matrix((1/A), 1, A)
	B1 <- matrix((1/B), 1, B)
	T1 <- matrix((1/T), 1, T)

	CA <- kronecker(PA, kronecker(B1, T1))
	CB <- kronecker(A1, kronecker(PB, T1))
	CT <- kronecker(A1, kronecker(B1, PT))
	CAB <- kronecker(PA, kronecker(PB, T1))
	CBT <- kronecker(A1, kronecker(PB, PT))
	CAT <- kronecker(PA, kronecker(B1, PT))
	CABT <- kronecker(PA, kronecker(PB, PT))

	fn.covr<-function(N, d, NN, Rmat.list, DatRMeans, Lamdamat.list, A, B, T)
	{
		V<-matrix(0,d,d);
		temp.mat <- matrix(0, T, T);
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
			for(j in 1:B) 
			{

				temp.Rmat <- Rmat.list[[i]][[j]]
				temp.Lamdamat <- Lamdamat.list[[i]][[j]]
				Ni <- apply(temp.Lamdamat, 2, sum)
				temp.mat <- fn.covr.block.mats(nrow(temp.Rmat), T, NN, Ni, temp.Rmat, DatRMeans[(((i-1)*
				B + (j-1))*T + 1) : (((i-1)*B + (j-1))*T + T)], temp.Lamdamat)

				V[((((i-1)*B + (j-1))*T + 1) : (((i-1)*B + (j-1))*T + T)), ((((i-1)*B + (j-1))*T + 1) : 
				(((i-1)*B + (j-1))*T + T))]  <-  (N/nrow(temp.Rmat))*temp.mat
			}
		}

		return(V);
	}


	ric <- (A + B + T + B*A + T*A + B*T)
	V <- fn.covr(N, A*B*T, NN, Ra.list[[1]][[2]], RMeans[(ric + 1) : (ric + A*B*T)], 
	R1a.list[[1]][[2]], A, B, T)

	SING.COV <- FALSE
	if(qr(V)$rank < (A*B*T)) SING.COV <- TRUE

	WARN.1 <- FALSE
	if(T > N) WARN.1 <- TRUE

	pvec <- RTE[(ric + 1) : (ric + A*B*T)]
	if((T > 1) && (A > 1) && (B > 1)) 
	{
		WA <- N*t(CA%*%pvec)%*%ginv(CA%*%V%*%t(CA))%*%(CA%*%pvec)
		WB <- N*t(CB%*%pvec)%*%ginv(CB%*%V%*%t(CB))%*%(CB%*%pvec)
		WT <- N*t(CT%*%pvec)%*%ginv(CT%*%V%*%t(CT))%*%(CT%*%pvec)

		WAB <- N*t(CAB%*%pvec)%*%ginv(CAB%*%V%*%t(CAB))%*%(CAB%*%pvec)
		WAT <- N*t(CAT%*%pvec)%*%ginv(CAT%*%V%*%t(CAT))%*%(CAT%*%pvec)
		WBT <- N*t(CBT%*%pvec)%*%ginv(CBT%*%V%*%t(CBT))%*%(CBT%*%pvec)

		WABT <- N*t(CABT%*%pvec)%*%ginv(CABT%*%V%*%t(CABT))%*%(CABT%*%pvec)

		dfWA <- qr(CA)$rank
		dfWB <- qr(CB)$rank
		dfWT <- qr(CT)$rank
		dfWAB <- qr(CAB)$rank
		dfWAT <- qr(CAT)$rank
		dfWBT <- qr(CBT)$rank
		dfWABT <- qr(CABT)$rank

		if(!is.na(WA) && WA > 0) pWA <- 1 - pchisq(WA, dfWA)
		else pWA <- NA

		if(!is.na(WB) && WB > 0) pWB <- 1 - pchisq(WB, dfWB)
		else pWB <- NA

		if(!is.na(WT) && WT > 0) pWT <- 1 - pchisq(WT, dfWT)
		else pWT <- NA

		if(!is.na(WAB) && WAB > 0) pWAB <- 1 - pchisq(WAB, dfWAB)
		else pWAB <- NA

		if(!is.na(WBT) && WBT > 0) pWBT <- 1 - pchisq(WBT, dfWBT)
		else pWBT <- NA

		if(!is.na(WAT) && WAT > 0) pWAT <- 1 - pchisq(WAT, dfWAT)
		else pWAT <- NA

		if(!is.na(WABT) && WABT > 0) pWABT <- 1 - pchisq(WABT, dfWABT)
		else pWABT <- NA

		### Wald type Statistics calculation

		W <- rbind(WA, WB, WT, WAB, WAT, WBT, WABT)
		pW <- rbind(pWA, pWB, pWT, pWAB, pWAT, pWBT, pWABT)
		dfW <- rbind(dfWA, dfWB, dfWT, dfWAB, dfWAT, dfWBT, dfWABT)

		WaldType <- data.frame(W, dfW, pW)
		rd.WaldType <- round(WaldType, Inf)

		Wdesc <- rbind(factor1.name, factor2.name, time.name, paste(factor1.name, ":", factor2.name, sep=""), 
		paste(factor1.name, ":", time.name, sep=""), paste(factor2.name, ":", time.name, sep=""), 
		paste(factor1.name, ":", factor2.name, ":", time.name, sep=""))

		colnames(rd.WaldType) <- c("Statistic", "df", "p-value")
		rownames(rd.WaldType) <- Wdesc

		fn.tr <- function(mat) 
		{
			return(sum(diag(mat)))
		}

		RTE.B <- RTE[(A + B + T + B*A + T*A + B*T + 1) : (A + B + T + B*A + T*A + B*T + A*B*T)]
		BtA <- t(CA)%*%(ginv(CA%*%t(CA)))%*%CA
		BtB <- t(CB)%*%(ginv(CB%*%t(CB)))%*%CB
		BtT <- t(CT)%*%(ginv(CT%*%t(CT)))%*%CT
		BtAB <- t(CAB)%*%(ginv(CAB%*%t(CAB)))%*%CAB
		BtAT <- t(CAT)%*%(ginv(CAT%*%t(CAT)))%*%CAT
		BtBT <- t(CBT)%*%(ginv(CBT%*%t(CBT)))%*%CBT
		BtABT <- t(CABT)%*%(ginv(CABT%*%t(CABT)))%*%CABT

		TVA <- BtA%*%V

		BA <- (N/fn.tr(TVA)) * ((t(RTE.B)) %*% BtA %*% (RTE.B))
		BAf <- ((fn.tr(BtA%*%V))^2)/(fn.tr(BtA%*%V%*%BtA%*%V))

		if((!is.na(BA))&&(!is.na(BAf))&&(BA > 0)&&(BAf > 0)) BAp <- 1 - pf(BA, BAf, 100000)
		else BAp <- NA

		TVB <- BtB%*%V

		BB <- (N/fn.tr(TVB)) * ((t(RTE.B)) %*% BtB %*% (RTE.B))
		BBf <- ((fn.tr(BtB%*%V))^2)/(fn.tr(BtB%*%V%*%BtB%*%V))

		if((!is.na(BB))&&(!is.na(BBf))&&(BB > 0)&&(BBf > 0)) BBp <- 1 - pf(BB, BBf, 100000)
		else BBp <- NA

		TVT <- BtT%*%V

		BT <- (N/fn.tr(TVT)) * ((t(RTE.B)) %*% BtT %*% (RTE.B))
		BTf <- ((fn.tr(BtT%*%V))^2)/(fn.tr(BtT%*%V%*%BtT%*%V))

		if((!is.na(BT))&&(!is.na(BTf))&&(BT > 0)&&(BTf > 0)) BTp <- 1 - pf(BT, BTf, 100000)
		else BTp <- NA

		TVAB <- BtAB%*%V

		BAB <- (N/fn.tr(TVAB)) * ((t(RTE.B)) %*% BtAB %*% (RTE.B))
		BABf <- ((fn.tr(BtAB%*%V))^2)/(fn.tr(BtAB%*%V%*%BtAB%*%V))

		if((!is.na(BAB))&&(!is.na(BABf))&&(BAB > 0)&&(BABf > 0)) BABp <- 1 - pf(BAB, BABf, 100000)
		else BABp <- NA

		TVAT <- BtAT%*%V

		BAT <- (N/fn.tr(TVAT)) * ((t(RTE.B)) %*% BtAT %*% (RTE.B))
		BATf <- ((fn.tr(BtAT%*%V))^2)/(fn.tr(BtAT%*%V%*%BtAT%*%V))

		if((!is.na(BAT))&&(!is.na(BATf))&&(BAT > 0)&&(BATf > 0)) BATp <- 1 - pf(BAT, BATf, 100000)
		else BATp <- NA

		TVBT <- BtBT%*%V

		BBT <- (N/fn.tr(TVBT)) * ((t(RTE.B)) %*% BtBT %*% (RTE.B))
		BBTf <- ((fn.tr(BtBT%*%V))^2)/(fn.tr(BtBT%*%V%*%BtBT%*%V))

		if((!is.na(BBT))&&(!is.na(BBTf))&&(BBT > 0)&&(BBTf > 0)) BBTp <- 1 - pf(BBT, BBTf, 100000)
		else BBTp <- NA

		TVABT <- BtABT%*%V

		BABT <- (N/fn.tr(TVABT)) * ((t(RTE.B)) %*% BtABT %*% (RTE.B))
		BABTf <- ((fn.tr(BtABT%*%V))^2)/(fn.tr(BtABT%*%V%*%BtABT%*%V))

		if((!is.na(BABT))&&(!is.na(BABTf))&&(BABT > 0)&&(BABTf > 0)) BABTp <- 1 - pf(BABT, BABTf, 100000)
		else BABTp <- NA

		QB <- rbind(BA, BB, BT, BAB, BAT, BBT, BABT)
		pB <- rbind(BAp, BBp, BTp, BABp, BATp, BBTp, BABTp)
		dfB <- rbind(BAf, BBf, BTf, BABf, BATf, BBTf, BABTf)

		### Box type Statistics calculation

		BoxType <- data.frame(QB, dfB, pB)
		rd.BoxType <- round(BoxType, Inf)

		Bdesc <- rbind(factor1.name, factor2.name, time.name, paste(factor1.name, ":", factor2.name, sep=""), 
		paste(factor1.name,":", time.name, sep=""), paste(factor2.name, ":", time.name, sep=""), 
		paste(factor1.name, ":", factor2.name, ":", time.name, sep=""))

		colnames(rd.BoxType) <- c("Statistic", "df", "p-value")
		rownames(rd.BoxType) <- Bdesc

		b2.ni <- as.vector(summary(FAC.1 : FAC.2))
		b2.lamda <- solve((diag(b2.ni) - diag(1, length(b2.ni), length(b2.ni))))
		b2.mat <- kronecker(diag(1, A, A), kronecker(diag(1, B, B), matrix((1/T), 1, T)))
		b2.sd <- b2.mat %*% V %*% t(b2.mat)
		b2.dA <- diag(kronecker(PA, matrix((1/B), B, B)))
		b2.dA <- diag(b2.dA, length(b2.dA), length(b2.dA))
		b2.dB <- diag(kronecker(matrix((1/A), A, A), PB))
		b2.dB <- diag(b2.dB, length(b2.dB), length(b2.dB))
		b2.dAB <- diag(kronecker(PA, PB))
		b2.dAB <- diag(b2.dAB, length(b2.dAB), length(b2.dAB))

		b2.df1 <- (fn.tr(b2.dA %*% b2.sd) %*% fn.tr(b2.dA %*% b2.sd)) / fn.tr(b2.dA %*%
 		b2.dA %*% b2.sd %*% b2.sd %*% b2.lamda)

		b2.df2 <- (fn.tr(b2.dB %*% b2.sd) %*% fn.tr(b2.dB %*% b2.sd)) / fn.tr(b2.dB %*% 
		b2.dB %*% b2.sd %*% b2.sd %*% b2.lamda)

		b2.df3 <- (fn.tr(b2.dAB %*% b2.sd) %*% fn.tr(b2.dAB %*% b2.sd)) / fn.tr(b2.dAB %*% 
		b2.dAB %*% b2.sd %*% b2.sd %*% b2.lamda)


		if((!is.na(BA))&&(!is.na(BAf))&&(BA > 0)&&(BAf > 0)&&(b2.df1 > 0)) B2.Ap <- 1 - pf(BA, BAf, b2.df1)
		else BAp <- NA

		if((!is.na(BB))&&(!is.na(BBf))&&(BB > 0)&&(BBf > 0)&&(b2.df2 > 0)) B2.Bp <- 1 - pf(BB, BBf, b2.df2)
		else BBp <- NA

		if((!is.na(BAB))&&(!is.na(BABf))&&(BAB > 0)&&(BABf > 0)&&(b2.df3 > 0)) B2.ABp <- 1 - pf(BAB, BABf, b2.df3)
		else BABp <- NA

		### Box type modified Statistics calculation

		B2 <- rbind(BA, BB, BAB)
		pB <- rbind(B2.Ap, B2.Bp, B2.ABp)
		df1.B2 <- rbind(BAf, BBf, BABf)
		df2.B2 <- rbind(b2.df1, b2.df2, b2.df3)

		BoxType2 <- data.frame(B2, df1.B2, df2.B2, pB)
		rd.BoxType2 <- round(BoxType2, Inf)
		B2.desc <- rbind(factor1.name, factor2.name, paste(factor1.name, ":", factor2.name, sep=""))
		colnames(rd.BoxType2) <- c("Statistic", "df1", "df2", "p-value")
		rownames(rd.BoxType2) <- B2.desc
	}


	### singular covariance matrix warning

	if(WARN.1 || SING.COV) 
	{
		cat("\n Warning(s):\n")
		if(WARN.1) cat(" There are less subjects than sub-plot factor levels.\n")
		if(SING.COV) cat(" The covariance matrix is singular. \n\n")
	}

        out.f2.ld.f1 <- list(RTE=rd.PRes1,Wald.test=rd.WaldType, ANOVA.test=rd.BoxType, ANOVA.test.mod.Box=rd.BoxType2, covariance=V) 
        return(out.f2.ld.f1)

}