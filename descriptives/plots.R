library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)

df <- readRDS("data/dataset.rds")

# Control whether to exclude the other tabloids or not
EXCLUDE_TABLOIDS <- FALSE

if (EXCLUDE_TABLOIDS) {
  # remove Heute, Krone, Krone.at
  filt <- df$outlet %in% c("krone.at", "Heute", "Krone")
  df <- df[!filt, ]
}

df$outlet <- as.factor(as.character(df$outlet)) # clean factor

df <- df |> mutate(actors = Kurz + Mitterlehner + Strache + `SPÖ-Leader`)

# filter out paragraphs without any actor mentioned
df <- df[df$actors > 0, ]

# Visibility

df_weeklyarticles <- df |>
  distinct(doc_uid, .keep_all = T) |>
  mutate(week = lubridate::floor_date(date, unit = "week")) |>
  group_by(week, outlet) |>
  count()

weekly_articles <- df_weeklyarticles |>
  ggplot(aes(x = week, y = n)) +
  geom_area() +
  facet_wrap(~outlet, axes = "all") +
  theme_clean() +
  theme(
    legend.position = "none",
    plot.background = element_rect(color = NA)
  ) +
  coord_cartesian(ylim = c(0, 200))

# This figure is not in the Manuscript or Appendix
ggsave("plots/01_descriptives_weekly_articles.png",
  weekly_articles,
  device = "png",
  width = 16,
  height = 9,
  units = "cm",
  dpi = 300,
  scale = 2
)

# This figure is not in the Manuscript or Appendix
ggsave("plots/01_descriptives_weekly_articles.pdf",
  weekly_articles,
  device = "pdf",
  width = 16,
  height = 9,
  units = "cm",
  dpi = 300,
  scale = 2
)


# Favourability (Sentiment)

# daily sentiment
df_dailysentiment <- df |>
  mutate(across(
    c(Kurz, Mitterlehner, Strache, `SPÖ-Leader`),
    ~ .x * sentiment_gottbert_regression
  )) |>
  group_by(date) |>
  summarise(across(c(Kurz, Mitterlehner, Strache, `SPÖ-Leader`), mean)) |>
  pivot_longer(c(Kurz, Mitterlehner, Strache, `SPÖ-Leader`),
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
    panel.spacing = unit(2, "lines"),
    plot.background = element_rect(color = NA)
  ) +
  coord_cartesian(ylim = c(-0.4, 0.4)) +
  geom_hline(yintercept = 0)

# Figure 2 in the Manuscript
ggsave("plots/Figure-02_descriptives_daily_sentiment.png",
  daily_sentiment,
  device = "png",
  width = 16,
  height = 9,
  units = "cm",
  dpi = 300,
  scale = 2
)

# Figure 2 in the Manuscript
ggsave("plots/Figure-02_descriptives_daily_sentiment.pdf",
  daily_sentiment,
  device = "pdf",
  width = 16,
  height = 9,
  units = "cm",
  dpi = 300,
  scale = 2
)
