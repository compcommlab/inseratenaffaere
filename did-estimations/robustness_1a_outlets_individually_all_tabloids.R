# Robustness Check of Actor Salience
# Compare each outlet individually with oe24.at

# Unit of analysis is actor visibility in paragraphs
# aggregated on monthly visibility

# Treatment group: visibility in www.oe24.at
# Control groups: one estimation series per news outlet (not www.oe24.at)
#                 Der Standard, Die Presse, Kurier, standard.at, kurier.at,
#                 Krone, krone.at, Heute

# Treatment year: 2016

library(dplyr)
library(DRDID)
library(did)

# Load dataset
df <- readRDS("data/dataset.rds")

df$outlet <- as.factor(as.character(df$outlet)) # clean factor


# Create a monthly date variable from the daily dates stored in date
df$month <- lubridate::floor_date(df$date, unit = "month")

# Create a vector containing the actors we want to analyze
actors <- c("Kurz", "Mitterlehner", "Strache")

# Aggregate by actor monthly mentions
# - calculate the total number of paragraphs per month for each actor
#   and outlet in which the current actor is mentioned
df <- df |>
  group_by(month, outlet) |>
  summarise(across(all_of(actors), sum, .names = "actor_{.col}")) |>
  ungroup()

# the value 0 (= actor does not appear in a newspaper within a month)
# is replaced by the value 1 so that the logarithm can be calculated in the next step

df <- df |>
  mutate(across(all_of(paste0('actor_', actors)), ~ if_else(.x == 0, 1, .x)))

# calculate the natural logarithm of the number of paragraphs per outlet
# and month for the current actor

df <- df |>
  mutate(across(all_of(paste0('actor_', actors)), log, .names = "ln_{.col}"))

# Assign some basic variables
df$treat <- as.numeric(df$outlet == 'www.oe24.at') # we want to check treatment against this outlet
df$year <- lubridate::year(df$month) # cast to year
df$id <- seq_len(nrow(df)) # DRDID needs a numeric ID for each observation

# Pre-allocate dummy variable
df$year_dummy <- 0

# time period we are interested in
years <- 2013:2021

# year where we expect to see a treatment effect
treatment_year <- 2016

# Outlets to compare against
outlets <- levels(df$outlet)
outlets <- outlets[outlets != 'www.oe24.at']

# Object to store the output of the estimation
results <- list()
# For each actor we run an estimation
for (a in actors) {

  # And also an estimation for each outlet individually
  for (o in outlets) {

    actor_results <- data.frame(year=years)
    actor_results$actor <- a
    actor_results$outlet <- o
    actor_results$ATET <- NA # average treatment effect on the treated (ATET)
    actor_results$standard_error <- NA # standard error
    actor_results$t_value <- NA # t value
    actor_results$pr_gt_t <- NA # Pr(>|t|)
    actor_results$lci <- NA # lower confidence interval
    actor_results$uci <- NA  # upper confidence interval

  for (i in years) {
    # For each actor we compare two years with each other

    # since Mitterlehner is not mentioned much after 2019,
    # the analysis here is only carried out up to and including 2019.
    if (a == 'Mitterlehner' & i > 2019) {
      next
    }


    if (i < treatment_year) {
      # before the treatment period
      # compare to the previous year
      df$year_dummy <- as.numeric(df$year > i - 1)
      df_tmp <- subset(df, df$year == i | df$year == i - 1)

    } else {
      # after the treatment period
      # compare to the year before the treatment
      # if treatment_year  is 2016, then we compare against 2015
      # so we compare 2016, 2017, 2018 ... with 2015 as reference
      df$year_dummy <- as.numeric(df$year >= treatment_year)
      df_tmp <- subset(df, df$year == treatment_year - 1 | df$year == i)
    }

    # subset by outlets
    df_tmp <- subset(df_tmp, df_tmp$outlet %in% c('www.oe24.at', o))

    estimation <-  did::att_gt(yname = paste0("ln_actor_", a),
                               tname = 'year_dummy',
                               idname = 'id',
                               gname = 'treat',
                               panel = FALSE,
                               data = df_tmp)

    actor_results[actor_results$year == i, 'ATET'] <- estimation$att
    actor_results[actor_results$year == i, 'standard_error'] <- estimation$se
    actor_results[actor_results$year == i, 't_value'] <- estimation$att / estimation$se
    actor_results[actor_results$year == i, 'pr_gt_t'] <- (2 * (stats::pnorm(-abs(estimation$att / estimation$se))))
    actor_results[actor_results$year == i, 'lci'] <- estimation$att - estimation$c * estimation$se
    actor_results[actor_results$year == i, 'uci'] <- estimation$att + estimation$c * estimation$se
  }
  res_name <- paste0(a, o)
  results[[res_name]] <- actor_results
  }
}

results <- dplyr::bind_rows(results)

# drop years without estimation
results <- results[!is.na(results$ATET), ]
results$pre_treatment <- results$year < treatment_year


# Save the results
saveRDS(results, "results/robustness_1a_outlets_individually_all_tabloids.RDS")


print(sessionInfo())
