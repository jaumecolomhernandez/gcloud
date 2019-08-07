#!/usr/bin/env bash

export IMAGE_FAMILY="pytorch-latest-gpu"
export ZONE="europe-west4-b"
export INSTANCE_NAME="fastai-instance"
export INSTANCE_TYPE="n1-highmem-8"


if [ "$#" -eq 0 ]; then
  echo "Missing parameter!"
  exit 1
fi

if [ "$1" == create  ]; then
  gcloud compute instances create $INSTANCE_NAME \
                --zone=$ZONE \
                --image-family=$IMAGE_FAMILY \
                --image-project=deeplearning-platform-release \
                --maintenance-policy=TERMINATE \
                --machine-type=$INSTANCE_TYPE \
                --boot-disk-size=100GB \
                --metadata="install-nvidia-driver=True" \
                --preemptible
                #--accelerator="type=nvidia-tesla-p4,count=1"
elif [ "$1" == delete ]; then
  gcloud compute instances delete $INSTANCE_NAME
elif [ "$1" == up ]; then
  gcloud compute instances start $INSTANCE_NAME
elif [ "$1" == down ]; then
  gcloud compute instances stop $INSTANCE_NAME
elif [ "$1" == connect ]; then
  gcloud compute ssh --zone=$ZONE jupyter@$INSTANCE_NAME -- -l 8080:localhost:8080
else
  echo "Command unkwown!"
fi