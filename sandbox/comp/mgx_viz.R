# This script creates an MDS plot of distances between samples in iHMP 
# metagenome samples where similarities are output of sourmash compare.

setwd("~/github/cosmo-kmers/")
library(dplyr)
library(ggplot2)
library(Rtsne)
library(plotly)
library(latticeExtra)
library(ggExtra)
library(viridis)

info <- read.csv("inputs/hmp2_metadata.csv", stringsAsFactors = F) 
info <- filter(info, data_type == "metagenomics")

mgx_comp <- read.csv("sandbox/comp/mgx_comp.csv")
colnames(mgx_comp) <- gsub("_mgx", "", colnames(mgx_comp)) # abbrev col names
rownames(mgx_comp) <- colnames(mgx_comp) # Label the rows
mgx_comp <- as.matrix(mgx_comp) # transform to matrix for dist calc

# PCoA/MDS plot -----------------------------------------------------------

mgx_dist <- dist(mgx_comp)
mgx_dist <- cmdscale(mgx_dist, eig = T)
mgx_dist_all <- as.data.frame(mgx_dist$points)
mgx_dist_all$sample <- rownames(mgx_dist_all)
mgx_dist_all <- left_join(mgx_dist_all, info, by = c("sample" = "External.ID"))

# percent variance explained:
var_mgx <- round(mgx_dist$eig*100/sum(mgx_dist$eig), 1)

mgx_pcoa_plt <- ggplot(mgx_dist_all, aes(x = V1, y = V2, color = diagnosis)) +
  geom_point() +
  theme_minimal() +
  labs(x = paste0("PCo 1 (", var_mgx[1], "%)"), 
       y = paste0("PCo 2 (", var_mgx[2], "%)"),
       title = "Metagenome MinHashes") +
  scale_color_viridis_d() +
  theme(legend.position = "none")

mgx_pcoa_plt <- ggExtra::ggMarginal(mgx_pcoa_plt, type = "density", 
                                    groupColour = T, groupFill = T)

# pdf("sandbox/comp/mgx_pcoa.pdf", height = 4, width = 5)
# mgx_pcoa_plt
# dev.off()

# tsne --------------------------------------------------------------------

mgx_tsne <- Rtsne(mgx_comp, check_duplicates=FALSE, 
                  pca=TRUE, perplexity=5, theta=0.5, dims=2)
mgx_tsne_y <- as.data.frame(mgx_tsne$Y) 
mgx_tsne_y$sample <- rownames(mgx_comp)
mgx_tsne_y <- left_join(mgx_tsne_y, info, by = c("sample" = "External.ID"))
mgx_tsne_plt <- ggplot(mgx_tsne_y %>%
              filter(data_type == "metagenomics"), 
            aes(x = V1, y = V2, color = diagnosis, label = Participant.ID)) +
  geom_point() +
  theme_minimal()   +
  labs(x = paste0("t-SNE 1"), 
       y = paste0("t-SNE 2")) + #,
       #title = "Metagenome MinHashes") +
  scale_color_viridis_d()

# pdf("sandbox/comp/mgx_tsne.pdf", height = 4, width = 5)
# mgx_tsne_plt
# dev.off()

#ggExtra::ggMarginal(p, type = "density", groupColour = T, groupFill = T)
#p
#ggplotly(p)

