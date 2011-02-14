\name{ld.f1}
\alias{ld.f1}
\title{Nonparametric Tests for the LD-F1 Design}
\description{
This function performs several tests for the relative treatment effects with global or patterned alternatives for the LD-F1 design (see Details for the definition). For the experiments with LD-F1 design, the Wald-type statistic (WTS), Hotelling's F (T-squared) statistic, and the ANOVA-type statistic (ATS) are calculated for the global alternatives. The hypothesis can also be tested against patterned alternatives to detect various trends. For the design with two time points where no data are missing, tests under Behrens-Fisher and homogeneous variance situations can be performed.
}

\usage{
ld.f1(var, time, subject, w.pat=NULL, time.name="Time", description=TRUE, 
time.order=NULL, plot.RTE=TRUE, show.covariance=FALSE)
}

\arguments{
  \item{var}{a vector of numeric variable of interest; missing values should be specified as NA.}
  \item{time}{a vector of the sub-plot factor variable. See Details for more explanation.}
  \item{subject}{a vector of individual subjects}
  \item{w.pat}{a vector of pattern for the pattern alternatives; the default option is NULL. The length, if specified, must be equal to the number of time levels.}
  \item{time.name}{a character vector specifying the name of the time vector; the default option is "Time".} 
  \item{description}{an indicator for whether a short description of the output should be shown; the default option is TRUE.}
  \item{time.order}{a character or numeric vector specifying the order of the time levels; the default option is NULL, in which case, the levels are in the order of the original data.}
  \item{plot.RTE}{an indicator for whether a plot of the relative treatment effect (RTE) should be shown; the default option is TRUE.}
  \item{show.covariance}{an indicator for whether the covariance matrix should be shown; the default option is FALSE, in which case, NULL is returned.}
}

\details{
The LD-F1 design refers to the experimental design with one sub-plot factor (longitudinal data for one homogeneous group of subjects). A sub-plot factor refers to a factor effective at a single time point for all time curves and all subjects. See Brunner et al. (2002) for more examples.
}

\value{
A list with the following numeric components.
  \item{RTE}{
Summary of the relative treatment effect (RTE) in a n-by-3 matrix form, where n is the number of time vector levels. The summary includes the mean of the ranks (RankMeans) in the 1st column, number of observations without counting the repeated measurements within the cell (Nobs) in the 2nd column, and the relative treatment effect (RTE) in the 3rd column.
}
  \item{Wald.test}{the test statistic, degrees of freedom (df), and corresponding p-value of the Wald-type test.}
  \item{Hotelling.test}{the test statistic, degrees of freedom (df1, df2), and corresponding p-value of the Hotelling's F (T-squared) test.}
  \item{ANOVA.test}{the test statistic, degrees of freedom (df), and corresponding p-value of the ANOVA-type test.}
  \item{two.sample.test}{the test statistic and corresponding p-values (approximated by standard normal and Student's t distributions) of the test under homogeneous variance situation.}
  \item{two.sample.BF.test}{the test statistic and corresponding p-values (approximated by standard normal (N) and Student's t distributions (T)) of the test under the Behrens-Fisher situation where variances of the two samples are not assumed to be equal.}
  \item{pattern.test}{the test statistic and corresponding p-values (approximated by standard normal (N) and Student's t distributions (T)) of the test with patterned alternatives where the patterns are specified by w.pat.}
  \item{covariance}{the covariance matrix.}
}

\note{
If there are more than two time points in the data, or if there is a missing observation, two.sample.test and two.sample.BF.test return NULL. 
If the second degrees of freedom (df2) is less than 1, Hotelling.test returns NULL.
}

\references{

Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.

}
\author{Kimihiro Noguchi, Mahbub Latif, Frank Konietschke, Yulia Gel, Edgar Brunner}

\seealso{\code{\link{ld.f2}}, \code{\link{f1.ld.f1}}, \code{\link{f1.ld.f2}}, 
\code{\link{f2.ld.f1}}, \code{\link{ld.ci}}, \code{\link{panic}}}

\examples{
## Example with the "Panic disorder study I" data ##
data(panic)
var<-c(panic[,"W0"],panic[,"W2"],panic[,"W4"],panic[,"W6"],panic[,"W8"])
time<-c(rep(0,16),rep(2,16),rep(4,16),rep(6,16),rep(8,16))
subject<-rep(panic[,"Patient"],5)
pat<-c(5,4,3,2,5)
ex.f1<-ld.f1(var,time,subject,w.pat=pat,time.name="Week",description=FALSE, 
time.order=c(0,2,4,6,8))
# Check that the order of the time level is correct.
# Time level:   0 2 4 6 8 
# If the order is not correct, specify the correct order in time.order.

## Wald-type statistic 
ex.f1$Wald.test

#     Statistic df p-value
#Week  126.6946  4       0

## ANOVA-type statistic
ex.f1$ANOVA.test

#     Statistic       df p-value
#Week  36.93664 2.234135       0
}
\keyword{htest}
