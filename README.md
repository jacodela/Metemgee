# Metemgee

Jacobo de la Cuesta-Zuluaga. August 2026.

`Metemgee` is the workflow for the quality control and profiling of shotgun
metagenomes of the Maier Lab. It takes the raw `fastq` files produced by the
sequencer and returns clean reads, a taxonomic profile and a functional profile
of each sample.

For quality control and removal of host reads it uses the `nf-core` pipeline
`detaxizer`, available [here](https://nf-co.re/detaxizer/). For taxonomic
profiles it uses the `nf-core` pipeline `taxprofiler`, available
[here](https://nf-co.re/taxprofiler). For functional profiles it uses
`mifaser`, found [here](https://bitbucket.org/bromberglab/mifaser).

The notebooks walk you through the download of the software, the
creation of files and the execution of the pipelines.

## Contributors
Some of the notebooks in this repository contain contributions from:
* Alba Nagel-González (`notebooks/01_Sequence_QC.ipynb`)

## Quickstart

1. Clone this repository and move into it:

    ```bash
    git clone https://github.com/Lisa-Maier-Lab/Metemgee
    cd Metemgee
    ```

2. Create the Conda environments (see below). You only need to do this once.
3. Open `notebooks/01_Sequence_QC.ipynb` and follow it. It ends by submitting a
    job to the cluster, which takes several hours. Everything that follows uses
    the clean reads it produces.
4. Once that job has finished, open `notebooks/02_Taxonomic_profile.ipynb`.
5. For the functional profile, open `notebooks/03_Functional_profile_mifaser.ipynb`.
    
*Note* that Notebooks 02 and 03 are independent of each other, so you can run
them separately.

## Requirements for Running the Notebooks
### Jupyter Notebook
To successfully execute the notebooks in this repository, you
will need to have Jupyter Notebook installed on your system.
You can run Jupyter Notebooks in two ways:

* Using VSCode (Recommended): you can run Jupyter Notebooks
    within Visual Studio Code, which provides a user-friendly
    interface for working with notebooks. If you use this, make
    sure to install the `Remote - SSH` and `Jupyter` extensions

* Standalone Installation: you can install Jupyter Notebook
    independently and run notebooks from your local environment.

The notebooks are written in R, not Python. Once you open one, click the
kernel selector on the top right and pick the R kernel from the `VScode`
environment.

### Conda
In addition to Jupyter Notebooks, you will need to have the
ability to create and manage Conda environments. Conda is a
package and environment management system that allows you to
install dependencies and manage different project environments
easily.

If you are using this notebook on the M3 HPC you should have
the ability to create Conda environments.

To create the VScode conda environment from the provided YAML file,
run the following command in your terminal:

```bash
conda env create -f envs/VScode.yaml
```

This command will set up a new environment with all the specified packages.
You only need to create the environment once.

To activate the environment after creation, use:

```bash
conda activate VScode
```

YAML files for other Conda environments necessary to execute the pipelines
are provided in the `./envs` folder. Notebooks 01 and 02 need the `Nextflow`
environment and notebook 03 needs `Profiling`. Both are created the same way:

```bash
conda env create -f envs/Nextflow.yaml
conda env create -f envs/Profiling.yaml
```

### Container images
The `nf-core` pipelines download container images the first time they run. To
keep them in one place instead of re-downloading them for every project, create
a folder where to store the container images and add the following to your 
`~/.bashrc`, changing the path to your own, and open a new terminal afterwards:

```bash
export NXF_SINGULARITY_CACHEDIR="/mnt/lustre/groups/maier/YOUR_M3HPC_USERNAME/bin/nf-core"
```

You only need to do this once. It applies to every notebook that runs a pipeline.

### Cluster and storage
The pipelines run on the cluster and each one takes several hours, depending on
the number of samples and the sequencing depth. Notebooks 01 and 03 submit jobs
and return. The execution of notebook 02 requires jobs to be run in the foreground,
so start it inside a `tmux` or `screen` session.

Metagenome `fastq` files and the intermediate files of the pipelines
are large, so make sure you have enough space before you start. The 
`nextflow_work` folder can be deleted once you are satisfied with the results.

## Repository structure

```
Metemgee
├── config/         # Nextflow configuration used by notebooks 01 and 02
├── envs/           # Conda environment files
└── notebooks/      # The notebooks, to be run in order
```

The notebooks create a `data` folder for the sequences, sample sheets, and
pipeline outputs, and a `bin` folder for the software downloaded.

## Running Metemgee outside the Maier Lab

The notebooks assume you are working on M3. If you are not, these are the
things you need to change:

* The paths to the Kraken2 and Bracken databases and to the taxonomy folder in
    notebook 02, which point to an internal Maier Lab folder.
* The `--genome` and `--tax2filter` arguments of the `detaxizer` command in
    notebook 01, if your host is not human
* The `-profile m3c` argument of the pipeline commands in notebooks 01 and 02
* The partition and resources in the slurm scripts of notebooks 01 and 03
* The `time` limits in the files under `config/`, which follow the 24 hour
    limit of M3

## Glossary

| Term | Meaning |
|---|---|
| `fastq` | File with the DNA sequences and their quality scores |
| Shotgun metagenome | All the DNA of a sample sequenced at once, without targeting a particular gene |
| Host sequence removal | Discarding the reads that come from the host rather than from the microbes |
| Sequencing run | One pass of a sample through the sequencer. A sample can be sequenced several times to reach the desired depth |
| Sequencing depth | How many reads were obtained for a sample |
| Taxonomic profile | Which organisms are in a sample, and in what proportion |
| Functional profile | Which genes or enzymes are encoded by the members of a microbial community, and in what proportion |
| EC number | A code that identifies the reaction an enzyme catalyses |
| slurm | The program that queues and runs jobs on the cluster |

## A note on the use of AI

I used Claude Opus 5 to improve the documentation and comments in this
repo (including this README file). The code itself was not AI generated,
although I implemented a few changes after requesting feedback.
I reviewed and tested all notebooks manually.

## License

This repository is released under the MIT License. See the `LICENSE` file for the full terms.

## Why `Metemgee`?
I was trying to come up with a clever name for this repo and it
proved harder than I thought. Googling around I accidentally found
this Guyanese dish called _metemgee_, made of cassava, sweet potatoes
and plantains, cooked in seasoned coconut milk. I haven't tried
it yet, but it sounds so so good. Besides, 'metemgee' kinda sounds
like 'meta-g', so I'm going with that.