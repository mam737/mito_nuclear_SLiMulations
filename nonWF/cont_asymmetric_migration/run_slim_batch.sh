#!/bin/bash -l
#SBATCH --job-name=slim_nonWF_cam
#SBATCH --output=slim-%A_%a.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=200
#SBATCH --time=24:00:00
#SBATCH --partition=regular
#SBATCH --account=bscb02
#SBATCH --exclude=cbsubscbgpu01
#SBATCH --array=1-2268

# set start time
d1=$(date +%s)

# set local directory name to unique job ID (unique for each task within a job)
newdir=${SLURM_JOB_ID}

# get parameter values for this task
myRow=`sed -n "${SLURM_ARRAY_TASK_ID}p" params.txt`
myModel=`sed -n "${SLURM_ARRAY_TASK_ID}p" params.txt | cut -f 1`
myNe=`sed -n "${SLURM_ARRAY_TASK_ID}p" params.txt | cut -f 2`
myMig1=`sed -n "${SLURM_ARRAY_TASK_ID}p" params.txt | cut -f 3`
myMig2=`sed -n "${SLURM_ARRAY_TASK_ID}p" params.txt | cut -f 4`
myMCdel=`sed -n "${SLURM_ARRAY_TASK_ID}p" params.txt | cut -f 5`
myMCadv=`sed -n "${SLURM_ARRAY_TASK_ID}p" params.txt | cut -f 6`
myMCR=`sed -n "${SLURM_ARRAY_TASK_ID}p" params.txt | cut -f 7`

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
cp /home/mam737/SLiMulations/nonWF_cam/run_10.5.20/cam_nonWF_mito_${myModel}.slim /workdir/$USER/$newdir
cd /workdir/$USER/$newdir

# run 10 replicates for parameter set
for idx in $(seq 1 10); do
  fn1=${myMCR}_${myMCdel}_${myMCadv}_fitnessrun${idx}.txt
  fn2=${myMCR}_${myMCdel}_${myMCadv}_freqrun${idx}.txt
  fn3=${myMCR}_${myMCdel}_${myMCadv}_sexratiorun${idx}.txt 
  /programs/SLiM/slim -d N=${myNe} -d mig1=${myMig1} -d mig2=${myMig2} -d MC_R=${myMCR} -d MC_del=${myMCdel} -d MC_adv=${myMCadv} -d "filename1='${fn1}'" -d "filename2='${fn2}'" -d "filename3='${fn3}'" cam_nonWF_mito_${myModel}.slim
done

# copy out results
outdir=/fs/cbsuclarkfs1/storage/mam737/SLiMULATION/cam_nonWF/${myModel}/NE_${myNe}/mig1_${myMig1}_mig2_${myMig2}/${myMCR}_${myMCdel}_${myMCadv}
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

