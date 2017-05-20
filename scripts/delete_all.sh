#!/bin/bash

if [ "$(bx plugin list | grep container-service | awk '{print $2}')" == "0.1.256" ]; then
	export PRIVATEIP=$(bx cs workers --cluster blockchain | grep free | awk '{print $2}')
else
	export PRIVATEIP=$(bx cs workers blockchain | grep free | awk '{print $2}')
fi

echo "IP = ${PRIVATEIP}"

sed "s/%PRIVATEIP%/${PRIVATEIP}/g" ../kube_configs/blockchain.yaml.base > ../kube_configs/blockchain.yaml
sed "s/%PRIVATEIP%/${PRIVATEIP}/g" ../kube_configs/create_channel.yaml.base > ../kube_configs/create_channel.yaml
sed "s/%PRIVATEIP%/${PRIVATEIP}/g" ../kube_configs/join_channel.yaml.base > ../kube_configs/join_channel.yaml
sed "s/%PRIVATEIP%/${PRIVATEIP}/g" ../kube_configs/composer-playground.yaml.base > ../kube_configs/composer-playground.yaml
sed "s/%PRIVATEIP%/${PRIVATEIP}/g" ../kube_configs/composer-rest-server.yaml.base > ../kube_configs/composer-rest-server.yaml

echo "Deleting Existing pods"
kubectl delete -f ../kube_configs/blockchain.yaml
kubectl delete -f ../kube_configs/create_channel.yaml
kubectl delete -f ../kube_configs/join_channel.yaml
kubectl delete -f ../kube_configs/composer-playground.yaml
kubectl delete -f ../kube_configs/composer-rest-server.yaml

while [ "$(kubectl get pods | wc -l | awk '{print $1}')" != "0" ]; do
	echo "Waiting for all old pods to be deleted"
	sleep 1;
done

