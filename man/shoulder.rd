\name{shoulder}
\alias{shoulder}
\docType{data}
\title{Shoulder tip pain study}
\description{
Measurements of shoulder pain levels from a group of patients having undergone laparoscopic surgery in abdomen.
}
\usage{data(shoulder)}
\format{
Longitudinal data of 41 patients from both a treatment and a control group with shoulder pain scores taken on 6 occasions (2 times a day for 3 days).
}
\details{
In the shoulder tip pain study described by Lumley (1996), the shoulder pain typically experienced in patients having undergone laparoscopic surgery in the abdomen was observed in a total of 41 patients. A subgroup of 22 randomly selected patients received a treatment in which the air was removed by using a specific suction procedure (treatment Y). The remaining 19 patients served as the control group (treatment N). The pain was subjectively assessed by means of pain-scores (1=low through 5=high). This score was repeatedly measured in the morning and the evening of the first three days after the operation, yielding six repeated measurements for each patient. The patients were stratified according to gender (M=male, F=female) since pain sensitivity may depend on the gender of the patient.
}
\references{
Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.\cr

Lumley, T. (1996). Generalized estimating equations for ordinal data: A note on working correlation structures. 
\emph{Biometrics} 52, 354-361. 
}

\examples{
## Analysis using F2-LD-F1 design ##
data(shoulder)
var<-c(shoulder[,"T1"],shoulder[,"T2"],shoulder[,"T3"],
shoulder[,"T4"],shoulder[,"T5"],shoulder[,"T6"])
time<-c(rep(1,41),rep(2,41),rep(3,41),rep(4,41),rep(5,41),rep(6,41))
group1<-rep(shoulder[,"Treat"],6)
group2<-rep(shoulder[,"Gender"],6)
subject<-rep(shoulder[,"Patient"],6)
ex.f2f1<-f2.ld.f1(var, time, group1, group2, subject, time.name = "Time", 
group1.name = "Treatment", group2.name = "Gender", description=FALSE)
# Check that the order of the time, group1, and group2 levels are correct.
# Time level:   1 2 3 4 5 6 
# Group1 level:   Y N 
# Group2 level:   F M 
# If the order is not correct, specify the correct order in time.order, group1.order, or group2.order.
#
# Warning(s):
# The covariance matrix is singular. 

## Wald-type statistic 
ex.f2f1$Wald.test

#                        Statistic df      p-value
#Treatment             16.40129021  1 5.125033e-05
#Gender                 0.04628558  1 8.296575e-01
#Time                  16.34274332  5 5.930698e-03
#Treatment:Gender       0.03583558  1 8.498554e-01
#Treatment:Time        27.51450085  5 4.527996e-05
#Gender:Time           12.37903186  5 2.994753e-02
#Treatment:Gender:Time  5.11864769  5 4.015727e-01

## ANOVA-type statistic
ex.f2f1$ANOVA.test

#                        Statistic       df      p-value
#Treatment             16.40129021 1.000000 5.128893e-05
#Gender                 0.04628558 1.000000 8.296579e-01
#Time                   3.38218704 2.700754 2.120748e-02
#Treatment:Gender       0.03583558 1.000000 8.498558e-01
#Treatment:Time         3.71077200 2.700754 1.398497e-02
#Gender:Time            1.14434841 2.700754 3.273019e-01
#Treatment:Gender:Time  0.43755394 2.700754 7.054263e-01
}
\keyword{datasets}
