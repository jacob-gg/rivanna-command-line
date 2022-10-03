### Rivanna from the command line
_A Mac-targeted guide for [StatLab](https://data.library.virginia.edu/statlab/)_  
Author: [Jacob Goldstein-Greenwood](https://github.com/jacob-gg)  
Last updated: 2022-09-27  

#### Contents
- [Logging in with SSH](#logging-in-with-ssh)  
- [Transferring files](#transferring-files)  
- [Preparing a Slurm script to run a job](#preparing-slurm-scripts)  
- [Executing a script on Rivanna](#executing-a-script-on-rivanna)  
- [Ad hoc Rivanna commands](#ad-hoc-rivanna-cl-commands)  
- [Ad hoc commands for using R in Rivanna](#ad-hoc-cl-commands-for-accessing-r-in-rivanna)  

---
#### Logging in with SSH

`ssh -Y <usr>@rivanna.hpc.virginia.edu`

You'll be prompted for your NetBadge password. As you type, nothing will appear; this is a normal security precaution.

---
#### Transferring files

_Note: This section will be updated with SFTP/rsync transfer instructions._

_Run SCP from the local (not in SSH)._  

_Local to remote:_  
- File: `scp localfile <usr>@rivanna.hpc.virginia.edu:/path/file`  
- Directory: `scp -r localdir <usr>@rivanna.hpc.virginia.edu:/path/dir`

_Remote to local:_  
- File: `scp <usr>@rivanna.hpc.virginia.edu:/path/file /targetfile`  
- Directory: `scp -r <usr>@rivanna.hpc.virginia.edu:/path/dir /targetdir`

SCP takes the directory it's invoked in as the default path. `cd` to the relevant local directory in advance (not in SSH) to make life easy. The default remote path is `home/<usr>/` (`mkdir` in SSH to create a new remote directory if needed).

---
#### Preparing Slurm scripts

Rivanna receives and manages jobs based on Slurm scripts. Write the script in bash, and save it as a `.slurm`.

_Note: I recommend using a text editor other than TextEdit (e.g., Atom) on Mac, as TextEdit seems to have trouble saving files as `.slurm` without coercing to `.rtf`._

Sample Slurm script to execute a serial (single-core) R script on Rivanna:
```
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
```

Key options:  
`-A`, `--account`: allocation to use  
`-t`, `--time`: max time to allot  
`-N`, `--nodes`: nodes  
`-n`, `--ntasks`: tasks  
`-M`, `--mem`: RAM in mb  
`-p`, `--partition`: partition (standard, dev)  
`-o`, `--output`: output file (optional; default name will be used otherwise)

---
#### Executing a script on Rivanna

`sbatch slurmscript.slurm`

---
#### Ad hoc Rivanna CL commands

`allocations -a <alloc>`: view allocation details  
`squeue --user <usr>`: view user's current jobs  
`jobq`: info on your current jobs  
`qlist`: info on available queues/partitions  
`qlimits`: info on queue/partition limits  
`sfsq`: info on your scratch (temporary) storage  
`scancel <jobid>`: cancel a job  

---
#### Ad hoc CL commands for accessing R in Rivanna

`module purge` # clear modules  
`module load goolf/7.1.0_3.1.4 R/4.0.3` # load R 4.0.3  
`module spider R` # see available R versions  

Once R is loaded in the CL, install packages as usual (`install.packages('<pkgname>')`); a prompt will open to select a mirror to download from (e.g., Germany Leipzig).

_Canary: R 4.1.1 on Rivanna seems to have package-handling issues._
