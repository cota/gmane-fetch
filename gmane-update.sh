#!/bin/bash
# gmane-update.sh: append messages to an mbox file from a gmane group
# The `start_id` parameter is also the name of the mbox file to update.
# When it gets updated, it's renamed to the id of the newest message retrieved.

# The gmane web server will cancel the transfer if it takes too long.
# Split the retrieval into chunks of `step` messages each to avoid timing out.
step=20

if [ $# -lt 1 -o $# -gt 2 ]
then
    echo "Usage: `basename $0` group_name [start_id]"
    exit 1
fi

# fetch the id of the message at the tip of the group
tip=$(wget http://blog.gmane.org/gmane.$1 -O- -q | \
    grep  'Permalink' | sed 1q | sed 's/^.*\/\([0-9]*\)">.*$/\1/')
if [[ $tip != [1-9][0-9]* ]]
then
    echo "Error: can't detect the tip of group '$1'."
    exit 1
fi

if [ ! $# -eq 2 ]
then
    init=0
else
    init=$2
fi

if [ ! $tip -gt $init ]
then
    echo "Error: tip not greater than initial id."
    exit 1
fi

for i in `seq $init $step $tip`
do
    let ttip=$i+$step
    if [ $ttip -gt $tip ]
    then
	let ttip=$tip
    fi

    echo -n "Downloading messages $i-$ttip... "

    if ./gmane-save.sh $1 $i $ttip
    then
	echo "OK"
    else
	echo "Failed"
	echo "Error from gmane detected: try lowering 'step'."
	exit 1
    fi
done
exit 0
