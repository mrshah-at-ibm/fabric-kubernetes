CHANNEL_NAME=${1:-${CHANNEL_NAME}}

cd /shared/utils/

sleep 5
echo "Fetching channel block for ${CHANNEL_NAME}"
CORE_LOGGING_LEVEL=debug PEER_CFG_PATH=/shared/utils peer channel fetch -o ${ORDERER_URL} -c ${CHANNEL_NAME}

echo "Joining channel block for channel name ${CHANNEL_NAME}"
PEER_CFG_PATH=/shared/utils peer channel join -b ${CHANNEL_NAME}.block || true

