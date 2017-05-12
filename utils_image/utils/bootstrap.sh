echo "Deleting old stuff"
rm -rf /shared/*
rm -rf /shared/utils
rm -rf /utils/orderer.block

echo "Generating crypto material"
generate_crypto.sh

echo "Generating genesis block"
generate_genesis_block.sh

echo "Copying orderer-ca.yaml"
cp -r cas /shared/

echo "Copying utils folder"
cp -r /utils /shared/

echo "Done bootstrapping"
touch /shared/bootstrapped
