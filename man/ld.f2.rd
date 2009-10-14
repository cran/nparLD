\name{ld.f2}
\alias{ld.f2}
\title{Nonparametric Tests for the LD-F2 Design}
\description{
This function performs several tests for the relative treatment effects for the LD-F2 design (see Details for the definition). The Wald-type statistic (WTS) and the ANOVA-type statistic (ATS) are calculated for each of the two sub-plot factors as well as their interaction.
}

\usage{
ld.f2(var, time1, time2, subject, time1.name="TimeC", 
time2.name="TimeT", description=TRUE)
}

\arguments{
  \item{var}{a vector of variable of interest; missing values should be specified as NA.}
  \item{time1}{a vector of the first sub-plot factor variable. See Details for more explanation.}
  \item{time2}{a vector of the second sub-plot factor variable. See Details for more explanation.}
  \item{subject}{a vector of individual subjects.}
  \item{time1.name}{name of the time1 vector; the default option is "TimeC".}
  \item{time2.name}{name of the time2 vector; the default option is "TimeT".}
  \item{description}{indicator for whether a short description of the output should be shown; the default option is TRUE.}
}

\details{
The LD-F2 design refers to the experimental design with two sub-plot factors (longitudinal data for one homogeneous group of subjects and an underlying structure in the time where time2 is the stratification of time1). A sub-plot factor refers to a factor effective at a single time point for all time curves and all subjects. See Brunner et al. (2002) for more examples.
}

\value{
A list with the following numeric components.
  \item{RTE}{
Summary of the relative treatment effect (RTE) in a n-by-3 matrix form, where n is the total of number of time1 and time2 levels, and their interactions. The summary includes the mean of the ranks (RankMeans) in the 1st column, number of observations without counting the repeated measurements within the cell (Nobs) in the 2nd column, and the relative treatment effect (RTE) in the 3rd column.
}
  \item{Wald.test}{the test statistic, degrees of freedom (df), and corresponding p-value of the Wald-type test.}
  \item{ANOVA.test}{the test statistic, degrees of freedom (df), and corresponding p-value of the ANOVA-type test.}
  \item{covariance}{the covariance matrix.}
}

\note{
Version 1.0 of the ld.f2 function had problems with calculations of the statistics, and the issues have been resolved in Version 1.1. We thank Dr. Stefano Burigat for pointing out the problems. Although the function is designed to work for any kind of input (either in charactor or numeric vector) for the factor parameter(s), we recommend inputting them as numeric vector(s) after assigning each group of factors a number (i.e., 1 = first group, 2 = second group, etc.). 
}

\references{

Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.

}
\author{Kimihiro Noguchi, Karthinathan Thangavelu, Frank Konietschke, Yulia Gel, Edgar Brunner}

\seealso{\code{\link{ld.f1}}, \code{\link{f1.ld.f1}}, \code{\link{f1.ld.f2}}, 
\code{\link{f2.ld.f1}}, \code{\link{ld.ci}}, \code{\link{amylase}}}
\examples{
## Example with the "Alpha-amylase study" data ##
data(amylase)
var<-c(amylase[,"m8"],amylase[,"m12"],amylase[,"m17"],amylase[,"m21"],
amylase[,"t8"],amylase[,"t12"],amylase[,"t17"],amylase[,"t21"])
time1<-factor(c(rep("M",56),rep("T",56)))
time2<-c(rep(8,14),rep(12,14),rep(17,14),rep(21,14),
rep(8,14),rep(12,14),rep(17,14),rep(21,14))
subject<-c(rep(amylase[,"Proband"],8))
ex.f2<-ld.f2(var=var,time1=time1,time2=time2,subject=subject,
time1.name="Day",time2.name="Time",description=FALSE)

## Wald-type statistic 
ex.f2$Wald.test

#          Statistic df      p-value
#Day       0.6761043  1 4.109314e-01
#Time     35.8647640  3 7.997949e-08
#Day:Time 14.3020921  3 2.521503e-03

## ANOVA-type statistic
ex.f2$ANOVA.test

#          Statistic       df      p-value
#Day       0.6761043 1.000000 4.109334e-01
#Time     14.2671950 2.858344 5.883893e-09
#Day:Time  5.2242782 2.184249 4.151609e-03
}
\keyword{htest}
