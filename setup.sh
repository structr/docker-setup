#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Structr Docker Setup${NC}\n"

# Check if docker is installed
if ! [ -x "$(command -v docker)" ]; then
  echo -e "${RED}Error: docker is not installed.${NC}" >&2
  exit 1
fi

USER=$(id -un)

# Setup user group for proper permissions
echo "Checking user and group configuration..."
if [[ $OSTYPE == 'darwin'* ]]; 
	then
		echo
		echo "	Darwin system detected - we need sudo privileges to create the structr user group"
		echo

		if ! [ -n "$(dscl . list /Groups | grep structr)" ]; then
			echo "Adding new structr user group for deployment file exchange between host and containers..."
			sudo dscl . -create /Groups/structr gid 8082
			sudo dseditgroup -o edit -a $USER -t user structr
			echo -e "${GREEN}✓ Created structr group and added current user${NC}"
		else
			echo -e "${GREEN}✓ Structr group already exists${NC}"
		fi
	else
		if ! [ $(getent group structr) ] && [ -x "$(command -v groupadd)" ]; then
			echo "Adding new structr user group for deployment file exchange between host and containers."
			groupadd -f --gid 8082 structr		
			usermod -a -G structr $USER
			echo -e "${GREEN}✓ Created structr group and added current user${NC}"
		else
			echo -e "${GREEN}✓ Structr group already exists${NC}"
		fi
fi

# Create volume directories
echo -e "\nCreating volume directories..."

echo "Creating structr file volume mount"
mkdir -p ./volumes/structr-files
echo -e "${GREEN}✓ Created ./volumes/structr-files${NC}"

echo "Creating structr repository volume mount"
mkdir -p ./volumes/structr-repository
echo -e "${GREEN}✓ Created ./volumes/structr-repository${NC}"

echo "Setting group structr as owner of the repository directory..."
if [[ $OSTYPE == 'darwin'* ]]; then
	sudo chown -R $USER:8082 ./volumes/structr-repository
else
	if [ -x "$(command -v chown)" ]; then
		sudo chown -R $USER:8082 ./volumes/structr-repository 2>/dev/null || chown -R $USER:8082 ./volumes/structr-repository
	fi
fi
echo -e "${GREEN}✓ Set permissions on ./volumes/structr-repository${NC}"

echo "Creating structr logs volume mount"
mkdir -p ./volumes/structr-logs
echo -e "${GREEN}✓ Created ./volumes/structr-logs${NC}"

echo "Creating neo4j database volume mount"
mkdir -p ./volumes/neo4j-database
echo -e "${GREEN}✓ Created ./volumes/neo4j-database${NC}"

echo "Creating neo4j logs volume mount"
mkdir -p ./volumes/neo4j-logs
echo -e "${GREEN}✓ Created ./volumes/neo4j-logs${NC}"

# Create license.key file
mkdir -p ./structr
touch ./structr/license.key
echo -e "${GREEN}✓ Created ./structr/license.key (empty for community edition)${NC}"

echo -e "\n${GREEN}Setup complete!${NC}\n"
echo -e "Next steps:"
echo -e "1. If you have a Structr license, copy it to ./structr/license.key"
echo -e "2. Modify docker-compose.yml to use bind mounts (see README.md for details)"
echo -e "3. Run: docker compose up -d"
echo -e "\nNote: You may need to log out and back in for group changes to take effect.\n"

exit 0