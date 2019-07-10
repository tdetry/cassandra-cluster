#!/bin/bash
echo -n "How many nodes? "
read numnodes
if ! [ "$numnodes" -eq "$numnodes" ] 2> /dev/null
then
    echo "Please enter an integer next time"
    exit
fi
SDIR=`pwd`
#sets up the first node with the name node01
source $SDIR/gcloud-server-setup.sh node01
#sets up subsequent nodes
for ((i=2;i<=$numnodes;i++))
do
        echo "starting node0$i"
        source $SDIR/gcloud-add-replicas.sh node0$i
done
