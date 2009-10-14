\name{f2.ld.f1}
\alias{f2.ld.f1}
\title{Nonparametric Tests for the F2-LD-F1 Design}
\description{
This function performs several tests for the relative treatment effects with global or patterned alternatives for the F2-LD-F1 design (see Details for the definition). For the experiments with F2-LD-F1 design, the Wald-type statistic (WTS), the ANOVA-type statistic (ATS), and the modified ANOVA-type statistic with Box (1954) approximation are calculated for testing group and time effects, and interaction. 
}

\usage{
f2.ld.f1(var, time, group1, group2, subject, time.name="Time", 
group1.name="GroupA", group2.name="GroupB", description=TRUE)
}

\arguments{
  \item{var}{a vector of variable of interest; missing values should be specified as NA.}
  \item{time}{a vector of the sub-plot factor variable. See Details for more explanation.}
  \item{group1}{a vector of the first whole-plot factor variable. See Details for more explanation.}
  \item{group2}{a vector of the second whole-plot factor variable. See Details for more explanation.}
  \item{subject}{a vector of individual subjects}
  \item{time.name}{name of the time vector; the default option is "Time".}
  \item{group1.name}{name of the group1 vector; the default option is "GroupA".}
  \item{group2.name}{name of the group2 vector; the default option is "GroupB".}
  \item{description}{indicator for whether a short description of the output should be shown; the default option is TRUE.}
}

\details{
The F2-LD-F1 design refers to the experimental design with two whole-plot factors (where group2 is the stratification of group1) and one sub-plot factor. A whole-plot factor refers to a factor effective for each subject at all times. A sub-plot factor refers to a factor effective at a single time point for all time curves and all subjects. See Brunner et al. (2002) for more examples.
}

\value{
A list with the following numeric components.
  \item{RTE}{
Summary of the relative treatment effect (RTE) in a n-by-3 matrix form, where n is the total number of time, group1, and group2 levels, and group-time interactions. The summary includes the mean of the ranks (RankMeans) in the 1st column, number of observations without counting the repeated measurements within the cell (Nobs) in the 2nd column, and the relative treatment effect (RTE) in the 3rd column.
}
  \item{Wald.test}{the test statistic, degrees of freedom (df), and corresponding p-value of the Wald-type test.}
  \item{ANOVA.test}{the test statistic, degrees of freedom (df), and corresponding p-value of the ANOVA-type test.}
  \item{ANOVA.test.mod.Box}{the test statistic, degrees of freedom (df1, df2), and corresponding p-value of the ANOVA-type test for the whole-plot factors and their interaction.}
  \item{covariance}{the covariance matrix.}
}

\note{
Although the function is designed to work for any kind of input (either in charactor or numeric vector) for the factor parameter(s), we recommend inputting them as numeric vector(s) after assigning each group of factors a number (i.e., 1 = first group, 2 = second group, etc.). 
}

\references{

Box, G.E.P. (1954). Some theorems on quadratic forms applied in the study of analysis of variance problems, I. Effect of inequality of variance in the one-way classification. \emph{Annals of Mathematical Statistics}, 25, 290-302.\cr

Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.

}
\author{Kimihiro Noguchi, Karthinathan Thangavelu, Frank Konietschke, Yulia Gel, Edgar Brunner}

\seealso{\code{\link{ld.f1}}, \code{\link{ld.f2}}, \code{\link{f1.ld.f1}}, \code{\link{f1.ld.f2}}, \code{\link{ld.ci}}, \code{\link{shoulder}}}

\examples{
## Example with the "Shoulder tip pain study" data ##
data(shoulder)
var<-c(shoulder[,"T1"],shoulder[,"T2"],shoulder[,"T3"],
shoulder[,"T4"],shoulder[,"T5"],shoulder[,"T6"])
time<-c(rep(1,41),rep(2,41),rep(3,41),rep(4,41),rep(5,41),rep(6,41))
group1<-rep(shoulder[,"Treat"],6)
group2<-rep(shoulder[,"Gender"],6)
subject<-rep(shoulder[,"Patient"],6)
ex.f2f1<-f2.ld.f1(var, time, group1, group2, subject, time.name = "Time", 
group1.name = "Treatment", group2.name = "Gender", description=FALSE)

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
\keyword{htest}
