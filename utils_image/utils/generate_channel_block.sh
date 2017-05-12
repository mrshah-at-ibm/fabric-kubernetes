CHANNEL_NAME=${CHANNEL_NAME:-$1}
CHANNEL_NAME=${CHANNEL_NAME:-"channel"}

./replace_configtxyaml.sh

echo "Generating Channel block for Channel name - ${CHANNEL_NAME}"
./configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ${CHANNEL_NAME}.tx -channelID ${CHANNEL_NAME}
