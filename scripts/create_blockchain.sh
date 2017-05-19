#!/bin/bash

if [ "$(bx plugin list | grep container-service | awk '{print $2}')" == "0.1.256" ]; then
	export PRIVATEIP=$(bx cs workers --cluster blockchain | grep free | awk '{print $2}')
else
	export PRIVATEIP=$(bx cs workers blockchain | grep free | awk '{print $2}')
fi

echo "IP = ${PRIVATEIP}"

sed "s/%PRIVATEIP%/${PRIVATEIP}/g" ../kube_configs/blockchain.yaml.base > ../kube_configs/blockchain.yaml

echo "Creating new Deployment"
kubectl create -f ../kube_configs/blockchain.yaml 

