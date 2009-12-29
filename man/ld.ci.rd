\name{ld.ci}
\alias{ld.ci}
\title{Confidence Intervals for the Relative Treatment Effects}
\description{
This function performs calculations of the two-sided confidence intervals for the relative treatment effects of the factors specified. The function performs calculations only if no observations are missing.
}

\usage{
ld.ci(var, time, subject, group=NULL, alpha=0.05, time.name="Time", 
group.name="Group", description=TRUE, time.order=NULL, group.order=NULL)
}

\arguments{
  \item{var}{a vector of numeric variable of interest.}
  \item{time}{a vector of the sub-plot factor variable. See Details for more explanation.}
  \item{subject}{a vector of individual subjects.}
  \item{group}{a vector of the whole-plot factor variable; the default option is NULL. See Details for more explanation.}
  \item{alpha}{the significance level of the confidence intervals; the default option is 0.05.}
  \item{time.name}{a vector of the sub-plot factor variable.}
  \item{group.name}{a vector of the whole-plot factor variable.}
  \item{description}{indicator for whether a short description of the output should be shown; the default option is TRUE.}
  \item{time.order}{a character or numeric vector specifying the order of the time levels; the default option is NULL, in which case, the levels are in the order of the original data.}
  \item{group.order}{a character or numeric vector specifying the order of the group levels; the default option is NULL, in which case, the levels are in the order of the original data.}
}

\details{
A whole-plot factor refers to a factor effective for each subject at all times. A sub-plot factor refers to a factor effective at a single time point for all time curves and all subjects. See Brunner et al. (2002) for more examples. Also, note that the interval for the relative treatment effects can only be interpreted as a confidence interval when the sample sample sizes are (approximately) the same (pp.60, Brunner et al., 2002).
}

\value{
A list with the following numeric components.

  \item{summary}{the relative treatment effect (RTE), bias estimation (Bias), variance estimation (Variance), as well as the lower and upper bound of the RTE (Lower bound, Upper bound, respectively), in the form of an n-by-8 matrix where n is the number of group factor levels times the number of time factor levels.}

}

\references{

Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.

}
\author{Kimihiro Noguchi, Karthinathan Thangavelu, Frank Konietschke, Yulia Gel, Edgar Brunner}

\seealso{\code{\link{ld.f1}}, \code{\link{ld.f2}}, \code{\link{f1.ld.f1}}, \code{\link{f1.ld.f2}}, \code{\link{f2.ld.f1}}, \code{\link{shoulder}}}
\examples{
## Example with the "Shoulder tip pain study" data ##
data(shoulder)
var<-c(shoulder[,"T1"],shoulder[,"T2"],shoulder[,"T3"],shoulder[,"T4"],
shoulder[,"T5"],shoulder[,"T6"])
time<-c(rep(1,41),rep(2,41),rep(3,41),rep(4,41),rep(5,41),rep(6,41))
subject<-rep(shoulder[,"Patient"],6)
group<-rep(paste(shoulder[,"Treat"],shoulder[,"Gender"],sep=""),6)
ex.ci<-ld.ci(var,time,subject,group=group,alpha=0.05, time.name="Time",
group.name="Group",description=FALSE, time.order=c(1,2,3,4,5,6), 
group.order=c("YF","YM","NF","NM"))
# Order of the time and group levels.
# Time level:   1 2 3 4 5 6 
# Group level:   YF YM NF NM 
# The order may be specified in time.order or group.order (does not affect the calculation).

## Summary of the output
ex.ci$summary

#        Time RankMeans Nobs       RTE          Bias   Variance Lower_bound Upper_bound
#GroupYF    1 123.96429   14 0.5018873  7.817386e-04 0.16799803   0.3791779   0.6243417
#GroupYF    2 100.28571   14 0.4056330  2.680247e-04 0.13660452   0.2999756   0.5221784
#GroupYF    3  89.25000   14 0.3607724 -4.802108e-04 0.09794961   0.2722481   0.4615337
#GroupYF    4 101.46429   14 0.4104239  1.116769e-05 0.11363906   0.3131013   0.5163647
#GroupYF    5  72.10714   14 0.2910859 -3.797016e-04 0.03888186   0.2351477   0.3554409
#GroupYF    6  84.32143   14 0.3407375 -2.010185e-04 0.08075188   0.2605495   0.4328717
#GroupYM    1 107.43750    8 0.4347053 -1.814750e-04 0.30930582   0.2786473   0.6059541
#GroupYM    2 113.43750    8 0.4590955  2.177700e-04 0.26074354   0.3119987   0.6142276
#GroupYM    3  87.37500    8 0.3531504  7.259001e-05 0.14644006   0.2471050   0.4774140
#GroupYM    4  76.68750    8 0.3097053  1.814750e-04 0.08732668   0.2277189   0.4070482
#GroupYM    5  92.06250    8 0.3722053 -1.451800e-04 0.20108702   0.2487034   0.5166544
#GroupYM    6  92.06250    8 0.3722053 -1.451800e-04 0.20108702   0.2487034   0.5166544
#GroupNF    1 154.36364   11 0.6254619  4.065041e-04 0.29536472   0.4499740   0.7708157
#GroupNF    2 174.36364   11 0.7067627  7.021434e-04 0.18898677   0.5573273   0.8188401
#GroupNF    3 162.45455   11 0.6583518 -1.108647e-04 0.19414002   0.5130420   0.7768149
#GroupNF    4 182.22727   11 0.7387288  6.836659e-04 0.17037687   0.5926421   0.8425176
#GroupNF    5 146.81818   11 0.5947894  9.238729e-05 0.23830019   0.4408203   0.7306618
#GroupNF    6 133.50000   11 0.5406504 -1.773836e-03 0.15310016   0.4208431   0.6555177
#GroupNM    1 126.75000    8 0.5132114 -5.444251e-04 0.33385938   0.3422031   0.6809777
#GroupNM    2 168.62500    8 0.6834350  4.718351e-04 0.28550592   0.5020507   0.8195959
#GroupNM    3 176.50000    8 0.7154472  1.560685e-03 0.33999653   0.5090255   0.8554739
#GroupNM    4 172.56250    8 0.6994411  1.306620e-03 0.31023269   0.5066492   0.8375506
#GroupNM    5 150.00000    8 0.6077236 -2.540650e-04 0.35845447   0.4175473   0.7683141
#GroupNM    6 122.81250    8 0.4972053 -2.540650e-03 0.24685893   0.3502014   0.6447272
}
\keyword{htest}
