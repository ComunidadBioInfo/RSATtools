
<!-- README.md is generated from README.Rmd. Please edit that file -->

# RSATtools

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/ComunidadBioInfo/RSATtools.svg?branch=master)](https://travis-ci.org/ComunidadBioInfo/RSATtools)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Codecov test
coverage](https://codecov.io/gh/ComunidadBioInfo/RSATtools/branch/master/graphs/badge.svg)](https://codecov.io/gh/ComunidadBioInfo/RSATtools?branch=master)
[![BioC
status](http://www.bioconductor.org/shields/build/release/bioc/RSATtools.svg)](https://bioconductor.org/checkResults/release/bioc-LATEST/RSATtools)
<!-- badges: end -->

The goal of `RSATtools` is to provide an interface to the RSAT
collection of web services <http://embnet.ccg.unam.mx/rsat/> from R and
is integrated in the Bioconductor ecosystem. This package was created as
a collaboration by members of the [Community of Bioinformatics Software
Developers](https://comunidadbioinfo.github.io/) (CDSB in Spanish).

For more details, please check the [documentation
website](http://comunidadbioinfo.github.io/RSATtools) or the
Bioconductor package landing page
[here](https://bioconductor.org/packages/RSATtools).

## Installation

You can install the released version of `RSATtools` from
[Bioconductor](http://bioconductor.org/) with:

``` r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("RSATtools")

## Check that you have a valid Bioconductor installation
BiocManager::valid()
```

And the development version from [GitHub](https://github.com/) with:

``` r
BiocManager::install("ComunidadBioinfo/RSATtools")
```

## Example

This is a basic example which shows you how to use `RSATtools`. For more
details, please check the vignette.

``` r
library('RSATtools')

## Get 5 random protein sequences of length 100 in fasta format.
## Use number 300 as seed.
res <- RSAT(
    method = "random_seq",
    parameters = list(
        sequence_length = 100,
        repetition = 5,
        type = "protein",
        seed = 300,
        format = "fasta"
    )
)
cat(res)
#> >rand_1  random sequence 1/5; type: protein; length: 100
#> kdpmanhvvcyfrkitrtahhiyeshvilwefqlryietrrdpdfmhkchdetyywdvknlgnptafnvd
#> tdgkpnsflihccrwqhmrkayyctawidd
#> >rand_2  random sequence 2/5; type: protein; length: 100
#> lcptnaghqelcmtcvtrirnqraancqpgianhnecrywwntlmncdngpcppkkawmfyscgwvvqln
#> wwnnaqwqivtmfwlarimlkndkircdnp
#> >rand_3  random sequence 3/5; type: protein; length: 100
#> gvnemwhacwfvfgftgkegwhydkgrfceyfvahkcniftlgadamgaqyaryyiwrnyfqigneqrgf
#> ncrltlefiqgwyesyeaqpdqnvfhslem
#> >rand_4  random sequence 4/5; type: protein; length: 100
#> pnvamcraffirgggkvsivfgvcksmthftkimyctlepfqkiinfkfkenwalyphrgfmikwtcwgt
#> gnyevpdeqwtkrkngmvidyqaggcddkn
#> >rand_5  random sequence 5/5; type: protein; length: 100
#> lgqgllkeevtvcytklnkkgcptpdfftgmmwfikreaekkkvqkeqnqgpfgfamshdrraamfdaes
#> pirqphncyiewvmmgrmlvftwvqqrhve
```

# Citation

Below is the citation output from using `citation('RSATtools')` in R.
Please run this yourself to check for any updates on how to cite
**RSATtools**.

``` r
citation('RSATtools')
#> 
#> Chavez J, Alquicira-Hernandez J (2020). _RSATtools: an R package
#> interacting with the RSAT web services_. doi:
#> 10.18129/B9.bioc.RSATtools (URL:
#> https://doi.org/10.18129/B9.bioc.RSATtools),
#> https://github.com/comunidadbioinfo/RSATtools - R package version
#> 0.99.0, <URL: http://www.bioconductor.org/packages/RSATtools>.
#> 
#> Chavez J, Alquicira-Hernandez J (2020). "RSATtools: an R package
#> interacting with the RSAT web services." _bioRxiv_. doi: 10.1101/xxxyyy
#> (URL: https://doi.org/10.1101/xxxyyy), <URL:
#> https://doi.org/10.1101/xxxyyy>.
#> 
#> To see these entries in BibTeX format, use 'print(<citation>,
#> bibtex=TRUE)', 'toBibtex(.)', or set
#> 'options(citation.bibtex.max=999)'.
```

# Development tools

  - Testing on Bioc-devel is possible thanks to [R
    Travis](http://docs.travis-ci.com/user/languages/r/).
  - Code coverage assessment is possible thanks to
    [codecov](https://codecov.io/gh).
  - The [documentation
    website](http://comunidadbioinfo.github.io/RSATtools) is
    automatically updated thanks to
    *[pkgdown](https://CRAN.R-project.org/package=pkgdown)* and
    *[travis](https://github.com/ropenscilabs/travis)*.

# RSAT

<a href="http://embnet.ccg.unam.mx"><img src="http://embnet.ccg.unam.mx/rsat/images/RSAT_20_Ann_logo.jpg" width="150px"></a>

# A CDSB community project

<a href="https://comunidadbioinfo.github.io/"><img src="https://comunidadbioinfo.github.io/img/Logo_texto-768x107.png"></a>
