#!/bin/bash
export PRIVATEIP=$(bx cs workers --cluster blockchain | grep free | awk '{print $2}')

sed "s/%PRIVATEIP%/${PRIVATEIP}/g" ../kube_configs/blockchain.yaml.base > ../kube_configs/blockchain.yaml
sed "s/%PRIVATEIP%/${PRIVATEIP}/g" ../kube_configs/create_channel.yaml.base > ../kube_configs/create_channel.yaml
sed "s/%PRIVATEIP%/${PRIVATEIP}/g" ../kube_configs/join_channel.yaml.base > ../kube_configs/join_channel.yaml

echo "Deleting Existing pods"
kubectl delete -f ../kube_configs/blockchain.yaml
kubectl delete -f ../kube_configs/create_channel.yaml
kubectl delete -f ../kube_configs/join_channel.yaml

while [ "$(kubectl get pods | wc -l)" != "0" ]; do
	echo "Waiting for all old pods to be deleted"
	sleep 1;
done

