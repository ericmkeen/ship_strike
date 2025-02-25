% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/outcome_chances.R
\name{outcome_chances}
\alias{outcome_chances}
\title{Chances of at least / no more than X interactions}
\usage{
outcome_chances(
  outcomes,
  collision_var = "collision2.2",
  mortality_var = "mortality2.2"
)
}
\arguments{
\item{outcomes}{A \code{data.frame} of results from the \code{shipstrike::gather_outcomes()} function.}

\item{collision_var}{desc}

\item{mortality_Var}{desc}
}
\value{
A named \code{list}.
}
\description{
This function predicts the chances of certain outcome severities.
}
