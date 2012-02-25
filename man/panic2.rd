\name{panic2}
\alias{panic2}
\docType{data}
\title{Panic disorder study II}
\description{
Measurements of the degree of illness on a P&A scale for a group of patients suffering from panic disorder with or without agoraphobia.
}
\usage{data(panic2)}
\format{
Longitudinal data of 37 patients with P&A scores taken on 5 occasions.
}
\details{
A group of 37 patients with a panic disorder with/without agoraphobia was treated with anti-depressant imipramin over a period of eight weeks. The severity of the panic disorder was determined at five different occasions in increments of two weeks (0=baseline, 2=after two weeks, 4=after four weeks,...) using the new P&A scale (Bandelow, 1995, 1999), a discrete scale assigning to each patient a value between 0 and 52. Aim of this study was to determine whether a patient's improvement as measured by the P&A scale was different depending on whether or not the patient suffered from agoraphobia (w=with agoraphobia, wo=without agoraphobia).
}
\references{
Bandelow, B. (1995). Assessing the efficacy of treatments for panic disorder and agoraphobia, II. The Panic and Agoraphobia Scale. \emph{International Journal of Clinical Psychopharmacology} 10, 73 2.\cr

Bandelow, B. (1999). \emph{Panic and Agoraphobia Scale (PAS)}. Hogrefe & Huber, Goettingen.\cr

Brunner, E., Domhof, S., and Langer, F. (2002). \emph{Nonparametric Analysis of Longitudinal Data in Factorial Experiments},
Wiley, New York.\cr

Brunner, E. and Langer, F. (1999). \emph{Nichtparametrische Analyse longitudinaler Daten}, 
R. Oldenbourg Verlag, Munchen Wien.
}

\examples{
## Analysis using F1-LD-F1 design ##
data(panic2)
attach(panic2)
w.t<-c(1:5)
w.g<-c(1:2)
w.pat<-rbind(c(1:5), c(1:5))
ex.f1f1.2<-f1.ld.f1(y=resp, time=time, group=group, subject=subject, w.pat=w.pat, 
w.t=w.t, w.g=w.g, time.name="Week", group.name="Agoraphobia", description=FALSE)
# F1 LD F1 Model 
# ----------------------- 
# Check that the order of the time and group levels are correct.
# Time level:   0 2 4 6 8 
# Group level:   w wo 
# If the order is not correct, specify the correct order in time.order or 
# group.order.

## Wald-type statistic
ex.f1f1.2$Wald.test

#              	   Statistic df     p-value
#Agoraphobia        8.427367  1 3.696152e-03
#Week             119.793400  4 5.912722e-25
#Agoraphobia:Week  13.493440  4 9.100275e-03

## ANOVA-type statistic
ex.f1f1.2$ANOVA.test

#           	  Statistic       df     p-value
#Agoraphobia       8.427367 1.000000 3.696152e-03
#Week             32.089272 2.693506 7.109822e-19
#Agoraphobia:Week  1.751998 2.693506 1.599706e-01

## ANOVA-type statistic for the whole-plot factor
ex.f1f1.2$ANOVA.test.mod.Box

#            Statistic df1      df2     p-value
#Agoraphobia  8.427367   1 28.62587 0.007044246
}

\keyword{datasets}
