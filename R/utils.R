#' Validate DNA Sequence
#'
#' Check that a DNA sequence contains only valid nucleotides (A, T, G, C, N)
#' and is not empty. Sequence can be in upper or lower case.
#'
#' @param sequence A character string or DNAString containing DNA sequence
#' @param max_length Maximum allowed sequence length. Default: 300,000,000
#'
#' @return Invisible TRUE if valid, raises error if not
#'
#' @keywords internal
.validate_sequence <- function(sequence, max_length = 300000000) {
  if (!is.character(sequence) && !inherits(sequence, "DNAString")) {
    stop("sequence must be a character string or DNAString", call. = FALSE)
  }

  seq_length <- nchar(sequence)

  if (seq_length == 0) {
    stop("sequence cannot be empty", call. = FALSE)
  }

  if (seq_length > max_length) {
    stop(sprintf(
      "sequence length (%d) exceeds maximum allowed (%d)",
      seq_length, max_length
    ), call. = FALSE)
  }

  # Check for valid nucleotides (convert to upper case first)
  seq_upper <- toupper(sequence)
  if (!grepl("^[ATGCN]+$", seq_upper)) {
    stop("sequence contains invalid characters. Only A, T, G, C, N allowed",
      call. = FALSE
    )
  }

  invisible(TRUE)
}

#' Validate FASTA File
#'
#' Check that a file exists, is readable, and appears to be valid FASTA format
#'
#' @param fasta_file Path to FASTA file
#'
#' @return Invisible TRUE if valid, raises error if not
#'
#' @keywords internal
.validate_fasta_file <- function(fasta_file) {
  if (!is.character(fasta_file) || length(fasta_file) != 1) {
    stop("fasta_file must be a single file path", call. = FALSE)
  }

  if (!file.exists(fasta_file)) {
    stop(sprintf("File does not exist: %s", fasta_file), call. = FALSE)
  }

  if (!file.access(fasta_file, 4) == 0) {
    stop(sprintf("File is not readable: %s", fasta_file), call. = FALSE)
  }

  # Quick check that it looks like FASTA
  first_line <- readLines(fasta_file, n = 1)
  if (length(first_line) == 0 || !startsWith(first_line, ">")) {
    stop("FASTA file does not start with '>' character", call. = FALSE)
  }

  invisible(TRUE)
}

#' Validate Output Path
#'
#' Check that output directory is writable and create if needed
#'
#' @param output_prefix Path prefix for output files
#' @param create_dir If TRUE, create directory if it doesn't exist
#'
#' @return Invisible validated output_prefix
#'
#' @keywords internal
.validate_output_path <- function(output_prefix, create_dir = TRUE) {
  if (!is.character(output_prefix) || length(output_prefix) != 1) {
    stop("output_prefix must be a single path string", call. = FALSE)
  }

  output_dir <- dirname(output_prefix)

  if (output_dir == ".") {
    output_dir <- getwd()
  } else if (!dir.exists(output_dir)) {
    if (create_dir) {
      dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    } else {
      stop(sprintf("Output directory does not exist: %s", output_dir),
        call. = FALSE
      )
    }
  }

  if (!file.access(output_dir, 2) == 0) {
    stop(sprintf("Output directory is not writable: %s", output_dir),
      call. = FALSE
    )
  }

  invisible(output_prefix)
}

#' Read GFF File
#'
#' Read a GFA-generated GFF file and return as data frame
#'
#' @param gff_file Path to GFF file
#'
#' @return A data frame with GFF columns
#'
#' @keywords internal
.read_gff_file <- function(gff_file) {
  if (!file.exists(gff_file)) {
    return(data.frame())
  }

  tryCatch(
    {
      df <- read.table(
        gff_file,
        header = FALSE,
        sep = "\t",
        stringsAsFactors = FALSE,
        comment.char = "#"
      )
      colnames(df) <- c(
        "seqname", "source", "feature", "start", "end",
        "score", "strand", "frame", "attribute"
      )
      df
    },
    error = function(e) {
      warning(sprintf("Error reading GFF file %s: %s", gff_file, e$message))
      data.frame()
    }
  )
}

#' Read TSV File
#'
#' Read a GFA-generated TSV file and return as data frame
#'
#' @param tsv_file Path to TSV file
#'
#' @return A data frame with TSV data
#'
#' @keywords internal
.read_tsv_file <- function(tsv_file) {
  if (!file.exists(tsv_file)) {
    return(data.frame())
  }

  tryCatch(
    {
      read.table(
        tsv_file,
        header = TRUE,
        sep = "\t",
        stringsAsFactors = FALSE
      )
    },
    error = function(e) {
      warning(sprintf("Error reading TSV file %s: %s", tsv_file, e$message))
      data.frame()
    }
  )
}

#' Get File Basename for Motif Type
#'
#' Generate output filename for a given motif type
#'
#' @param output_prefix Base output path
#' @param motif_type Motif abbreviation (APR, DR, IR, GQ, STR, Z-DNA, MR)
#'
#' @return Character filename for the motif type
#'
#' @keywords internal
.get_motif_filename <- function(output_prefix, motif_type) {
  sprintf("%s_%s.gff", output_prefix, motif_type)
}
