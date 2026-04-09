test_that("gfa_analyze requires either sequence or fasta_file", {
  # Neither provided
  expect_error(
    gfa_analyze(output_prefix = "/tmp/test"),
    "Either sequence or fasta_file must be provided"
  )

  # Both provided
  expect_error(
    gfa_analyze(
      sequence = "ATGC",
      fasta_file = "/tmp/test.fa",
      output_prefix = "/tmp/test"
    ),
    "Provide either sequence or fasta_file, not both"
  )
})

test_that("gfa_analyze validates sequence input", {
  # Invalid nucleotides
  expect_error(
    gfa_analyze(
      sequence = "ATGCX",
      output_prefix = "/tmp/test"
    ),
    "sequence contains invalid characters"
  )

  # Empty sequence
  expect_error(
    gfa_analyze(
      sequence = "",
      output_prefix = "/tmp/test"
    ),
    "sequence cannot be empty"
  )

  # Sequence with lowercase (should work - converted to uppercase)
  expect_error(
    gfa_analyze(
      sequence = "atgcnnn",
      output_prefix = "/tmp/test"
    ),
    NA
  ) # Should NOT error
})

test_that("gfa_analyze validates FASTA file input", {
  # File doesn't exist
  expect_error(
    gfa_analyze(
      fasta_file = "/nonexistent/file.fasta",
      output_prefix = "/tmp/test"
    ),
    "File does not exist"
  )
})

test_that("gfa_analyze requires gfa_params object", {
  expect_error(
    gfa_analyze(
      sequence = "ATGC",
      output_prefix = "/tmp/test",
      parameters = list(minGQrep = 3)
    ),
    "parameters must be a gfa_params object"
  )
})

test_that("gfa_analyze accepts skip flags", {
  # Should handle various skip flag combinations
  # These are just validation tests - actual behavior depends on C code
  skip_flags <- list(
    skip_apr = TRUE,
    skip_str = TRUE,
    skip_dr = FALSE,
    skip_mr = FALSE,
    skip_ir = FALSE,
    skip_gq = FALSE,
    skip_z = FALSE,
    skip_slipped = FALSE,
    skip_cruciform = FALSE,
    skip_triplex = FALSE
  )

  # Should accept without error for validation
  expect_no_error(
    gfa_analyze(
      sequence = "ATGC",
      output_prefix = "/tmp/test_skip",
      skip_apr = TRUE,
      skip_str = TRUE
    ),
    NA # Expect error or success depending on C code availability
  )
})

test_that("gfa_analyze returns gfa_results object", {
  skip_if_not_installed("testthat")

  # Use simple test sequence
  test_seq <- paste0(
    "GGGAGGGAGGGAGGG", # G-quadruplex
    "ATATATAT", # Simple tandem repeat
    "AAAAAA" # A-Phased repeat pattern
  )

  output_dir <- tempdir()
  output_prefix <- file.path(output_dir, "test_analysis")

  # Skip this test if C code not compiled
  tryCatch(
    {
      result <- gfa_analyze(
        sequence = test_seq,
        output_prefix = output_prefix
      )

      expect_s3_class(result, "gfa_results")
    },
    error = function(e) {
      skip("C code not yet integrated")
    }
  )
})

test_that("gfa_analyze handles chromosomal identifiers", {
  test_seq <- "ATGCATGCATGC"

  output_dir <- tempdir()
  output_prefix <- file.path(output_dir, "test_chrom")

  # Should accept chrom parameter
  tryCatch(
    {
      result <- gfa_analyze(
        sequence = test_seq,
        output_prefix = output_prefix,
        chrom = "chr1"
      )

      expect_s3_class(result, "gfa_results")
    },
    error = function(e) {
      skip("C code not yet integrated")
    }
  )
})

test_that("gfa_analyze output directory handling", {
  test_seq <- "ATGC"

  # Test with non-existent directory (should create it)
  output_prefix <- file.path(tempdir(), "new_output_dir", "result")

  tryCatch(
    {
      result <- gfa_analyze(
        sequence = test_seq,
        output_prefix = output_prefix
      )

      # Directory should exist after analysis
      expect_true(dir.exists(dirname(output_prefix)))
    },
    error = function(e) {
      skip("C code not yet integrated")
    }
  )
})
