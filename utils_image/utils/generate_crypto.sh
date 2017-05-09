echo "Generating Crypto Material"
cryptogen generate --config=crypto-config.yaml
cp -r crypto-config /shared/
