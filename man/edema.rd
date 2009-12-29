\name{edema}
\alias{edema}
\docType{data}
\title{Postoperative edema}
\description{
Measurements of skin temperatures in (degree Celcius/10) of both operated and non-operated hands from a group of patients who had a surgery on a hand.
}
\usage{data(edema)}
\format{
Longitudinal data of 58 patients from both a treatment and a control group with skin temperatues taken on 4 occasions on each hand, which result in 8 occasions per patient.
}
\details{
Surgical procedures on the hand may lead to a postoperative edema and a reddening of the skin. This is related to an increase in the skin temperature. A randomized clinical study was conducted to investigate whether treatment with a substance (V) effects a faster reduction of the edema and reddening than a placebo (P). Each experimental group consists of 29 patients. Temperature measurements were taken on the same area of both the operated and non-operated hand on the day previous to the operation (day -1) as well as on the first, third and fifth day (days 1, 3, 5) subsequent to the surgery.
}
\references{
Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.
}

\examples{
## Analysis using F1-LD-F2 design ##
data(edema)
var<-c(edema[,"n01"],edema[,"n1"],edema[,"n3"],edema[,"n5"],
edema[,"o01"],edema[,"o1"],edema[,"o3"],edema[,"o5"])
time1<-factor(c(rep("Healthy",232),rep("Operated",232)))
time2<-c(rep(-1,58),rep(1,58),rep(3,58),rep(5,58),
rep(-1,58),rep(1,58),rep(3,58),rep(5,58))
group<-rep(edema[,"Group"],8)
subject<-rep(edema[,"Patient"],8)
ex.f1f2<-f1.ld.f2(var, time1, time2, group, subject, time1.name = "Hand", 
time2.name = "Day", group.name = "Treatment", description=FALSE)
# Check that the order of the time1, time2, and group levels are correct.
# Time1 level:   Healthy Operated 
# Time2 level:   -1 1 3 5 
# Group level:   Drug Placebo 
# If the order is not correct, specify the correct order in time1.order, time2.order, or group.order.

## Wald-type statistic 
ex.f1f2$Wald.test

#$Wald.test
#                    Statistic df      p-value
#Treatment           1.0725762  1 3.003643e-01
#Hand               25.8758257  1 3.641005e-07
#Day                36.8857947  3 4.864630e-08
#Treatment:Hand      0.3304448  1 5.653973e-01
#Day:Hand           47.3460508  3 2.933702e-10
#Treatment:Day       5.3048189  3 1.507900e-01
#Treatment:Hand:Day  1.6581652  3 6.462743e-01

## ANOVA-type statistic
ex.f1f2$ANOVA.test

#                    Statistic       df      p-value
#Treatment           1.0725762 1.000000 3.003668e-01
#Hand               25.8758257 1.000000 3.647569e-07
#Day                11.0630080 2.699667 9.682198e-07
#Treatment:Hand      0.3304448 1.000000 5.653986e-01
#Day:Hand           15.1854889 2.630202 6.208596e-09
#Treatment:Day       1.3342605 2.699667 2.625598e-01
#Treatment:Hand:Day  0.7170325 2.630202 5.242392e-01
}
\keyword{datasets}
