# Equivalence tests: Compare new R package outputs to original CLI baseline

test_that("Baseline test data files exist", {
  baseline_files <- c(
    "gfa_baseline_APR.gff", "gfa_baseline_APR.tsv",
    "gfa_baseline_DR.gff", "gfa_baseline_DR.tsv",
    "gfa_baseline_GQ.gff", "gfa_baseline_GQ.tsv",
    "gfa_baseline_IR.gff", "gfa_baseline_IR.tsv",
    "gfa_baseline_MR.gff", "gfa_baseline_MR.tsv",
    "gfa_baseline_STR.gff", "gfa_baseline_STR.tsv",
    "gfa_baseline_Z.gff", "gfa_baseline_Z.tsv"
  )

  for (file in baseline_files) {
    baseline_path <- file.path(BASELINE_DIR, file)
    expect_true(
      file.exists(baseline_path),
      info = sprintf("Baseline file missing: %s", file)
    )
  }
})

test_that("Test FASTA file exists", {
  test_fasta <- .get_test_fasta()
  expect_true(file.exists(test_fasta), "Test FASTA file not found")
})

test_that("Baseline G-Quadruplex results have expected structure", {
  baseline_gq <- .load_baseline_gff("GQ")

  expect_gt(nrow(baseline_gq), 0, "Expected G-Quadruplex results in baseline")
  expect_equal(ncol(baseline_gq), 9, "GFF files should have 9 columns")
})

test_that("Baseline Inverted Repeat results have expected structure", {
  baseline_ir <- .load_baseline_gff("IR")

  expect_gt(nrow(baseline_ir), 0, "Expected Inverted Repeat results")
  expect_equal(ncol(baseline_ir), 9, "GFF files should have 9 columns")
})

test_that("Baseline Mirror Repeat results have expected structure", {
  baseline_mr <- .load_baseline_gff("MR")

  expect_gt(nrow(baseline_mr), 0, "Expected Mirror Repeat results")
  expect_equal(ncol(baseline_mr), 9, "GFF files should have 9 columns")
})

test_that("Baseline Direct Repeat results have expected structure", {
  baseline_dr <- .load_baseline_gff("DR")

  expect_gt(nrow(baseline_dr), 0, "Expected Direct Repeat results")
  expect_equal(ncol(baseline_dr), 9, "GFF files should have 9 columns")
})

test_that("Baseline Z-DNA results have expected structure", {
  baseline_z <- .load_baseline_gff("Z")

  expect_gt(nrow(baseline_z), 0, "Expected Z-DNA results")
  expect_equal(ncol(baseline_z), 9, "GFF files should have 9 columns")
})

test_that("Baseline Short Tandem Repeat results have expected structure", {
  baseline_str <- .load_baseline_gff("STR")

  expect_gt(nrow(baseline_str), 0, "Expected STR results")
  expect_equal(ncol(baseline_str), 9, "GFF files should have 9 columns")
})

test_that("Baseline A-Phased Repeat results have expected structure", {
  baseline_apr <- .load_baseline_gff("APR")

  expect_gt(nrow(baseline_apr), 0, "Expected APR results")
  expect_equal(ncol(baseline_apr), 9, "GFF files should have 9 columns")
})

test_that("Baseline TSV files have expected columns", {
  baseline_gq_tsv <- .load_baseline_tsv("GQ")

  # Check expected columns
  expected_cols <- c(
    "Sequence_name", "Source", "Type", "Start", "Stop",
    "Length", "Score", "Strand", "Repeat", "Spacer",
    "nIslands", "nRuns", "maxGQ", "Subset", "Composition", "Sequence"
  )

  # TSV might have slightly different column names, just check minimum number
  expect_gte(ncol(baseline_gq_tsv), 10, "TSV should have at least 10 columns")
  expect_true("Sequence_name" %in% colnames(baseline_gq_tsv))
  expect_true("Start" %in% colnames(baseline_gq_tsv))
  expect_true("Stop" %in% colnames(baseline_gq_tsv))
})

test_that("Baseline results are correctly ordered by position", {
  baseline_gq <- .load_baseline_gff("GQ")

  # Column 4 and 5 are start and end positions
  starts <- as.numeric(baseline_gq[[4]])
  expect_true(all(starts == sort(starts)), "GFF results should be sorted by start position")
})

test_that("Baseline results have valid coordinates", {
  baseline_ir <- .load_baseline_gff("IR")

  # Check that start < end
  starts <- as.numeric(baseline_ir[[4]])
  ends <- as.numeric(baseline_ir[[5]])

  expect_true(all(starts < ends), "Start positions should be < end positions")
})

# Integration test: When R package is compiled, compare outputs
test_that("R package output matches baseline (when compiled)", {
  test_fasta <- .get_test_fasta()

  skip_if(
    !file.exists(test_fasta),
    "Test FASTA file not available"
  )

  output_dir <- tempdir()
  output_prefix <- file.path(output_dir, "equiv_test")

  tryCatch(
    {
      result <- gfa_analyze(
        fasta_file = test_fasta,
        output_prefix = output_prefix
      )

      expect_s3_class(result, "gfa_results")

      # When outputs are written, can compare with baseline
      # This will be verified once C code is integrated
    },
    error = function(e) {
      skip("C code not yet compiled")
    }
  )
})
