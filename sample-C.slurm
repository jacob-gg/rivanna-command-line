#!/bin/bash
#SBATCH -A <alloc-name>
#SBATCH --time=0-00:59:00
#SBATCH -N 1
#SBATCH --mem 64000
#SBATCH -p standard
#SBATCH -o output.out

module purge
module load gcc/12.2.0

# Compile and run prog.c
gcc prog.c -o prog
./prog