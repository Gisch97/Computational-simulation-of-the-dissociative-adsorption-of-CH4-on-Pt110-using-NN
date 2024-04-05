#!/bin/bash
#SBATCH --partition=eth20
#SBATCH --exclude=c[1-4,9,12,15,26,27]
#SBATCH --job-name=test-01           # Job name
#SBATCH --nodes=1                    # Run all processes on a single node
##SBATCH --ntasks=32                 # Run a single task
#SBATCH --ntasks-per-node=20         # Use 40 cores per node
#SBATCH --time=02:00:00              # Time limit hrs:min:sec
#SBATCH --output=parallel_%j.log     # Standard output and error log
pwd; hostname; date

echo "Running VASP on $SLURM_NTASKS cores"

##module use /opt/software/apps/modules/all
####module load VASP/5.4.4-18Apr17-p01-intel-2021b    # version estandard de vasp
module load VASP/5.4.4-SRP-intel-2021b                # version de vasp compilado con la funcional SRP de Leiden
cp /home/gkulemeyer.ifir/VASP/Sample_input_files/vdw_kernel.bindat .
EXE=vasp_std

mpirun -n $SLURM_NTASKS $EXE

rm -vf EIGENVAL* PCDAT* IBZKPT \
       DOSCAR* ELFCAR* LOCPOT* OUTPAR* PROOUT* \
       TMPCAR* CHG* WAVECAR vdw_kernel.bindat

date
