---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# fbar
[![Travis-CI Build Status](https://travis-ci.org/maxconway/fbar.svg?branch=master)](https://travis-ci.org/maxconway/fbar)
<!-- [![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/fbar)](https://cran.r-project.org/package=fbar) -->

`fbar` is a simple, easy to use Flux Balance Analysis package with a tidy data approach. Just `data_frames` and the occasional `list`, no new classes to learn. The focus is on simplicity and speed. Models are expected as a flat table, and results can be simply appended to the table. This makes this package very suitable for useage in pipelines with pre- and post- processing of models and results, so that it works well as a backbone for customized methods. Loading, parsing and evaluating a model takes around 0.1s, which, together with the straightforward data structures used, makes this library very suitable for large parameter sweeps.

## A Simple Example
This example calculates the fluxes for the model ecoli_core. Ecoli_core starts out as a data frame, and is returned as the same data frame, with fluxes appended.


```r
library(fbar)
data(ecoli_core)

try({ # this will fail if no appropriate solver is available.
  library(ROI.plugin.ecos)

  ecoli_core_with_flux <- find_fluxes_df(ecoli_core)
})
#> Warning: `as_data_frame()` is deprecated as of tibble 2.0.0.
#> Please use `as_tibble()` instead.
#> The signature and semantics have changed, see `?as_tibble`.
#> This warning is displayed once every 8 hours.
#> Call `lifecycle::last_warnings()` to see where this warning was generated.
#> Warning: `data_frame()` is deprecated as of tibble 1.1.0.
#> Please use `tibble()` instead.
#> This warning is displayed once every 8 hours.
#> Call `lifecycle::last_warnings()` to see where this warning was generated.
```

## A Complicated Example
This example finds the fluxes in ecoli_core, just like the previous case. However, this has more detail to show how the package works.


```r
library(fbar)
library(dplyr)
library(ROI)
try(library(ROI.plugin.ecos))
data(ecoli_core)

roi_model <- ecoli_core %>%
  reactiontbl_to_expanded %>%
  expanded_to_ROI
  
# First, we need to check that an appropriate solver is available.
# If you don't have an appropriate solver, see the section on installing 
# one later in this document.
if(length(ROI_applicable_solvers(roi_model))>=1){
  roi_result <- ROI_solve(roi_model)
  
  ecoli_core_with_flux <- ecoli_core %>%
    mutate(flux = roi_result[['solution']])
}
```

This example expands the single data frame model into an intermediate form, the collapses it back to a gurobi model and evaluates it. Then it adds the result as a column, named flux. This longer style is useful because it allows access to the intermediate form. This just consists of three data frames: metabolites, stoichiometry, and reactions. This makes it easy to alter and combine models.

## Functions
`fbar`'s functions can be considered in three groups: convenience wrappers which perform a common workflow all in one go, parsing and conversion functions that form the core of the package and provide extensibility, and functions for gene set processing which allow models to be parameterized by genetic information.

#### Convenience wrappers
These functions wrap common workflows. They parse and evaluate models all in one go.

- `find_fluxes_df` - Given a metabolic model as a data frame, return a new data frame with fluxes. For simple FBA, this is what you want.
- `find_flux_varability_df` - Given a metabolic model as a data frame, return a new data frame with fluxes and variability.

#### Parsing and conversion
These functions convert metabolic models between different formats.

- `reactiontbl_to_expanded` - Convert a reaction table to an expanded, intermediate, format.
- `expanded_to_gurobi`, `expanded_to_glpk` and `expanded_to_ROI` - Convert a metabolic model in expanded format to the input format for a linear programming library.
- `reactiontbl_to_gurobi` - Convert a reaction table data frame to gurobi format. This is shorthand for `reactiontbl_to_expanded` followed by `expanded_to_gurobi`.

#### Gene set processing
These functions process gene protein reaction mappings.

- `gene_eval` - Evaluate gene sets in the context of particular gene presence levels.
- `gene_associate` - Apply gene presence levels to a metabolic model.


## Notes and FAQs

### Installation
#### Install this package:

```r
devtools::install_github('maxconway/fbar')
```

#### Install an additional linear programming solver (optional):
This package requires a linear programming solver. `ROI.plugin.ecos` is installed by default, and does the job, but other solvers, such as Gurobi and GLPK are faster. Anything that is supported by the R Optimization Infrastructure package should work.


### Comparison with other packages
The most famous package for constraint based methods is probably COBRA, a Matlab package. If you prefer Matlab to R, you'll probably want to try that before `fbar`.

The existing R packages for Flux Balance Analysis include `sybil` and `abcdeFBA`. Compared to these packages, `fbar` is smaller and does less. The aim of `fbar` is to be more suitable for use as a building block in bioinformatics pipelines. Whereas `sybil` and to a lesser extent `abcdeFBA` intend to act as tools with a function for each analysis you might want to do, `fbar` intends to supply just enough functionality that you can easily construct your analysis with only standard data frame operations.


### Linear programming solvers
`fbar` uses [ROI](https://CRAN.R-project.org/package=ROI) by default, which gives access to a number of solvers via plugins. It also supports Rglpk and Gurobi directly. [Gurobi](http://www.gurobi.com) is substantially faster than other solvers in my experience, so it is recommended if you can get it (it is commercial, but has a free academic licence).

### Bugs and feature requests
If you find problems with the package, or there's anything that it doesn't do which you think it should, please submit them to https://github.com/maxconway/fbar/issues. In particular, let me know about optimizers and formats which you'd like supported, or if you have a workflow which might make sense for inclusion as a default convenience function.

