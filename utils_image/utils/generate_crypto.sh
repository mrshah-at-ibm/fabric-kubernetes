echo "Generating Crypto Material"
cryptogen -peerOrgs 2 -peersPerOrg 1 -ordererNodes 1 -baseDir /utils/

cp -r crypto-config /shared/

# Delete admin certs so anyone on the org can perform transaction
find /shared/ -iname admincerts | xargs -i {} rm -rf {}/*

for file in $(find /shared/ -iname *_sk); do dir=$(dirname $file); mv ${dir}/*_sk ${dir}/key.pem; done
