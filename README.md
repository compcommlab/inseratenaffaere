# Inseratenaffäre

Replication Materials for DID Analyis


# Datasets

- `data/dataset.rds`: Contains results of content analysis of all articles mention one of the actors (Kurz, Strache, Mitterlehner). 
- `data/parties_random_sample.rds`: Contains results of content analysis of randomly sampled articles that mention a political party (ÖVP, SPÖ, FPÖ, Grüne, NEOS)

Both stored as RDS (version 3; writer version 4.3.1; UTF-8 encoded; with xz compression; format is "xdr").

# Scripts

## Installation & Requirements

All required R-Packages are listed in `rpackages.R`. Run the script to install everything.

## Descriptives

The directory `descriptives` contains scripts for creating summary tables and plots for the datasets.