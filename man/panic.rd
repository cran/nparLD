\name{panic}
\alias{panic}
\docType{data}
\title{Panic disorder study I}
\description{
Measurements of the degree of illness on a CGI scale for a group of patients suffering from panic disorder and agoraphobia.
}
\usage{data(panic)}
\format{
Longitudinal data of 16 patients with CGI scores taken on 5 occasions.
}
\details{
A group of 16 patients from panic disorder and agoraphobia were treated with anti-depressant imipramin over a period of eight weeks. Measurements on a discrete scale of scores between 2 and 8 were taken (2=not ill through 8=extremely ill) on 5 occasions (0=baseline, 2=after two weeks, 4=after four weeks,...).
}
\references{
Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.\cr

Noguchi, K., Gel, Y.R., Brunner, E., and Konietschke, F. (2012). 
nparLD: An R Software Package for the Nonparametric Analysis of Longitudinal Data in Factorial Experiments. 
\emph{Journal of Statistical Software}, 50(12), 1-23.

}

\examples{
## Analysis using LD-F1 design ##
data(panic)
attach(panic)
w.pat<-c(5,4,3,2,5)
ex.f1<-ld.f1(y=resp, time=time, subject=subject, w.pat=w.pat, time.name="Week", 
description=FALSE)
# LD F1 Model 
# ----------------------- 
# Check that the order of the time level is correct.
# Time level:   0 2 4 6 8 
# If the order is not correct, specify the correct order in time.order.

## Wald-type statistic 
ex.f1$Wald.test

#     Statistic df p-value
#Week  126.6946  4 1.9822e-26

## ANOVA-type statistic
ex.f1$ANOVA.test

#     Statistic       df p-value
#Week  36.93664 2.234135 1.975781e-18
}
\keyword{datasets}
