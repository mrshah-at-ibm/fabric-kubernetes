#!/bin/bash

export PRIVATEIP=$(bx cs workers --cluster blockchain | grep free | awk '{print $2}')

sed "s/%PRIVATEIP%/${PRIVATEIP}/g" ../kube_configs/blockchain.yaml.base > ../kube_configs/blockchain.yaml

echo "Creating new Deployment"
kubectl create -f ../kube_configs/blockchain.yaml 

