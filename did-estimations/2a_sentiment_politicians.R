# Difference in Difference Estimation for Actor Favourability
# Considering contextual sentiment score of individual politicians

# Unit of analysis is sentiment score on article level (local clustering)

# Treatment year: 2016
# Treatment group: sentiment score in oe24.at
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


library(dplyr)
library(DRDID)
library(did)

# We run this estimation in parallel,
# so we detect the number of cores to use for computation
# default is 14 cores
n_cores <- parallel::detectCores() - 2

# Load dataset
df <- readRDS("data/dataset.rds")

# remove Heute, Krone, Krone.at
filt <- df$outlet %in% c("krone.at", "Heute", "Krone")
df <- df[!filt, ]

df$outlet <- as.factor(as.character(df$outlet)) # clean factor


# Create a monthly date variable from the daily dates stored in date
df$month <- lubridate::floor_date(df$date, unit = "month")

# Create an id variable by grouping together observations from the same newspaper article
# this is a numerical version of doc_uid and is used for local clustering
df <- df |>
    group_by(doc_uid) |>
    mutate(id = cur_group_id())

# Assign some basic variables
df$treat <- as.numeric(df$outlet == "oe24.at") # we want to check treatment against this outlet
df$year <- lubridate::year(df$month) # cast to year

# estimations for actors
actors <- c("Kurz", "Strache", "Mitterlehner", "SPÖ-Leader")

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
        df_tmp <- subset(df_tmp, df_tmp[, a] == 1)
        estimation <- did::att_gt(
            yname = "sentiment_gottbert_regression",
            tname = "year_dummy",
            idname = "id",
            gname = "treat",
            panel = FALSE,
            clustervars = c("id"),
            data = df_tmp,
            pl = TRUE,
            cores = n_cores
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
saveRDS(results, "results/2a_sentiment_politicians.RDS")


print(sessionInfo())
