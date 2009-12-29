\name{f1.ld.f2}
\alias{f1.ld.f2}
\title{Nonparametric Tests for the F1-LD-F2 Design}
\description{
This function performs several tests for the relative treatment effects with global or patterned alternatives for the F1-LD-F2 design (see Details for the definition). For the experiments with F1-LD-F2 design, the Wald-type statistic (WTS) and the ANOVA-type statistic (ATS) are calculated.
}

\usage{
f1.ld.f2(var, time1, time2, group, subject, time1.name="TimeC", 
time2.name="TimeT", group.name="GroupA", description=TRUE, 
time1.order=NULL, time2.order=NULL, group.order=NULL)
}

\arguments{
  \item{var}{a vector of numeric variable of interest; missing values should be specified as NA.}
  \item{time1}{a vector of the first sub-plot factor variable. See Details for more explanation.}
  \item{time2}{a vector of the second sub-plot factor variable. See Details for more explanation.}
  \item{group}{a vector of the whole-plot factor variable. See Details for more explanation.}
  \item{subject}{a vector of individual subjects.}
  \item{time1.name}{name of the time1 vector; the default option is "TimeC".}
  \item{time2.name}{name of the time2 vector; the default option is "TimeT".}
  \item{group.name}{name of the group vector; the default option is "GroupA".}
  \item{description}{indicator for whether a short description of the output should be shown; the default option is TRUE.}
  \item{time1.order}{a character or numeric vector specifying the order of the time1 levels; the default option is NULL, in which case, the levels are in the order of the original data.}
  \item{time2.order}{a character or numeric vector specifying the order of the time2 levels; the default option is NULL, in which case, the levels are in the order of the original data.}
  \item{group.order}{a character or numeric vector specifying the order of the group levels; the default option is NULL, in which case, the levels are in the order of the original data.}
}

\details{
The F1-LD-F2 design refers to the experimental design with one whole-plot factor and two sub-plot factors (where time2 is the stratification of time1). A whole-plot factor refers to a factor effective for each subject at all times. A sub-plot factor refers to a factor effective at a single time point for all time curves and all subjects. See Brunner et al. (2002) for more examples.
}

\value{
A list with the following numeric components.
  \item{RTE}{
Summary of the relative treatment effect (RTE) in a n-by-3 matrix form, where n is the total number of time1, time2, and group levels, and group-time interactions. The summary includes the mean of the ranks (RankMeans) in the 1st column, number of observations without counting the repeated measurements within the cell (Nobs) in the 2nd column, and the relative treatment effect (RTE) in the 3rd column.
}
  \item{Wald.test}{the test statistic, degrees of freedom (df), and corresponding p-value of the Wald-type test.}
  \item{ANOVA.test}{the test statistic, degrees of freedom (df), and corresponding p-value of the ANOVA-type test.}
  \item{covariance}{the covariance matrix.}
}

\references{

Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.

}
\author{Kimihiro Noguchi, Karthinathan Thangavelu, Frank Konietschke, Yulia Gel, Edgar Brunner}

\seealso{\code{\link{ld.f1}}, \code{\link{ld.f2}}, \code{\link{f1.ld.f1}}, 
\code{\link{f2.ld.f1}}, \code{\link{ld.ci}}, \code{\link{edema}}}

\examples{
## Example with the "Postoperative edema" data ##
data(edema)
var<-c(edema[,"n01"],edema[,"n1"],edema[,"n3"],edema[,"n5"],
edema[,"o01"],edema[,"o1"],edema[,"o3"],edema[,"o5"])
time1<-c(rep("Healthy",232),rep("Operated",232))
time2<-c(rep(-1,58),rep(1,58),rep(3,58),rep(5,58),
rep(-1,58),rep(1,58),rep(3,58),rep(5,58))
group<-rep(edema[,"Group"],8)
subject<-rep(edema[,"Patient"],8)
ex.f1f2<-f1.ld.f2(var, time1, time2, group, subject, time1.name = "Hand", 
time2.name = "Day", group.name = "Treatment", description=FALSE, 
time1.order=c("Healthy","Operated"), time2.order=c(-1,1,3,5), 
group.order=c("Drug","Placebo"))
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
\keyword{htest}
