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

treatment_year <- 2016

df <- df %>%
  mutate(treat = as.integer(outlet == "www.oe24.at" & year >= treatment_year))

# synthdid package doesn't like tibbles
df <- as.data.frame(df)

results <- list()

# Run estimations for each actor and save results
for (a in actors) {
  setup <- panel.matrices(df,
    unit = "id",
    time = "year",
    outcome = paste0("ln_actor_", a),
    treatment = "treat"
  )

  tau_hat <- synthdid_estimate(setup$Y, setup$N0, setup$T0)
  se = sqrt(vcov(tau_hat, method='placebo'))
  tval = as.numeric(tau_hat) / se # t-values based on asymptotic formula
  pval = 2 * pnorm(-abs(tval)) # p-values based on asymptotic formula
  
  results[[a]] <- data.frame(actor = a, 
                             tau_hat = as.numeric(tau_hat),
                             se = se,
                             tval = tval,
                             pval = pval,
                             lci = as.numeric(tau_hat) - 1.96 * se,
                             uci = as.numeric(tau_hat) + 1.96 * se)
}

results <- dplyr::bind_rows(results)

saveRDS(results, paste0("results/3a_synthdid_total.RDS"))

# Additional checks:
# run estimations only considering
# every year after treatment separately
years <- 2016:2019

results <- list()

for (a in actors) {

  actor_results <- data.frame(year=years)
  actor_results$actor <- a
  actor_results$tau_hat <- NA # average treatment effect on the treated (ATET)
  actor_results$standard_error <- NA # standard error
  actor_results$t_value <- NA # t value
  actor_results$p_value <- NA # Pr(>|t|)
  actor_results$lci <- NA # lower confidence interval
  actor_results$uci <- NA  # upper confidence interval

  for (j in years) {
    new_df <- df[(df$year < treatment_year | df$year == j), ]

    setup <- synthdid::panel.matrices(new_df,
      unit = "id",
      time = "year",
      outcome = paste0("ln_actor_", a),
      treatment = "treat"
    )

    tau_hat <- synthdid_estimate(setup$Y, setup$N0, setup$T0)
    se = sqrt(vcov(tau_hat, method='placebo'))
    tval = as.numeric(tau_hat) / se # t-values based on asymptotic formula
    pval = 2 * pnorm(-abs(tval)) # p-values based on asymptotic formula

    actor_results[actor_results$year == j, 'tau_hat'] <- as.numeric(tau_hat)
    actor_results[actor_results$year == j, 'standard_error'] <- se
    actor_results[actor_results$year == j, 't_value'] <- tval
    actor_results[actor_results$year == j, 'p_value'] <- pval
    actor_results[actor_results$year == j, 'lci'] <- as.numeric(tau_hat) - 1.96 * se
    actor_results[actor_results$year == j, 'uci'] <- as.numeric(tau_hat) + 1.96 * se
   }
   results[[a]] <- actor_results
}


results <- dplyr::bind_rows(results)


# drop years without estimation
results <- results[!is.na(results$tau_hat), ]
results$pre_treatment <- results$year < treatment_year

saveRDS(results, file = "results/3a_synthdid_year.RDS")
