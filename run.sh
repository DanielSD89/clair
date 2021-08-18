#!/bin/bash

timetorun=90
stoptime=$((timetorun + $(date +%s)))

while [ true ]
do  
    if [[ $(date +%s) > $stoptime ]]; then
        echo "[Error]: Timeout waiting for Postgres"
        exit 1;
    fi
    
    #docker exec postgres pg_isready -U clair -d clair
    docker exec postgres psql -U clair -d clair &> /dev/null 2>&1
    
    if [ "$?" -eq 0 ]; then
        docker-compose -f $GITHUB_ACTION_PATH/docker-compose.yml up -d
        echo "Postgres is ready!"
        exit 0;
    fi
    
    sleep 3;
done

timetorun=90
stoptime=$((timetorun + $(date +%s)))

# Check if Clair is UP!
echo "Checking Clair status..."

docker logs -f clair > clair.logs 2>&1

while [ true ]
do  
    if [[ $(date +%s) > $stoptime ]]; then
        echo "[Error]: Timeout waiting for Clair"
        cat clair.logs
        exit 1;
    fi
    
    curl --max-time 5 http://localhost:6060 &> /dev/null 2>&1
    
    if [ "$?" -eq 0 ]; then
        echo "Clair is ready!"
        exit 0;
    fi
    
    sleep 3;
done
