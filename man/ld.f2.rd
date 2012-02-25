\name{ld.f2}
\alias{ld.f2}
\title{Nonparametric Tests for the LD-F2 Design}
\description{
This function performs several tests for the relative treatment effects for the LD-F2 design (see Details for the definition). The Wald-type statistic (WTS) and the ANOVA-type statistic (ATS) are calculated for each of the two sub-plot factors as well as their interaction.
}

\usage{
ld.f2(y, time1, time2, subject, time1.name="Treatment", 
time2.name="Time", description=TRUE, time1.order=NULL, 
time2.order=NULL, plot.RTE=TRUE, show.covariance=FALSE,
order.warning=TRUE) 
}

\arguments{
  \item{y}{a vector of numeric variable of interest; missing values should be specified as NA.}
  \item{time1}{a vector of the first sub-plot factor variable. See Details for more explanation.}
  \item{time2}{a vector of the second sub-plot factor variable. See Details for more explanation.}
  \item{subject}{a vector of individual subjects.}
  \item{time1.name}{a character vector specifying the name of the time1 vector; the default option is "Treatment".}
  \item{time2.name}{a character vector specifying the name of the time2 vector; the default option is "Time".}
  \item{description}{an indicator for whether a short description of the output should be shown; the default option is TRUE.}
  \item{time1.order}{a character or numeric vector specifying the order of the time1 levels; the default option is NULL, in which case, the levels are in the order of the original data.}
  \item{time2.order}{a character or numeric vector specifying the order of the time2 levels; the default option is NULL, in which case, the levels are in the order of the original data.}
  \item{plot.RTE}{an indicator for whether a plot of the relative treatment effect (RTE) should be shown; the default option is TRUE.}
  \item{show.covariance}{an indicator for whether the covariance matrix should be shown; the default option is FALSE, in which case, NULL is returned.}
  \item{order.warning}{an indicator for whether a short description of the warning regarding the ordering of factors should be shown; the default option is TRUE.}
}

\details{
The LD-F2 design refers to the experimental design with two sub-plot factors (longitudinal data for one homogeneous group of subjects and an underlying structure in the time where time2 is the stratification of time1). A sub-plot factor refers to a factor effective at a single time point for all time curves and all subjects. See Brunner et al. (2002) for more examples.
}

\value{
A list with the following numeric components.
  \item{RTE}{
summary of the relative treatment effect (RTE) in a n-by-3 matrix form, where n is the total of number of time1 and time2 levels, and their interactions; the summary includes the mean of the ranks (RankMeans) in the 1st column, number of observations without counting the repeated measurements within the cell (Nobs) in the 2nd column, and the relative treatment effect (RTE) in the 3rd column.
}
  \item{Wald.test}{the test statistic, degrees of freedom (df) for the central chi-square distribution, and corresponding p-value of the Wald-type test.}
  \item{ANOVA.test}{the test statistic, numerator degrees of freedom (df) for the central F distribution, and corresponding p-value of the ANOVA-type test; denominator degrees of freedom is set to infinity.}
  \item{covariance}{the covariance matrix.}
  \item{model.name}{the name of the model used.}
}

\note{
Version 1.0 of the ld.f2 function had problems with calculations of the statistics, and the issues have been resolved in Version 1.1. We would like to thank Dr. Stefano Burigat for pointing out the problems.
}

\references{

Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.

}
\author{Kimihiro Noguchi, Karthinathan Thangavelu, Frank Konietschke, Yulia Gel, Edgar Brunner}

\seealso{\code{\link{nparLD}}, \code{\link{ld.f1}}, \code{\link{f1.ld.f1}}, 
\code{\link{f1.ld.f2}}, \code{\link{f2.ld.f1}}, \code{\link{ld.ci}}, 
\code{\link{amylase}}}
\examples{
## Example with the "Alpha-amylase study" data ##
data(amylase)
attach(amylase)
ex.f2<-ld.f2(y=resp, time1=time1, time2=time2, subject=subject,
time1.name="Day", time2.name="Time", description=FALSE, 
time1.order=c("M","T"), time2.order=c(8,12,17,21))
# LD F2 Model 
# ----------------------- 
# Check that the order of the time1 and time2 levels are correct.
# Time1 level:   M T 
# Time2 level:   8 12 17 21 
# If the order is not correct, specify the correct order in time1.order and 
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
\keyword{htest}
