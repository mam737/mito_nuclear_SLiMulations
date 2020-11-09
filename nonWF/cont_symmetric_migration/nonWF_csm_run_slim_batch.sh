#!/bin/bash -l
#SBATCH --job-name=slim_nonWF_csm
#SBATCH --output=slim-%A_%a.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=2000
#SBATCH --array=1-648%40

# set start time
d1=$(date +%s)

# set local directory name to unique job ID (unique for each task within a job)
newdir=${SLURM_JOB_ID}

# get parameter values for this task
myRow=`sed -n "${SLURM_ARRAY_TASK_ID}p" params.txt`
myModel=`sed -n "${SLURM_ARRAY_TASK_ID}p" params.txt | cut -f 1`
myNe=`sed -n "${SLURM_ARRAY_TASK_ID}p" params.txt | cut -f 2`
myMig=`sed -n "${SLURM_ARRAY_TASK_ID}p" params.txt | cut -f 3`
myMCdel=`sed -n "${SLURM_ARRAY_TASK_ID}p" params.txt | cut -f 4`
myMCadv=`sed -n "${SLURM_ARRAY_TASK_ID}p" params.txt | cut -f 5`
myMCR=`sed -n "${SLURM_ARRAY_TASK_ID}p" params.txt | cut -f 6`

# print task info to stdout (.out) file
echo host node
echo $HOSTNAME
echo task index
echo $SLURM_ARRAY_TASK_ID
echo job ID
echo $newdir
echo parameter set
echo $myRow

# make local directory, copy required file, change to local directory
mkdir -p /workdir/$USER/$newdir
cp csm_nonWF_mito_${myModel}.slim /workdir/$USER/$newdir
cd /workdir/$USER/$newdir

pwd

# run 10 replicates for parameter set
for idx in $(seq 1 10); do
  fn1=${myMCR}_${myMCdel}_${myMCadv}_fitnessrun${idx}.txt
  fn2=${myMCR}_${myMCdel}_${myMCadv}_freqrun${idx}.txt
  fn3=${myMCR}_${myMCdel}_${myMCadv}_sexratiorun${idx}.txt 
  /programs/SLiM/slim -d N=${myNe} -d mig=${myMig} -d MC_R=${myMCR} -d MC_del=${myMCdel} -d MC_adv=${myMCadv} -d "filename1='${fn1}'" -d "filename2='${fn2}'" -d "filename3='${fn3}'" csm_nonWF_mito_${myModel}.slim
done

# copy out results
outdir=/fs/cbsuclarkfs1/storage/mam737/SLiMULATION/csm_nonWF/${myModel}/NE_${myNe}/mig_${myMig}/${myMCR}_${myMCdel}_${myMCadv}
/programs/bin/labutils/mount_server cbsuclarkfs1 /storage
mkdir -p ${outdir}
rsync -a *run*.txt ${outdir}

# clean up
cd ..
rm -r ./$newdir

# print elapsed time
d2=$(date +%s)
sec=$(( ( $d2 - $d1 ) ))
hour=$(echo - | awk '{ print '$sec'/3600}')
echo Runtime: $hour hours \($sec\s\)
