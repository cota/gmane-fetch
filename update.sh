#!/bin/sh

set -e

if [ ! -e [0-9]* ]
then
	touch 0
fi

LISTNAME=$(cat .listname | sed '/^$/d' | sed 1q)

./gmane-update.sh $LISTNAME [0-9]*
exit 0
