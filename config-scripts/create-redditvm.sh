#!/bin/bash

gcloud compute instances create reddit-app-`date +"%m-%d-%y-%H-%M"` --image-family=reddit-full --tags=puma-server --restart-on-failure

