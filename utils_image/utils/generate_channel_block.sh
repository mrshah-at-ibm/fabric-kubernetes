CHANNEL_NAME=${1:-"channel"}
echo "Generating Channel block for Channel name - ${CHANNEL_NAME}"
./configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ${CHANNEL_NAME}.tx -channelID ${CHANNEL_NAME}
