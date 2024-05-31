# DevOps Project: Docker Configuration for 3-Tier Application

This README outlines the necessary steps and configurations for setting up a robust 3-tier application using Docker. This setup includes a PostgreSQL database, a backend API, and an HTTP server.

## Why Attach a Volume to PostgreSQL Container?

Attaching a volume to your PostgreSQL container ensures that your data is secure, accessible, and independent of the container lifecycle. It's a standard practice for database management in Docker environments to ensure data durability and reliability.

## Commands List

### Network Configuration
First, create a Docker network to enable inter-container communication:

```bash
docker network create app-network
```

### Build the Docker Image

```bash
docker build -t <image_name> .
```

```bash
docker build -t <image_name> .
```

```bash
docker build -t <image_name> .
```

### Run the Docker Container

```bash
docker run --name <nom_du_conteneur_postgres> -e POSTGRES_DB=db -e POSTGRES_USER=usr -e POSTGRES_PASSWORD=pwd --network app-network -d <Tag_name_docker_image_bdd>
```

```bash
docker run --name <nom_du_conteneur_backend> -p 8090:8080 --network app-network <Tag_name_docker_image_backend>
```

```bash
docker run -dit --name <nom_du_conteneur_http> -p 8080:80 <Tag_name_docker_image_http>
```
### Docker Login and Image pushing 

