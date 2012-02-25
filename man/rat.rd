\name{rat}
\alias{rat}
\docType{data}
\title{Rat growth study}
\description{
Measurements of body weights (in grams) of rats.
}
\usage{data(rat)}
\format{
Longitudinal data of 27 rats with body weight measurements from both control and treatment groups taken over a 5-week period.
}
\details{
In clinical chemistry, it is important for the determination of reference intervals to investigate whether a variable of interest has a circadian rhythm. If so, the reference intervals cannot be determined independently of time. This question is to be analyzed in the case of alpha-amylase in saliva. Measurements of alpha-amylase levels were taken from the saliva of 14 volunteers, four times per day (8 a.m., 12 p.m., 5 p.m., 9 p.m.) on two days (Monday (m), Thursday (t)), since differences in the alpha-amylase profiles immediately after a weekend as opposed to the middle of the week are suspected. Thus, each subject was examined on Monday and Thursday.

Box (1950) and Wolfinger (1996) consider the growth curve problem using the body weight measurements of 27 rats. In the data, 10 rats are in the control group while the remaining 17 rats are in two treatment groups. The treatment groups with 7 and 10 rats had thyroxin and thiouracil in their drinking water, respectively. The main difficulty in modeling their growth curves is the fanning effect, which indicates an increase in variances over time. To stabilize the variances, Box (1950) considers differencing based on the data at the initial week and Wolfinger (1996) illustrates the logarithmic transformation and discusses ways to model the growth curve without relying on the data transformation.

}
\references{

Box, G.E.P. (1950). Problems in the analysis of growth and wear curves. 
\emph{Biometrics}, 6, 362-389.\cr

Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.\cr

Wolfinger, R.D. (1996). Heterogeneous variance: covariance structures for repeated measures.
\emph{Journal of Agricultural, Biological, and Environmental Statistics}, 1, 205-230.
}

\examples{
## Analysis using F1-LD-F1 design ##
data(rat)
attach(rat)
w.pat<-matrix(rep(c(1:5),each=5),ncol=5,nrow=5)
ex.f1f1<-f1.ld.f1(y=resp, time=time, group=group, subject=subject, 
time.name="Week", group.name="Treatment", description="FALSE", w.pat=w.pat)
# F1 LD F1 Model 
# ----------------------- 
# Check that the order of the time and group levels are correct.
# Time level:   0 1 2 3 4 
# Group level:   control thyrox thiour 
# If the order is not correct, specify the correct order in time.order or 
# group.order.

## Wald-type statistic 
ex.f1f1$Wald.test

#                Statistic df      p-value
#Treatment        12.52657  2 1.904977e-03
#Week           3619.03739  4 0.000000e+00
#Treatment:Week   70.34311  8 4.199050e-12

## ANOVA-type statistic
ex.f1f1$ANOVA.test

#                 Statistic       df      p-value
#Treatment         5.286582 1.922792 5.654723e-03
#Week           1008.512138 1.990411 0.000000e+00
#Treatment:Week   11.093940 3.516933 3.616929e-08

## ANOVA-type statistic for the whole-plot factor
ex.f1f1$ANOVA.test.mod.Box

#          Statistic      df1      df2    p-value
#Treatment  5.286582 1.922792 19.23468 0.01563658

## The same analysis can be done using the wrapper function "nparLD" ##

ex.f1f1np<-nparLD(resp~time*group, data=rat, subject="subject", 
description=FALSE)
# F1 LD F1 Model 
# ----------------------- 
# Check that the order of the time and group levels are correct.
# Time level:   0 1 2 3 4 
# Group level:   control thyrox thiour 
# If the order is not correct, specify the correct order in time.order or 
# group.order.
}
\keyword{datasets}
