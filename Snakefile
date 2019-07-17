include: 'snakefiles/data.snakefile'
include: 'snakefiles/classify.snakefile'

# variable SAMPLES defined in `snakefiles/classify.snakefile`
rule all:
    input:
        expand('outputs/gather/matches/{sample}.matches', sample = SAMPLES),
        expand('outputs/gather/unassigned/{sample}.un', sample = SAMPLES),
