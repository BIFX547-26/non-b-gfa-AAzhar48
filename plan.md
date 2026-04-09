# R Package Refactoring Plan: nonBgfa

## Overview
Transform the existing non-B GFA C application (a command-line tool for detecting non-B DNA-forming motifs) into a well-structured R package while maintaining the core C functionality.

### Key Design Decisions
- **Architecture**: R wrapper around existing C code (preserve C implementation via `.C()` interface)
- **Documentation**: CRAN-style with roxygen2 for high-quality documentation
- **API Level**: Expose high-level analysis functions (gfa_analyze) rather than all internal C functions
- **Testing**: Comprehensive R unit tests using testthat to validate behavior equivalence
- **Package Name**: nonBgfa

## Strategy
1. Set up R package structure with standard directories (R/, man/, tests/, vignettes/, src/)
2. Refactor C code for R compatibility (minimal C changes needed)
3. Create R wrapper functions with clear interfaces
4. Write comprehensive tests comparing new R output to old command-line output
5. Update and expand README for R users
6. Add pkgdown documentation site
7. Prepare for CRAN submission (if desired)

## Project Structure
```
nonBgfa/
├── R/                           # R functions
│   ├── gfa_analyze.R           # Main wrapper for gfa analysis
│   ├── parse_parameters.R      # Parameter validation & parsing
│   └── utils.R                 # Utility functions
├── src/                         # C/C++ source code
│   ├── *.c (existing files)    # Existing C implementations
│   └── Makevars                # Build configuration
├── tests/
│   └── testthat/               # Unit tests
│       ├── test-gfa_analyze.R
│       ├── test-parameters.R
│       └── test-equivalence.R  # Verify old vs new outputs match
├── man/                         # Generated roxygen2 documentation
├── data-raw/                    # Sample FASTA files for testing
├── vignettes/                   # Usage documentation (Quarto .qmd files)
├── README.md                    # Updated for R users
└── DESCRIPTION                 # Package metadata
```

## Todos

### Phase 1: Setup & Infrastructure
1. **setup-pkg-structure** - Create standard R package structure and DESCRIPTION file
2. **organize-c-code** - Move C files to src/, update Makevars for R build system
3. **create-makevars** - Configure src/Makevars for compilation with R's build tools

### Phase 2: R Wrapper Functions
4. **write-gfa-analyze** - Create main gfa_analyze() R function that wraps C code
5. **write-parameters** - Create parameter validation and default value handling
6. **write-utils** - Create utility functions (sequence validation, output parsing)
7. **add-roxygen-docs** - Add roxygen2 documentation to R functions

### Phase 3: Testing (High Priority)
8. **extract-test-data** - Extract and prepare test FASTA files from test_files.tar
9. **baseline-tests** - Run original gfa CLI to establish baseline outputs
10. **write-equivalence-tests** - Create tests verifying new R functions match old CLI output
11. **write-unit-tests** - Write additional unit tests for parameter validation, edge cases
12. **document-test-coverage** - Ensure all major code paths are tested

### Phase 4: Documentation
13. **update-readme** - Rewrite README for R users with installation, usage examples
14. **create-vignette** - Write introductory Quarto vignette (.qmd) showing typical workflows
15. **add-function-docs** - Ensure all exported functions have complete roxygen docs
16. **create-dataset-docs** - Document any included test datasets

### Phase 5: Verification & Refinement
17. **run-check** - Run R CMD check to identify issues
18. **fix-check-warnings** - Resolve any warnings or notes from R CMD check
19. **refine-api** - Simplify/improve API based on testing experience
20. **build-documentation-site** - Generate pkgdown site for online documentation

### Phase 6: Final Polish
21. **code-review** - Review code for consistency, style, performance
22. **cleanup-c-code** - Remove unused functions/variables from C code
23. **optimize-performance** - Profile and optimize if needed
24. **prepare-release** - Version bump, changelog, release notes

## Key Considerations

### C Code Integration
- Minimal changes to C code (keep algorithms intact)
- Add safety checks for parameter ranges
- Ensure memory cleanup for large inputs
- Test with various FASTA file sizes

### API Design
- Single main function: `gfa_analyze(sequence, output_prefix, parameters = gfa_params())`
- Parameter object approach: `gfa_params()` for setting non-default values
- Return R list with all results (GFF and TSV data as data frames)
- Clear error messages for invalid inputs

### Test Strategy
- Compare raw outputs from old CLI vs new R package
- Unit tests for each motif type (APR, DR, IR, GQ, STR, Z-DNA, MR)
- Edge case tests (empty sequences, ambiguous nucleotides, boundary conditions)
- Performance tests for large sequences
- Cross-platform testing if possible

### Documentation Priorities
1. README with installation & quick start
2. Roxygen docs for all exported functions
3. Getting started vignette
4. Parameter reference guide
5. Theory/background on non-B DNA motifs

## Notes
- Original codebase ~3,600 lines of C
- ~20 separate motif detection functions
- Robust command-line argument parsing (will simplify in R)
- Mature algorithm (published, tested)
- Good opportunity for validation testing
