# This script creates an MDS plot of distances between samples in iHMP 
# metatranscriptome samples where similarities are output of sourmash compare.
setwd("~/github/cosmo-kmers/")
library(dplyr)
library(ggplot2)
library(Rtsne)
library(plotly)
library(latticeExtra)
library(ggExtra)
library(viridis)

info <- read.csv("inputs/hmp2_metadata.csv", stringsAsFactors = F) 
info <- filter(info, data_type == "metatranscriptomics")

mtx_comp <- read.csv("sandbox/comp/mtx_comp.csv")
colnames(mtx_comp) <- gsub("X.gather.2017.paper.gather.ihmp.inputs.data.", "",
                           colnames(mtx_comp)) # abbrev col names
colnames(mtx_comp) <- gsub(".fastq.gz", "", colnames(mtx_comp)) # abrev colnames
rownames(mtx_comp) <- colnames(mtx_comp) # Label the rows
mtx_comp <- as.matrix(mtx_comp) # transform to matrix for dist calc


# PCoA/MDS plot -----------------------------------------------------------
# all samples, not just those with metadata
# mtx_dist <- dist(mtx_comp)
# mtx_dist <- cmdscale(mtx_dist, eig = T)
# mtx_dist_all <- as.data.frame(mtx_dist$points)
# mtx_dist_all$sample <- rownames(mtx_dist_all)
# mtx_dist_all <- left_join(mtx_dist_all, info, by = c("sample" = "External.ID"))
# 
# # percent variance explained:
# var <- round(mtx_dist$eig*100/sum(mtx_dist$eig), 1)
# 
# p <- ggplot(mtx_dist_all, #%>%
#          #filter(data_type == "metatranscriptomics"), 
#        aes(x = V1, y = V2, color = diagnosis)) +
#   geom_point() +
#   theme_minimal() +
#   labs(x = paste0("PCo 1 (", var[1], "%)"), 
#        y = paste0("PCo 2 (", var[2], "%)"),
#        title = "Metatranscriptome MinHashes") +
#   scale_color_viridis_d()
#   
# p <- ggExtra::ggMarginal(p, type = "density", groupColour = T, groupFill = T)

# tsne --------------------------------------------------------------------

# tsne all samples, not just those with metadata
# mtx_tsne <- Rtsne(mtx_comp, check_duplicates=FALSE, 
#                   pca=TRUE, perplexity=5, theta=0.5, dims=2)
# mtx_tsne_y <- as.data.frame(mtx_tsne$Y) 
# mtx_tsne_y$sample <- rownames(mtx_comp)
# mtx_tsne_y <- left_join(mtx_tsne_y, info, by = c("sample" = "External.ID"))
# p <- ggplot(mtx_tsne_y %>%
#          filter(data_type == "metatranscriptomics"), 
#        aes(x = V1, y = V2, color = diagnosis, label = Participant.ID)) +
#   geom_point() +
#   theme_minimal() +
#   scale_color_viridis_d()

# subsetting to those samples annotated in metadata -----------------------

mtx_info <- info %>% 
  filter(External.ID %in% colnames(mtx_comp))

mtx_comp_filt <- as.data.frame(mtx_comp) %>%
  select(mtx_info$External.ID) %>%                          # select columns
  t() %>%                                                   # transpose
  as.data.frame() %>%
  select(mtx_info$External.ID) %>%                          # select cols again
  t() %>%
  as.data.frame()

# mds filt ----------------------------------------------------------------

mtx_dist <- dist(mtx_comp_filt)
mtx_dist <- cmdscale(mtx_dist, eig = T)
mtx_dist_all <- as.data.frame(mtx_dist$points)
mtx_dist_all$sample <- rownames(mtx_dist_all)
mtx_dist_all <- left_join(mtx_dist_all, info, by = c("sample" = "External.ID"))

# percent variance explained:
var <- round(mtx_dist$eig*100/sum(mtx_dist$eig), 1)

mtx_pcoa_plt <- ggplot(mtx_dist_all, #%>%
            #filter(data_type == "metatranscriptomics"), 
            aes(x = V1, y = V2, color = diagnosis)) +
  geom_point() +
  theme_minimal() +
  labs(x = paste0("PCo 1 (", var[1], "%)"), 
       y = paste0("PCo 2 (", var[2], "%)"),
       title = "Metatranscriptome MinHashes")  +
  scale_color_viridis_d() +
  theme(legend.position = "none")

mtx_pcoa_plt <- ggExtra::ggMarginal(mtx_pcoa_plt, type = "density",
                                   groupColour = T, groupFill = T)

# pdf("sandbox/comp/mtx_pcoa.pdf", height = 4, width = 5)
# mtx_pcoa_plt
# dev.off()

# tsne filt ---------------------------------------------------------------

mtx_tsne <- Rtsne(mtx_comp_filt, check_duplicates=FALSE, 
                  pca=TRUE, perplexity=5, theta=0.5, dims=2)
mtx_tsne_y <- as.data.frame(mtx_tsne$Y) 
mtx_tsne_y$sample <- rownames(mtx_comp_filt)
mtx_tsne_y <- left_join(mtx_tsne_y, info, by = c("sample" = "External.ID"))
mtx_tsne_plt <- ggplot(mtx_tsne_y %>%
              filter(data_type == "metatranscriptomics"), 
            aes(x = V1, y = V2, color = diagnosis, label = Participant.ID)) +
  geom_point() +
  theme_minimal()  +
  labs(x = paste0("t-SNE 1"), 
       y = paste0("t-SNE 2")) + #,
       # title = "Metatranscriptome MinHashes") +
  scale_color_viridis_d()

# pdf("sandbox/comp/mtx_tsne.pdf", height = 4, width = 5)
# mtx_tsne_plt
# dev.off()
