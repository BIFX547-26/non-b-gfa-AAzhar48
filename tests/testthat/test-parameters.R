test_that("gfa_params creates object with correct defaults", {
  params <- gfa_params()

  # Check class
  expect_s3_class(params, "gfa_params")

  # Check all parameters are present
  expect_equal(length(params), 25)

  # Check specific defaults
  expect_equal(params$minGQrep, 3)
  expect_equal(params$maxGQspacer, 7)
  expect_equal(params$minMRrep, 10)
  expect_equal(params$maxMRspacer, 100)
  expect_equal(params$minIRrep, 6)
  expect_equal(params$maxIRspacer, 100)
  expect_equal(params$minDRrep, 10)
  expect_equal(params$maxDRrep, 300)
  expect_equal(params$minZlen, 10)
  expect_equal(params$minSTR, 1)
  expect_equal(params$maxSTR, 9)
  expect_equal(params$minATracts, 3)
})

test_that("gfa_params allows custom parameter values", {
  params <- gfa_params(
    minGQrep = 5,
    maxGQspacer = 10,
    minIRrep = 8
  )

  expect_equal(params$minGQrep, 5)
  expect_equal(params$maxGQspacer, 10)
  expect_equal(params$minIRrep, 8)

  # Others should retain defaults
  expect_equal(params$minMRrep, 10)
})

test_that("gfa_params can be printed", {
  params <- gfa_params()

  # Should not error
  expect_silent(print(params))

  # Check class of print output is still gfa_params
  expect_s3_class(params, "gfa_params")
})

test_that("gfa_params with all custom values", {
  params <- gfa_params(
    minGQrep = 2,
    maxGQspacer = 8,
    minMRrep = 12,
    maxMRspacer = 110,
    minIRrep = 7,
    maxIRspacer = 110,
    shortIRcut = 10,
    shortIRspacer = 5,
    minDRrep = 12,
    maxDRrep = 310,
    maxDRspacer = 110,
    minATracts = 4,
    minATractSep = 11,
    maxATractSep = 12,
    maxAPRlen = 10,
    minAPRlen = 4,
    minZlen = 11,
    minSTR = 2,
    maxSTR = 10,
    minSTRbp = 9,
    minCruciformRep = 7,
    maxCruciformSpacer = 5,
    minTriplexYRpercent = 11,
    maxTriplexSpacer = 9,
    maxSlippedSpacer = 1
  )

  expect_equal(params$minGQrep, 2)
  expect_equal(params$minMRrep, 12)
  expect_equal(params$maxSlippedSpacer, 1)
  expect_equal(length(params), 25)
})
