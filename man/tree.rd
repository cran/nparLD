\name{tree}
\alias{tree}
\docType{data}
\title{Vitality of treetops}
\description{
Measurements of the vitality condition of the treetops on a grading scale from three experimental sites.
}
\usage{data(tree)}
\format{
Longitudinal data of 72 trees from three areas with the treetop vitality scores taken on 4 occasions.
}
\details{
In this study, the condition of the trees in all three experimental sites was evaluated by means of a crane constructed for the examination of the treetops. Each individual tree was identified (22 trees in the D0 area, 23 in the D2 area, and 27 in the D1 area) and categorized according to the vitality of the tree using a grading scale from 1 (vital) to 10 (dead). This determination of the vitality status was conducted each year from 1993 until 1996.
}
\references{
Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.
}

\examples{
## Analysis using F1-LD-F1 design ##
data(tree)
var<-c(tree[,"T1"],tree[,"T2"],tree[,"T3"],tree[,"T4"])
time<-c(rep(1,72),rep(2,72),rep(3,72),rep(4,72))
group<-rep(tree[,"Area"],4)
subject<-rep(tree[,"Tree"],4)
w.t<-c(1:4)
w.g<-c(1:3)
w.pat <- rbind(c(1:4), c(1:4), c(1:4))
ex.f1f1<-f1.ld.f1(var,time,group,subject,w.pat,w.t,w.g,
time.name="Year",group.name="Area",description=FALSE)
# Check that the order of the time and group levels are correct.
# Time level:   1 2 3 4 
# Group level:   D0 D2 D1 
# If the order is not correct, specify the correct order in time.order or group.order.

## Wald-type statistic 
ex.f1f1$Wald.test

#Area       4.510037  2 1.048716e-01
#Year      58.061097  3 1.525335e-12
#Area:Year 14.819966  6 2.170415e-02

## ANOVA-type statistic
ex.f1f1$ANOVA.test

#          Statistic       df      p-value
#Area       2.352854 1.968147 9.601181e-02
#Year      21.389142 2.729147 8.211209e-13
#Area:Year  3.113632 5.346834 6.768732e-03
}
\keyword{datasets}
