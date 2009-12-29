\name{plasma}
\alias{plasma}
\docType{data}
\title{Plasma-renin study}
\description{
Measurements of the plasma-renin activity (PRA) (in ng/ml/h) for agroup of healthy non-smokers aged 21-30 years
}
\usage{data(plasma)}
\format{
Longitudinal data of 49 subjects with PRA measurements taken on 5 occasions.
}
\details{
In a randomized, controlled study of 49 subjects (healthy non-smokers, aged 21-30 years) 750 ml of blood was removed and replaced with 1000 ml of a physiological electrolyte solution, together with one of four drugs (propanolol: $n_1=10$ subjects, dobutamine: $n_2=13$ subjects, fenoterol: $n_3=13$ subjects, placebo: $n_4=13$ subjects). Three of the original 13 subjects in the propanolol group fell ill and were unable to continue their participation in the study. The plasma-renin activity (PRA) was measured on five occasions (after 0, 2, 6, 8, 12 hours) and determined by means of blood test. One of the aims of the study was to analyze the extent to which PRA was increased or reduced by the drug.
}
\references{
Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.
}

\examples{
## Analysis using F1-LD-F1 design ##
data(plasma)
var<-c(plasma[,"H0"],plasma[,"H2"],plasma[,"H6"],plasma[,"H8"],plasma[,"H12"])
time<-c(rep(0,49),rep(2,49),rep(6,49),rep(8,49),rep(12,49))
group<-rep(plasma[,"Group"],5)
subject<-rep(plasma[,"Proband"],5)
w.t<-c(1:5)
w.g<-c(1:4)
w.pat<-rbind(c(1:5), c(1:5), c(1:5), c(1:5))
ex.f1f1.3<-f1.ld.f1(var,time,group,subject,w.pat,w.t,w.g,
time.name="Hour",group.name="Drug",description=FALSE)
# Check that the order of the time and group levels are correct.
# Time level:   0 2 6 8 12 
# Group level:   Propanolol Dobutamine Fenoterol Placebo 
# If the order is not correct, specify the correct order in time.order or group.order.

## Wald-type statistic
ex.f1f1.3$Wald.test

#          Statistic df p-value
#Drug       128.6257  3       0
#Hour       235.4921  4       0
#Drug:Hour  163.9275 12       0

## ANOVA-type statistic
ex.f1f1.3$ANOVA.test

#          Statistic       df      p-value
#Drug       23.74689 2.610248 1.113554e-13
#Hour       53.66771 3.108207 0.000000e+00
#Drug:Hour  16.03977 7.778431 0.000000e+00

}

\keyword{datasets}
