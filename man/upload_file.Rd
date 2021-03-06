% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/upload_file.R
\name{upload_file}
\alias{upload_file}
\title{Upload a local file to Egnyte}
\usage{
upload_file(file, dest, token = get_parameter("token"),
  domain = get_parameter("domain"))
}
\arguments{
\item{file}{Path to a local file}

\item{dest}{The remote Egnyte file path you want to upload to}

\item{token}{User's Egnyter authorisation token}

\item{domain}{Egnyte domain URL}
}
\description{
This function uploads a local file directly to a specified remote Egnyte directory. This function can
be used to upload a local file of any kind directly to Egnyte. It can also be used to implement additional helper
functions e.g. \code{\link{upload_csv}} for specific file type uploads.
}
