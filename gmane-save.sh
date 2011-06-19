#!/bin/bash
# gmane-save.sh: retrieve gmane messages through 'gmane export'
# http://gmane.org/export.php

if [ ! $# -eq 3 ]
then
    echo "Save messages from gmane into an mbox file"
    echo "Usage:"
    echo "`basename $0` group_name id_init id_end"
    echo "Save messages from group group_name starting from id_init to id_end"
    exit 1
fi

wget -q http://download.gmane.org/gmane.$1/$2/$3 -O$3.tmp

# this is dodgy but does the job
if tail -1 $3.tmp | grep 'Fatal error' | grep -q '<b>/home/httpd/gmane/'
then
    exit 1
fi

cat "$3.tmp" >> $2
mv $2 $3
rm "$3.tmp"
exit 0
