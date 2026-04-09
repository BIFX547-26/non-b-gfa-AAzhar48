# Test setup and utilities
# Provides helper functions for loading test data and comparing outputs

# Path to test data directory
TEST_DATA_DIR <- system.file("tests", "testthat", "data", package = "nonBgfa")
BASELINE_DIR <- file.path(TEST_DATA_DIR, "baseline")

# Helper: Load a baseline GFF file
.load_baseline_gff <- function(motif_type) {
  file <- file.path(BASELINE_DIR, sprintf("gfa_baseline_%s.gff", motif_type))
  if (!file.exists(file)) {
    return(data.frame())
  }
  read.table(
    file,
    header = FALSE,
    sep = "\t",
    stringsAsFactors = FALSE,
    comment.char = "#"
  )
}

# Helper: Load a baseline TSV file
.load_baseline_tsv <- function(motif_type) {
  file <- file.path(BASELINE_DIR, sprintf("gfa_baseline_%s.tsv", motif_type))
  if (!file.exists(file)) {
    return(data.frame())
  }
  read.table(
    file,
    header = TRUE,
    sep = "\t",
    stringsAsFactors = FALSE
  )
}

# Helper: Get test FASTA file path
.get_test_fasta <- function() {
  file.path(TEST_DATA_DIR, "gfa_test.fasta")
}
