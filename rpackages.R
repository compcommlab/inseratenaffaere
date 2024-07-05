# Run this script to install all required R Packages
require(pak)

pkgs <- c(
    "dplyr",
    "tidyr",
    "lubridate",
    "ggplot2",
    "ggthemes",
    "did",
    "DRDID",
    "devtools",
    "viridis"
)

pak::pkg_install(pkgs)
pak::pkg_install("synth-inference/synthdid")
