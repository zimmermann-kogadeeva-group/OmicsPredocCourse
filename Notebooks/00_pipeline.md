
# RNASeq pipeline

The pipeline we will be using is outlined in the schematic diagram below.

![pipeline](../Data/pipeline.png)

We first use the [trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)
to remove the illumna adapters and then use
[salmon](https://salmon.readthedocs.io/en/latest/salmon.html) to quantify the
transcripts in the sequencing data for each sample.

The pipeline itself was implemented in
[snakemake](https://snakemake.readthedocs.io/en/stable/) workflow manager that
lets us tie together different tools or scripts and automate the submission
process to the cluster. You can see the code the pipeline [here](../Snakefile).

When the pipeline will finish, we will move on to running differential
expression analysis using `DESeq2` in notebook
[01_diff_expr_analysis](01_diff_expr_analysis.Rmd). Please open rstudio on
[jupyterhub](https://jupyterhub.embl.de) and open OmicsPredocCourse project
from recent projects. Then, open notebook
`Notebooks/01_diff_expr_analysis.Rmd`.
