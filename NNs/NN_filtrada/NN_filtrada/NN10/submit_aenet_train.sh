#!/bin/bash
#SBATCH --partition=ib16
#SBATCH --exclude=c[2-5,11]
#SBATCH --job-name=NN10Train      # Job name
#SBATCH --nodes=8                    # Run all processes on a single node
##SBATCH --ntasks=80                 # Run a single task
#SBATCH --ntasks-per-node=16         # Use 16 cores per node
#SBATCH --time=24:00:00              # Time limit hrs:min:sec
#SBATCH --output=parallel_%j.log     # Standard output and error log
pwd; hostname; date

echo "Running Aenet Training 2.0.4 on $SLURM_NTASKS CPU cores"

##module use /opt/software/apps/modules/all
####module load VASP/5.4.4-18Apr17-p01-intel-2021b    # version estandard de vasp
module load aenet/2.0.4-intel-2021b                # version de aenet 2.0.4
EXE=train.x-2.0.4-ifort_intelmpi


rm TRAIN.* TEST.*
mpirun -n $SLURM_NTASKS $EXE train.in > train.out

## Generar los archivos con la energia DFT y NN
cat energies.train.* > energies.train
cat energies.test.* > energies.test
rm energies.t*.*
sed -i '/Ref/d' energies.train
sed -i '/Ref/d' energies.test

## Generar archivo con datos de convergencia y graficar
if [ -f "convergence.dat" ]; then
    grep "<" train.out >> convergence.dat
else
    grep "<" train.out > convergence.dat
fi

## Mover los archivos con las redes a una carpeta NNs
if [ ! -d "NNs" ]; then
    mkdir NNs
fi
cp *.ann   NNs
mv *.ann-?0000 NNs
rm *.ann-* NNs

# -------- NO NEED TO MODIFY THIS SECTION -------------------------------------
echo "END_TIME (success) = `date +'%y-%m-%d %H:%M:%S %s'`" date END_TIME=`date +%s` echo "RUN_TIME (hours) = "`echo "$START_TIME $END_TIME" | awk 
'{printf("%.4f",($2-$1)/60.0/60.0)}'`
exit 0
