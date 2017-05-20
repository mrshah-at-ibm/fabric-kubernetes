#!/bin/bash

if [ "$(bx plugin list | grep container-service | awk '{print $2}')" == "0.1.256" ]; then
	export PRIVATEIP=$(bx cs workers --cluster blockchain | grep free | awk '{print $2}')
else
	export PRIVATEIP=$(bx cs workers blockchain | grep free | awk '{print $2}')
fi

echo "IP = ${PRIVATEIP}"

sed "s/%PRIVATEIP%/${PRIVATEIP}/g" ../kube_configs/composer-playground.yaml.base > ../kube_configs/composer-playground.yaml

echo "Deleting Existing pods"
kubectl delete -f ../kube_configs/composer-playground.yaml

while [ "$(kubectl get pods | grep composer-playground | wc -l | awk '{print $1}')" != "0" ]; do
	echo "Waiting for old pod to be deleted"
	sleep 1;
done

echo "Creating composer-playground pod"
kubectl create -f ../kube_configs/composer-playground.yaml


