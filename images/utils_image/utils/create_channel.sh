CHANNEL_NAME=${1:-${CHANNEL_NAME}}
ORDERER_URL=${2:-${ORDERER_URL}}

cd /shared/utils/

./replace_configtxyaml.sh

set +e
echo "Generating channel block for channel name ${CHANNEL_NAME}"
FABRIC_CFG_PATH=/shared/utils ./generate_channel_block.sh ${CHANNEL_NAME}

echo "Creating channel ${CHANNEL_NAME}"
CORE_LOGGING_LEVEL=debug peer channel create -o ${ORDERER_URL} -c ${CHANNEL_NAME} -f ${CHANNEL_NAME}.tx 

set -e
