#!/bin/bash
echo "Starting node for user $USER";
if [ "$PEER" == "" ]; then
    killall php
else
    echo "Bootstrapping network with node $PEER"
    # shellcheck disable=SC2006
    peerPort=`cat data/"$PEER".port`
fi
rm -rf data/"$USER".json
port=8000
retry=30
while [ $retry -gt 0 ]
do
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null ; then
           (( retry -=1 ))
           (( port +=1 ))
    else
        break
    fi
done

echo "$port" > data/"$USER".port
php -S 127.0.0.1:"$port" &
echo ""
php gossip.php "$port" "$peerPort"