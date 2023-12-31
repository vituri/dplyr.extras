% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vec.R
\name{vec_mutate}
\alias{vec_mutate}
\title{Modify a vector with some function}
\usage{
vec_mutate(.x, .f = identity, .p = vec_all_true)
}
\arguments{
\item{.x}{A vector.}

\item{.f}{A function to apply in .x or a vector of the same length as .x.}

\item{.p}{A single predicate function or a logical vector of the same length as .x. Only those elements where .p evaluates to TRUE will be modified.}
}
\value{
The vector .x with possibly some entries modified by .f.
}
\description{
Modify a vector with some function
}
