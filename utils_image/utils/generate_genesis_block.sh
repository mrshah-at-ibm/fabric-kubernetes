echo "Generating Genesis Block for the orderer"
configtxgen -profile TwoOrgsOrdererGenesis -outputBlock orderer.block
cp orderer.block /shared/
