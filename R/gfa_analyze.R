#' Analyze DNA Sequence for Non-B DNA-Forming Motifs
#'
#' Detect non-B DNA structures in DNA sequences. Identifies sequences associated
#' with non-B DNA-forming motifs including A-Phased Repeats (bent DNA),
#' Direct Repeats (slipped DNA), Inverted Repeats (cruciform DNA),
#' G-Quadruplexes, Z-DNA, Short Tandem Repeats, and Mirror Repeats (triplex DNA).
#'
#' @param sequence A character string or DNAString containing the DNA sequence to analyze.
#'   Sequence should contain only A, T, G, C, N characters (case-insensitive).
#'   Maximum length: 300,000,000 bp
#' @param fasta_file Alternatively, path to a FASTA file containing DNA sequence(s).
#'   Either sequence or fasta_file must be provided.
#' @param output_prefix Path and prefix for output files. Output files will be named
#'   as output_prefix_MOTIF.gff and output_prefix_MOTIF.tsv for each motif type.
#' @param parameters A gfa_params object from [gfa_params()]. Default uses all default parameters.
#' @param skip_apr If TRUE, skip A-Phased Repeat (bent DNA) detection. Default: FALSE
#' @param skip_str If TRUE, skip Short Tandem Repeat detection. Default: FALSE
#' @param skip_dr If TRUE, skip Direct Repeat (slipped DNA) detection. Default: FALSE
#' @param skip_mr If TRUE, skip Mirror Repeat (triplex DNA) detection. Default: FALSE
#' @param skip_ir If TRUE, skip Inverted Repeat (cruciform DNA) detection. Default: FALSE
#' @param skip_gq If TRUE, skip G-Quadruplex detection. Default: FALSE
#' @param skip_z If TRUE, skip Z-DNA detection. Default: FALSE
#' @param skip_slipped If TRUE, skip slipped subset identification. Default: FALSE
#' @param skip_cruciform If TRUE, skip cruciform subset identification. Default: FALSE
#' @param skip_triplex If TRUE, skip triplex subset identification. Default: FALSE
#' @param chrom Chromosome identifier to use in output. If not provided,
#'   the first word of FASTA header is used. Default: NULL
#'
#' @return A list of class "gfa_results" containing:
#'   \describe{
#'     \item{apr}{Data frame with A-Phased Repeat results (GFF and TSV)}
#'     \item{dr}{Data frame with Direct Repeat results}
#'     \item{ir}{Data frame with Inverted Repeat results}
#'     \item{gq}{Data frame with G-Quadruplex results}
#'     \item{str}{Data frame with Short Tandem Repeat results}
#'     \item{z_dna}{Data frame with Z-DNA results}
#'     \item{mr}{Data frame with Mirror Repeat results}
#'     \item{summary}{Summary statistics for each motif type}
#'     \item{files_written}{Character vector of output files created}
#'   }
#'
#' @details
#' Non-B DNA structures may play a role in DNA instability and mutagenesis,
#' leading to DNA rearrangements and increased mutational rates, which are
#' hallmarks of cancer. This function detects these motifs using algorithms
#' from the Genomic Feature Analyzer (GFA) tool.
#'
#' The analysis can be customized using the `parameters` argument and individual
#' skip flags. Detection parameters have sensible defaults based on the original
#' GFA publication.
#'
#' Results are returned both as data frames and written to output files in
#' GFF (Gene Feature Format) and TSV (Tab-Separated Values) formats.
#'
#' @references
#' Non-B DB v2.0: a database of predicted non-B DNA-forming motifs and its
#' associated tools.
#' Regina Z. Cer, Duncan E. Donohue, Uma S. Mudunuri, Nuri A. Temiz,
#' Michael A. Loss, Nathan J. Starner, Goran N. Halusa, Natalia Volfovsky,
#' Ming Yi, Brian T. Luke, Albino Bacolla, Jack R. Collins and Robert M. Stephens.
#' Nucl. Acids Res. (2013) 41 (D1): D94-D100.
#'
#' Website: https://nonb-abcc.ncifcrf.gov/apps/site/default
#'
#' @examples
#' \dontrun{
#' # Simple example with a small sequence
#' seq <- "AAAAAAAATATATATATGGGGGGGCCCCCCC"
#' result <- gfa_analyze(sequence = seq, output_prefix = "./gfa_test")
#'
#' # Use FASTA file with custom parameters
#' params <- gfa_params(minGQrep = 4, maxGQspacer = 5)
#' result <- gfa_analyze(
#'   fasta_file = "my_sequence.fasta",
#'   output_prefix = "./output/my_analysis",
#'   parameters = params
#' )
#'
#' # Skip certain motif types
#' result <- gfa_analyze(
#'   fasta_file = "my_sequence.fasta",
#'   output_prefix = "./output/gq_only",
#'   skip_apr = TRUE,
#'   skip_dr = TRUE,
#'   skip_ir = TRUE,
#'   skip_str = TRUE,
#'   skip_z = TRUE,
#'   skip_mr = TRUE
#' )
#' }
#'
#' @export
gfa_analyze <- function(
    sequence = NULL,
    fasta_file = NULL,
    output_prefix,
    parameters = gfa_params(),
    skip_apr = FALSE,
    skip_str = FALSE,
    skip_dr = FALSE,
    skip_mr = FALSE,
    skip_ir = FALSE,
    skip_gq = FALSE,
    skip_z = FALSE,
    skip_slipped = FALSE,
    skip_cruciform = FALSE,
    skip_triplex = FALSE,
    chrom = NULL) {

  # Validate inputs
  if (is.null(sequence) && is.null(fasta_file)) {
    stop("Either sequence or fasta_file must be provided", call. = FALSE)
  }

  if (!is.null(sequence) && !is.null(fasta_file)) {
    stop("Provide either sequence or fasta_file, not both", call. = FALSE)
  }

  # Validate parameters
  if (!inherits(parameters, "gfa_params")) {
    stop("parameters must be a gfa_params object from gfa_params()",
      call. = FALSE
    )
  }

  # Validate output path
  .validate_output_path(output_prefix)

  # Load sequence
  if (!is.null(sequence)) {
    .validate_sequence(sequence)
    dna <- toupper(sequence)
  } else {
    .validate_fasta_file(fasta_file)
    dna <- .read_fasta_sequence(fasta_file)
  }

  # Call C function
  result <- .Call(
    "gfa_main",
    dna = dna,
    output_prefix = output_prefix,
    params = parameters,
    skip_flags = list(
      apr = skip_apr,
      str = skip_str,
      dr = skip_dr,
      mr = skip_mr,
      ir = skip_ir,
      gq = skip_gq,
      z = skip_z,
      slipped = skip_slipped,
      cruciform = skip_cruciform,
      triplex = skip_triplex
    ),
    chrom = chrom,
    PACKAGE = "nonBgfa"
  )

  # Read results from output files
  results <- .collect_results(output_prefix, result)

  class(results) <- c("gfa_results", "list")
  results
}

#' @keywords internal
.read_fasta_sequence <- function(fasta_file) {
  lines <- readLines(fasta_file)

  # Remove header and empty lines
  sequence_lines <- lines[!startsWith(lines, ">") & nchar(lines) > 0]

  # Concatenate all sequence lines
  sequence <- paste(sequence_lines, collapse = "")

  sequence
}

#' @keywords internal
.collect_results <- function(output_prefix, call_result) {
  motifs <- c("apr", "dr", "ir", "gq", "str", "z_dna", "mr")
  results <- list()

  # Read GFF and TSV files for each motif
  for (motif in motifs) {
    gff_file <- sprintf("%s_%s.gff", output_prefix, toupper(motif))
    tsv_file <- sprintf("%s_%s.tsv", output_prefix, toupper(motif))

    results[[motif]] <- list(
      gff = .read_gff_file(gff_file),
      tsv = .read_tsv_file(tsv_file)
    )
  }

  # Add summary
  results$summary <- .summarize_results(results)

  results
}

#' @keywords internal
.summarize_results <- function(results) {
  motifs <- c("apr", "dr", "ir", "gq", "str", "z_dna", "mr")
  summary_df <- data.frame(
    motif = character(),
    count = integer(),
    stringsAsFactors = FALSE
  )

  for (motif in motifs) {
    count <- nrow(results[[motif]]$gff)
    summary_df <- rbind(summary_df, data.frame(
      motif = toupper(motif),
      count = count
    ))
  }

  summary_df
}

#' Print gfa_results object
#'
#' @param x A gfa_results object from [gfa_analyze()]
#' @param ... Additional arguments passed to print
#'
#' @keywords internal
print.gfa_results <- function(x, ...) {
  cat("GFA Analysis Results\n")
  cat("====================\n\n")

  if (!is.null(x$summary)) {
    cat("Summary:\n")
    print(x$summary, ...)
    cat("\n")
  }

  invisible(x)
}
