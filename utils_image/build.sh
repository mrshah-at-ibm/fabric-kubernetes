#!/bin/bash
ARCH=`uname -m | sed 's|i686|x86_64|'`
SNAPSHOT=9d6cec8
VERSION=1.0.0
BASE_FOLDER=${PWD}

PEER_DOCKER_REPOSITORY=rameshthoomu/fabric-peer-${ARCH}
PEER_VERSION=${ARCH}-${VERSION}-snapshot-${SNAPSHOT}

# Peer config path ocmes from Dockerfile.in in hyperledger repository
# Ref: https://github.com/hyperledger/fabric/blob/master/images/peer/Dockerfile.in
PEER_CFG_PATH=/etc/hyperledger/fabric

docker run --rm -v ${BASE_FOLDER}/output/executable:/opt ${PEER_DOCKER_REPOSITORY}:${PEER_VERSION} cp /usr/local/bin/peer /opt
docker run --rm -v ${BASE_FOLDER}/output/peerconfig:/opt ${PEER_DOCKER_REPOSITORY}:${PEER_VERSION} cp -r ${PEER_CFG_PATH} /opt

docker build -f Dockerfile_utils -t mrshahibm/utils:x86_64-1.0.0 .

docker run --rm -v ${BASE_FOLDER}:/opt mrshahibm/utils:x86_64-1.0.0 rm -rf /opt/output
