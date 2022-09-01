#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: docker is not installed.' >&2
  exit 1
fi

SWARM_ACTIVE=`docker info | grep 'Swarm: active' -c`
USER=$(id -un)

echo "Checking docker configuration for active docker swarm mode..."
if [ $SWARM_ACTIVE -eq 0 ];	
	then
   		echo -e "${RED}\n\tDocker swarm mode not active.\n\t${NC}Please refer to the README.md for more information.\n";
	else
		echo -e "${GREEN}\n\tDocker swarm mode active.\n\n${NC}To start Structr and Neo4j, run the following command or refer to the README.md for more information:\n\n\tdocker stack deploy --compose-file=docker-compose.yml structr\n";
fi

echo "Checking user and group configuration..."
if [[ $OSTYPE == 'darwin'* ]]; 
	then

		echo
		echo "	darwin system detected we need sudo privileges to create the structr user group"
		echo

		if ! [ -n $(dscl . list /Groups | grep structr) ]; then

			echo "Adding new structr user group for deployment file exchange between host and containers..."
			sudo dscl . -create /Groups/structr gid 8082
			sudo dseditgroup -o edit -a $USER -t user structr

		fi
		
	else
		if ! [ $(getent group structr) ] && [ -x "$(command -v groupadd)" ]; then

			echo "Adding new structr user group for deployment file exchange between host and containers."
			groupadd -f --gid 8082 structr		
			usermod -a -G structr $USER

		fi
fi

echo "Creating structr file volume mount"
mkdir -p ./volumes/structr-files

echo "Creating structr repository volume mount"
mkdir -p ./volumes/structr-repository
echo "Setting group structr as owner of the structr usergroup. We need sudo access for this..."
sudo chown -R $USER:8082 ./volumes/structr-repository

echo "Creating structr logs volume mount"
mkdir -p ./volumes/structr-logs

echo "Creating neo4j database volume mount"
mkdir -p ./volumes/neo4j-database

echo "Creating neo4j logs volume mount"
mkdir -p ./volumes/neo4j-logs

mkdir -p ./structr
touch ./structr/license.key

echo -e "\n${GREEN}Setup complete"

exit 0
