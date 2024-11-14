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

## DiD

`did-estimations` contains all scripts for Difference-in-Difference (DiD) estimations and generating plots.

We use the package `did` (Callaway & Sant'Anna, 2021a) which is a wrapper for [`DRDID`](https://psantanna.com/DRDID/) (Sant'Anna & Zhao, 2020) for estimating ATET on visibility and favourability.

## Snythetic DiD

We also ran synthetic estimations as robustness checks. This requires the [`synthdid`](https://synth-inference.github.io/synthdid/index.html) package (Arkhangelsky et al, 2018).


# References

- Arkhangelsky, D., Athey, S., Hirshberg, D. A., Imbens, G. W., & Wager, S. (2018). Synthetic Difference in Differences (Version 4). arXiv. <https://arxiv.org/abs/1812.09970v4>. R-Package information: https://synth-inference.github.io/synthdid/index.html 
- Callaway B, Sant'Anna P (2021a). “did: Difference in Differences.” R
  package version 2.1.2, <https://bcallaway11.github.io/did/>.
- Callaway B, Sant'Anna P (2021b). “Difference-in-differences with multiple time periods.” *Journal of Econometrics*. <https://doi.org/10.1016/j.jeconom.2020.12.001>.
- Sant'Anna P, Zhao J (2020). “Doubly Robust Difference-in-Differences
  Estimators.” _Journal of Econometrics_, *219*, 101-122.
  <https://doi.org/10.1016/j.jeconom.2020.06.003>. More information: https://psantanna.com/DRDID/
