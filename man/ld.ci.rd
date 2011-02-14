\name{ld.ci}
\alias{ld.ci}
\title{Confidence Intervals for the Relative Treatment Effects}
\description{
This function performs calculations of the two-sided confidence intervals for the relative treatment effects of the factors specified. The function performs calculations only if no observations are missing.
}

\usage{
ld.ci(var, time, subject, group=NULL, alpha=0.05, time.name="Time", 
group.name="Group", description=TRUE, time.order=NULL, group.order=NULL,
rounds=4, plot.CI = TRUE)
}

\arguments{
  \item{var}{a vector of numeric variable of interest.}
  \item{time}{a vector of the sub-plot factor variable. See Details for more explanation.}
  \item{subject}{a vector of individual subjects.}
  \item{group}{a vector of the whole-plot factor variable; the default option is NULL. See Details for more explanation.}
  \item{alpha}{a numeric specifying the significance level of the confidence intervals; the default option is 0.05.}
  \item{time.name}{a vector of the sub-plot factor variable.}
  \item{group.name}{a vector of the whole-plot factor variable.}
  \item{description}{an indicator for whether a short description of the output should be shown; the default option is TRUE.}
  \item{time.order}{a character or numeric vector specifying the order of the time levels; the default option is NULL, in which case, the levels are in the order of the original data.}
  \item{group.order}{a character or numeric vector specifying the order of the group levels; the default option is NULL, in which case, the levels are in the order of the original data.}
  \item{rounds}{a numeric specifying the number of digits to be displayed.}
  \item{plot.CI}{an indicator for whether a plot of the confidence interval (CI) should be shown; the default option is TRUE.}
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
# The order may be specified in time.order or group.order.

## Summary of the output
ex.ci$summary

#     Group Time Nobs RankMeans    RTE    Bias Variance  Lower  Upper
#1  GroupYF    1   14  123.9643 0.5019  0.0008   0.1680 0.3792 0.6243
#2  GroupYF    2   14  100.2857 0.4056  0.0003   0.1366 0.3000 0.5222
#3  GroupYF    3   14   89.2500 0.3608 -0.0005   0.0979 0.2722 0.4615
#4  GroupYF    4   14  101.4643 0.4104  0.0000   0.1136 0.3131 0.5164
#5  GroupYF    5   14   72.1071 0.2911 -0.0004   0.0389 0.2351 0.3554
#6  GroupYF    6   14   84.3214 0.3407 -0.0002   0.0808 0.2605 0.4329
#7  GroupYM    1    8  107.4375 0.4347 -0.0002   0.3093 0.2786 0.6060
#8  GroupYM    2    8  113.4375 0.4591  0.0002   0.2607 0.3120 0.6142
#9  GroupYM    3    8   87.3750 0.3532  0.0001   0.1464 0.2471 0.4774
#10 GroupYM    4    8   76.6875 0.3097  0.0002   0.0873 0.2277 0.4070
#11 GroupYM    5    8   92.0625 0.3722 -0.0001   0.2011 0.2487 0.5167
#12 GroupYM    6    8   92.0625 0.3722 -0.0001   0.2011 0.2487 0.5167
#13 GroupNF    1   11  154.3636 0.6255  0.0004   0.2954 0.4500 0.7708
#14 GroupNF    2   11  174.3636 0.7068  0.0007   0.1890 0.5573 0.8188
#15 GroupNF    3   11  162.4545 0.6584 -0.0001   0.1941 0.5130 0.7768
#16 GroupNF    4   11  182.2273 0.7387  0.0007   0.1704 0.5926 0.8425
#17 GroupNF    5   11  146.8182 0.5948  0.0001   0.2383 0.4408 0.7307
#18 GroupNF    6   11  133.5000 0.5407 -0.0018   0.1531 0.4208 0.6555
#19 GroupNM    1    8  126.7500 0.5132 -0.0005   0.3339 0.3422 0.6810
#20 GroupNM    2    8  168.6250 0.6834  0.0005   0.2855 0.5021 0.8196
#21 GroupNM    3    8  176.5000 0.7154  0.0016   0.3400 0.5090 0.8555
#22 GroupNM    4    8  172.5625 0.6994  0.0013   0.3102 0.5066 0.8376
#23 GroupNM    5    8  150.0000 0.6077 -0.0003   0.3585 0.4175 0.7683
#24 GroupNM    6    8  122.8125 0.4972 -0.0025   0.2469 0.3502 0.6447
}
\keyword{htest}
