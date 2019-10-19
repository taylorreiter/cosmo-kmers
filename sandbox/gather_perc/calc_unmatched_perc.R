setwd("~/github/cosmo-kmers/")
# for infile in gather/*gather
# do
# echo $infile > filename.txt
# cat ${infile} | cut -d "," -f 4 | paste -sd+ - | bc > file_perc.txt
# paste -d"," filename.txt file_perc.txt >> gather_human_micro_perc.txt
# done
# 
# for infile in genbank/*gather
# do
# echo $infile > filename.txt
# cat ${infile} | cut -d "," -f 4 | paste -sd+ - | bc > file_perc.txt
# paste -d"," filename.txt file_perc.txt >> gather_genbank_perc.txt
# done

perc <- read.csv("sandbox/gather_perc/gather_percs.csv", stringsAsFactors = F)
head(perc)
perc$unmatched <- (1 - perc$perc_match_genbank)*(1-perc$perc_matched_human_micro)
mean(perc$unmatched, na.rm = T)
sd(perc$unmatched, na.rm = T)
