# Structr Docker Setup

### Requirements:
- docker
- docker-compose

----

### Usage with docker-compose:
##### Initial setup:

- Copy your license.key file to ./structr/license.key
- Configure the environment variables for the structr-autodeploy service in docker-compose.yml.
	- HOST: host and port of the Structr service. Can be left to default for the regular compose setup.
	- APP_ZIP_URL: URL of a Structr app deployment ZIP that is reachable from within the container.
	- DATA_ZIP_URL: URL of a Structr data deployment ZIP that is reachable from within the container.
	- STRUCTR_SUPERADMIN_PASSWORD: Structr superadmin password that is specified in the structr.conf file.

##### Starting the instances:
- Run `docker-compose up`, optionally add the `-d` flag to run in daemon mode.
- Open `http://127.0.0.1:8082/structr/` in your browser to access Structr

##### Stopping the instances:
- `docker-compose down`

----
