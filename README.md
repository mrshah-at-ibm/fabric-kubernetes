# Blockchain on IBM Container Service

These instructions are to run a basic IBM blockchain network on IBM's container service.
It will bring up the following components:
* Fabric-CA (with 3 CAs - 1 for orderer org and 2 for peer orgs)
* Orderer (SOLO)
* Fabric-Peer (for org1)
* Fabric-Peer (for org2)

It also creates services to expose the components.

## 1. Download and install the Bluemix cli

http://clis.ng.bluemix.net/ui/home.html

## 2. Add the bluemix plugins repo

```
bx plugin repo-add bluemix https://plugins.ng.bluemix.net
```

## 3. Add the container service plugin

```
bx plugin install container-service -r bluemix
```

## 4. Create a cluster on container service

```
bx cs cluster-create --name blockchain
```

### 5. Wait for the cluster to be ready

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

### 6. Use the script to setup the blockchain network

```
. refresh.sh
```

### 7. Add the pods to run create and join channel commands

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
