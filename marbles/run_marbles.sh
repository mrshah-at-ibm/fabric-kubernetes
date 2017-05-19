
if [ ! -d marbles ]; then
	echo "Marbles is not setup. Run 'setup_marbles.sh'."
	exit
fi

cd marbles
gulp marbles1

