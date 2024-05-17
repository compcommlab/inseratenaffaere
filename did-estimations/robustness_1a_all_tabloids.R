# Robustness Check of Actor Salience
# Include other tabloids (Krone, Krone.at, Heute) in estimations

# Unit of analysis is actor visibility in paragraphs
# aggregated on monthly visibility

# Treatment year: 2016
# Treatment group: visibility in oe24.at
# Control group:
# - Der Standard
# - derstandard.at
# - Die Presse
# - diepresse.com
# - Kleine Zeitung
# - kleinezeitung.at
# - Kurier
# - kurier.at
# - Niederösterreichische Nachrichten
# - Oberösterreichisches Volksblatt
# - oe24.at
# - OÖ Nachrichten
# - Salzburger Nachrichten
# - sn.at
# - Tiroler Tageszeitung
# - Vorarlberger Nachrichten
# - Wiener Zeitung
# - Krone
# - Krone.at
# - Heute


library(dplyr)
library(DRDID)
library(did)

# Load dataset
df <- readRDS("data/dataset.rds")


# Create a monthly date variable from the daily dates stored in date
df$month <- lubridate::floor_date(df$date, unit = "month")

# Create a vector containing the actors we want to analyze
actors <- c("Kurz", "Mitterlehner", "Strache", "SPÖ-Leader")

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
  mutate(across(all_of(paste0("actor_", actors)), ~ if_else(.x == 0, 1, .x)))

# calculate the natural logarithm of the number of paragraphs per outlet
# and month for the current actor

df <- df |>
  mutate(across(all_of(paste0("actor_", actors)), log, .names = "ln_{.col}"))

# Assign estimation variables

# Treatment variable
df$treat <- as.numeric(df$outlet == "oe24.at") # we want to check treatment against this outlet

# We compare across years
df$year <- lubridate::year(df$month) # cast to year

# DRDID needs a numeric ID for each observation
df$id <- seq_len(nrow(df))

# Pre-allocate dummy variable
df$year_dummy <- 0

# time period we are interested in
years <- 2013:2021

# year where we expect to see a treatment effect
treatment_year <- 2016

# Object to store the output of the estimation
results <- list()
# For each actor we run an estimation
for (a in actors) {
  actor_results <- data.frame(year = years)
  actor_results$actor <- a
  actor_results$ATET <- NA # average treatment effect on the treated (ATET)
  actor_results$standard_error <- NA # standard error
  actor_results$t_value <- NA # t value
  actor_results$pr_gt_t <- NA # Pr(>|t|)
  actor_results$lci <- NA # lower confidence interval
  actor_results$uci <- NA # upper confidence interval

  for (i in years) {
    # Run estimation for each actor at a given year (i)

    # since Mitterlehner is not mentioned much after 2019,
    # the analysis here is only carried out up to and including 2019.
    if (a == "Mitterlehner" & i > 2019) {
      next
    }

    # For each actor we compare two years with each other
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
    estimation <- did::att_gt(
      yname = paste0("ln_actor_", a),
      tname = "year_dummy",
      idname = "id",
      gname = "treat",
      panel = FALSE,
      data = df_tmp
    )

    actor_results[actor_results$year == i, "ATET"] <- estimation$att
    actor_results[actor_results$year == i, "standard_error"] <- estimation$se
    actor_results[actor_results$year == i, "t_value"] <- estimation$att / estimation$se
    actor_results[actor_results$year == i, "pr_gt_t"] <- (2 * (stats::pnorm(-abs(estimation$att / estimation$se))))
    actor_results[actor_results$year == i, "lci"] <- estimation$att - estimation$c * estimation$se
    actor_results[actor_results$year == i, "uci"] <- estimation$att + estimation$c * estimation$se
  }
  results[[a]] <- actor_results
}

results <- dplyr::bind_rows(results)

# drop years without estimation
results <- results[!is.na(results$ATET), ]
results$pre_treatment <- results$year < treatment_year

# Save the results
saveRDS(results, "results/robustness_1a_all_tabloids.RDS")

print(sessionInfo())
