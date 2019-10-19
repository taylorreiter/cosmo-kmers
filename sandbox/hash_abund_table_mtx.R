setwd("~/github/cosmo-kmers/")

library(dplyr)
library(data.table)

# filter files to those with metadata
files_keep <- list.files("sandbox/mtx_sig_csv_10k", pattern = ".csv$")
files_keep <- gsub(".scaled2k_10k.csv", "", files_keep)
info <- read.csv("inputs/hmp2_metadata.csv", stringsAsFactors = F)
info_meta <- info %>%
  filter(data_type == "metatranscriptomics") %>%
  filter(External.ID %in% files_keep)
files_keep <- files_keep %in% info_meta$External.ID
files <- list.files("sandbox/mtx_sig_csv_10k", pattern = ".csv$", full.names = T)
files <- files[files_keep]

# read files into list with each row labelled by sample. 
mtx_long <- list()
for(i in 1:length(files)){
  sig <- read.csv(files[i])
  sample <- colnames(sig)[2]
  sample <- gsub(".scaled2k_10k.sig", "", sample)
  sig$sample <- sample
  colnames(sig) <- c("minhash", "abund", "sample")
  mtx_long[[i]] <- sig
}

# bind into one dataframe
mtx_long <- do.call(rbind, mtx_long)

# transform from long to wide with data.table
mtx_long <- as.data.table(mtx_long)
mtx_wide <- dcast.data.table(mtx_long, sample ~ minhash, 
                             fill = 0, drop=FALSE, value.var = "abund")

fwrite(x = mtx_wide, file = "sandbox/mtx_sig_csv_10k/mtx_hash_table_10k.csv")
saveRDS(mtx_wide, file = "sandbox/mtx_sig_csv_10k/mtx_hash_table_10k.RDS")
