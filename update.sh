#!/bin/sh

set -e

LISTNAME_FILE=.listname

if [ ! -e $LISTNAME_FILE ]
then
	echo "Cannot find .listname file, exiting."
	exit 1
fi

if [ ! -e [0-9]* ]
then
	touch 0
fi

LISTNAME=$(cat $LISTNAME_FILE | sed '/^$/d' | sed 1q)

./gmane-update.sh $LISTNAME [0-9]*
exit 0
