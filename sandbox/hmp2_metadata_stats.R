setwd("~/github/cosmo-kmers/")
library(dplyr)
meta <- read.csv("inputs/hmp2_metadata.csv", stringsAsFactors = F)

## calc max number of observations per participant in MGX and MTX
mtx <- meta %>%
  filter(data_type =="metatranscriptomics")

mtx_num_part <- mtx %>% 
  group_by(Participant.ID) %>%
  tally

mgx <- meta %>%
  filter(data_type == "metagenomics")
  
mgx_num_part <- mgx %>% 
  group_by(Participant.ID) %>%
  tally

length(unique(meta$Participant.ID))