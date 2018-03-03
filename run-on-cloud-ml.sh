#!/bin/bash

# local mode, small run
gcloud ml-engine local train \
	--module-name trainer.train --package-path trainer \
	--job-dir log -- --max-epoch 1 \
	--train-files data/modelnet40_ply_hdf5_2048/ply_data_train4.h5 \
	--eval-files data/modelnet40_ply_hdf5_2048/ply_data_test1.h5

# Cloud ML job, full run with GPU's
export JOB_NAME=pointnet12
gcloud ml-engine jobs submit training $JOB_NAME \
	--module-name trainer.train --package-path trainer \
	--config config.yaml --staging-bucket gs://ywz-cloud-ml/ \
	--job-dir gs://ywz-cloud-ml/$JOB_NAME --region us-east1 -- \
	--train-files=gs://ywz-cloud-ml/pointnet-data/ply_data_train{0,1,2,3,4}.h5 \
	--eval-files=gs://ywz-cloud-ml/pointnet-data/ply_data_test{0,1}.h5
