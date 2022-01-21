#!/usr/bin/env bash

PYTHON=${PYTHON:-"python"}

GPUS=$1
EXPNAME=$2

$PYTHON -m torch.distributed.run --nproc_per_node=$GPUS ./main.py $EXPNAME --launcher pytorch --world_size=$GPUS ${@:3}
