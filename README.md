# nonBgfa: Non-B DNA Motif Detection in R

<!-- badges -->
[![R-CMD-check](https://github.com/example/nonBgfa/workflows/R-CMD-check/badge.svg)](https://github.com/example/nonBgfa)
[![CRAN status](https://www.r-pkg.org/badges/version/nonBgfa)](https://CRAN.R-project.org/package=nonBgfa)

## Overview

**nonBgfa** is an R package that detects and analyzes non-B DNA-forming motifs in DNA sequences. Non-B DNA structures—including cruciforms (inverted repeats), triplexes (mirror repeats), slipped-strand structures (direct repeats), G-quadruplexes, A-phased repeats, short tandem repeats, and Z-DNA—have been implicated in DNA instability, mutagenesis, and genetic diseases including cancer.

This package wraps the mature [GFA (Gene Feature Analysis) suite](https://nonb-abcc.ncifcrf.gov/apps/site/default) developed at NCI-Frederick/Frederick National Lab, providing an easy-to-use R interface for analyzing DNA sequences.

## Features

- **7 motif types**: A-Phased Repeats (APR), Direct Repeats (DR), Inverted Repeats (IR), G-Quadruplexes (GQ), Mirror Repeats (MR), Short Tandem Repeats (STR), Z-DNA
- **Flexible input**: Analyze DNA sequences directly or load from FASTA files
- **Customizable parameters**: 25 tunable parameters with sensible defaults
- **Multiple output formats**: Results as R data frames (GFF and TSV formats)
- **Comprehensive validation**: Input sequence validation and output format checking
- **Skip options**: Selectively disable motif searches to save computation time

## Installation

Install from source (development version):

```r
# Install devtools if you don't have it
if (!require("devtools")) install.packages("devtools")

# Install nonBgfa from GitHub
devtools::install_github("example/nonBgfa")
```

System requirements: C99 compiler (gcc/clang)

## Quick Start

### Basic Analysis

Analyze a DNA sequence directly:

```r
library(nonBgfa)

# Simple sequence analysis
dna_seq <- "ACGTACGTACGTACGTACGTACGTACGTACGTACGT"
results <- gfa_analyze(dna_seq)

# View results summary
print(results)
```

### Analyze FASTA File

```r
# Analyze a FASTA file
results <- gfa_analyze("path/to/sequence.fasta")

# Access results as data frames
head(results$gq_gff)      # G-Quadruplex motifs (GFF format)
head(results$gq_tsv)      # G-Quadruplex motifs (TSV format with annotations)
head(results$ir_gff)      # Inverted Repeats (cruciforms)
```

### Customize Parameters

```r
# Create custom parameters
params <- gfa_params(
  minGQrep = 4,           # More stringent G-quadruplex detection
  minIRrep = 8,           # Longer minimum inverted repeat
  maxIRspacer = 50,       # Tighter spacer constraint
  skipDR = TRUE           # Skip direct repeat detection
)

# Analyze with custom parameters
results <- gfa_analyze("sequence.fasta", params = params)
```

### Skip Specific Motif Searches

```r
# Only analyze G-quadruplexes and Z-DNA
results <- gfa_analyze(
  "sequence.fasta",
  skip_apr = TRUE,
  skip_dr = TRUE,
  skip_ir = TRUE,
  skip_mr = TRUE,
  skip_str = TRUE
)
```

## Parameters Reference

Key parameters (see `?gfa_params` for complete list):

| Parameter | Default | Description |
|-----------|---------|-------------|
| `minGQrep` | 3 | Minimum consecutive G's in a G-run |
| `maxGQspacer` | 7 | Maximum distance between G-runs |
| `minIRrep` | 6 | Minimum half-length of inverted repeat |
| `maxIRspacer` | 100 | Maximum spacer between IR halves |
| `minDRrep` | 10 | Minimum half-length of direct repeat |
| `maxDRspacer` | 100 | Maximum spacer between DR halves |
| `minMRrep` | 10 | Minimum half-length of mirror repeat |
| `maxMRspacer` | 100 | Maximum spacer between MR halves |
| `minSTR` | 1 | Minimum repeat unit length (STR) |
| `maxSTR` | 9 | Maximum repeat unit length (STR) |
| `minZlen` | 10 | Minimum Z-DNA motif length |
| `minATracts` | 3 | Minimum A-tracts for APR |

## Output Format

Results are returned as a list of data frames:

```r
results <- gfa_analyze("sequence.fasta")

# Access individual motif results
results$apr_gff    # A-Phased Repeats (GFF format)
results$apr_tsv    # A-Phased Repeats (TSV format)
results$dr_gff     # Direct Repeats
results$dr_tsv
results$ir_gff     # Inverted Repeats (cruciforms)
results$ir_tsv
results$gq_gff     # G-Quadruplexes
results$gq_tsv
results$mr_gff     # Mirror Repeats (triplex)
results$mr_tsv
results$str_gff    # Short Tandem Repeats
results$str_tsv
results$z_gff      # Z-DNA
results$z_tsv
```

### GFF Format Columns
- `seqname`: Chromosome/sequence identifier
- `source`: Data source (GFA)
- `feature`: Motif type
- `start`: Start position (1-based)
- `end`: End position (inclusive)
- `score`: Detection score/confidence
- `strand`: DNA strand (+/-)
- `frame`: Reading frame
- `attributes`: Additional annotations (composition, runs, etc.)

### TSV Format Columns
Extended format with additional columns:
- All GFF columns plus:
- `islands`: Number of motif islands
- `runs`: Number of runs within island
- `max`: Maximum run length
- `composition`: Nucleotide breakdown
- `sequence`: Detected motif sequence

## Background: Non-B DNA Structures

### Why Non-B DNA Matters

Standard B-form DNA (Watson-Crick double helix) is the predominant DNA conformation. However, under specific conditions, DNA can adopt alternative secondary structures:

- **G-Quadruplexes (GQ)**: Four-stranded structures formed by G-rich sequences; common near telomeres and oncogene promoters
- **Inverted Repeats (IR) → Cruciforms**: Hairpin structures that can cause chromosomal rearrangements
- **Direct Repeats (DR) → Slipped-Strand**: Cause expansion/contraction via strand slippage
- **Mirror Repeats (MR) → Triplex**: Three-stranded DNA structures with unique stability
- **A-Phased Repeats (APR)**: Periodic A-tracts associated with DNA bending and nucleosome positioning
- **Short Tandem Repeats (STR)**: Microsatellites; highly variable in length and often used in forensics
- **Z-DNA**: Left-handed helical form; rare but found in regulatory regions

These structures play roles in:
- Gene regulation and transcription
- DNA replication and recombination
- Genomic instability and mutagenesis
- Disease mechanisms (fragile sites, expansions)

## Citation

If you use **nonBgfa** in your research, please cite both the original GFA paper and this R package:

**Original GFA Suite:**
> Non-B DB v2.0: a database of predicted non-B DNA-forming motifs and its associated tools.
> Cer RZ, Donohue DE, Mudunuri US, Temiz NA, Loss MA, Starner NJ, Halusa GN, Volfovsky N, Yi M, Luke BT, Bacolla A, Collins JR, Stephens RM.
> *Nucleic Acids Research.* 2013 Jan 1;41(D1):D94-D100.
> doi: [10.1093/nar/gks955](https://doi.org/10.1093/nar/gks955)

**Original Website:** https://nonb-abcc.ncifcrf.gov/apps/site/default

## Examples

See the package vignette for detailed workflows:

```r
vignette("getting-started", package = "nonBgfa")
```

## License

This R package is provided under the same license as the original GFA source code.

## Authors

**R Package:** Copilot (2025)  
**Original GFA Tool:** Duncan E. Donohue, Ph.D. (expansion of work by Jack R. Collins, Ph.D.), NCI-Frederick

## Development

This package wraps the established GFA C implementation, providing:
- Clean R interface to the underlying algorithms
- Comprehensive testthat test suite comparing outputs to original CLI
- Complete roxygen2 documentation
- Vignettes demonstrating common workflows

For issues, feature requests, or contributions, please see the package repository.
