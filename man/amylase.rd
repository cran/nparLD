\name{amylase}
\alias{amylase}
\docType{data}
\title{Alpha-amylase study}
\description{
Measurements of alpha-amylase levels (in U/ml) of the saliva from a group of volunteers.
}
\usage{data(amylase)}
\format{
Longitudinal data of 14 probands with alpha-amylase level measurements taken on 8 occasions (4 times per day for 2 days).
}
\details{
In clinical chemistry, it is important for the determination of reference intervals to investigate whether a variable of interest has a circadian rhythm. If so, the reference intervals cannot be determined independently of time. This question is to be analyzed in the case of alpha-amylase in saliva. Measurements of alpha-amylase levels were taken from the saliva of 14 volunteers, four times per day (8 a.m., 12 p.m., 5 p.m., 9 p.m.) on two days (Monday (m), Thursday (t)), since differences in the alpha-amylase profiles immediately after a weekend as opposed to the middle of the week are suspected. Thus, each subject was examined on Monday and Thursday.
}
\references{
Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.
}

\examples{
## Analysis using LD-F2 design ##
data(amylase)
attach(amylase)
ex.f2<-ld.f2(y=resp, time1=time1, time2=time2, subject=subject,
time1.name="Day", time2.name="Time", description=FALSE)
# LD F2 Model 
# ----------------------- 
# Check that the order of the time1 and time2 levels are correct.
# Time1 level:   M T 
# Time2 level:   8 12 17 21 
# If the order is not correct, specify the correct order in time1.order or 
# time2.order.

## Wald-type statistic 
ex.f2$Wald.test

#          Statistic df      p-value
#Day       0.6761043  1 4.109314e-01
#Time     35.8647640  3 7.997949e-08
#Day:Time 14.3020921  3 2.521503e-03

## ANOVA-type statistic
ex.f2$ANOVA.test

#          Statistic       df      p-value
#Day       0.6761043 1.000000 4.109314e-01
#Time     14.2671950 2.858344 5.860479e-09
#Day:Time  5.2242782 2.184249 4.150298e-03
}
\keyword{datasets}
