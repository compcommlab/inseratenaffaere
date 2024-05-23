library(dplyr)
library(ggplot2)
library(ggthemes)
library(viridis)

years <- 2013:2021

# 1a_paragraphs_politicians

results_1a <- readRDS("results/1a_paragraphs_politicians.RDS")

results_1a$`Treatment Period` <- factor(ifelse(results_1a$pre_treatment,
  "Pre",
  "Post"
), levels = c("Pre", "Post"))



plot_1a <- results_1a |>
  ggplot(aes(
    x = year, y = ATET,
    color = `Treatment Period`,
    shape = `Treatment Period`
  )) +
  # convoluted solution to plot confidence intervals
  geom_segment(aes(xend = year, y = lci, yend = uci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = lci, y = lci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = uci, y = uci)) +
  # actual point estimates
  geom_point(size = 2) +
  # fix year scale
  scale_x_continuous(breaks = years) +
  # theme
  theme_clean() +
  theme(
    legend.position = "top",
    panel.spacing = unit(2, "lines"),
    plot.background = element_rect(color = NA)
  ) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  # colors for publication
  scale_color_viridis(discrete = TRUE, option = "magma", end = 0.6) +
  # scale_color_grey(start = 0, end = 0.4) +
  # show the comparison point
  # geom_vline(xintercept = 2015.5, linetype = 'dotted') +
  # facet against actor
  facet_wrap(~actor)

ggsave("plots/1a_paragraphs_politicians.png",
  plot_1a,
  device = "png",
  width = 16,
  height = 12,
  units = "cm",
  dpi = 300,
  scale = 2
)


ggsave("plots/1a_paragraphs_politicians.pdf",
  plot_1a,
  device = "pdf",
  width = 16,
  height = 12,
  units = "cm",
  dpi = 300,
  scale = 2
)



# 1b paragraphs parties

results_1b <- readRDS("results/1b_paragraphs_parties.RDS")

results_1b$`Treatment Period` <- factor(ifelse(results_1b$pre_treatment,
  "Pre",
  "Post"
), levels = c("Pre", "Post"))

results_1b$actor <- factor(results_1b$actor,
  levels = c("ÖVP", "SPÖ", "FPÖ", "Grüne")
)

plot_1b <- results_1b |>
  ggplot(aes(
    x = year, y = ATET,
    color = `Treatment Period`,
    shape = `Treatment Period`
  )) +
  # convoluted solution to plot confidence intervals
  geom_segment(aes(xend = year, y = lci, yend = uci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = lci, y = lci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = uci, y = uci)) +
  # actual point estimates
  geom_point(size = 2) +
  # fix year scale
  scale_x_continuous(breaks = years) +
  # theme
  theme_clean() +
  theme(
    legend.position = "top",
    panel.spacing = unit(2, "lines"),
    plot.background = element_rect(color = NA)
  ) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  # colors for publication
  scale_color_viridis(discrete = TRUE, option = "magma", end = 0.6) +
  # scale_color_grey(start = 0, end = 0.4) +
  # show the comparison point
  # geom_vline(xintercept = 2015.5, linetype = 'dotted') +
  # facet against actor
  facet_wrap(~actor)

ggsave("plots/1b_paragraphs_parties.png",
  plot_1b,
  device = "png",
  width = 16,
  height = 12,
  units = "cm",
  dpi = 300,
  scale = 2
)


ggsave("plots/1b_paragraphs_parties.pdf",
  plot_1b,
  device = "pdf",
  width = 16,
  height = 12,
  units = "cm",
  dpi = 300,
  scale = 2
)


# 2a sentiment politicians

results_2a <- readRDS("results/2a_sentiment_politicians.RDS")

results_2a$`Treatment Period` <- factor(ifelse(results_2a$pre_treatment,
  "Pre",
  "Post"
), levels = c("Pre", "Post"))

plot_2a <- results_2a |>
  ggplot(aes(
    x = year, y = ATET,
    color = `Treatment Period`,
    shape = `Treatment Period`
  )) +
  # convoluted solution to plot confidence intervals
  geom_segment(aes(xend = year, y = lci, yend = uci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = lci, y = lci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = uci, y = uci)) +
  # actual point estimates
  geom_point(size = 2) +
  # fix year scale
  scale_x_continuous(breaks = years) +
  # theme
  theme_clean() +
  theme(
    legend.position = "top",
    panel.spacing = unit(2, "lines"),
    plot.background = element_rect(color = NA)
  ) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  # colors for publication
  scale_color_viridis(discrete = TRUE, option = "magma", end = 0.6) +
  # scale_color_grey(start = 0, end = 0.4) +
  # show the comparison point
  # geom_vline(xintercept = 2015.5, linetype = 'dotted') +
  # facet against actor
  facet_wrap(~actor)


ggsave("plots/2a_sentiment_politicians.png",
  plot_2a,
  device = "png",
  width = 16,
  height = 12,
  units = "cm",
  dpi = 300,
  scale = 2
)

ggsave("plots/2a_sentiment_politicians.pdf",
  plot_2a,
  device = "pdf",
  width = 16,
  height = 12,
  units = "cm",
  dpi = 300,
  scale = 2
)

# 2b sentiment parties

results_2b <- readRDS("results/2b_sentiment_parties.RDS")

results_2b$`Treatment Period` <- factor(ifelse(results_2b$pre_treatment,
  "Pre",
  "Post"
), levels = c("Pre", "Post"))

results_2b$actor <- factor(results_2b$actor,
  levels = c("ÖVP", "SPÖ", "FPÖ", "Grüne")
)

plot_2b <- results_2b |>
  ggplot(aes(
    x = year, y = ATET,
    color = `Treatment Period`,
    shape = `Treatment Period`
  )) +
  # convoluted solution to plot confidence intervals
  geom_segment(aes(xend = year, y = lci, yend = uci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = lci, y = lci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = uci, y = uci)) +
  # actual point estimates
  geom_point(size = 2) +
  # fix year scale
  scale_x_continuous(breaks = years) +
  # theme
  theme_clean() +
  theme(
    legend.position = "top",
    panel.spacing = unit(2, "lines"),
    plot.background = element_rect(color = NA)
  ) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  # colors for publication
  scale_color_viridis(discrete = TRUE, option = "magma", end = 0.6) +
  # scale_color_grey(start = 0, end = 0.4) +
  # show the comparison point
  # geom_vline(xintercept = 2015.5, linetype = 'dotted') +
  # facet against actor
  facet_wrap(~actor)

ggsave("plots/2b_sentiment_parties.png",
  plot_2b,
  device = "png",
  width = 16,
  height = 12,
  units = "cm",
  dpi = 300,
  scale = 2
)

ggsave("plots/2b_sentiment_parties.pdf",
  plot_2b,
  device = "pdf",
  width = 16,
  height = 12,
  units = "cm",
  dpi = 300,
  scale = 2
)

# robustness 1a outlets individually

results_rob_1a <- readRDS("results/robustness_1a_outlets_individually.RDS")

results_rob_1a$`Treatment Period` <- factor(ifelse(results_rob_1a$pre_treatment,
  "Pre",
  "Post"
), levels = c("Pre", "Post"))


plot_r1a_kurz <- results_rob_1a |>
  filter(actor == "Kurz") |>
  mutate(outlet = paste("oe24.at vs", outlet)) |>
  ggplot(aes(
    x = year, y = ATET,
    color = `Treatment Period`,
    shape = `Treatment Period`
  )) +
  # convoluted solution to plot confidence intervals
  geom_segment(aes(xend = year, y = lci, yend = uci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = lci, y = lci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = uci, y = uci)) +
  # actual point estimates
  geom_point(size = 2) +
  # fix year scale
  scale_x_continuous(breaks = years) +
  # theme
  theme_clean() +
  theme(
    legend.position = "top",
    panel.spacing = unit(2, "lines"),
    plot.background = element_rect(color = NA)
  ) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  # colors for publication
  scale_color_viridis(discrete = TRUE, option = "magma", end = 0.6) +
  # scale_color_grey(start = 0, end = 0.4) +
  # show the comparison point
  # geom_vline(xintercept = 2015.5, linetype = 'dotted') +
  # facet against outlet
  facet_wrap(~outlet)

ggsave("plots/robustneess_1a_outlets_individually_kurz.png",
  plot_r1a_kurz,
  device = "png",
  width = 20,
  height = 16,
  units = "cm",
  dpi = 300,
  scale = 2
)

ggsave("plots/robustneess_1a_outlets_individually_kurz.pdf",
  plot_r1a_kurz,
  device = "pdf",
  width = 20,
  height = 16,
  units = "cm",
  dpi = 300,
  scale = 2
)


plot_r1a_all <- results_rob_1a |>
  mutate(outlet = paste("oe24.at vs", outlet)) |>
  ggplot(aes(
    x = year, y = ATET,
    color = `Treatment Period`,
    shape = `Treatment Period`
  )) +
  # convoluted solution to plot confidence intervals
  geom_segment(aes(xend = year, y = lci, yend = uci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = lci, y = lci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = uci, y = uci)) +
  # actual point estimates
  geom_point(size = 2) +
  # fix year scale
  scale_x_continuous(breaks = years) +
  # theme
  theme_clean() +
  theme(
    legend.position = "top",
    panel.spacing = unit(2, "lines"),
    plot.background = element_rect(color = NA)
  ) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  # colors for publication
  scale_color_viridis(discrete = TRUE, option = "magma", end = 0.6) +
  # scale_color_grey(start = 0, end = 0.4) +
  # show the comparison point
  # geom_vline(xintercept = 2015.5, linetype = 'dotted') +
  # facet against outlet
  facet_wrap(~ outlet * actor, ncol = 3)

ggsave("plots/robustneess_1a_outlets_individually_all.png",
  plot_r1a_all,
  device = "png",
  width = 16,
  height = 18,
  units = "cm",
  dpi = 300,
  scale = 2
)

ggsave("plots/robustneess_1a_outlets_individually_all.pdf",
  plot_r1a_all,
  device = "pdf",
  width = 16,
  height = 18,
  units = "cm",
  dpi = 300,
  scale = 2
)



# robustness 2a outlets individually

results_rob_2a <- readRDS("results/robustness_2a_outlets_individually.RDS")

results_rob_2a$`Treatment Period` <- factor(ifelse(results_rob_2a$pre_treatment,
  "Pre",
  "Post"
), levels = c("Pre", "Post"))


plot_r2a_all <- results_rob_2a |>
  mutate(outlet = paste("oe24.at vs", outlet)) |>
  ggplot(aes(
    x = year, y = ATET,
    color = `Treatment Period`,
    shape = `Treatment Period`
  )) +
  # convoluted solution to plot confidence intervals
  geom_segment(aes(xend = year, y = lci, yend = uci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = lci, y = lci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = uci, y = uci)) +
  # actual point estimates
  geom_point(size = 2) +
  # fix year scale
  scale_x_continuous(breaks = years) +
  # theme
  theme_clean() +
  theme(
    legend.position = "top",
    panel.spacing = unit(2, "lines"),
    plot.background = element_rect(color = NA)
  ) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  # colors for publication
  scale_color_viridis(discrete = TRUE, option = "magma", end = 0.6) +
  # scale_color_grey(start = 0, end = 0.4) +
  # show the comparison point
  # geom_vline(xintercept = 2015.5, linetype = 'dotted') +
  # facet against outlet
  facet_wrap(~ outlet * actor, ncol = 4)

ggsave("plots/robustneess_2a_outlets_individually_all.png",
  plot_r2a_all,
  device = "png",
  width = 20,
  height = 60,
  units = "cm",
  dpi = 300,
  scale = 2
)

ggsave("plots/robustneess_2a_outlets_individually_all.pdf",
  plot_r2a_all,
  device = "pdf",
  width = 16,
  height = 18,
  units = "cm",
  dpi = 300,
  scale = 2
)

# robustness 1a with all tabloids


results_r1a_all <- readRDS("results/robustness_1a_all_tabloids.RDS")

results_r1a_all$`Treatment Period` <- factor(ifelse(results_r1a_all$pre_treatment,
  "Pre",
  "Post"
), levels = c("Pre", "Post"))



plot_r1a_all <- results_r1a_all |>
  ggplot(aes(
    x = year, y = ATET,
    color = `Treatment Period`,
    shape = `Treatment Period`
  )) +
  # convoluted solution to plot confidence intervals
  geom_segment(aes(xend = year, y = lci, yend = uci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = lci, y = lci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = uci, y = uci)) +
  # actual point estimates
  geom_point(size = 2) +
  # fix year scale
  scale_x_continuous(breaks = years) +
  # theme
  theme_clean() +
  theme(
    legend.position = "top",
    panel.spacing = unit(2, "lines"),
    plot.background = element_rect(color = NA)
  ) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  # colors for publication
  scale_color_viridis(discrete = TRUE, option = "magma", end = 0.6) +
  # scale_color_grey(start = 0, end = 0.4) +
  # show the comparison point
  # geom_vline(xintercept = 2015.5, linetype = 'dotted') +
  # facet against actor
  facet_wrap(~actor)

ggsave("plots/robustness_1a_all_tabloids.png",
  plot_r1a_all,
  device = "png",
  width = 16,
  height = 12,
  units = "cm",
  dpi = 300,
  scale = 2
)

ggsave("plots/robustness_1a_all_tabloids.pdf",
  plot_r1a_all,
  device = "pdf",
  width = 16,
  height = 12,
  units = "cm",
  dpi = 300,
  scale = 2
)


# Robustness 2a sentiment politicians with all tabloids

results_r2a_all <- readRDS("results/robustness_2a_all_tabloids.RDS")

results_r2a_all$`Treatment Period` <- factor(ifelse(results_r2a_all$pre_treatment,
  "Pre",
  "Post"
), levels = c("Pre", "Post"))

plot_r2a_all <- results_r2a_all |>
  ggplot(aes(
    x = year, y = ATET,
    color = `Treatment Period`,
    shape = `Treatment Period`
  )) +
  # convoluted solution to plot confidence intervals
  geom_segment(aes(xend = year, y = lci, yend = uci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = lci, y = lci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = uci, y = uci)) +
  # actual point estimates
  geom_point(size = 2) +
  # fix year scale
  scale_x_continuous(breaks = years) +
  # theme
  theme_clean() +
  theme(
    legend.position = "top",
    panel.spacing = unit(2, "lines"),
    plot.background = element_rect(color = NA)
  ) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  # colors for publication
  scale_color_viridis(discrete = TRUE, option = "magma", end = 0.6) +
  # scale_color_grey(start = 0, end = 0.4) +
  # show the comparison point
  # geom_vline(xintercept = 2015.5, linetype = 'dotted') +
  # facet against actor
  facet_wrap(~actor)


ggsave("plots/robustness_2a_all_tabloids.png",
  plot_r2a_all,
  device = "png",
  width = 16,
  height = 12,
  units = "cm",
  dpi = 300,
  scale = 2
)

ggsave("plots/robustness_2a_all_tabloids.pdf",
  plot_r2a_all,
  device = "pdf",
  width = 16,
  height = 12,
  units = "cm",
  dpi = 300,
  scale = 2
)

# Robustness 1a - Include all Tabloids in Control Group and run estimations indivdually

results_rob_1a_all_tabloids_individually <-
  readRDS("results/robustness_1a_outlets_individually_all_tabloids.RDS")


results_rob_1a_all_tabloids_individually$`Treatment Period` <-
  factor(ifelse(results_rob_1a_all_tabloids_individually$pre_treatment,
    "Pre",
    "Post"
  ), levels = c("Pre", "Post"))


plot_r1a_all_tabloids_individually <- results_rob_1a_all_tabloids_individually |>
  mutate(outlet = paste("oe24.at vs", outlet)) |>
  ggplot(aes(
    x = year, y = ATET,
    color = `Treatment Period`,
    shape = `Treatment Period`
  )) +
  # convoluted solution to plot confidence intervals
  geom_segment(aes(xend = year, y = lci, yend = uci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = lci, y = lci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = uci, y = uci)) +
  # actual point estimates
  geom_point(size = 2) +
  # fix year scale
  scale_x_continuous(breaks = years) +
  # theme
  theme_clean() +
  theme(
    legend.position = "top",
    panel.spacing = unit(2, "lines"),
    plot.background = element_rect(color = NA)
  ) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  # colors for publication
  scale_color_viridis(discrete = TRUE, option = "magma", end = 0.6) +
  # scale_color_grey(start = 0, end = 0.4) +
  # show the comparison point
  # geom_vline(xintercept = 2015.5, linetype = 'dotted') +
  # facet against outlet
  facet_wrap(~ outlet * actor, ncol = 4)

ggsave("plots/robustneess_1a_outlets_individually_all_tabloids.png",
  plot_r1a_all_tabloids_individually,
  device = "png",
  width = 22,
  height = 60,
  units = "cm",
  dpi = 300,
  scale = 2
)

ggsave("plots/robustneess_1a_outlets_individually_all_tabloids.pdf",
  plot_r1a_all_tabloids_individually,
  device = "pdf",
  width = 22,
  height = 60,
  units = "cm",
  dpi = 300,
  scale = 2
)



# robustness 2a Include all Tabloids in Control Group and run estimations indivdually

results_rob_2a_all_tabloids_individually <- readRDS("results/robustness_2a_outlets_individually_all_tabloids.RDS")

results_rob_2a_all_tabloids_individually$`Treatment Period` <- factor(ifelse(results_rob_2a_all_tabloids_individually$pre_treatment,
  "Pre",
  "Post"
), levels = c("Pre", "Post"))


plot_r2a_all_tabloids_individually <- results_rob_2a_all_tabloids_individually |>
  mutate(outlet = paste("oe24.at vs", outlet)) |>
  ggplot(aes(
    x = year, y = ATET,
    color = `Treatment Period`,
    shape = `Treatment Period`
  )) +
  # convoluted solution to plot confidence intervals
  geom_segment(aes(xend = year, y = lci, yend = uci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = lci, y = lci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = uci, y = uci)) +
  # actual point estimates
  geom_point(size = 2) +
  # fix year scale
  scale_x_continuous(breaks = years) +
  # theme
  theme_clean() +
  theme(
    legend.position = "top",
    panel.spacing = unit(2, "lines"),
    plot.background = element_rect(color = NA)
  ) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  # colors for publication
  scale_color_viridis(discrete = TRUE, option = "magma", end = 0.6) +
  # scale_color_grey(start = 0, end = 0.4) +
  # show the comparison point
  # geom_vline(xintercept = 2015.5, linetype = 'dotted') +
  # facet against outlet
  facet_wrap(~ outlet * actor, ncol = 3)

ggsave("plots/robustneess_2a_outlets_individually_all_tabloids.png",
  plot_r2a_all_tabloids_individually,
  device = "png",
  width = 16,
  height = 28,
  units = "cm",
  dpi = 300,
  scale = 2
)

ggsave("plots/robustneess_2a_outlets_individually_all_tabloids.pdf",
  plot_r2a_all_tabloids_individually,
  device = "pdf",
  width = 16,
  height = 28,
  units = "cm",
  dpi = 300,
  scale = 2
)
