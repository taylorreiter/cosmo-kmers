include: 'snakefiles/data.snakefile'
include: 'snakefiles/classify.snakefile'

rule all:
    input:
        #expand('inputs/data/{sample}.fastq.gz', sample = SAMPLES)
        expand('outputs/gather_human_micro/unassigned/{sample}.un', sample = SAMPLES)    
        #expand('outputs/gather/matches/{sample}.matches', sample = SAMPLES),
        #expand('outputs/gather/unassigned/{sample}.un', sample = SAMPLES)
