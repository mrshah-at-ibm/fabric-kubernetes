PRIVATEIP=$(bx cs workers blockchain | grep free | awk '{print $2}')

sed "s/%PRIVATEIP%/${PRIVATEIP}/g" blockchain.yaml.base > blockchain.yaml

echo "Deleting Services"
kubectl delete svc blockchain-org1peer1-service
kubectl delete svc blockchain-org2peer1-service
kubectl delete svc blockchain-orderer-service
kubectl delete svc blockchain-test-service

echo "Deleting deployment"
kubectl delete deployment blockchain

while [ "$(kubectl get pods | grep blockchain | wc -l)" != "0" ]; do
	echo "Waiting for old pod to be deleted"
	sleep 1;
done

echo "Creating new Deployment"
kubectl create -f blockchain.yaml 

echo "Hold on..."
sleep 5

#while [ "$(kubectl get pods | grep blockchain | wc -l)" != "1" ]; do
#	echo "Waiting for old pod to be deleted"
#	sleep 1;
#done

kubectl logs $(kubectl get pods | grep blockchain | awk '{print $1}') -c org1peer1
