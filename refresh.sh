
PRIVATEIP=$(bx cs workers blockchain | grep free | awk '{print $2}')

sed "s/%PRIVATEIP%/${PRIVATEIP}/g" blockchain.yaml.base > blockchain.yaml
sed "s/%PRIVATEIP%/${PRIVATEIP}/g" create_channel.yaml.base > create_channel.yaml
sed "s/%PRIVATEIP%/${PRIVATEIP}/g" join_channel.yaml.base > join_channel.yaml

echo "Deleting Existing pods"
kubectl delete -f blockchain.yaml
kubectl delete -f create_channel.yaml
kubectl delete -f join_channel.yaml

while [ "$(kubectl get pods | wc -l)" != "0" ]; do
	echo "Waiting for old pod to be deleted"
	sleep 1;
done

echo "Creating new Deployment"
kubectl create -f blockchain.yaml 

echo "Hold on..."
sleep 5

kubectl create -f create_channel.yaml
sleep 10
kubectl create -f join_channel.yaml

kubectl cp utils:/shared/crypto-config ./crypto-config

#while [ "$(kubectl get pods | grep blockchain | wc -l)" != "1" ]; do
#	echo "Waiting for old pod to be deleted"
#	sleep 1;
#done

#kubectl logs $(kubectl get pods | grep blockchain | awk '{print $1}') -c org1peer1
