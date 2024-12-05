
# Omics predoc course 2024

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

When rstudio updates itself run the following:
```{r}
install.packages('renv')
```
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

## Running the transcriptomics pipeline

Go into the project folder and run snakemake pipeline:
```
module load snakemake Miniforge3
cd ~/scratch/OmicsPredocCourse/
snakemake --workflow-profile Profiles/Slurm
```

**Note: you can switch between rstudio and jupyter-lab on jupyterhub.embl.de by
going to <https://jupyterhub.embl.de/hub/home>.**


