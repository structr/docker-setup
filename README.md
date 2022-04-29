# Structr Docker Setup

### Requirements:
- docker
- (docker-compose)

----

### Usage with docker-compose:
##### Initial setup:

- Copy your license.key file to ./structr/license.key
- Run `docker-compose build`

##### Starting the instances:
- Run `docker-compose --compatibility up -d` to start Neo4j and Structr
- Open `http://127.0.0.1:8082/structr/` in your browser to access Structr

##### Stopping the instances:
- `docker-compose down`

##### Inspecting the containers
- `docker ps`
- `note the container id`
- `docker exec -it <Unique identifier for container> /bin/sh`

----

### Usage with docker swarm:
##### Initial setup:

- copy your license.key file to ./structr/license.key
- run `docker swarm init`

##### Starting the instances:
- Run `docker stack deploy --compose-file docker-compose.yml structr` to start Neo4j and Structr
- Open `http://127.0.0.1:8082/structr/` in your browser to access Structr

##### Stopping the instances:
- `docker stack rm structr`

##### Inspecting the containers
- `docker ps`
- `note the container id`
- `docker exec -it <Unique identifier for container> /bin/sh`

##### Inspecting the stack
- Run `docker stack ps structr` to get a list of all tasks in the structr stack
- Run `docker stack services structr` to get a list of all services in the structr stack

----

### Customizing Ressources
The CPU and RAM configuration of the containers can be changed in the docker-compose.yml file. If the config is changed here, then `./structr/memory.config` has to be adjusted as well to prevent Structr from using too much or too little ressources and triggering an OutOfMemory exception.

----

### Deployment Roundtrip of an Structr application (order is crucial!!!):

1. clone repository to ./volumes/repository
2. goto `http://localhost:8082/structr/#dashboard` -> Deployment
3. copy `/var/lib/structr/repository/webapp` into the 'Application import from server directory' input field and click on the import button
4. when changes have been made copy the same path into the 'Application export to server directory' input field and click the button
5. commit your changes on the host system to github
6. pull the new repository version
7. push your changes
8. repeat from 3.
