#!/bin/bash
#SBATCH -A <alloc>
#SBATCH --time=04:00:00
#SBATCH -N 1
#SBATCH --mem 64000
#SBATCH -p standard
#SBATCH -o output.out

module purge
module load goolf/7.1.0_3.1.4 R/4.0.3

Rscript script.R
