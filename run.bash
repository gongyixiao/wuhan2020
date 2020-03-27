#/bin/bash

if [[ ! -f data.csv ]]
then
	echo "City,Province/State,Country/Region,Date,Confirmed,Deaths,Recovered" > data.csv
fi
Rscript ./run.R $1
