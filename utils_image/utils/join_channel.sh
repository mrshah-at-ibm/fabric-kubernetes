CHANNEL_NAME=${1:-${CHANNEL_NAME}}

cd /shared/utils/

sleep 5
echo "Fetching channel block for ${CHANNEL_NAME}"
CORE_LOGGING_LEVEL=debug PEER_CFG_PATH=/shared/utils CORE_PEER_MSPCONFIGPATH=/shared/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/ peer channel fetch -o ${ORDERER_URL} -c ${CHANNEL_NAME}

echo "Joining channel block for channel name ${CHANNEL_NAME}"
PEER_CFG_PATH=/shared/utils CORE_PEER_MSPCONFIGPATH=/shared/crypto-config/peerOrganizations/org1.example.com/users/Admin\@org1.example.com/msp/ peer channel join -b ${CHANNEL_NAME}.block || true

