library(dplyr)
library(ggplot2)
library(ggthemes)

df <- readRDS("data/dataset.rds") #

# Visibility

df_weeklyarticles <- df |>
  distinct(doc_uid, .keep_all = T) |>
  mutate(week = lubridate::floor_date(date, unit = "week")) |>
  group_by(week, outlet) |>
  count()

weekly_articles <- df_weeklyarticles |>
  ggplot(aes(x = week, y = n)) +
  geom_area() +
  facet_wrap(~outlet) +
  theme_clean() +
  theme(legend.position = "none") +
  coord_cartesian(ylim = c(0, 250))

ggsave("plots/01_descriptives_weekly_articles.png",
  weekly_articles,
  device = "png",
  width = 16,
  height = 9,
  units = "cm",
  dpi = 300,
  scale = 2
)

# Favourability (Sentiment)

# daily sentiment
df_dailysentiment <- df |>
  mutate(across(Kurz:Strache, ~ .x * sentiment_gottbert_regression)) |>
  group_by(date) |>
  summarise(across(Kurz:Strache, mean)) |>
  pivot_longer(Kurz:Strache,
    names_to = "Actor",
    values_to = "Average Sentiment"
  )

daily_sentiment <- df_dailysentiment |>
  ggplot(aes(x = date, y = `Average Sentiment`)) +
  geom_area() +
  facet_wrap(~Actor) +
  theme_clean() +
  theme(
    legend.position = "none",
    panel.spacing = unit(2, "lines")
  ) +
  coord_cartesian(ylim = c(-0.3, 0.3)) +
  geom_hline(yintercept = 0)

ggsave("plots/01_descriptives_daily_sentiment.png",
  daily_sentiment,
  device = "png",
  width = 16,
  height = 9,
  units = "cm",
  dpi = 300,
  scale = 2
)
