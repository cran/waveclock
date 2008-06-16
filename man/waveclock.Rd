\name{waveclock}
\alias{waveclock}
\title{
Reconstruction of the modal frequencies in a time series using continuous
wavelet transformation and the "crazy climbers" algorithm
}
\description{
This function can be used to reconstruct the modal frequencies in a time
series such as cycling cell luminescence data. First the continuous wavelet
transform is calculated using the (complex-valued) Morlet wavelet. Next,
the modal frequencies are identified from the time-frequency decomposition
using the "crazy climbers" algorithm from package \pkg{Rwave}.
}
\usage{
waveclock( x, period = c( 6, 48 ), time.limits = NULL, reflect = TRUE,
noctave = floor( log2( length( x ) ) ), nvoice = 96,
crc.args = list( seed = 0, nbclimb = 50 ),
cfamily.args = list( ptile = 0.005, bstep = 5, nbchain = 400 ),
crcrec.args = list( compr = 3, epsilon = 0, para = 3, plot = FALSE ),
xlab = "Time (h)", ylab = "Period (h)", jpg = NULL, ... )
}
\arguments{
\item{x}{
Input signal (possibly complex-valued)
}
\item{period}{
Range defining lower and upper period limits. The default values may be
useful for detecting circadian rhythmicity in data with time units measured
in hours
}
\item{time.limits}{
Time range for truncation of series
}
\item{reflect}{
Smooths end effects by reflecting data series at time limits
}
\item{noctave}{
Number of powers of 2 for the scale variable in the wavelet decomposition
}
\item{nvoice}{
Number of scales in each octave (i.e., between two consecutive powers of 2)
}
\item{crc.args}{
Arguments provided to "crazy climbers" function \code{\link[Rwave]{crc}}
}
\item{cfamily.args}{
Arguments provided to chaining function \code{\link[Rwave]{cfamily}}
}
\item{crcrec.args}{
Arguments provided to modal frequency reconstruction function \code{\link[Rwave]{crcrec}}
}
\item{xlab}{
x axis label for plot of continuous wavelet transform scalogram
}
\item{ylab}{
y axis label for plot of continuous wavelet transform scalogram
}
\item{jpg}{
Name of jpg filename for plot output. The default plots to the default device
}
\item{...}{
Additional parameters passed to \code{\link[graphics]{filled.contour}} plot function
}
}
\details{
\item{original.signal}{
Contains the original signal provided to the function.
}
\item{modified.signal}{
Contains the modified signal (after truncation and reflection) used in the analysis.
}
\item{cwt}{
Contains the (complex) values of the continuous wavelet transform of the
input signal. Since Morlet's wavelet is not strictly speaking a wavelet
(it is not of vanishing integral), artifacts may occur for certain signals.
}
\item{crc}{
Modal frequencies identified by "crazy climbers" algorithm
}
\item{cfamily}{
Output of procedure to remove short discontinuities in the modal frequencies
}
\item{modes}{
Matrix containing information about the modal frequencies.
The first column gives an index for the modal frequency
that corresponds to the row number in cfamily\$chain and the column number
in the reconstructed signal and mask.
The next three columns identify the median voice of the modal signal,
excluding the \emph{cone of influence} (region subject to edge effects).
Each voice corresponds to a range of periods: columns 2, 3, and 4 give
the midpoint, lower limit, and upper limit of periods under the median voice.
The next three columns summarize the period lengths of each mode by
averaging over time, again excluding the cone of influence. Columns 5, 6,
and 7 give the mean of the midpoints, lower limits, and upper limits.
The last column gives the variance of the reconstructed wave.
The rows correspond to the modes identified.
The final row gives the the statistics for all the modal frequencies
combined and can be useful when a single mode is split into segments,
as in the example.
}
\item{rec}{
Modal frequencies reconstructed as time series.
}
\item{mask}{
Voice numbers for the modal frequencies, or 0 within the cone of influence;
NA elsewhere.
}
}
\references{
"Practical Time-Frequency Analysis: Gabor and Wavelet Transforms with
an Implementation in S", by Rene Carmona, Wen L. Hwang and Bruno
Torresani, Academic Press, 1998.
\url{http://sgdp.iop.kcl.ac.uk/tprice/software.html}
}
\author{T.S.Price}
\seealso{
See \code{\link[Rwave]{cwt}} for the continuous wavelet transform,
\code{\link[Rwave]{crc}} and \code{\link[Rwave]{cfamily}} for the estimation of modal
frequencies from the continuous wavelet transform,
\code{\link[Rwave]{crcrec}} for the reconstruction of the modal frequencies, and
\code{\link{waveclock.auto}} to run \code{\link{waveclock}} in another
instance of R.
}
\examples{
set.seed( 0 )
freq <- 6 # data point every 10 minutes
T <- 24 * 5 * freq
t <- ( 0:T ) / freq

# models an initial 'spike' and slow background trend
spike <- 0.5 * dgamma( t / 24, 2, 10 )
trend <- 5 * poly( t, 2 ) %*% rnorm( 2 )
background <- spike + trend

# exponentially damped circadian signal with random phase
amplitude <- sqrt( 2 ) * exp( -t / ( 24 * 2 ) )
period <- 24
phase <- runif( 1 ) * 2 * pi
signal <- amplitude * sin( t / period * 2 * pi + phase )

# Gaussian noise
noise <- 0.15 * rnorm( T + 1 )

# simulated luminescence trace
trace <- ts( signal + background + noise, start = 0, freq = freq )
plot( trace )

# wavelet analysis
result <- waveclock( trace )
result$modes
reconstructed.trace <- ts( rowSums( result$rec, na.rm = TRUE ), start = 0, freq = freq )

# plot reconstructed wave
# code not run
##plot( trace )
##lines( reconstructed.trace, col = 2 )
##abline( h = 0, lty = 2, col = 2 )
}
\keyword{ts}
