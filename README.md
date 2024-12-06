
# Omics predoc course 2024

Welcome to the omics practical! 

Below you will find the background information on the project which this
practical is based on.

## Background

**Multi-omics practical with a focus on Bulk RNAseq: Investigating the
mechanisms of antibiotic resistance in human pathogens with multi-omics
approaches (genomics, transcriptomics, proteomics)**

**Scenario**: you are a computational biologist who has set up a collaboration with
a clinical scientist: Dr. Baharak Babouee Flury, MD, Infectiologist from
Kantonsspital St. Gallen, Switzerland.

**Goal**: Your goal is to investigate potential mechanisms of antibiotic resistance
development and cross-resistance in Pseudomonas aeruginosa strains isolated
from patient samples. 

**Data**: The collaborators performed experimental evolution of the isolated
strains under exposure to two different antibiotics, measured antibiotic
resistance levels of the different strains, and collected genomics,
transcriptomics and proteomics measurements for the parent and the evolved
strains. 

**Methods**: 

**You will learn how to:**
- Perform bulk RNAseq analysis (running on the EMBL cluster)
- Manage your code and scripts (with git and SnakeMake pipelines)
- Perform differential analysis of gene expression
- Perform dimensionality reduction with Principal Component Analysis
- Build simple machine learning models to predict antibiotic resistance based on gene expression profiles and identify genes associated with resistance
- (optional) Perform differential analysis of a proteomics dataset
- (optional) Investigate inconsistencies in the experimental data 

The schematic diagram of the experimental setup
![exp_setup](./Data/exp_setup.png)

## Setup

First, access the one of the login nodes on the cluster using ssh. On
MacOS/linux open terminal and on Windows open powershell or WSL and run 
```
ssh <your_embl_username>@login1.cluster.embl.de
```

On the login node run the following to use the tools needed for this practical:
```
module load git-lfs snakemake Miniforge3
```
Then we make sure that conda settings are correct with:
```
conda config --remove channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict
```
Go to scratch and make your own folder with the following commands:
```
mkdir -p /scratch/$USER/ &&
ln -s /scratch/$USER/ $HOME/scratch && 
cd scratch
```
Then clone the git repository:
```
git clone https://git.embl.de/grp-zimmermann-kogadeeva/OmicsPredocCourse.git
```

The raw transcriptomics reads can be found on the cluster at
`/scratch/omics_predoc_course/Data/Transcriptomics`. Use the following command
to access this data from your folder:
```
ln -s /scratch/omics_predoc_course/Data/Transcriptomics/ /scratch/$USER/OmicsPredocCourse/Data/Transcriptomics
```

### Running the transcriptomics pipeline

In the interest of time, we will first start running the pipeline before
discussing it.

To make sure the pipeline is not interrupted by internet issues we will use
`tmux`, which you can start by running:
```
tmux
```
Within the tmux session, run the following three commands to start the pipeline:
```
module load snakemake Miniforge3 git-lfs &&
cd ~/scratch/OmicsPredocCourse/ &&
git lfs install && 
git lfs fetch &&
git lfs checkout &&
snakemake --workflow-profile Profiles/Slurm all_salmon
```
The pipeline will be discussed in [here](Notebooks/00_pipeline.md). But before
we move on there, let's setup up our conda and R environments for later.

### Conda setup

Create a new tmux session by pressing `Ctrl+b c`. Then, in the new shell, we
setup the conda environment with the following three commands:
```
module load Miniforge3 &&
eval "$(conda shell.bash hook)" &&
conda create -n omics_predoc_course --override-channels -c bioconda -c conda-forge python==3.11 jupyterlab ipympl pandas requests scikit-learn seaborn matplotlib diskcache
```

Then register the new jupyter kernel with jupyterhub:
```
conda activate omcis_predoc_course &&
python3 -m ipykernel install --user --name "omics_predoc_course"
```

### R setup

Open <https://jupyterhub.embl.de> and select rstudio 4.4 environment from dropdown menu
under Coding environment section. Then in rstudio click on File -> New Project
-> Existing Directory and select scratch/OmicsPredocCourse/.

We will need `tidyverse` for data manipulation, `tximport` to load the data,
`DESeq2` to perform differential expression analysis and `here` package for
easier file path managment. You can install these with:
```{r}
renv::restore()
```
**or** like so:
```{r}
renv::install("tidyverse")
renv::install("tximport")
renv::install("bioc::DESeq2")
renv::install("here")
```

**Note: you can switch between rstudio and jupyter-lab on jupyterhub.embl.de by
going to <https://jupyterhub.embl.de/hub/home>.**

Now, let's move on to description of the pipeline [here](Notebooks/00_pipeline.md).
