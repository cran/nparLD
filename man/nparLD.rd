\name{nparLD}
\alias{nparLD}
\alias{nparLD-package}
\title{Nonparametric Tests for Repeated Measures Data in Factorial Designs}
\description{
This function performs several nonparametric tests for the relative treatment effects with global alternatives for repeated measures data in various factorial designs (see Details for the designs). For such data, the Wald-type statistic (WTS) and the ANOVA-type statistic (ATS) are calculated (see On the Test Statistics for details of the test staistics). The methods are available for the LD-F1, LD-F2, F1-LD-F1, F1-LD-F2, and F2-LD-F1 designs.
}

\usage{
nparLD(formula, data=NULL, subject, description=TRUE,
time1.order=NULL, time2.order=NULL, group1.order=NULL, group2.order=NULL,
plot.CI=FALSE, alpha=0.05, show.covariance=FALSE, order.warning=TRUE)
}

\arguments{
  \item{formula}{a model \code{\link[stats]{formula}} object. The left hand side contains the response variable, and the right hand side contains the whole-plot and sub-plot factor variables. The whole-plot and sub-plot factor variables are automatically detected according to the \code{subject} variable.}
  \item{data}{a data.frame, list or environment (or object coercible by \code{\link[base]{as.data.frame}} to a data.frame), containing the variables in formula. Neither a matrix nor an array will be accepted; the default option is NULL.}
  \item{subject}{the column number in \code{data}, the column name in \code{data}, or a vector to specify individual subjects.}
  \item{description}{an indicator for whether a short description of the output should be shown; the default option is TRUE.}
  \item{time1.order}{a character or numeric vector specifying the order of the time1 levels; applicable to all designs.}
  \item{time2.order}{a character or numeric vector specifying the order of the time2 levels; applicable to the LD-F2 and F1-LD-F2 designs.}
  \item{group1.order}{a character or numeric vector specifying the order of the group1 levels; applicable to the F1-LD-F1 and F1-LD-F2 designs.}
  \item{group2.order}{a character or numeric vector specifying the order of the group2 levels; applicable to the F2-LD-F1 design.}
  \item{plot.CI}{an indicator for whether a plot of the confidence interval (CI) for the relative treatment effect (RTE) should be shown; the default option is FALSE.}
  \item{alpha}{a numeric specifying the significance level of the confidence intervals; the default option is 0.05.}
  \item{show.covariance}{an indicator for whether the covariance matrix should be shown; the default option is FALSE, in which case, NULL is returned.}
  \item{order.warning}{an indicator for whether a short description of the warning regarding the ordering of factors should be shown; the default option is TRUE.}
}

\details{
The Fx-LD-Fy design refers to the experimental design with x whole-plot factor and y sub-plot factors. A whole-plot (between-subjects) factor refers to a factor effective for each subject at all times. A sub-plot (within-subjects) factor refers to a factor effective at a single time point for all time curves and all subjects. The LD-Fy design refers to the experimental design with no whole-plot factor. See Brunner et al. (2002) for more examples. Also see \code{\link{print}}, \code{\link{plot}}, and \code{\link{summary}} for summarized outputs.
}

\value{
An \code{nparLD} class object with the following components.
  \item{RTE}{
summary of the relative treatment effect (RTE) in a n-by-3 matrix form, where n is the total number of time1, time2, and group levels, and group-time interactions; the summary includes the mean of the ranks (RankMeans) in the 1st column, number of observations without counting the repeated measurements within the cell (Nobs) in the 2nd column, and the relative treatment effect (RTE) in the 3rd column.
}
  \item{Wald.test}{the test statistic, the degrees of freedom (df) of the central chi-squared distribution, and the corresponding p-value of the Wald-type test.}
  \item{ANOVA.test}{the test statistic, the numerator degrees of freedom (df) of the central F distribution, and the corresponding p-value of the ANOVA-type test; the denominator degrees of freedom is set to infinity.}
  \item{covariance}{the covariance matrix.}
  \item{Conf.Int}{the (pointwise) 100(1-alpha) percent confidence intervals. See \code{\link{ld.ci}} for details.}
  \item{\ldots}{Other function-specific outputs. For example, \code{ANOVA.test.mod.Box} which is applicable to designs with whole-plot factor(s).}
}

\section{On the Test Statistics}{

Although we provide both Wald-type statistic (WTS, see \code{Wald.test}) and ANOVA-type statistic with the denominator degrees of freedom set to infinity (ATS, see \code{ANOVA.test}), ATS is typically preferred to WTS as it requires less assumptions on the covariance matrix and it has superior small sample performances. Moreover, for the main effects and interactions involving only the whole-plot factors, the modified ANOVA-type statistic with Box (1954) approximation (\code{ANOVA.test.mod.Box}) is preferred to ATS. See Brunner et al. (2002) for more details.

}

\references{

Box, G.E.P. (1954). Some theorems on quadratic forms applied in the study of analysis of variance problems, I. Effect of inequality of variance in the one-way classification. \emph{Annals of Mathematical Statistics}, 25, 290-302.\cr

Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.\cr

Noguchi, K., Gel, Y.R., Brunner, E., and Konietschke, F. (2012). 
nparLD: An R Software Package for the Nonparametric Analysis of Longitudinal Data in Factorial Experiments. 
\emph{Journal of Statistical Software}, 50(12), 1-23.
}
\author{Kimihiro Noguchi, Karthinathan Thangavelu, Frank Konietschke, Yulia Gel, Edgar Brunner}

\seealso{\code{\link{ld.f1}}, \code{\link{ld.f2}}, \code{\link{f1.ld.f1}}, \code{\link{f1.ld.f2}}, \code{\link{f2.ld.f1}}, \code{\link{ld.ci}}, \code{\link{amylase}}, \code{\link{edema}}, \code{\link{shoulder}}, \code{\link{tree}}, \code{\link{panic}}, \code{\link{panic2}}, \code{\link{plasma}}, \code{\link{dental}}, \code{\link{rat}}, \code{\link{respiration}}, \code{\link{print}}, \code{\link{plot}}, \code{\link{summary}}}

\examples{

## Example with the "Panic disorder study I" data (LD-F1 design) ##
data(panic)
ex.f1.np<-nparLD(resp~time, data=panic, subject="subject", description=FALSE)
# LD F1 Model 
# ----------------------- 
# Check that the order of the time level is correct.
# Time level:   0 2 4 6 8 
# If the order is not correct, specify the correct order in time.order.

ex.f1.np$Wald.test
#     Statistic df    p-value
#time  126.6946  4 1.9822e-26

ex.f1.np$ANOVA.test
#     Statistic       df      p-value
#time  36.93664 2.234135 1.975781e-18

## Example with the "Alpha-amylase study" data (LD-F2 design) ##
data(amylase)
ex.f2.np<-nparLD(resp~time1*time2, data=amylase, subject="subject", description=FALSE)
# LD F2 Model 
# ----------------------- 
# Check that the order of the time1 and time2 levels are correct.
# Time1 level:   M T 
# Time2 level:   8 12 17 21 
# If the order is not correct, specify the correct order in time1.order or 
# time2.order.

ex.f2.np$Wald.test
#             Statistic df      p-value
#time1        0.6761043  1 4.109314e-01
#time2       35.8647640  3 7.997949e-08
#time1:time2 14.3020921  3 2.521503e-03

ex.f2.np$ANOVA.test
#             Statistic       df      p-value
#time1        0.6761043 1.000000 4.109314e-01
#time2       14.2671950 2.858344 5.860479e-09
#time1:time2  5.2242782 2.184249 4.150298e-03

## Example with the "Vitality of treetops" data (F1-LD-F1 design) ##
data(tree)
ex.f1f1.np<-nparLD(resp~time*group, data=tree, subject="subject", 
description=FALSE)
# F1 LD F1 Model 
# ----------------------- 
# Check that the order of the time and group levels are correct.
# Time level:   1 2 3 4 
# Group level:   D2 D0 D1 
# If the order is not correct, specify the correct order in time.order or 
# group.order.

ex.f1f1.np$Wald.test
#           Statistic df      p-value
#group       4.510037  2 1.048716e-01
#time       58.061097  3 1.525356e-12
#group:time 14.819966  6 2.170415e-02

ex.f1f1.np$ANOVA.test
#           Statistic       df      p-value
#group       2.352854 1.968147 9.601181e-02
#time       21.389142 2.729147 8.210954e-13
#group:time  3.113632 5.346834 6.768732e-03

ex.f1f1.np$ANOVA.test.mod.Box
#      Statistic      df1     df2   p-value
#group  2.352854 1.968147 64.3979 0.1040525

## Example with the "Postoperative edema" data (F1-LD-F2 design) ##
data(edema)
ex.f1f2.np<-nparLD(resp~group*time1*time2, data=edema, subject="subject", 
description=FALSE)
# F1 LD F2 Model 
# -----------------------  
# Check that the order of the time1, time2, and group levels are correct.
# Time1 level:   Healthy Operated 
# Time2 level:   -1 1 3 5 
# Group level:   Drug Placebo 
# If the order is not correct, specify the correct order in time1.order, 
# time2.order, or group.order.

ex.f1f2.np$Wald.test
#                   Statistic df      p-value
#group              1.0725762  1 3.003643e-01
#time1             25.8758257  1 3.641005e-07
#time2             36.8857947  3 4.864630e-08
#group:time1        0.3304448  1 5.653973e-01
#time2:time1       47.3460508  3 2.933702e-10
#group:time2        5.3048189  3 1.507900e-01
#group:time1:time2  1.6581652  3 6.462743e-01

ex.f1f2.np$ANOVA.test
#                   Statistic       df      p-value
#group              1.0725762 1.000000 3.003643e-01
#time1             25.8758257 1.000000 3.641005e-07
#time2             11.0630080 2.699667 9.661602e-07
#group:time1        0.3304448 1.000000 5.653973e-01
#time2:time1       15.1854889 2.630202 6.184646e-09
#group:time2        1.3342605 2.699667 2.625538e-01
#group:time1:time2  0.7170325 2.630202 5.242367e-01

## Example with the "Shoulder tip pain study" data (F2-LD-F1 design) ##
data(shoulder)
ex.f2f1.np<-nparLD(resp~time*group1*group2, data=shoulder, subject="subject", 
description=FALSE)
# F2 LD F1 Model 
# ----------------------- 
# Check that the order of the time, group1, and group2 levels are correct.
# Time level:   1 2 3 4 5 6 
# Group1 level:   Y N 
# Group2 level:   F M 
# If the order is not correct, specify the correct order in time.order, 
# group1.order, or group2.order.
#
#
# Warning(s):
# The covariance matrix is singular. 

ex.f2f1.np$Wald.test
#                     Statistic df      p-value
#group1             16.40129021  1 5.125033e-05
#group2              0.04628558  1 8.296575e-01
#time               16.34274332  5 5.930698e-03
#group1:group2       0.03583558  1 8.498554e-01
#group1:time        27.51450085  5 4.527996e-05
#group2:time        12.37903186  5 2.994753e-02
#group1:group2:time  5.11864769  5 4.015727e-01

ex.f2f1.np$ANOVA.test
#                     Statistic       df      p-value
#group1             16.40129021 1.000000 5.125033e-05
#group2              0.04628558 1.000000 8.296575e-01
#time                3.38218704 2.700754 2.120366e-02
#group1:group2       0.03583558 1.000000 8.498554e-01
#group1:time         3.71077200 2.700754 1.398190e-02
#group2:time         1.14434841 2.700754 3.272967e-01
#group1:group2:time  0.43755394 2.700754 7.054255e-01

ex.f2f1.np$ANOVA.test.mod.Box
#                Statistic df1      df2      p-value
#group1        16.40129021   1 21.86453 0.0005395379
#group2         0.04628558   1 21.86453 0.8316516274
#group1:group2  0.03583558   1 21.86453 0.8516017168
}
\keyword{htest}
