\name{dental}
\alias{dental}
\docType{data}
\title{Dental study}
\description{
Measurements of distances (in millimeters) between the center of the pituitary and the pterygomaxillary fissure from a group of boys.
}
\usage{data(dental)}
\format{
Longitudinal data of of 16 boys with the dental measurements taken on 4 occasions (at the ages 8, 10, 12, and 14).
}
\details{
Potthoff and Roy (1964) use this dental measurement dataset to analyze the growth curve problem to suggest answers to questions such as a suitable form for the function of time, the difference in the curves between boys and girls, and possibility of obtaining confidence bands. The dataset contains the data for boys (see \code{\link[nlme]{Orthodont}} for a complete dataset). The dataset was obtained by investigators at the University of North Carolina Dental School.
}
\references{
Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.\cr

Noguchi, K., Gel, Y.R., Brunner, E., and Konietschke, F. (2012). 
nparLD: An R Software Package for the Nonparametric Analysis of Longitudinal Data in Factorial Experiments. 
\emph{Journal of Statistical Software}, 50(12), 1-23.\cr

Potthoff, R.F. and Roy, S.N. (1964). Generalized multivariate analysis of variance model useful especially for growth curve problems, 
\emph{Biometrika}, 51, 313-326.

}

\seealso{\code{\link{nparLD}}, \code{\link{ld.f1}}, \code{\link[nlme]{Orthodont}}}

\examples{
## Analysis using LD-F1 design ##
data(dental)
attach(dental)
ex.f1<-ld.f1(y=resp, time=time, subject=subject, w.pat=c(1,2,3,4), 
time.name="Age", description=FALSE, time.order=NULL)
# LD F1 Model 
# ----------------------- 
# Check that the order of the time level is correct.
# Time level:   8 10 12 14 
# If the order is not correct, specify the correct order in time.order.

## Wald-type statistic 
ex.f1$Wald.test
#     Statistic df p-value
#Week  94.47718  3 2.391503e-20

## ANOVA-type statistic
ex.f1$ANOVA.test
#    Statistic       df      p-value
#Age  31.48774 2.700785 1.437729e-18

## The same analysis can be done using the wrapper function "nparLD" ##

ex.f1np<-nparLD(resp~time, data=dental, subject="subject", description=FALSE)
# LD F1 Model 
# ----------------------- 
# Check that the order of the time level is correct.
# Time level:   8 10 12 14 
# If the order is not correct, specify the correct order in time.order.
}
\keyword{datasets}
