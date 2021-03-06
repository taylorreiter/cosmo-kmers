# Try DESeq2 for differential expression with k-mers 
#  full = formula(~ Time + Treat + Time:Treat), reduced = formula(~ Time)

setwd("~/github/cosmo-kmers")
library(dplyr)
library(limma)
library(edgeR)
library(ggplot2)


mtx <- readRDS("sandbox/mtx_sig_csv_10k/mtx_hash_table_10k.RDS")
mtx_colnames <- mtx$sample
rownames(mtx) <- mtx$sample
mtx <- mtx[ , -1]
mtx <- t(mtx)
colnames(mtx) <- mtx_colnames

info <- read.csv("inputs/hmp2_metadata.csv")
info <- info %>%
  filter(data_type == "metatranscriptomics") %>%
  filter(External.ID %in% colnames(mtx)) %>% 
  select(External.ID, diagnosis, Participant.ID)

info <- info[match(colnames(mtx), info$External.ID), ] # match order of mtx
rownames(info) <- info$External.ID
info <- info[ , 2:3]
all(rownames(info) %in% colnames(mtx))
all(rownames(info) == colnames(mtx))

## Why we cannot use DESeq2 with this experimental design:
# https://support.bioconductor.org/p/91445/
# Consider data that look like the following:
# Condition CellLine
# Control       C1
# Control       C1
# Control       C1
# Control       C2
# Control       C2
# Control       C2
# Disease       D1
# Disease       D1
# Disease       D1
# Disease       D2
# Disease       D2
# Disease       D2
# The problem with the design is that you can't use fixed effects to control for
# cell line, and then to test the condition, because these variables are 
# perfectly confounded. So you can't attempt this with DESeq2 or other packages 
# that only offer fixed effects modeling.
#
# You have to take an alternate approach with such a design, if you want to 
# control for cell line, which is to inform the model that there are 
# correlations within cell lines. A package which let's you do this is limma, 
# with the duplicateCorrelation() function. So you should look up the voom and
# limma workflow for analyzing RNA-seq data, and then look up the 
# duplicateCorrelation function.


diagnosis <- factor(info$diagnosis)
design <- model.matrix(~ 0 + diagnosis)
colnames(design) <- levels(diagnosis)

dge <- DGEList(counts = mtx, group = diagnosis)

# remove  rows  that  consistently  have  zero  or  very  low  counts.   
keep <- filterByExpr(dge, design, min.count = 5, min.total.count = 5)
dge <- dge[keep, , keep.lib.sizes=FALSE]
dim(dge)
voom(dge, design, plot = T)
dge <- calcNormFactors(dge)
# plotMDS(dge, col = as.numeric(diagnosis), labels = diagnosis)
y <- voom(dge, design)

# Estimate the correlation between measurements made on the same subject: 
corfit <- duplicateCorrelation(y, design, block = info$Participant.ID)
corfit$consensus
# inter-subject correlation is input into the linear model fit:
fit <- lmFit(y, design, block = info$Participant.ID, 
             correlation=corfit$consensus)

# make any comparisons between the experimental conditions:
cm <- makeContrasts(UCvsCD = CD-UC,
                    UCvsNon = nonIBD-UC, 
                    CDvsNon = nonIBD-CD,
                    levels=design)
# compute these contrasts and moderated t-tests:
fit2 <- contrasts.fit(fit, cm)
fit2 <- eBayes(fit2)
ucvsnon <- topTable(fit2, coef="UCvsNon", p.value = .1, number = dim(dge)[1])
cdvsnon <- topTable(fit2, coef="CDvsNon", p.value = .1, number = dim(dge)[1])
# topTable(fit2, coef="UCvsCD")

dim(ucvsnon)
dim(cdvsnon)

# Were any of the tested k-mers unknown?
unknown <- read.table("sandbox/mtx_unk_hashes/mtx_unk_hashes.txt")
unknown <- as.character(unknown$V1)

unknown_uc <-ucvsnon[rownames(ucvsnon) %in% unknown, ]
unknown_cd <-cdvsnon[rownames(cdvsnon) %in% unknown, ]

unk_cosmo <- read.table("outputs/cosmo/hmp_2k_t138_mtx.labels.txt")
unk_cosmo <- as.character(unk_cosmo$V1)
cosmo_uc <-ucvsnon[rownames(ucvsnon) %in% unk_cosmo, ]
cosmo_cd <-cdvsnon[rownames(cdvsnon) %in% unk_cosmo, ]

dge$counts[rownames(dge$counts == "1415139327400663"), ]
boxplot(1415139327400663 ~ diagnosis, data=dge$counts)

# heatmap -----------------------------------------------------------------

logCPM <- cpm(dge, prior.count=2, log=TRUE)
# colnames(logCPM) <- dge$samples$group
logCPM <- logCPM[rownames(logCPM) %in% rownames(cdvsnon), ]
#pdf(file= "Rplot1.pdf", width = 150, height = 6)
#coolmap(logCPM, "expression level", sepwidth=c(0.01,0.01), 
#        offsetRow = .1, lhei = .01,
#        offsetCol = .1)
#dev.off()

library(pheatmap)
pheatmap(logCPM)

mat_col <- data.frame(diagnosis = dge$samples$group)
rownames(mat_col) <- rownames(dge$samples)
tmp_pal <- brewer.pal(12, "Paired")
mat_colors <- list(diagnosis = tmp_pal[c(11, 12, 2)])
names(mat_colors$diagnosis) <- unique(mat_col$diagnosis)

# fiter to just CD and non-ibd samples
nonUC_samples <- dge$samples[dge$samples$group != "UC", ]
head(nonUC_samples)

logCPM_nonUC <- logCPM %>%
  as.data.frame() %>%
  select(colnames(logCPM)[colnames(logCPM) %in% rownames(nonUC_samples)]) %>%
  as.matrix()

mat_col <- data.frame(diagnosis = nonUC_samples$group)
rownames(mat_col) <- rownames(nonUC_samples)
tmp_pal <- brewer.pal(12, "Paired")
mat_colors <- list(diagnosis = tmp_pal[c(11, 2)])
names(mat_colors$diagnosis) <- unique(mat_col$diagnosis)

pheatmap(mat                  = logCPM_nonUC, 
         show_rownames        = F,
         show_colnames        = F, 
         cluster_rows         = T, 
         cluster_cols         = T,
         color                = inferno(14),
         annotation_col       = mat_col,
         annotation_colors    = mat_colors,
         fontsize             = 14,
         annotation_names_row = T)
