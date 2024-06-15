rm(list=ls( ))

library(dplyr)
library(ggplot2)
library(ggthemes)
library(viridis)
library(knitr)

years <- 2013:2019

results_3a <- readRDS("results/3a_synthdid_year.RDS")

results_3a$pre_treatment <- (results_3a$year < 2016)

results_3a$`Treatment Period` <- factor(ifelse(results_3a$pre_treatment,
                                               'Pre',
                                               'Post'), levels = c('Pre', 'Post'))

plot_3a <- results_3a |>
  rename(ATET = tau_hat) |> 
  ggplot(aes(x=year, y=ATET, 
             color = `Treatment Period`, 
             shape = `Treatment Period`)) +
  # convoluted solution to plot confidence intervals
  geom_segment(aes(xend = year, y = lci, yend = uci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = lci, y = lci)) +
  geom_segment(aes(xend = year + 0.1, x = year - 0.1, yend = uci, y = uci)) +
  # actual point estimates
  geom_point(size=2) +
  # fix year scale
  scale_x_continuous(breaks = years) +
  # theme
  theme_clean() +
  theme(legend.position = "none",  # Remove the legend
        panel.spacing = unit(2, "lines"),
        plot.background = element_rect(color = NA)) +
  geom_hline(yintercept = 0, linetype = 'dashed') +
  # colors for publication
  scale_color_viridis(discrete = TRUE, option = "magma", end = 0.6, direction = -1) +
  # shapes corresponding to the previous graphs
  scale_shape_manual(values=c(17,19)) +
  # scale_color_grey(start = 0, end = 0.4) +
  # show the comparison point
  # geom_vline(xintercept = 2015.5, linetype = 'dotted') +
  # facet against actor
  facet_wrap(~actor)


ggsave("plots/3a_synthdid.png",
       plot_3a,
       device = "png",
       width = 16,
       height = 12,
       units = "cm",
       dpi = 300,
       scale = 2
)


ggsave("plots/3a_synthdid.pdf",
       plot_3a,
       device = "pdf",
       width = 16,
       height = 12,
       units = "cm",
       dpi = 300,
       scale = 2
)

# Table for Appendix of average effect size

results_3a_total <- readRDS("results/3a_synthdid_total.RDS")

results_3a_total$`ATET (se)` <- paste0(round(results_3a_total$tau_hat, 2),
                                       " (",
                                       round(results_3a_total$se, 2),
                                       ")",
                                       ifelse(results_3a_total$pval < 0.001, "***", ""))


knitr::kable(t(results_3a_total[, c("actor", "ATET (se)")]), "latex", booktabs = TRUE)