% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parsing_and_conversion.R
\name{split_on_arrow}
\alias{split_on_arrow}
\title{Internal function: Splitting reaction equation into substrate and product}
\usage{
split_on_arrow(equations, regex_arrow = "<?[-=]+>")
}
\arguments{
\item{equations}{Character vector of reaction equations.}

\item{regex_arrow}{Regular expression for the arrow splitting sides of the reaction equation.}
}
\value{
a \code{data_frame}, with columns: \describe{
  \item{reversible}{boolean, is reaction reversible}
  \item{before}{the left hand side of the reaction string}
  \item{after}{the right hand side of the reaction string}
}
}
\description{
Internal function: Splitting reaction equation into substrate and product
}
