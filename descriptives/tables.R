library(dplyr)
library(tidyr)
library(readr)

df <- readRDS("data/dataset.rds")

# Control whether to exclude the other tabloids or not
EXCLUDE_TABLOIDS <- FALSE

if (EXCLUDE_TABLOIDS) {
  # remove Heute, Krone, Krone.at
  filt <- df$outlet %in% c("krone.at", "Heute", "Krone")
  df <- df[!filt, ]
}

df <- df |> mutate(actors = Kurz + Mitterlehner + Strache + `SPÖ-Leader`)

# filter out paragraphs without any actor mentioned
df <- df[df$actors > 0, ]

# how many times was more than one actor mentioned in a paragraph?
more_than_one <- nrow(df[df$actors > 1, ])
exactly_one <- nrow(df[df$actors == 1, ])

more_than_one / exactly_one


df$outlet <- as.factor(as.character(df$outlet)) # clean factor

total_articles <- length(unique(df$doc_uid))

# mentions of actors in paragraphs per outlet
paragraphs <- df |>
  group_by(outlet) |>
  summarise(across(c(Kurz, Mitterlehner, Strache, `SPÖ-Leader`),
    sum,
    .names = "{.col}_paragraphs"
  ))

total_paragraphs <- df |>
  group_by(outlet, doc_uid) |>
  count() |>
  group_by(outlet) |>
  summarise(n = sum(n))

# mention of actors in articles per outlet
articles <- df |>
  group_by(doc_uid) |>
  mutate(across(c(Kurz, Mitterlehner, Strache, `SPÖ-Leader`), sum)) |>
  distinct(doc_uid, .keep_all = T) |>
  group_by(outlet) |>
  summarise(across(c(Kurz, Mitterlehner, Strache, `SPÖ-Leader`), sum))

# total articles per outlet
articles_total <- df |>
  distinct(doc_uid, .keep_all = T) |>
  mutate(actors = Kurz + Mitterlehner + Strache + `SPÖ-Leader`) |>
  filter(actors > 0) |>
  group_by(outlet) |>
  count()

actors <- full_join(paragraphs, total_paragraphs, by = "outlet")
actors <- full_join(actors, articles, by = "outlet")
actors <- full_join(actors, articles_total, by = "outlet")
column_totals <- actors |>
  summarise(across(Kurz_paragraphs:n.y, sum))
column_totals$outlet <- "Total"

actors <- rbind(actors, column_totals)

actors <- actors |>
  mutate(across(Kurz_paragraphs:n.y, ~ format(.x, big.mark = ",")))

write_csv(actors, "tables/01_descriptives_actors_mentioned.csv")

# Latex Output
# knitr::kable(actors, format="latex", booktabs=T, format.args=list(big.mark=","))


# Parties Dataset


df <- readRDS("data/parties_random_sample.rds")

df$actors <- df$`ÖVP` + df$`SPÖ` + df$`FPÖ` + df$`Grüne`

# filter out paragraphs without any actor mentioned
df <- df[df$actors > 0, ]

total_articles <- length(unique(df$doc_uid))

# mentions of actors in paragraphs per outlet
paragraphs <- df |>
  group_by(outlet) |>
  summarise(across(c(`ÖVP`, `SPÖ`, `FPÖ`, `Grüne`), sum, .names = "{.col}_paragraphs"))

total_paragraphs <- df |>
  group_by(outlet, doc_uid) |>
  count() |>
  group_by(outlet) |>
  summarise(n = sum(n))

# mention of actors in articles per outlet
articles <- df |>
  group_by(doc_uid) |>
  mutate(across(c(`ÖVP`, `SPÖ`, `FPÖ`, `Grüne`), sum)) |>
  distinct(doc_uid, .keep_all = T) |>
  group_by(outlet) |>
  summarise(across(c(`ÖVP`, `SPÖ`, `FPÖ`, `Grüne`), sum))

# total articles per outlet
articles_total <- df |>
  distinct(doc_uid, .keep_all = T) |>
  group_by(outlet) |>
  count()

actors <- full_join(paragraphs, total_paragraphs, by = "outlet")
actors <- full_join(actors, articles, by = "outlet")
actors <- full_join(actors, articles_total, by = "outlet")
column_totals <- actors |>
  summarise(across(`ÖVP_paragraphs`:n.y, sum))
column_totals$outlet <- "Total"

actors <- rbind(actors, column_totals)

actors <- actors |>
  mutate(across(`ÖVP_paragraphs`:n.y, ~ format(.x, big.mark = ",")))

write_csv(actors, "tables/01_descriptives_parties_mentioned.csv")
# Latex Output
# knitr::kable(actors, format="latex", booktabs=T, format.args=list(big.mark=","))
