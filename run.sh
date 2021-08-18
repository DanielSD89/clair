#!/bin/bash

timetorun=60
stoptime=$((timetorun + $(date +%s)))

# Check if Clair is UP!
echo "Checking Clair status..."

docker logs -f clair > clair.logs

while [ true ]
do  
    if [[ $(date +%s) > $stoptime ]]; then
        echo "[Error]: Timeout waiting for Clair"
        cat clair.logs
        exit 1;
    fi
    
    curl http://localhost:6060 &> /dev/null 2>&1
    
    if [ "$?" -eq 0 ]; then
        echo "Ready!"
        exit 0;
    fi
    
    sleep 5;
done
