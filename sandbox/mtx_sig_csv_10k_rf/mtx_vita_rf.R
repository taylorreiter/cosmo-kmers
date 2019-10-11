setwd("~/github/cosmo-kmers/")

remotes::install_github("silkeszy/Pomona")
library(Pomona)
library(ranger)
library(dplyr)
library(randomForest)

set.seed(1)

# perform variable selection within random forests on MTX minhashes. 
# Uses the Pomona package vita implementation, which wraps the ranger package.
# With selected variables, perform rfPermute later. Save output as RDS for
# easy loading of output objects into subsequent R sessions. 


## read in data ------------------------------------------------------------

## format hash table (samples x features)
mtx <- readRDS("sandbox/mtx_sig_csv_10k/mtx_hash_table_10k.RDS")
# mtx <- readRDS("mtx_hash_table_10k.RDS")

mtx <- as.data.frame(mtx)  # convert to a dataframe
rownames(mtx) <- mtx[ , 1] # set rownames as sample names
mtx <- mtx[ , -1]          # remove sample names from df

## format classification vector
info <- read.csv("inputs/hmp2_metadata.csv", stringsAsFactors =F)
info <- info %>%
  filter(data_type == "metatranscriptomics") %>% # filter to metatranscriptomes  
  filter(External.ID %in% rownames(mtx))         # filter to observations in mtx
info <- info[match(rownames(mtx), info$External.ID), ] # match order of classification to mtx
diagnosis <- info$diagnosis # make diagnosis var

## split to test and train
train <- sample(nrow(mtx), 0.7*nrow(mtx), replace = FALSE)
train_set <- mtx[train, ]
test_set <- mtx[-train, ]

diagnosis_train <- diagnosis[train]
diagnosis_test <- diagnosis[-train]

# run vita ----------------------------------------------------------------
# this was run on jetstream.
print("All inputs formatted. Running VITA now.")

## perform variant selection
## var.sel.vita calculates p-values based on the empirical null distribution 
## from non-positive VIMs as described in Janitza et al. (2015). 
mtx_vita <- var.sel.vita(x = train_set, y = diagnosis_train, p.t = 0.05, 
                         ntree = 5000, mtry.prop = 0.2, nodesize.prop = 0.1, 
                         no.threads = 10, method = "ranger", 
                         type = "classification")
saveRDS(mtx_vita, "sandbox/mtx_sig_csv_10k_rf/mtx_vita.RDS")



# build rf with sel feat ---------------------------------------------------
mtx_vita <- readRDS("sandbox/mtx_sig_csv_10k_rf/mtx_vita.RDS")

var <- mtx_vita$var       # separate out selected predictive hashes
var <- gsub("X", "", var) # remove the X from the beginning of hashes
mtx_filt <- mtx[ , colnames(mtx) %in% var] # subset mtx to hashes in mtx_vita


# vita <- mtx[ , mtx_vita$var] # filter counts to selected var
# vita$var <- var # make regression variable a column
# vita <- as.matrix(vita) # transform back to matrix

## Run random forest reg on var sel
# split the dataset into train and validation set in the ratio 70:30
train <- sample(nrow(mtx_filt), 0.7*nrow(mtx_filt), replace = FALSE)
train_set <- mtx_filt[train, ]
test_set <- mtx_filt[-train, ]
diagnosis_train <- diagnosis[train]
diagnosis_test <- diagnosis[-train]

mtx_filt_rf <- randomForest(x = train_set, y = as.factor(diagnosis_train), 
                            importance = TRUE)
mtx_filt_rf # look at the model
saveRDS(mtx_filt_rf, "sandbox/mtx_sig_csv_10k_rf/mtx_filt_rf.RDS")
# predict train
predValid <- predict(mtx_filt_rf, train_set, type = "class")
mean(predValid == ValidSet$site) # 0.6428571
table(predValid, ValidSet$site)

pred_train <- predict(mtx_filt_rf, train_set)
table(observed = diagnosis_train, predicted = pred_train)

# predicted
# observed  CD nonIBD  UC
# CD     238      0   0
# nonIBD   1    138   0
# UC       0      0 152

pred_test <- predict(mtx_filt_rf, test_set)
table(observed = diagnosis_test, predicted = pred_test) 

# predicted
# observed  CD nonIBD  UC
# CD     109      0   0
# nonIBD   3     49   1
# UC       7      1  57

varImpPlot(mtx_filt_rf)

