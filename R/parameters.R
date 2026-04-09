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
.validate_params <- function(...) {
  # Placeholder for parameter validation
  # Can be expanded to check ranges and relationships
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
