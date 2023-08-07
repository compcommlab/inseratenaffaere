# Synthetic DiD: Approach dataset as panel data
# DiD relies on the assumption that visibility for different politicians
# would have evolved in a parallel way absent any intervention.
# There is variation in the visibility of actors in the pre-treatment period.
# "What synthetic DiD does here is to re-weight the unexposed control units 
# to make their time trend parallel (but not necessarily identical)
# to pre-intervention, and then applies a DID analysis to this re-weighted panel." 
# (Arkhangelsky et al, 2018)

library(dplyr)
library(synthdid)

# Load the data
df <- readRDS("data/dataset.rds")

# remove Heute, Krone, Krone.at
filt <- df$outlet %in% c('www.krone.at', 'Heute', 'Krone')
df <- df[!filt, ]

df$outlet <- as.factor(as.character(df$outlet)) # clean factor

# create a variable indicating the month (but not the year)
# which can be used later to create the panel id
df <- df |>
  mutate(
    month = lubridate::month(date),
    year = lubridate::year(date),
    yearmonth = lubridate::floor_date(date, unit = "month")
  )

# exclude the year 2021 from the panel
# Keep data until December 2019, excluding the years 2020 and 2021
filt <- df$date <= "2019-12-31"

df <- df[filt, ]

# Create a vector containing the actors we want to analyze
actors <- c("Strache", "Kurz", 'Mitterlehner')

# Loop over each actor in the vector "actors" and
# calculate the total number of paragraphs per month
# and outlet in which the current actor is mentioned
df <- df |>
  group_by(yearmonth, outlet) |>
  mutate(across(all_of(actors), sum, .names = "actor_{.col}")) |>
  ungroup() |>
  select(outlet, year, month, actor_Strache, actor_Kurz, actor_Mitterlehner)

# Drop duplicate observations
df <- df %>%
  distinct()

# the value 0 (= actor does not appear in a newspaper within a month)
# is replaced by the value 1 so that the logarithm can be calculated in the next step
df <- df |>
  mutate(across(all_of(paste0("actor_", actors)), ~ if_else(.x == 0, 1, .x)))

# Loop over each actor in the vector "actors"
# and calculate the natural logarithm of the number of paragraphs per outlet
# and month for the current actor
df <- df |>
  mutate(across(all_of(paste0("actor_", actors)), log, .names = "ln_{.col}"))

# Create panel id variable by grouping observations by outlet and month
df <- df %>%
  group_by(month, outlet) %>%
  mutate(id = cur_group_id()) %>%
  ungroup()

# Create a variable defining the treatment group
# in the post-treatment period
# (takes the value of 1 if the variable outlet = www.oe24.at
# in the years 2016-2020, and 0 otherwise)
df <- df %>%
  mutate(treat = as.integer(outlet == "www.oe24.at" & year >= 2016))

# synthdid package doesn't like tibbles
df <- as.data.frame(df)

# Run estimations for each actor and save results
for (a in actors) {
  setup <- panel.matrices(df,
    unit = "id",
    time = "year",
    outcome = paste0("ln_actor_", a),
    treatment = "treat"
  )

  tau_hat <- synthdid_estimate(setup$Y, setup$N0, setup$T0)
  # se = sqrt(vcov(tau_hat, method='placebo'))
  # sprintf('point estimate: %1.5f', tau_hat)
  # sprintf('95%% CI (%1.2f, %1.2f)', tau_hat - 1.96 * se, tau_hat + 1.96 * se)
  saveRDS(tau_hat, paste0("results/3a_synthdid_", a, "_total.RDS"))
}

# Additional checks:
# run estimations only considering
# every year after treatment separately
for (j in 2016:2019) {
  new_df <- df[(df$year <= 2015 | df$year == j), ]

  for (a in actors) {
    setup <- synthdid::panel.matrices(new_df,
      unit = "id",
      time = "year",
      outcome = paste0("ln_actor_", a),
      treatment = "treat"
    )

    tau_hat <- synthdid_estimate(setup$Y, setup$N0, setup$T0)
    # se = sqrt(vcov(tau_hat, method='placebo'))
    # sprintf('point estimate: %1.5f', tau_hat)
    # sprintf('95%% CI (%1.2f, %1.2f)', tau_hat - 1.96 * se, tau_hat + 1.96 * se)

    saveRDS(tau_hat, paste0("results/3a_synthdid_", a, "_", j, ".RDS"))
  }
}
