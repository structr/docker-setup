#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: docker is not installed.' >&2
  exit 1
fi

SWARM_ACTIVE=`docker info | grep 'Swarm: active' -c`

echo "Checking docker configuration for active docker swarm mode..."
if [ $SWARM_ACTIVE -eq 0 ];	
	then
   		echo "${RED}\n\tDocker swarm mode not active.\n\t${NC}Please refer to the README.md for more information.\n";
	else
		echo "${GREEN}\n\tDocker swarm mode active.\n\n${NC}To start Structr and Neo4j, run the following command or refer to the README.md for more information:\n\n\tdocker stack deploy --compose-file=docker-compose.yml structr\n";
fi

echo "Creating structr file volume mount"
mkdir -p ./volumes/structr-files

echo "Creating structr repository volume mount"
mkdir -p ./volumes/structr-repository

echo "Creating structr logs volume mount"
mkdir -p ./volumes/structr-logs

echo "Creating neo4j database volume mount"
mkdir -p ./volumes/neo4j-database

echo "Creating neo4j logs volume mount"
mkdir -p ./volumes/neo4j-logs

mkdir -p ./structr
touch ./structr/license.key

echo "\n${GREEN}Setup complete"

exit 0