#!/bin/bash -login
#SBATCH --job-name=expname

#SBATCH --ntasks=8
#SBATCH --time=3-00:00:00

#SBATCH --mem=80G
#SBATCH --mail-type=ALL
#SBATCH --partition gpu
#SBATCH --gres=gpu:4
#SBATCH --ntasks-per-node=4
cd $SLURM_SUBMIT_DIR

PARTITION=gpu #mlcnu

TRAINFILE="$SLURM_SUBMIT_DIR"/main.py
EXPNAME=expname
GPUS=8

GPUS_PER_NODE=4
SRUN_ARGS=${SRUN_ARGS:-""}

PYTHON=/mnt/storage/scratch/rn18510/anaconda3/envs/pytorch/bin/python
while true;
do
srun -p ${PARTITION}\
	--job-name=${EXPNAME}\
	--gres=gpu:${GPUS_PER_NODE}\
	--ntasks=${GPUS}\
	--ntasks-per-node=${GPUS_PER_NODE}\
	--kill-on-bad-exit=1\
	${SRUN_ARGS}\
	$PYTHON -u $TRAINFILE $EXPNAME  --launcher="slurm"   && break \
	|| echo 0 > "$SLURM_SUBMIT_DIR"/control_$SLURM_JOBID; ~/.local/bin/composemail $SLURM_JOBID "$SLURM_SUBMIT_DIR"/slurm-"$SLURM_JOBID".out; sendmail rn18510@bristol.ac.uk < ~/.tmp/mail_"$SLURM_JOBID".txt; while [ $(cat "$SLURM_SUBMIT_DIR"/control_$SLURM_JOBID) == 0 ];
do
	sleep 1
done
done
[ -f  "$SLURM_SUBMIT_DIR"/control_$SLURM_JOBID ] && rm "$SLURM_SUBMIT_DIR"/control_$SLURM_JOBID

