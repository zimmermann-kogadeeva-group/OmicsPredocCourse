
# RNASeq pipeline

The pipeline we will be using is outlined in the schematic diagram below. There
are two parts to this pipeline: one for QC, which uses fastqc and multiqc, and
one for reads quantification, which uses trimmomatic and salmon.

![pipeline](../Data/pipeline.png)

## Snakemake

The pipeline itself was implemented in
[snakemake](https://snakemake.readthedocs.io/en/stable/) workflow manager that
lets us tie together different tools or scripts and automate the submission
process to the cluster. More resources on snakemake are available
[here](https://carpentries-incubator.github.io/snakemake-novice-bioinformatics/01-introduction.html)
and [here](https://snakemake.readthedocs.io/en/stable/index.html). 

In brief, a Snakemake workflow is defined by specifying rules in a Snakefile.
Rules decompose the workflow into small steps (for example, the application of
a single tool) by specifying how to create sets of output files from sets of
input files. Snakemake automatically determines the dependencies between the
rules by matching file names. You can see the rules in our pipeline
[here](../Snakefile).

## QC

As shown in the diagram above, part of the pipeline is used to do quality
control of the raw transcriptomics data.
[Fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
generates QC reports on a per sample bases and all of these are combined into a
single report with the use of [multiqc](https://seqera.io/multiqc/).
[Here](https://hbctraining.github.io/Intro-to-rnaseq-hpc-salmon/lessons/qc_fastqc_assessment.html)
is a good resource on RNASeq QC.

In the mutliqc report, there might be some yellow warnings or even red fails
for some sample, but these should not be taken too seriously; they should be
interpreted as samples for further investigation.

Further within the mutliqc report, in the "General statistics" section, it is
worth checking that all the numbers are as expected, such as the total number
of sequences or GC content. The following section shows sequence counts, which
shows us the number duplicated and unique reads. 

One of the most important plots in the report is the mean quality scores, which
give quality of the reads per base pair of the reads. With this plot we can
catch various errors including ones from sequencing isues, such as
overclustering of the flow cells or sequencer failure mid-run. Per sequence
quality scores plot gives us an overview of sequence quality in all samples,
where we do not want a peak at the low score end of the graph.

Per sequence GC content will almost always fail for RNAseq data. Though, the
distributions in this plot should look normally distributed. If the
distributions in this plot do not look normally distributed, it could indicate
either contamination or higly over-expressed gene.

The rest of the plots look at over-represented or duplicated sequences, which
can help us identify any contaminated sequences.

## Reads quantification

In the reads quantification part of our pipeline, we first use the
[trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)[^1] to remove the
illumna adapters. This is to make sure that these adapters do not interfere
with quantification.

The quantification of reads is done using
[salmon](https://salmon.readthedocs.io/en/latest/salmon.html)[^2], which unlike
traditional aligners, uses a method called pseudo-alignment that identifies the
set of transcripts that are compatible with each sequencing read without
performing base-by-base alignment. The benefit of the approach that it is much
faster than traditional alignment tools such as HISAT2 or STAR, while still
being accurate.

## Next steps

**Task**: have a look at the outputs of both parts of the pipeline *i.e.*
`Output/QC/mutliqc_report.html` and `Output/Quants/083.2/quants.sf` to
familiarize yourself with the data.

When the pipeline will finish, we will move on to running differential
expression analysis using
[DESeq2](https://bioconductor.org/packages/release/bioc/html/DESeq2.html)[^3]
in notebook [01_diff_expr_analysis](01_diff_expr_analysis.Rmd). 

1. Go to <https://jupyterhub.embl.de> and if rstudio does not show up, select
   **rstudio 4.4** environment from dropdown menu under **Coding environment**
   section
2. Open **OmicsPredocCourse** project from recent projects 
3. Open notebook **Notebooks/01_diff_expr_analysis.Rmd** in bottom right panel

[^1]: Bolger, A. M., Lohse, M., & Usadel, B. "Trimmomatic: A flexible trimmer for Illumina Sequence Data." (2014). Bioinformatics, btu170.

[^2]: Patro, R., et al. "Salmon provides fast and bias-aware quantification of transcript expression." Nature Methods (2017). Advanced Online Publication. doi: 10.1038/nmeth.4197..

[^3]: Love, M. I., Huber, W., Anders, S.  "Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2." Genome Biology (2014). 15, 550. doi:10.1186/s13059-014-0550-8. 
