pkgLoad <- function()
{
    repos <- "https://cran.irsn.fr"

    # https://support.rstudio.com/hc/en-us/articles/201057987
    packages <- c(
        "caret",
        "chron",
        "data.table",
        "devtools",
        "doMC",
        "dplyr",
        "DT",
        "feather",
        "gapminder",
        "ggplot2",
        "ggThemeAssist",
        "googlesheets",
        "IRkernel",
        "knitr",
        "Lahman",
        "lars",
        "lubridate",
        "microbenchmark",
        "nycflights13",
        "pacman",
        "padr",
        "parallel",
        "plyr",
        "psych",
        "Rcpp",
        "readr",
        "readxl",
        "reticulate",
        "rmarkdown",
        "rio",
        "shiny",
        "shinyjs",
        "smooth",
        "stats",
        "tensorflow",
        "tidyverse",
        "utils",
        "zoo"
    )

    packagecheck <- match(packages, utils::installed.packages()[, 1])

    packagestoinstall <- packages[is.na(packagecheck)]

    if(length(packagestoinstall) > 0L) 
    {
        utils::install.packages(packagestoinstall, repos = repos)
    }

    for(package in packages) 
    {
        suppressPackageStartupMessages(
            library(package, character.only = TRUE, quietly = TRUE)
        )
    }
}

pkgLoad()
