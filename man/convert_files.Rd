% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convert_files.R
\name{convert_files}
\alias{convert_files}
\title{Covert Files}
\usage{
convert_files(
  files,
  outpath = NULL,
  msconvert_args = c("peakPicking true 1-"),
  docker_args = c()
)
}
\arguments{
\item{files}{the absolute filepath vendor specific files to be converted}

\item{outpath}{an optional filepath where \code{.mzML} files will be saved to. If \code{NULL} then \code{.mzML} files are saved to the same location as input files.}

\item{msconvert_args}{a character vector of arguments to pass to \code{msconvert}.}

\item{docker_args}{additional arguments to pass to \verb{docker run}}
}
\description{
Convert vendor specific mass spectrometry files to the open \code{.mzML} format. This functions makes a \code{system} call to \code{docker} in order to convert files.
Conversion arguments should be supplied to the \code{args} parameter exactly as they would be for \code{msconvert} but omitting the \code{--filter} prefix.
}
\details{
For example to convert a file with vendor specific centroiding only;

\code{convert_files(rawFiles, outpath = NULL, args = 'peakPicking true 1-')}

To only retain positive mode data;

\code{convert_files(rawFiles, outpath = NULL, args = c('peakPicking true 1-', 'polarity positive'))}
}
