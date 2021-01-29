# Structr Docker Setup

### Requirements:
- docker
- docker-compose

### Usage with docker-compose:
##### Initial setup:

- copy your license.key file to ./structr/license.key
- run `docker-compose build`

##### Starting the instances:
- `docker-compose --compatibility up -d``
- Open `http://127.0.0.1:8082/structr/` in your browser to access Structr

##### Stopping the instances:
- `docker-compose down`

##### Inspecting the containers
- `docker ps`
- `note the container id`
- `docker exec -it <Unique identifier for container> /bin/sh`


### Usage with docker swarm:
##### Initial setup:

- copy your license.key file to ./structr/license.key
- run `docker swarm init`

##### Starting the instances:
- `docker stack deploy --compose-file docker-compose.yml structr`
- Open `http://127.0.0.1:8082/structr/` in your browser to access Structr

##### Stopping the instances:
- `docker stack rm structr`

##### Inspecting the containers
- `docker ps`
- `note the container id`
- `docker exec -it <Unique identifier for container> /bin/sh`

##### Inspecting the stack
- `docker stack ps structr`
- `docker stack services structr`


### Deployment Roundtrip of an Structr application (order is crucial!!!):

1. clone repository to ./volumes/repository
2. goto `http://localhost:8082/structr/#dashboard` -> Deployment
3. copy `/var/lib/structr/repository/webapp` into the 'Import application from local directory' input field and click on the import button
4. when changes have been made copy the same path into the 'Export application to local directory' input field and click the button
5. commit your changes on the host system to github
6. pull the new repository version
7. push your changes
8. repeat from 3.