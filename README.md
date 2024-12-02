
module load snakemake Miniforge3

snakemake --workflow-profile Profiles/Slurm all_salmon
