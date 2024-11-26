#!/bin/bash
sudo apt-get -q update && sudo apt-get -q upgrade
sudo snap install kubectl --classic;sudo snap install aws-cli --classic
aws configure set aws_access_key_id AKIAX5ZI55F3HFOUAWRV;aws configure set aws_secret_access_key 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;aws configure set default.region us-east-1
aws eks --region us-east-1 update-kubeconfig --name demo
