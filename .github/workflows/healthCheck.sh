#!/bin/bash

function healthCheck() {
    echo "Waiting for Structr to be ready for deployment"
    for i in $(seq 1 100)
    do
      STATUS_CODE=$(curl --write-out %{http_code} --silent localhost:8082/structr/health/ready)
      
      if [ "$STATUS_CODE" -ne 200 ] ; then
        echo "Status is $STATUS_CODE. Still waiting for Structr to start..."
        sleep 5
      else
        echo "Running Structr instance found"
        return 0
      fi
    done
    echo "Structr failed to start. Exiting..."
    exit 1
}

healthCheck