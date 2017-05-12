echo "Generating Genesis Block for the orderer"

./replace_configtxyaml.sh

configtxgen -profile TwoOrgsOrdererGenesis -outputBlock orderer.block
cp orderer.block /shared/
