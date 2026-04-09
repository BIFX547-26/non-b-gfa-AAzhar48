#' GFA Parameter Configuration
#'
#' Create a parameter object for configuring non-B DNA motif detection.
#' All parameters have sensible defaults matching the original GFA algorithm.
#'
#' @param minGQrep Minimum number of consecutive G's to form a G run. Default: 3
#' @param maxGQspacer Maximum allowed distance between G runs (min 1). Default: 7
#' @param minMRrep Minimum length of half of a mirror repeat. Default: 10
#' @param maxMRspacer Maximum distance between mirror repeat halves (min 0). Default: 100
#' @param minIRrep Minimum length of half of an inverted repeat. Default: 6
#' @param maxIRspacer Maximum distance between inverted repeat halves (min 0). Default: 100
#' @param shortIRcut Maximum length of short inverted repeat half. Default: 9
#' @param shortIRspacer Maximum distance between short inverted repeat halves (min 0). Default: 4
#' @param minDRrep Minimum length of direct repeat half. Default: 10
#' @param maxDRrep Maximum length of direct repeat half. Default: 300
#' @param maxDRspacer Maximum distance between direct repeat halves (min 0). Default: 100
#' @param minATracts Minimum number of consecutive A tracts. Default: 3
#' @param minATractSep Minimum separation between A tract centers. Default: 10
#' @param maxATractSep Maximum separation between A tract centers. Default: 11
#' @param maxAPRlen Maximum consecutive A's in an A tract. Default: 9
#' @param minAPRlen Minimum consecutive A's in an A tract. Default: 3
#' @param minZlen Minimum length of Z-DNA alternating purine/pyrimidine run. Default: 10
#' @param minSTR Minimum length of repeating element in short tandem repeats. Default: 1
#' @param maxSTR Maximum length of repeating element in short tandem repeats. Default: 9
#' @param minSTRbp Minimum overall length for qualification as STR. Default: 8
#' @param minCruciformRep Minimum repeat length for IR to qualify as cruciform. Default: 6
#' @param maxCruciformSpacer Maximum spacer length for IR to qualify as cruciform. Default: 4
#' @param minTriplexYRpercent Minimum purine/pyrimidine percent for MR to qualify as triplex. Default: 10
#' @param maxTriplexSpacer Maximum spacer length for MR to qualify as triplex. Default: 8
#' @param maxSlippedSpacer Maximum spacer length for DR to qualify as slipped. Default: 0
#'
#' @return A list of class "gfa_params" containing all parameter settings.
#'
#' @details
#' The gfa_params function creates a parameter configuration object that controls
#' which non-B DNA motifs are detected and how sensitive the detection is.
#'
#' Default values match those used by the original GFA tool, available at
#' https://nonb-abcc.ncifcrf.gov/apps/site/default
#'
#' @examples
#' # Default parameters
#' params <- gfa_params()
#'
#' # Custom parameters - stricter G-quadruplex detection
#' params <- gfa_params(minGQrep = 4, maxGQspacer = 5)
#'
#' @export
gfa_params <- function(
    minGQrep = 3,
    maxGQspacer = 7,
    minMRrep = 10,
    maxMRspacer = 100,
    minIRrep = 6,
    maxIRspacer = 100,
    shortIRcut = 9,
    shortIRspacer = 4,
    minDRrep = 10,
    maxDRrep = 300,
    maxDRspacer = 100,
    minATracts = 3,
    minATractSep = 10,
    maxATractSep = 11,
    maxAPRlen = 9,
    minAPRlen = 3,
    minZlen = 10,
    minSTR = 1,
    maxSTR = 9,
    minSTRbp = 8,
    minCruciformRep = 6,
    maxCruciformSpacer = 4,
    minTriplexYRpercent = 10,
    maxTriplexSpacer = 8,
    maxSlippedSpacer = 0) {

  # Validate parameters
  .validate_params(
    minGQrep, maxGQspacer, minMRrep, maxMRspacer,
    minIRrep, maxIRspacer, shortIRcut, shortIRspacer,
    minDRrep, maxDRrep, maxDRspacer, minATracts,
    minATractSep, maxATractSep, maxAPRlen, minAPRlen,
    minZlen, minSTR, maxSTR, minSTRbp,
    minCruciformRep, maxCruciformSpacer,
    minTriplexYRpercent, maxTriplexSpacer, maxSlippedSpacer
  )

  params <- list(
    minGQrep = minGQrep,
    maxGQspacer = maxGQspacer,
    minMRrep = minMRrep,
    maxMRspacer = maxMRspacer,
    minIRrep = minIRrep,
    maxIRspacer = maxIRspacer,
    shortIRcut = shortIRcut,
    shortIRspacer = shortIRspacer,
    minDRrep = minDRrep,
    maxDRrep = maxDRrep,
    maxDRspacer = maxDRspacer,
    minATracts = minATracts,
    minATractSep = minATractSep,
    maxATractSep = maxATractSep,
    maxAPRlen = maxAPRlen,
    minAPRlen = minAPRlen,
    minZlen = minZlen,
    minSTR = minSTR,
    maxSTR = maxSTR,
    minSTRbp = minSTRbp,
    minCruciformRep = minCruciformRep,
    maxCruciformSpacer = maxCruciformSpacer,
    minTriplexYRpercent = minTriplexYRpercent,
    maxTriplexSpacer = maxTriplexSpacer,
    maxSlippedSpacer = maxSlippedSpacer
  )

  class(params) <- c("gfa_params", "list")
  params
}

#' @keywords internal
.validate_params <- function(
    minGQrep, maxGQspacer, minMRrep, maxMRspacer,
    minIRrep, maxIRspacer, shortIRcut, shortIRspacer,
    minDRrep, maxDRrep, maxDRspacer, minATracts,
    minATractSep, maxATractSep, maxAPRlen, minAPRlen,
    minZlen, minSTR, maxSTR, minSTRbp,
    minCruciformRep, maxCruciformSpacer,
    minTriplexYRpercent, maxTriplexSpacer, maxSlippedSpacer) {

  errors <- character()

  # G-quadruplex parameters
  if (minGQrep < 1) errors <- c(errors, "minGQrep must be >= 1")
  if (maxGQspacer < 0) errors <- c(errors, "maxGQspacer must be >= 0")

  # Mirror repeat parameters
  if (minMRrep < 1) errors <- c(errors, "minMRrep must be >= 1")
  if (maxMRspacer < 0) errors <- c(errors, "maxMRspacer must be >= 0")

  # Inverted repeat parameters
  if (minIRrep < 1) errors <- c(errors, "minIRrep must be >= 1")
  if (maxIRspacer < 0) errors <- c(errors, "maxIRspacer must be >= 0")
  if (shortIRcut < 1) errors <- c(errors, "shortIRcut must be >= 1")
  if (shortIRspacer < 0) errors <- c(errors, "shortIRspacer must be >= 0")

  # Direct repeat parameters
  if (minDRrep < 1) errors <- c(errors, "minDRrep must be >= 1")
  if (maxDRrep < minDRrep) errors <- c(errors, "maxDRrep must be >= minDRrep")
  if (maxDRspacer < 0) errors <- c(errors, "maxDRspacer must be >= 0")

  # A-tract parameters
  if (minATracts < 1) errors <- c(errors, "minATracts must be >= 1")
  if (minATractSep < 1) errors <- c(errors, "minATractSep must be >= 1")
  if (maxATractSep < minATractSep) errors <- c(errors, "maxATractSep must be >= minATractSep")
  if (maxAPRlen < 1) errors <- c(errors, "maxAPRlen must be >= 1")
  if (minAPRlen < 1) errors <- c(errors, "minAPRlen must be >= 1")
  if (minAPRlen > maxAPRlen) errors <- c(errors, "minAPRlen must be <= maxAPRlen")

  # Z-DNA parameters
  if (minZlen < 1) errors <- c(errors, "minZlen must be >= 1")

  # STR parameters
  if (minSTR < 1) errors <- c(errors, "minSTR must be >= 1")
  if (maxSTR < minSTR) errors <- c(errors, "maxSTR must be >= minSTR")
  if (minSTRbp < 1) errors <- c(errors, "minSTRbp must be >= 1")

  # Cruciform parameters
  if (minCruciformRep < 1) errors <- c(errors, "minCruciformRep must be >= 1")
  if (maxCruciformSpacer < 0) errors <- c(errors, "maxCruciformSpacer must be >= 0")

  # Triplex parameters
  if (minTriplexYRpercent < 0 || minTriplexYRpercent > 100) {
    errors <- c(errors, "minTriplexYRpercent must be between 0 and 100")
  }
  if (maxTriplexSpacer < 0) errors <- c(errors, "maxTriplexSpacer must be >= 0")

  # Slipped parameters
  if (maxSlippedSpacer < 0) errors <- c(errors, "maxSlippedSpacer must be >= 0")

  if (length(errors) > 0) {
    stop(paste("Parameter validation failed:", paste(errors, collapse = "; ")),
      call. = FALSE
    )
  }

  invisible(TRUE)
}

#' Print gfa_params object
#'
#' @param x A gfa_params object
#' @param ... Additional arguments passed to print
#'
#' @keywords internal
print.gfa_params <- function(x, ...) {
  cat("GFA Parameters:\n")
  cat("===============\n")
  for (name in names(x)) {
    cat(sprintf("  %25s = %s\n", name, x[[name]]))
  }
  invisible(x)
}
