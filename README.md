# IBM Blockchain on IBM Container Service

These instructions are to run a basic IBM blockchain network on IBM's container service.
It will bring up the following components:
* Fabric-CA (with 3 CAs - 1 for orderer org and 2 for peer orgs)
* Orderer (SOLO)
* Fabric-Peer (for org1)
* Fabric-Peer (for org2)
* Fabric Composer
* Marbles

It also creates services to expose the components.

## What are we trying to achieve?

1. Make it easy for a developer to set up a basic hyperledger fabric network on IBM Cloud.
2. Keep it to basic hyperledger fabric network.
3. _**WE DO NOT SUPPORT THIS OFFERING**_. Support is only provided through the IBM Container Service; IBM Blockchain does not have a support offering for this. 

## Can this run on minikube? If yes, why CS?

Yes, this can run on minikube. But, running on CS gives you a cloud hosted network. You can point your solution to HSBN once you are ready and have a HSBN.

# Instructions

## CREATE A CLUSTER ON IBM CONTAINER SERVICE

### 1. Download and install kubectl cli

https://kubernetes.io/docs/tasks/kubectl/install/

### 2. Download and install the Bluemix cli

http://clis.ng.bluemix.net/ui/home.html

### 3. Add the bluemix plugins repo

```
bx plugin repo-add bluemix https://plugins.ng.bluemix.net
```

### 4. Add the container service plugin

```
bx plugin install container-service -r bluemix
```

### 5. Create a cluster on container service

```
bx cs cluster-create --name blockchain
```

You will have to login to Bluemix for the above to work:
```
# Point to Bluemix
bx api api.ng.bluemix.net
# Login to Bluemix
bx login
```

#### Wait for the cluster to be ready

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

### 6. Configure kubectl to use the cluster

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

## SETUP BLOCKCHAIN NETWORK

Following instructions will setup the blockchain network on IBM Container Service.

*Note:* You might see some errors `Error from server (NotFound): error when stopping`. Ignore those errors, as those occur when the cleanup is trying to delete pods which are not created.

### TL;DR
To perform all the following steps in one script:
```
cd scripts
./setup_all.sh
```

### 1. Get into the scripts folder
```
cd scripts
```

### 2. Remove all the blockchain pods running on IBM container service

```
./delete_all.sh
```

### 3. Setup the blockchain network
This will create the following:
1. _utils_ pod     - This pod pulls the ccenv image and generates the crypto material & the genesis block.
2. _CA_ pods       - One for each org
3. _Orderer_ pod   - The SOLO orderer
4. _Org1Peer1_ pod - The peer for org1
5. _Org2Peer1_ pod - The peer for org2
```
./create_blockchain.sh
```

*Note:* Make sure that the network is up and running before following the next steps.
```
kubectl get pods
```

### 4. Create a channel named _channel1_
This will create a new channel named channel1 on the orderer.
```
./create_channel.sh
```

### 5. Make peer of org1 join the channel created in (4)
This will make the peer of Org1 join the channel named _channel1_
```
./join_channel.sh
```
At the end of this step, you should see the log `Peer joined the channel!` when you check the logs of the _joinchannel_ pod.
```
kubectl logs joinchannel
```

### 6. Start Hyperledger Composer Playground for developing Blockchain business networks
Hyperledger Composer is a framework for developing Blockchain business networks. Find more information here:
[https://hyperledger.github.io/composer/](https://hyperledger.github.io/composer/)

This command will start an instance of the Hyperledger Composer Playground for developing Blockchain business networks:
```
./composer-playground.sh
```
Next, determine the public IP address of the cluster by running the following command:
```
bx cs workers blockchain
```
The output should be similiar to the following:
```
Listing cluster workers...
OK
ID                                                 Public IP      Private IP       Machine Type   State    Status
kube-dal10-pabdda14edc4394b57bb08d53c149930d7-w1   169.48.140.99   10.171.239.186   free           normal   Ready
```
Using the value of the `Public IP` (in this example 169.48.140.99) you can now access the Hyperledger Composer Playground:
`http://YOUR_PUBLIC_IP_HERE:31080`

## Run Marbles

For instructions to run marbles, look [here](./marbles/README.md)

## Create a Hyperledger Composer connection profile

You can create a Hyperledger Composer connection profile for use with locally installed Composer tools - for example, the `composer` CLI tool for deploying business network archives.

First, determine the public IP address of the cluster by running the following command:
```
bx cs workers blockchain
```
The output should be similiar to the following:
```
Listing cluster workers...
OK
ID                                                 Public IP      Private IP       Machine Type   State    Status
kube-dal10-pabdda14edc4394b57bb08d53c149930d7-w1   169.48.140.99   10.171.239.186   free           normal   Ready
```
You then need to make the following changes to this example JSON connection profile document:
1. Replace all instances of YOUR_PUBLIC_IP_HERE with the value of the `Public IP` (in this example 169.48.140.99).
2. Change YOUR_HOME_DIRECTORY_HERE to a directory on your machine that already exists, for example `/home/sstone1`.
```
{
    "type": "hlfv1",
    "orderers": [
        "grpc://YOUR_PUBLIC_IP_HERE:31010"
    ],
    "ca": "http://YOUR_PUBLIC_IP_HERE:31001",
    "peers": [
        {
            "requestURL": "grpc://YOUR_PUBLIC_IP_HERE:31020",
            "eventURL": "grpc://YOUR_PUBLIC_IP_HERE:31021"
        }
    ],
    "keyValStore": "YOUR_HOME_DIRECTORY_HERE/.hfc-key-store",
    "channel": "channel1",
    "mspID": "Org1MSP",
    "deployWaitTime": "300",
    "invokeWaitTime": "100"
}
```

## Start a Hyperledger Composer REST server

You can also deploy a Hyperledger Composer REST server after you have deployed a business network definition.

First, edit the file `kube_configs/composer-rest-server.yaml.base` to reflect the business network that you have deployed. You **only** need to do this step if you have deployed a business network using the `composer` CLI. You will need to change the values of the environment variable `COMPOSER_BUSINESS_NETWORK` to reflect the name of the deployed business network. Note that when deploying using Hyperledger Composer Playground, the deployed business network is always named `org.acme.biznet`.

Next, run the following commands:
```
./composer-rest-server.sh
```

Next, determine the public IP address of the cluster by running the following command:
```
bx cs workers blockchain
```
The output should be similiar to the following:
```
Listing cluster workers...
OK
ID                                                 Public IP      Private IP       Machine Type   State    Status
kube-dal10-pabdda14edc4394b57bb08d53c149930d7-w1   169.48.140.99   10.171.239.186   free           normal   Ready
```
Using the value of the `Public IP` (in this example 169.48.140.99) you can now access the Hyperledger Composer REST server:
`http://YOUR_PUBLIC_IP_HERE:31090/explorer/`

# Helpful commands:
```
# To get the logs of a component, use -f to follow the logs
kubectl logs $(kubectl get pods | grep <component> | awk '{print $1}')
# Example
kubectl logs $(kubectl get pods | grep org1peer1 | awk '{print $1}')

# To get into a running container
kubectl exec -ti $(kubectl get pods | grep <component> | awk '{print $1}') bash
# Example
kubectl exec -ti $(kubectl get pods | grep ordererca | awk '{print $1}') bash
```
