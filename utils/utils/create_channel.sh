CHANNEL_NAME=${1:-${CHANNEL_NAME}}
ORDERER_URL=${2:-${ORDERER_URL}}

cd /shared/utils/

echo "Generating channel block for channel name ${CHANNEL_NAME}"
FABRIC_CFG_PATH=/shared/utils ./generate_channel_block.sh ${CHANNEL_NAME}

echo "Creating channel ${CHANNEL_NAME}"
CORE_LOGGING_LEVEL=debug PEER_CFG_PATH=/shared/utils CORE_PEER_MSPCONFIGPATH=/shared/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/ peer channel create -o ${ORDERER_URL} -c ${CHANNEL_NAME} -f ${CHANNEL_NAME}.tx 

echo "Fetching channel block for ${CHANNEL_NAME}"
CORE_LOGGING_LEVEL=debug PEER_CFG_PATH=/shared/utils CORE_PEER_MSPCONFIGPATH=/shared/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/ peer channel fetch -o ${ORDERER_URL} -c ${CHANNEL_NAME}
