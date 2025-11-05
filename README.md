
# Omics predoc course 2025

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

This mini-project is based on this publication: 
<https://journals.asm.org/doi/full/10.1128/mbio.03896-24>

## Setup

First, access the one of the login nodes on the cluster using ssh. On
MacOS/linux open terminal and on Windows open command line (type `cmd` in the search field upon pressing the Start button) 
or powershell or WSL and run 
```
ssh <your_embl_username>@login1.cluster.embl.de
```
Alternatively, use
[PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) with
`<your_embl_username>@login1.cluster.embl.de` as the host name.

On the login node run the following to use the tools needed for this practical:
```
module load git-lfs Miniforge3
```
Then we make sure that conda and git settings are correct with:
```
conda config --remove channels defaults
conda config --remove channels r
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict
git lfs install
```
Go to scratch and make your own folder (if you don't have one already). The following commands make a new directory (`mkdir`), 
make a symbolic link to this directory called "scratch" in the home directory (`ln -s`) and change to the scratch directory (`cd`):
```
mkdir -p /scratch/$USER/
ln -s /scratch/$USER/ $HOME/scratch 
cd scratch
```
Then clone the git repository:
```
git clone https://git.embl.de/grp-zimmermann-kogadeeva/OmicsPredocCourse.git
cd OmicsPredocCourse/
```

The raw transcriptomics reads can be found on the cluster at
`/scratch/omics_predoc_course/Data/Transcriptomics`. Use the following command (which makes a symbolic link to the data folder 
in your current folder) to be able to access this data from your folder:
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
module load snakemake Miniforge3
eval "$(conda shell.bash hook)"
snakemake --workflow-profile Profiles/Slurm
```
The pipeline will be discussed in [here](Notebooks/00_pipeline.md). But before
we move on there, let's setup up our conda and R environments for later.

### Conda setup

Create a new tmux window by pressing `Ctrl+b c`. We use tmux here to setup the
conda environment in parallel with snakemake pipeline. Few useful keyboard
shortcuts are:
- create a window with `Ctrl+b c`
- to switch between windows use `Ctrl+b n` or `Ctrl+b p`. 
- to exit a session **without** closing (*.i.e.* detaching) use `Ctrl+b d`
- to get back to a session type `tmux attach`

Within the new tmux window, we setup the conda environment with the following
three commands:
```
module load Miniforge3
eval "$(conda shell.bash hook)"
conda create -n omics_predoc_course python==3.11 jupyterlab ipympl pandas requests scikit-learn seaborn matplotlib diskcache
```

Then register the new jupyter kernel with jupyterhub:
```
conda activate omics_predoc_course
python3 -m ipykernel install --user --name "omics_predoc_course"
```

### R setup

1. Open <https://jupyterhub.embl.de>  
2. Select **rstudio 4.4** environment from dropdown menu under **Coding environment** section
3. In rstudio click on **File -> New Project -> Existing Directory** and select
   **scratch/OmicsPredocCourse/**.

We will need `tidyverse` for data manipulation, `tximport` to load the data,
`DESeq2` to perform differential expression analysis and `here` package for
easier file path managment. You can install these with the following command,
which uses the premade `renv.lock` file to install all the specified packages:
```{r}
renv::restore()
```
**Alternatively**, you can install these packages with:
```{r}
renv::install("tidyverse")
renv::install("tximport")
renv::install("bioc::DESeq2")
renv::install("here")
```

**Note: you can switch between rstudio and jupyter-lab on jupyterhub.embl.de by
going to <https://jupyterhub.embl.de/hub/home>.**

Now, let's move on to description of the pipeline [here](Notebooks/00_pipeline.md).
