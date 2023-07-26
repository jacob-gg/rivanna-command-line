#!/bin/bash
#SBATCH -A <alloc-name>
#SBATCH --time=0-00:59:00
#SBATCH -N 1
#SBATCH --mem 64000
#SBATCH -p standard
#SBATCH -o output.out

module purge
module load gcc/9.2.0
module load openmpi/3.1.6
module load R/4.2.1

Rscript script.R