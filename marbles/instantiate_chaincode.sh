
if [ ! -d marbles ]; then
	echo "Marbles is not setup. Run 'setup_marbles.sh'."
	exit
fi

cd marbles
node scripts/instantiate_chaincode.js

