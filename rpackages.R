# Run this script to install all required R Packages

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

install.packages(pkgs)

devtools::install_github("synth-inference/synthdid")
