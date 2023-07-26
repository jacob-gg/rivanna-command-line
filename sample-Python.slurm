#!/bin/bash
#SBATCH -A <alloc-name>
#SBATCH --time=0-00:59:00
#SBATCH -N 1
#SBATCH --mem 64000
#SBATCH -p dev
#SBATCH -o output.out

module purge
module load gcc/11.2.0 
module load openmpi/4.1.4
module load python/3.11.1

python script.py