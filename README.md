### [Rivanna](https://www.rc.virginia.edu/userinfo/rivanna/overview/) from the command line
_A Mac-targeted guide for [StatLab](https://data.library.virginia.edu/statlab/) ([on GitHub](https://github.com/uvastatlab))_  
Author: [Jacob Goldstein-Greenwood](https://github.com/jacob-gg)  
Last updated: 2023-07-26

#### Contents
- [Logging in with SSH](#logging-in-with-ssh)  
- [Modules (software/languages) on Rivanna](#Modules-%28software-and-languages%29-on-Rivanna)
- [Preparing and executing Slurm scripts](#preparing-and-executing-slurm-scripts)  
- [Transferring files to and from Rivanna](#transferring-files-to-and-from-rivanna)  
- [Miscellaneous Rivanna commands](#miscellaneous-rivanna-commands)  

---
#### Logging in with SSH

`ssh -Y <usr>@rivanna.hpc.virginia.edu`

If you're not accessing Rivanna on UVA WiFi, you'll need to use a VPN (UVA More Secure Network or UVA Anywhere VPN). You'll be prompted for your NetBadge password. As you type, nothing will appear; this is a normal security precaution.

---
#### Modules (software and languages) on Rivanna

Software and compilers/interpreters for programming languages are available on Rivanna in the form of modules.

- See all available software: `module avail`
- See just available languages: `module key lang`

To make use of a module (e.g., R), you must load it _and any modules on which it depends_. This loading process is usually done via commands written in _Slurm scripts_ (described in the next section), which control jobs run on Rivanna.

- See available versions of a module: `module spider <mod>`
- See dependency modules for a given module: `module spider <mod>/<ver>`

For example, as of 2023-07-26, running `module spider R` indicates that R versions from 3.5.3 to 4.2.1 are available on Rivanna. Running `module spider R/4.2.1` indicates that using the R/4.2.1 module requires also loading the gcc/9.2.0 and openmpi/3.1.6 modules.

- Load a module(s) with: `module load <mod>/<ver> <mod>/<ver>`
- See all currently loaded modules: `module list`
- Clear all loaded modules: `module purge`

Although `module load` commands are often issued as part of Slurm scripts that control how jobs are executed on Rivanna, I could also run the R/4.2.1 interpreter from the command line when logged into Rivanna via SSH like so:

```
module purge
module load gcc/9.2.0 openmpi/3.1.6 R/4.2.1
R
```

---
#### Preparing and executing Slurm scripts

Rivanna receives and manages jobs based on Slurm scripts. Write the script in bash, and save it as a `.slurm` file.

Begin the script with `#!/bin/bash`. Then, write lines beginning with `#SBATCH` to define job options (memory, maximum time, etc.). After defining job options, use `module` commands to load the necessary modules. Then, write command-line instructions that execute the job (for example, pass an R script to the R interpreter with `Rscript script.R`).

The following is a sample Slurm script to execute a serial (single-core) R script on Rivanna:

```
#!/bin/bash
#SBATCH -A <alloc-name>
#SBATCH --time=0-04:00:00
#SBATCH -N 1
#SBATCH --mem 64000
#SBATCH -p standard
#SBATCH -o output.out

module purge
module load gcc/9.2.0
module load openmpi/3.1.6
module load R/4.2.1

Rscript script.R
```

Key options:  
`-A`, `--account`: allocation to use  
`-t`, `--time`: max time to allot (`d-hh:mm:ss`)
`-N`, `--nodes`: nodes  
`-n`, `--ntasks`: tasks  
`-M`, `--mem`: RAM in mb  
`-p`, `--partition`: partition (standard, dev)  
`-o`, `--output`: output file (optional; default name will be used otherwise)

Once the Slurm script is prepared, submit the job with:

`sbatch slurmscript.slurm`

---
#### Transferring files to and from Rivanna

**rsync** (recommended)

`rsync <opts> <from> <to>`

_Local to remote:_
- File: `rsync local/file <usr>@rivanna.hpc.virginia.edu:target/dir`
- Directory: `rsync -r local/dir <usr>@rivanna.hpc.virginia.edu:target/dir`

_Remote to local:_
- File: `rsync <usr>@rivanna.hpc.virginia.edu:remote/file target/dir`
- Directory: `rsync -r <usr>@rivanna.hpc.virginia.edu:remote/dir target/dir`

Some key options (see more [here](https://download.samba.org/pub/rsync/rsync.1):
- `-r`: copy recursively, so directories within a directory are copied also
- `-a`: "archive mode" (keep symbolic links, timestamps, ownership info, special files, and more)
- `-P`: add a progress bar
- `--dry-run`: see the files rsync is set to transfer without actually doing so

**scp**

_Local to remote:_  
- File: `scp local/file <usr>@rivanna.hpc.virginia.edu:/target/dir`  
- Directory: `scp -r local/dir <usr>@rivanna.hpc.virginia.edu:/target/dir`

_Remote to local:_  
- File: `scp <usr>@rivanna.hpc.virginia.edu:/path/file /target/dir`  
- Directory: `scp -r <usr>@rivanna.hpc.virginia.edu:/path/dir /target/dir`

---
#### Miscellaneous Rivanna commands

`allocations`: view all allocations associated with your account  
`allocations -a <alloc>`: view details for a specific allocation  
`qlist`: info on available queues/partitions  
`qlimits`: info on queue/partition limits  
`sfsq`: info on your scratch (temporary) storage  
`squeue`: view all jobs in the queue  
`squeue --user <usr>`: view a user's current jobs  
`jobq`: info on your current jobs  
`sstat <jobid>`: view a job's status  
`scancel <jobid>`: cancel a job  
`scancel -u <usr>`: cancel all of a user's jobs

When you log in to Rivanna via SSH, the command line provides access to standard tools/commands available on Unix-like operating systems. For example, I could write a one-line script using the AWK language to see just jobs in the queue that are running (or set to run) on the "dev" partition:

`squeue | awk '$2=="dev" {print}'`
