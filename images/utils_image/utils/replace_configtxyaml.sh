#!/bin/bash

cp configtx.yaml.base configtx.yaml.tmp
sed -i "s/orderer0:7050/${ORDERER_URL}/g" configtx.yaml.tmp
#sleep 1
sed -i "s/PEERHOST1/${PEERHOST1}/g" configtx.yaml.tmp
#sleep 1
sed -i "s/PEERPORT1/${PEERPORT1}/g" configtx.yaml.tmp
#sleep 1
sed -i "s/PEERHOST2/${PEERHOST2}/g" configtx.yaml.tmp
#sleep 1
sed -i "s/PEERPORT2/${PEERPORT2}/g" configtx.yaml.tmp
#sleep 1
mv configtx.yaml.tmp configtx.yaml

