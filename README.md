# IBM Blockchain on IBM Container Service

These instructions are to run a basic IBM blockchain network on IBM's container service.
It will bring up the following components:
* Fabric-CA (with 3 CAs - 1 for orderer org and 2 for peer orgs)
* Orderer (SOLO)
* Fabric-Peer (for org1)
* Fabric-Peer (for org2)

It also creates services to expose the components.

## What are we trying to achieve?

1. Make it easy for a developer to set up a basic hyperledger network on IBM Cloud.
2. Keep it to basic hyperledger network. Don't make it production ready that they don't buy HSBN.
3. _*WE DO NOT SUPPORT THIS OFFERING*_. All the support customers can get on this is from IBM Container service and IBM Blockchain will not have a part number to support this.
4. Take point 3 seriously.

## 1. Download and install kubectl cli

https://kubernetes.io/docs/tasks/kubectl/install/

## 2. Download and install the Bluemix cli

http://clis.ng.bluemix.net/ui/home.html

## 3. Add the bluemix plugins repo

```
bx plugin repo-add bluemix https://plugins.ng.bluemix.net
```

## 4. Add the container service plugin

```
bx plugin install container-service -r bluemix
```

## 5. Create a cluster on container service

```
bx cs cluster-create --name blockchain
```

### Wait for the cluster to be ready

Command:
```
bx cs clusters
```

The response will be similar to the following:
```
Name         ID                                 State       Created                    Workers   
blockchain   7fb45431d9a54d2293bae421988b0080   deploying   2017-05-09T14:55:09+0000   0   
```

Wait for the State to change from _deploying_ to _normal_. Note that this might take about 15-30 minutes. If it takes more than 30 minutes, there is some issue on the container service side - Contact them on _#armada-users_ channel on IBM slack.

A ready cluster should give the following response:
```
$ bx cs clusters
Listing clusters...
OK
Name         ID                                 State    Created                    Workers   
blockchain   0783c15e421749a59e2f5b7efdd351d1   normal   2017-05-09T16:13:11+0000   1   

```


If you want to inspect on the status of the workers:
Command:
```
# bx cs workers <cluster-name>
# Example
bx cs workers blockchain
```

The expected response is as follows:
```
$ bx cs workers blockchain
Listing cluster workers...
OK
ID                                                 Public IP       Private IP       Machine Type   State    Status   
kube-dal10-pa0783c15e421749a59e2f5b7efdd351d1-w1   169.48.140.48   10.176.190.176   free           normal   Ready   
```

## 6. Configure kubectl to use the cluster

Command:
```
#bx cs cluster-config <cluster-name>
bx cs cluster-config blockchain
```

Expected output:

```
Downloading cluster config for blockchain
OK
The configuration for blockchain was downloaded successfully. Export environment variables to start using Kubernetes.

export KUBECONFIG=/home/mrshah/.bluemix/plugins/container-service/clusters/blockchain/kube-config-prod-dal10-blockchain.yml
```

Use the export command above to point your kubectl cli to the cluster.

## 7. Use the script to setup the blockchain network

```
. refresh.sh
```

## 8. Add the pods to run create and join channel commands

```
kubectl create -f create_channel.yaml
kubectl create -f join_channel.yaml
```



# Helpful commands:
```
# To get the logs of a component, use -f to follow the logs
kubectl logs $(kubectl get pods | grep <component> | awk '{print $1}')
# Example
kubectl logs $(kubectl get pods | grep org1peer1 | awk '{print $1}')

# To get into a running container
kubectl exec -ti $(kubectl get pods | grep <component> | awk '{print $1}') bash
# Example
kubectl exec -ti $(kubectl get pods | grep ca | awk '{print $1}') bash
```
