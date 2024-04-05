	#!/bin/bash
#
### Job Name
#$ -N gsrd-
#
###### Add the $ symbol after # only in the desired SGE option
#
### Select a queue
#$ -q medium_amd,long_amd,parallel_amd ## colisiones,fiquin,ferro,iicar,long_amd,medium_amd
#
#  Number of cores
#$ -pe impi_32 32
##$ -l netIB=true
#
#  Set maximum running time
#$ -l h_rt=96:00:00
#
### Write output files .oxxxx .exxxx in current directory
#$ -cwd
#
### Merge '-j y' (do not merge '-j n') stderr into stdout stream:
#$ -j y
#
#  SGE environment variables
#$ -V
#

# -------- SECTION print some infos to stdout ---------------------------------
echo " "
echo "START_TIME           = `date +'%y-%m-%d %H:%M:%S %s'`"
START_TIME=`date +%s`
echo "HOSTNAME             = $HOSTNAME"
echo "JOB_NAME             = $JOB_NAME"
echo "JOB_ID               = $JOB_ID"
echo "SGE_O_WORKDIR        = $SGE_O_WORKDIR"
echo "NSLOTS               = $NSLOTS"
echo "PE_HOSTFILE          = $PE_HOSTFILE"
if [ -e "$PE_HOSTFILE" ]; then
  echo "--------------------------------------------------------"
  cat $PE_HOSTFILE
  echo "--------------------------------------------------------"
fi

#-------- SECTION executing gsrd  ---------------------------------------------

echo " "
echo "Calling gsrd:"
echo " "

cp $HOME/TrainingANN/004NN/*.ann .
module load gcc-6.3.0
source /share/apps/intelOneApi/pilusoSetvars.sh

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/lib
mpirun -np $NSLOTS $HOME/bin/gsrd_2.1.2_aenet2.0.3.x

rm *.ann
### rm slabmotion.in

## Mover los archivos con las redes a una carpeta NNs
# if [ ! -d "xsf-files" ]; then
#     mkdir xsf-files
# fi

# mv *.xsf xsf-files

# -------- NO NEED TO MODIFY THIS SECTION -------------------------------------
echo "END_TIME (success)   = `date +'%y-%m-%d %H:%M:%S %s'`"
END_TIME=`date +%s`
echo "RUN_TIME (hours)     = "`echo "$START_TIME $END_TIME" | awk '{printf("%.4f",($2-$1)/60.0/60.0)}'`

exit 0


