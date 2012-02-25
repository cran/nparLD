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
In a randomized, controlled study of 49 subjects (healthy non-smokers, aged 21-30 years) 750 ml of blood was removed and replaced with 1000 ml of a physiological electrolyte solution, together with one of four drugs (propanolol: 10 subjects, dobutamine: 13 subjects, fenoterol: 13 subjects, placebo: 13 subjects). Three of the original 13 subjects in the propanolol group fell ill and were unable to continue their participation in the study. The plasma-renin activity (PRA) was measured on five occasions (after 0, 2, 6, 8, 12 hours) and determined by means of blood test. One of the aims of the study was to analyze the extent to which PRA was increased or reduced by the drug.
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
attach(plasma)
w.t<-c(1:5)
w.g<-c(1:4)
w.pat<-rbind(c(1:5), c(1:5), c(1:5), c(1:5))
ex.f1f1.3<-f1.ld.f1(y=resp, time=time, group=group, subject=subject, 
w.pat=w.pat, w.t=w.t, w.g=w.g, time.name="Hour", group.name="Drug", 
description=FALSE)
# F1 LD F1 Model 
# ----------------------- 
# Check that the order of the time and group levels are correct.
# Time level:   0 2 6 8 12 
# Group level:   Propanolol Dobutamine Fenoterol Placebo 
# If the order is not correct, specify the correct order in time.order or 
# group.order.

## Wald-type statistic
ex.f1f1.3$Wald.test

#          Statistic df      p-value
#Drug       128.6257  3 1.069606e-27
#Hour       235.4921  4 8.672886e-50
#Drug:Hour  163.9275 12 8.307977e-29

## ANOVA-type statistic
ex.f1f1.3$ANOVA.test

#          Statistic       df      p-value
#Drug       23.74689 2.610248 1.113276e-13
#Hour       53.66771 3.108207 7.870535e-36
#Drug:Hour  16.03977 7.778431 2.488143e-23

## ANOVA-type statistic for the whole-plot factor
ex.f1f1.3$ANOVA.test.mod.Box

#     Statistic      df1      df2      p-value
#Drug  23.74689 2.610248 38.76767 2.207969e-08
}

\keyword{datasets}
