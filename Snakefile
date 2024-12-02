
from pathlib import Path

configfile: "config.json"

rule all:
    input:
        quant_files = expand(
            "Output/Quants/{f}/quant.sf", f=config["transcriptomics"]
        )
        "Output/QC/multiqc_report.html",

rule fastqc:
    input:
        "Data/Transcriptomics/Raw/{filename}.fastq.gz"
    output:
        "Output/QC/{filename}_fastqc.html"
    conda:
        "Envs/qc.yaml"
    shell:
        "fastqc {input} -o Output/QC/"

rule multiqc:
    input:
        expand(
            "Output/QC/{f}_L{lane}_fastqc.html", 
            f=config["transcriptomics"], 
            lane=[1, 2]
        )
    output:
        "Output/QC/multiqc_report.html",
        directory("Output/QC/multiqc_data/")
    conda:
        "Envs/qc.yaml"
    shell:
        "multiqc Output/QC/ -o Output/QC/"

rule run_trimmomatic:
    input:
        adapter="Data/illumina_adapters.fasta",
        fastq="Data/{path_to_file}.fastq.gz"
    output:
        temp("Output/TrimmedReads/{path_to_file}.fastq.gz")
    params:
        trim_opts = lambda wildcards, input :  
            f"ILLUMINACLIP:{input.adapter}:2:30:10 "
            "LEADING:3 "
            "TRAILING:3 "
            "SLIDINGWINDOW:4:15 "
            "MINLEN:36"
    conda:
        "Envs/salmon.yaml"
    resources:
        runtime = 90
    shell:
        "trimmomatic SE -phred33 {input.fastq} {output} {params.trim_opts}"

rule merge:
    input:
        l1="Output/TrimmedReads/{path_to_file}_L1.fastq.gz",
        l2="Output/TrimmedReads/{path_to_file}_L2.fastq.gz"
    output:
        merged=temp("Output/Merged/{path_to_file}_merged.fastq.gz")
    shell:
        "cat {input.l1} {input.l2} > {output.merged}"

rule salmon_index:
    input:
        "Data/reference.fa.gz"
    output:
        directory("Output/SalmonIndex")
    conda:
        "Envs/salmon.yaml"
    shell:
        "salmon index -t {input} -i {output}"

rule salmon_quant:
    input:
        index="Output/SalmonIndex",
        reads="Output/Merged/Transcriptomics/{filename}_merged.fastq.gz",
    output:
        counts="Output/Quants/{filename}/quant.sf"
    conda:
        "Envs/salmon.yaml"
    params:
        outdir = lambda wildcards, output : Path(output[0]).parent,
        salmon = "-l A -p 1 --gcBias --validateMappings"
    shell:
        "salmon quant -i {input.index} {params.salmon} -r {input.reads} -o {params.outdir}"

