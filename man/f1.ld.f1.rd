\name{f1.ld.f1}
\alias{f1.ld.f1}
\title{Nonparametric Tests for the F1-LD-F1 Design}
\description{
This function performs several tests for the relative treatment effects with global or patterned alternatives for the F1-LD-F1 design (see Details for the definition). For the experiments with F1-LD-F1 design, the Wald-type statistic (WTS), the ANOVA-type statistic (ATS), and the modified ANOVA-type statistic with Box (1954) approximation are calculated for testing group and time effects, and interaction. The hypothesis can also be tested against patterned alternatives to detect various trends. Moreover, pairwise comparisons of the groups, patterned interactions, and patterned group effects can be tested using this function.
}

\usage{
f1.ld.f1(y, time, group, subject, w.pat=NULL, w.t=NULL, w.g=NULL, 
time.name="Time", group.name="Group", description=TRUE, 
time.order=NULL, group.order=NULL, plot.RTE=TRUE, show.covariance=FALSE,
order.warning=TRUE)
}

\arguments{
  \item{y}{a vector of numeric variable of interest; missing values should be specified as NA.}
  \item{time}{a vector of the sub-plot factor variable. See Details for more explanation.}
  \item{group}{a vector of the whole-plot factor variable. See Details for more explanation.}
  \item{subject}{a vector of individual subjects.}
  \item{w.pat}{an A-by-T matrix specifying the pattern for the pattern alternatives where A is the group level and T is the time level; the default option is NULL.}
  \item{w.t}{a vector of time pattern for the pattern alternatives; the default option is NULL. The length, if specified, must be equal to the number of time levels.}
  \item{w.g}{a vector of group pattern for the pattern alternatives; the default option is NULL. The length, if specified, must be equal to the number of group levels.}
  \item{time.name}{a character vector specifying the name of the time vector; the default option is "Time".}
  \item{group.name}{a character vector specifying the name of the group vector; the default option is "Group".}
  \item{description}{an indicator for whether a short description of the output should be shown; the default option is TRUE.}
  \item{time.order}{a character or numeric vector specifying the order of the time levels; the default option is NULL, in which case, the levels are in the order of the original data.}
  \item{group.order}{a character or numeric vector specifying the order of the group levels; the default option is NULL, in which case, the levels are in the order of the original data.}
  \item{plot.RTE}{an indicator for whether a plot of the relative treatment effect (RTE) should be shown; the default option is TRUE.}
  \item{show.covariance}{an indicator for whether the covariance matrix should be shown; the default option is FALSE, in which case, NULL is returned.}
  \item{order.warning}{an indicator for whether a short description of the warning regarding the ordering of factors should be shown; the default option is TRUE.}
}

\details{
The F1-LD-F1 design refers to the experimental design with one whole-plot factor and one sub-plot factor. A whole-plot factor refers to a factor effective for each subject at all times. A sub-plot factor refers to a factor effective at a single time point for all time curves and all subjects. See Brunner et al. (2002) for more examples.
}

\value{
A list with the following numeric components.
  \item{RTE}{
summary of the relative treatment effect (RTE) in a n-by-3 matrix form, where n is the total number of time points, group levels, and group-time interactions; the summary includes the mean of the ranks (RankMeans) in the 1st column, number of observations without counting the repeated measurements within the cell (Nobs) in the 2nd column, and the relative treatment effect (RTE) in the 3rd column.
}
  \item{case2x2}{the test statistic, corresponding p-value (approximated by standard normal distribution), degrees of freedom (df) for Student's t distribution, and corresponding p-value (approximated by Student's t distribution with the degrees of freedom in the previous column) for the 2-by-2 design with no missing observations. For the cases which do not use the 2-by-2 design, or when there is a missing value in the 2-by-2 design, case2x2 returns NULL.}
  \item{Wald.test}{the test statistic, degrees of freedom (df) for the central chi-square distribution, and corresponding p-value of the Wald-type test.}
  \item{ANOVA.test}{the test statistic, numerator degrees of freedom (df) for the central F distribution, and corresponding p-value of the ANOVA-type test; denominator degrees of freedom is set to infinity.}
  \item{ANOVA.test.mod.Box}{the test statistic, numerator and denominator degrees of freedom (df1, df2), respectively, for the central F distribution, and corresponding p-value of the ANOVA-type test for the whole-plot factor.}
  \item{Wald.test.time}{the test statistic and corresponding p-value of the Wald-type test with the hypothesis of no simple time effects.}
  \item{ANOVA.test.time}{the test statistic and corresponding p-value of the ANOVA-type test with the hypothesis of no simple time effects.}
  \item{pattern.time}{the test statistic, corresponding p-value (approximated by standard normal distribution), degrees of freedom (df) for Student's t distribution, and corresponding p-value (approximated by Student's t distribution with the degrees of freedom in the previous column) to test for patterned simple time effects. If the pattern (w.pat) is not specified, pattern.time returns NULL.}
  \item{pair.comparison}{the test statistic, degrees of freedom (df), and the corresponding p-value of the pairwise comparisons.}
  \item{pattern.pair.comparison}{the test statistic, corresponding p-value (approximated by standard normal distribution), degrees of freedom (df) for Student's t distribution, and corresponding p-value (approximated by Student's t distribution with the degrees of freedom in the previous column) to test for patterned interactions.}
  \item{pattern.group}{the test statistic, corresponding p-value (approximated by standard normal distribution), degrees of freedom (df) for Student's t distribution, and corresponding p-value (approximated by Student's t distribution with the degrees of freedom in the previous column) to test for patterned group effects.}
  \item{covariance}{the covariance matrix.}
  \item{model.name}{the name of the model used.}
}

\references{

Box, G.E.P. (1954). Some theorems on quadratic forms applied in the study of analysis of variance problems, I. Effect of inequality of variance in the one-way classification. \emph{Annals of Mathematical Statistics}, 25, 290-302.\cr

Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.

}
\author{Kimihiro Noguchi, Mahbub Latif, Frank Konietschke, Yulia Gel, Edgar Brunner}

\seealso{\code{\link{nparLD}}, \code{\link{ld.f1}}, \code{\link{ld.f2}},
\code{\link{f1.ld.f2}}, \code{\link{f2.ld.f1}}, \code{\link{ld.ci}}, 
\code{\link{tree}}}

\examples{
## Example with the "Vitality of treetops" data ##
data(tree)
attach(tree)
w.t<-c(1:4)
w.g<-c(1:3)
w.pat <- rbind(c(1:4), c(1:4), c(1:4))
ex.f1f1<-f1.ld.f1(y=resp, time=time, group=group, subject=subject,
w.pat=w.pat, w.t=w.t, w.g=w.g, time.name="Year", group.name="Area",
description=FALSE, time.order=c(1,2,3,4), group.order=c("D0","D1","D2"))
# F1 LD F1 Model 
# ----------------------- 
# Check that the order of the time and group levels are correct.
# Time level:   1 2 3 4 
# Group level:   D0 D1 D2 
# If the order is not correct, specify the correct order in time.order or 
# group.order.

## Wald-type statistic 
ex.f1f1$Wald.test

#          Statistic df      p-value
#Area       4.510037  2 1.048716e-01
#Year      58.061097  3 1.525356e-12
#Area:Year 14.819966  6 2.170415e-02

## ANOVA-type statistic
ex.f1f1$ANOVA.test

#          Statistic       df      p-value
#Area       2.352854 1.968147 9.601181e-02
#Year      21.389142 2.729147 8.210954e-13
#Area:Year  3.113632 5.346834 6.768732e-03

## ANOVA-type statistic for the whole-plot factor
ex.f1f1$ANOVA.test.mod.Box

#     Statistic      df1     df2   p-value
#Area  2.352854 1.968147 64.3979 0.1040525
}
\keyword{htest}
