#!/bin/bash
#
### Add the $ symbol after # only in the desired SGE option
#
### Job Name
#$ -N CH4Pt110-
#
# Infiniband:    #$ -l netIB=true
### Number of cores
#$ -pe impi-node 4  ####   impi-node 4
#
### Select a queue
# Infiniband:    #$ -q  divMC
#$ -q colisiones,fiquin
#
### Set maximum running time
#$ -l h_rt=12:00:00
#
### Write output files .oxxxx .exxxx in current directory
#$ -cwd
#
### Merge '-j y' (do not merge '-j n') stderr into stdout stream:
#$ -j y
#
### SGE environment variables
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

#-------- SECTION executing VASP  ---------------------------------------------
echo " "
echo "Calling VASP:"
echo " "

module load intel-compiler-2018
module load intel-mkl-2018
module load intel-mpi-2018

### IMPI_HOME=/share/apps/intel/impi/4.0.0.028/intel64/bin
IMPI_HOME=/share/apps/intel/compilers_and_libraries_2018.1.163/linux/mpi/intel64/bin/

cp ~/VASP/VASP5.4/vdw_kernel.bindat .

EXE=~/VASP/VASP5.4/vasp.5.4.4/bin/vasp5.4.4_std-par_SRP_tst
##EXE=/home/fbusnengo.ifir/VASP/VASP5.4/vasp.5.4.4/bin/vasp_std
##EXE=/home/alozano.ifir/VASP-builds/VASP-5.4.4/vasp.5.4.4/bin/vasp_std

$IMPI_HOME/mpirun  -machinefile $TMPDIR/machines -np $NSLOTS $EXE
### $IMPI_HOME/mpirun -machinefile $TMPDIR/machines -np $NSLOTS $EXE


# -------- NO NEED TO MODIFY THIS SECTION -------------------------------------
echo "END_TIME (success)   = `date +'%y-%m-%d %H:%M:%S %s'`"
END_TIME=`date +%s`
echo "RUN_TIME (hours)     = "`echo "$START_TIME $END_TIME" | awk '{printf("%.4f",($2-$1)/60.0/60.0)}'`

# -------- SECTION clean up files ---------------------------------------------
echo " "
echo "Cleaning up files ... removing unnecessary files ..."
echo " "
rm -vf EIGENVAL* PCDAT* IBZKPT \
       DOSCAR* ELFCAR* LOCPOT* OUTPAR* PROOUT* \
       TMPCAR* CHG* WAVECAR vdw_kernel.bindat

exit 0
