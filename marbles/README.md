# Instructions to run marbles with CS

## Prereqs

1. You have setup the blockchain network on the IBM Container service as mentioned [here](../README.md)
2. You have created channel on the network as mentioned [here](../README.md)
3. The peer you are using here has joined the channel as mentioned [here](../README.md)

## Run Marbles Local

1. Clone marbles, edit the config file & install the dependencies (npm install).
```bash
./setup_marbles.sh
```

2. Install marbles chaincode on the Peer 1.
```bash
./install_chaincode.sh
```

3. Instantiate marbles chaincode on the channel created & joined by this peer.
```bash
./instantiate_chaincode.sh
```

4. Run marbles for org1
```bash
./run_marbles.sh
```

5. Go to marbles UI
Open a browser and go to `localhost:3001`
