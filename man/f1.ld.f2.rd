\name{f1.ld.f2}
\alias{f1.ld.f2}
\title{Nonparametric Tests for the F1-LD-F2 Design}
\description{
This function performs several tests for the relative treatment effects with global or patterned alternatives for the F1-LD-F2 design (see Details for the definition). For the experiments with F1-LD-F2 design, the Wald-type statistic (WTS) and the ANOVA-type statistic (ATS) are calculated.
}

\usage{
f1.ld.f2(y, time1, time2, group, subject, time1.name="Time1", 
time2.name="Time2", group.name="Group", description=TRUE, 
time1.order=NULL, time2.order=NULL, group.order=NULL,
plot.RTE=TRUE, show.covariance=FALSE, order.warning=TRUE)
}

\arguments{
  \item{y}{a vector of numeric variable of interest; missing values should be specified as NA.}
  \item{time1}{a vector of the first sub-plot factor variable. See Details for more explanation.}
  \item{time2}{a vector of the second sub-plot factor variable. See Details for more explanation.}
  \item{group}{a vector of the whole-plot factor variable. See Details for more explanation.}
  \item{subject}{a vector of individual subjects.}
  \item{time1.name}{a character vector specifying the name of the time1 vector; the default option is "Treatment".}
  \item{time2.name}{a character vector specifying the name of the time2 vector; the default option is "Time".}
  \item{group.name}{a character vector specifying the name of the group vector; the default option is "Group".}
  \item{description}{an indicator for whether a short description of the output should be shown; the default option is TRUE.}
  \item{time1.order}{a character or numeric vector specifying the order of the time1 levels; the default option is NULL, in which case, the levels are in the order of the original data.}
  \item{time2.order}{a character or numeric vector specifying the order of the time2 levels; the default option is NULL, in which case, the levels are in the order of the original data.}
  \item{group.order}{a character or numeric vector specifying the order of the group levels; the default option is NULL, in which case, the levels are in the order of the original data.}
  \item{plot.RTE}{an indicator for whether a plot of the relative treatment effect (RTE) should be shown; the default option is TRUE.}
  \item{show.covariance}{an indicator for whether the covariance matrix should be shown; the default option is FALSE, in which case, NULL is returned.}
  \item{order.warning}{an indicator for whether a short description of the warning regarding the ordering of factors should be shown; the default option is TRUE.}
}

\details{
The F1-LD-F2 design refers to the experimental design with one whole-plot factor and two sub-plot factors (where time2 is the stratification of time1). A whole-plot factor refers to a factor effective for each subject at all times. A sub-plot factor refers to a factor effective at a single time point for all time curves and all subjects. See Brunner et al. (2002) for more examples.
}

\value{
A list with the following numeric components.
  \item{RTE}{
summary of the relative treatment effect (RTE) in a n-by-3 matrix form, where n is the total number of time1, time2, and group levels, and group-time interactions; the summary includes the mean of the ranks (RankMeans) in the 1st column, number of observations without counting the repeated measurements within the cell (Nobs) in the 2nd column, and the relative treatment effect (RTE) in the 3rd column.
}
  \item{Wald.test}{the test statistic, degrees of freedom (df) for the central chi-square distribution, and corresponding p-value of the Wald-type test.}
  \item{ANOVA.test}{the test statistic, numerator degrees of freedom (df) for the central F distribution, and corresponding p-value of the ANOVA-type test; denominator degrees of freedom is set to infinity.}
  \item{ANOVA.test.mod.Box}{the test statistic, numerator and denominator degrees of freedom (df1, df2), respectively, for the central F distribution, and corresponding p-value of the ANOVA-type test for the whole-plot factor.}
  \item{covariance}{the covariance matrix.}
  \item{model.name}{the name of the model used.}
}

\note{
Version 1.3 of the f1.ld.f2 function had problems with calculations of the statistics with unequal group sizes, and the issues have been resolved in Version 2.0. We would like to thank Dr. Fernando Marmolejo-Ramos for bringing this to our attention.
}

\references{

Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.

}
\author{Kimihiro Noguchi, Karthinathan Thangavelu, Frank Konietschke, Yulia Gel, Edgar Brunner}

\seealso{\code{\link{nparLD}}, \code{\link{ld.f1}}, \code{\link{ld.f2}}, 
\code{\link{f1.ld.f1}}, \code{\link{f2.ld.f1}}, \code{\link{ld.ci}}, 
\code{\link{edema}}}

\examples{
## Example with the "Postoperative edema" data ##
data(edema)
attach(edema)
ex.f1f2<-f1.ld.f2(y=resp, time1=time1, time2=time2, group=group, 
subject=subject, time1.name="Hand", time2.name="Day", group.name="Treatment",
description=FALSE, time1.order=c("Healthy","Operated"), time2.order=c(-1,1,3,5), 
group.order=c("Drug","Placebo"))
# F1 LD F2 Model 
# ----------------------- 
# Check that the order of the time1, time2, and group levels are correct.
# Time1 level:   Healthy Operated 
# Time2 level:   -1 1 3 5 
# Group level:   Drug Placebo 
# If the order is not correct, specify the correct order in time1.order, 
# time2.order, or group.order.

## Wald-type statistic 
ex.f1f2$Wald.test

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
#Treatment           1.0725762 1.000000 3.003643e-01
#Hand               25.8758257 1.000000 3.641005e-07
#Day                11.0630080 2.699667 9.661602e-07
#Treatment:Hand      0.3304448 1.000000 5.653973e-01
#Day:Hand           15.1854889 2.630202 6.184646e-09
#Treatment:Day       1.3342605 2.699667 2.625538e-01
#Treatment:Hand:Day  0.7170325 2.630202 5.242367e-01

## ANOVA-type statistic for the whole-plot factor
ex.f1f2$ANOVA.test.mod.Box

#          Statistic df1      df2   p-value
#Treatment  1.072576   1 55.80551 0.3048313
}
\keyword{htest}
