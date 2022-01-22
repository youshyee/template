#!/bin/bash -login
#SBATCH --job-name=expname

#SBATCH --ntasks=4
#SBATCH --time=3-00:00:00

#SBATCH --mem=80G
#SBATCH --mail-type=ALL
#SBATCH --partition mlcnu
#SBATCH --gres=gpu:4
#SBATCH --ntasks-per-node=4

cd $SLURM_SUBMIT_DIR

GPU=4

TRAINFILE="$SLURM_SUBMIT_DIR"/dist_train.sh
EXPNAME=expname

PYTHON=$HOME/.conda/envs/torch/bin/python
while true;
do
PYTHON=$PYTHON sh $TRAINFILE $GPU $EXPNAME && break \
	|| echo 0 > "$SLURM_SUBMIT_DIR"/control_$SLURM_JOBID; ~/.local/bin/composemail $SLURM_JOBID "$SLURM_SUBMIT_DIR"/slurm-"$SLURM_JOBID".out; sendmail rn18510@bristol.ac.uk < ~/.tmp/mail_"$SLURM_JOBID".txt; while [ $(cat "$SLURM_SUBMIT_DIR"/control_$SLURM_JOBID) == 0 ];
do
	sleep 1
done
done
[ -f  "$SLURM_SUBMIT_DIR"/control_$SLURM_JOBID ] && rm "$SLURM_SUBMIT_DIR"/control_$SLURM_JOBID

