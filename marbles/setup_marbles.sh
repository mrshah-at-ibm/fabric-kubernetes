#!/bin/bash

echo "Deleting existing marbles folder"
rm -rf marbles/
echo "Deleting existing network credentials"
rm -rf /tmp/hfc* ~/.hfc-key-store

echo "Cloning marbles repository"
git clone https://github.com/IBM-Blockchain/marbles

echo "Getting IP address of the worker on the cluster"
if [ "$(bx plugin list | grep container-service | awk '{print $2}')" == "0.1.256" ]; then
	export PRIVATEIP=$(bx cs workers --cluster blockchain | grep free | awk '{print $2}')
else
	export PRIVATEIP=$(bx cs workers blockchain | grep free | awk '{print $2}')
fi

echo "IP = ${PRIVATEIP}"

echo "Setting up Blockchain Credentials file"
export PORT_CA_ORDERER=31000
export PORT_CA_PEERORG1=31001
export PORT_CA_PEERORG2=31002
export PORT_ORDERER=31010
export PORT_ORG1PEER1_DISCOVERY=31020
export PORT_ORG1PEER1_EVENTS=31021
export PORT_ORG2PEER1_DISCOVERY=31020
export PORT_ORG2PEER1_EVENTS=31021

export CHANNEL="channel1"

sed -i "s|localhost|${PRIVATEIP}|g" marbles/config/blockchain_creds1.json
sed -i "s|7050|${PORT_ORDERER}|g" marbles/config/blockchain_creds1.json
sed -i "s|7054|${PORT_CA_PEERORG1}|g" marbles/config/blockchain_creds1.json
sed -i "s|7051|${PORT_ORG1PEER1_DISCOVERY}|g" marbles/config/blockchain_creds1.json
sed -i "s|7053|${PORT_ORG1PEER1_EVENTS}|g" marbles/config/blockchain_creds1.json
sed -i "s|mychannel|${CHANNEL}|g" marbles/config/blockchain_creds1.json

echo "Installing dependencies (NPM)"
cd marbles/
npm install --unsafe-perm
npm install -g --unsafe-perm gulp
