CHANNEL_NAME=${1:-${CHANNEL_NAME}}

cd /shared/utils/

echo "Joining channel block for channel name ${CHANNEL_NAME}"
 PEER_CFG_PATH=/shared/utils CORE_PEER_MSPCONFIGPATH=/shared/crypto-config/peerOrganizations/org1.example.com/users/Admin\@org1.example.com/msp/ peer channel join -b ${CHANNEL_NAME}.block

