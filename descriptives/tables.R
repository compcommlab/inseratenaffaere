library(dplyr)
library(tidyr)
library(readr)

df <- readRDS("data/dataset.rds")

# remove Heute, Krone, Krone.at
filt <- df$outlet %in% c('www.krone.at', 'Heute', 'Krone')
df <- df[!filt, ]

df$outlet <- as.factor(as.character(df$outlet)) # clean factor

total_articles <- length(unique(df$doc_uid))

# mentions of actors in paragraphs per outlet
paragraphs <- df |>
  group_by(outlet) |>
  summarise(across(Kurz:Strache, sum, .names = "{.col}_paragraphs"))

total_paragraphs <- df |>
  distinct(doc_uid, .keep_all = T) |>
  group_by(outlet) |>
  summarise(n = sum(total_paragraphs))

# mention of actors in articles per outlet
articles <- df |>
  group_by(doc_uid) |>
  mutate(across(Kurz:Strache, max)) |>
  distinct(doc_uid, .keep_all = T) |>
  group_by(outlet) |>
  summarise(across(Kurz:Strache, sum))

# total articles per outlet
articles_total <- df |>
  distinct(doc_uid, .keep_all = T) |>
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


# Parties Dataset


df <- readRDS("data/parties_random_sample.rds")

total_articles <- length(unique(df$doc_uid))

df <- df |> 
  rename('ÖVP' =  'oevp',
        'SPÖ' = 'spoe',
        'FPÖ' = 'fpoe',
        'Grüne' = 'gruene') 

# mentions of actors in paragraphs per outlet
paragraphs <- df |>
  group_by(outlet) |>
  summarise(across(`ÖVP`:`Grüne`, sum, .names = "{.col}_paragraphs"))

total_paragraphs <- df |>
  distinct(doc_uid, .keep_all = T) |>
  group_by(outlet) |>
  summarise(n = sum(total_paragraphs))

# mention of actors in articles per outlet
articles <- df |>
  group_by(doc_uid) |>
  mutate(across(`ÖVP`:`Grüne`, max)) |>
  distinct(doc_uid, .keep_all = T) |>
  group_by(outlet) |>
  summarise(across(`ÖVP`:`Grüne`, sum))

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
