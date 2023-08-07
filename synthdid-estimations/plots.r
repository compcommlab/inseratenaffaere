library(synthdid)
library(ggplot2)
library(ggthemes)
library(viridis)

actors <- c("Strache", "Kurz", "Mitterlehner")

for (a in actors) {
    results <- readRDS(paste0("results/3a_synthdid_", a, "_total.RDS"))


    p <- synthdid::synthdid_plot(results, overlay = 0.99) +
        scale_alpha(range = c(0, 1), guide = "none") +
        theme_clean() +
        theme(
            legend.position = "top",
            plot.background = element_rect(color = NA)
        ) +
        scale_color_viridis(discrete = TRUE, option = "magma", end = 0.6) +
        scale_fill_viridis(discrete = TRUE, option = "magma", end = 0.6) +
        geom_vline(xintercept = 2015)

    ggsave(paste0("plots/3a_synthdid_", a, "_total.png"),
        p,
        device = "png",
        width = 16,
        height = 9,
        units = "cm",
        dpi = 300,
        scale = 2
    )
    ggsave(paste0("plots/3a_synthdid_", a, "_total.pdf"),
        p,
        device = "pdf",
        width = 16,
        height = 9,
        units = "cm",
        dpi = 300,
        scale = 2
    )
}
