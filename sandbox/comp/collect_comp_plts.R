setwd("~/github/cosmo-kmers/")

library(ggpubr)
library(dplyr)
library(ggplot2)
library(Rtsne)
library(plotly)
library(latticeExtra)
library(ggExtra)
library(viridis)
library(gridExtra)

source("sandbox/comp/mgx_viz.R")
source("sandbox/comp/mtx_viz.R")

plt_all <- ggarrange(as_ggplot(mgx_pcoa_plt), as_ggplot(mtx_pcoa_plt), mgx_tsne_plt, mtx_tsne_plt,
                     labels = c("A", "B", "C", "D"),
                     nrow = 2, ncol =2,
                     common.legend = TRUE, legend="right",
                     heights = c(3, 2.3))

pdf("sandbox/comp/minhash-comp-plts.pdf", height = 8.22, width = 6.77)
plt_all 
dev.off()

