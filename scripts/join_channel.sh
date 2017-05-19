#!/bin/bash

export PRIVATEIP=$(bx cs workers --cluster blockchain | grep free | awk '{print $2}')

sed "s/%PRIVATEIP%/${PRIVATEIP}/g" ../kube_configs/join_channel.yaml.base > ../kube_configs/join_channel.yaml

echo "Deleting Existing pods"
kubectl delete -f ../kube_configs/join_channel.yaml

while [ "$(kubectl get pods | grep joinchannel | wc -l)" != "0" ]; do
	echo "Waiting for old pod to be deleted"
	sleep 1;
done

echo "Creating joinchannel pod"
kubectl create -f ../kube_configs/join_channel.yaml


