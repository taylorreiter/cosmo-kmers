include: 'snakefiles/data.snakefile'
include: 'snakefiles/classify.snakefile'
include: 'snakefiles/mgx.snakefile'

rule all:
    input:
        #expand('inputs/data/{sample}.fastq.gz', sample = SAMPLES)
        #expand('outputs/gather_human_micro/unassigned/{sample}.un', sample = SAMPLES)
        #"outputs/cosmo/hmp_2k_t138_mtx.labels.txt", 
        #expand('outputs/mgx_sigs/{sample}_mgx.scaled2k.sig', sample = SAMPLES),
        #"outputs/cosmo/hmp_2k_t138_mgx.labels.txt"
        dynamic(expand("{sample}_k31_r1_hashval_k51/{{hash}}.cdbg_ids.reads.fa.gz", sample = SAMPLES)) 
