# Structr Docker Setup

[![Tests](https://github.com/structr/docker-setup/actions/workflows/main.yml/badge.svg)](https://github.com/structr/docker-setup/actions/workflows/main.yml)

A Docker Compose setup for running Structr with a pre-configured Neo4j database.

## Note: Privacy Policy Agreement

The environment variable `AGREE_TO_STRUCTR_PRIVACY_POLICY` (https://structr.com/privacy) needs to be set to `yes` in the `docker-compose.yml` file before Structr can be started.

---

## Requirements

- Docker
- Docker Compose

---

## Quick Start (Easiest Method)

This is the simplest way to get started. No configuration needed.

1. **Start the containers:**
   ```bash
   docker compose up -d
   ```

2. **Access Structr:**
   Open http://127.0.0.1:8082/structr/ in your browser

3. **Stop the containers:**
   ```bash
   docker compose down
   ```

**Note:** This uses Docker-managed volumes. Your data persists between restarts but is managed internally by Docker.

---

## Advanced Setup (Custom Volume Directories)

If you want to access Structr data directly on your host filesystem (useful for deployments and backups), you can use custom volume mounts.

### Initial Setup

1. **Run the setup script:**
   ```bash
   ./setup.sh
   ```
   This creates local directories and sets proper permissions.

2. **Add your license file:**
   - If you have a Structr license, copy it to `./structr/license.key`
   - For community edition, the setup script creates an empty file for you

3. **Modify docker-compose.yml:**
   
   Replace the named volumes with bind mounts. Change the `volumes` section for each service:

   **For Neo4j:**
   ```yaml
   volumes:
     - ./volumes/neo4j-database:/data
     - ./volumes/neo4j-logs:/logs
   ```

   **For Structr:**
   ```yaml
   volumes:
     - ./volumes/structr-files:/var/lib/structr/files
     - ./volumes/structr-repository:/var/lib/structr/repository
     - ./volumes/structr-logs:/var/lib/structr/logs
     - ./structr/license.key:/var/lib/structr/license.key
   ```

4. **Start the containers:**
   ```bash
   docker compose up -d
   ```

### Benefits of Custom Volume Directories

- Direct access to logs in `./volumes/structr-logs/` and `./volumes/neo4j-logs/`
- Easy backup and restore of data
- Simplified deployment workflows (see below)

---

## Working with Containers

### View running containers
```bash
docker ps
```

### Access container shell
```bash
docker exec -it <container_id> /bin/sh
```

### View logs
```bash
docker compose logs          # All logs
docker compose logs structr  # Structr logs only
docker compose logs neo4j    # Neo4j logs only
```

---

## Deployment Workflow

When using custom volume directories, you can deploy Structr applications through the repository directory.

**Important: Follow this order:**

1. Clone your application repository to `./volumes/structr-repository`

2. Navigate to Structr's dashboard at http://localhost:8082/structr/#dashboard → Deployment

3. **Import application:**
   - Enter `/var/lib/structr/repository/webapp` in the "Application import from server directory" field
   - Click import

4. **Export changes:**
   - After making changes in Structr
   - Enter `/var/lib/structr/repository/webapp` in the "Application export to server directory" field
   - Click export

5. **Commit and push:**
   - From the host system, commit your changes in `./volumes/structr-repository`
   - Push to your repository

6. **Deploy updates:**
   - Pull the latest changes
   - Repeat from step 3

---

## Configuration

### Default Credentials

- **Structr:**
  - Username: `admin`
  - Password: `admin`

- **Neo4j:**
  - Username: `neo4j`
  - Password: `structrDockerSetup`

### Resource Limits

You can adjust CPU and memory limits in `docker-compose.yml` under the `deploy.resources` section for each service.

Default limits:
- **CPU:** 2 cores limit, 1 core reserved
- **Memory:** 4GB limit, 1GB reserved

---

## Troubleshooting

### Containers won't start
- Check if ports 8082, 7474, 7473, or 7687 are already in use
- View logs with `docker compose logs`

### Permission issues with custom volumes
- Run the setup script again: `./setup.sh`
- Ensure your user is in the `structr` group (may require logout/login)

### Data persistence
- **Quick Start method:** Data stored in Docker volumes, persists until you run `docker compose down -v`
- **Advanced method:** Data stored in `./volumes/` directory on your host
