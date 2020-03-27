#/bin/bash

if [[ ! -f data.csv ]]
then
	echo "City,Province/State,Country/Region,Date,Confirmed,Deaths,Recovered" > data.csv
fi
tmp=`mktemp`
cat $1 | sed 's/\//_/g' | sed 's/Last Update/Last_Update/g' > $tmp
Rscript ./run.R $tmp
rm -rf $tmp
