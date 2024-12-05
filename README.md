
# Omics predoc course 2024

Welcome to the omics practical! 

Below you will find the background information on the project which this
practical is based on.

## Background

Collaboration with Dr. Baharak Babouee Flury, MD, Infectiologist from
Kantonsspital St. Gallen, Switzerland.

**Goal**: Investigate potential mechanisms of antibiotic resistance development
and cross-resistance in Pseudomonas aeruginosa strains isolated form patient
samples.

**Study design**:

1. Eight strains of P. aeruginosa were isolated from patient samples. Strain
   IDs: 083.2, 090.3, 095.3, 678.3, 804.2, 816.3
2. Strains were passaged in either of the two antibiotics: ceftazidime
   avibactam and meropenem.
3. After 18 days of passageing, the evolved strains were collected. For each
   strain, the parent strain, strain evolved in meropenem, and strain evolved
   in ceftazidime avibactam (ID with P, M or C) were tested for resistance to
   meropenem and ceftazidime (MIC, minimal inhibitory concentration, was
   calculated for each strain in each drug).
4. Each of the three versions of the six strains were profiled as follows:
    1. Full genome sequencing to identify mutations
    2. Transcriptomic analysis
    3. Proteomic analysis

The schematic diagram of the experimental setup
![exp_setup](./Data/exp_setup.png)

## Setup

First, access the one of the login nodes on the cluster using ssh. 

On the login node run the following to use the tools needed for this practical:
```
module load git-lfs snakemake Miniforge3
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

### Conda setup

We setup the conda environment with the following two commands:
```
eval "$(conda shell.bash hook)" &&
conda create -n omics_predoc_course -c bioconda -c conda-forge python==3.11 jupyterlab ipympl pandas requests scikit-learn seaborn matplotlib diskcache
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

### Data

The raw transcriptomics reads can be found on the cluster at
`/scratch/omics_predoc_course/Data/Transcriptomics`. Use the following command
to access this data from your folder:
```
ln -s /scratch/omics_predoc_course/Data/Transcriptomics/ /scratch/$USER/OmicsPredocCourse/Data/Transcriptomics
```

## Running the transcriptomics pipeline

Go into the project folder and run snakemake pipeline:
```
module load snakemake Miniforge3
cd ~/scratch/OmicsPredocCourse/
snakemake --workflow-profile Profiles/Slurm
```

**Note: you can switch between rstudio and jupyter-lab on jupyterhub.embl.de by
going to <https://jupyterhub.embl.de/hub/home>.**


