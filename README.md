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

The best alternative is to use Docker-compose. We created a docker-compose file to build all the images and run all the docker container. You can use it by using in the right folder. This will setup the project with the container and images name that i created.

```bash
docker-compose up
```


### Docker Login and Image pushing 

```bash
docker login
docker tag <Tag_name_docker_image_bdd> <your_dockerhub_username>/postgres_image:<tag>
docker push <your_dockerhub_username>/postgres_image:<tag>
docker tag <Tag_name_docker_image_backend> <your_dockerhub_username>/backend_api_image:<tag>
docker push <your_dockerhub_username>/backend_api_image:<tag>
docker tag <Tag_name_docker_image_http> <your_dockerhub_username>/http_server_image:<tag>
docker push <your_dockerhub_username>/http_server_image:<tag>
```
## Why do we need a multistage build? And explain each step of this dockerfile.

By handling the build and packaging within the Dockerfile, we encapsulate the entire build process in one script. 

### Explanation of Each Step in the Dockerfile

## Build Stage:

```dockerfile
FROM maven:3.8.6-amazoncorretto-17 AS myapp-build
ENV MYAPP_HOME /opt/myapp
WORKDIR $MYAPP_HOME
COPY pom.xml .
COPY src ./src
RUN mvn package -DskipTests
```
##### FROM maven:3.8.6-amazoncorretto-17 AS myapp-build:

The image includes both the JDK and Maven, which are required to build Java applications. AS myapp-build names this stage so that it can be referenced later.

##### ENV MYAPP_HOME /opt/myapp: 

Sets an environment variable MYAPP_HOME which specifies the directory where the application will be built.

##### WORKDIR $MYAPP_HOME:

 Sets the working directory for the subsequent instructions. In this case, it's set to /opt/myapp, where the source code and build artifacts will reside.

##### COPY pom.xml .:

 Copies the Maven project descriptor file (pom.xml) to the current working directory in the image (which is /opt/myapp).

##### COPY src ./src:

 Copies the application's source code into the src directory of the working directory in the image.

##### RUN mvn package -DskipTests:

 Runs Maven to build the project and package it into a JAR file, skipping tests to speed up the build process.

 ## Run Stage:

 ```dockerfile
FROM amazoncorretto:17
ENV MYAPP_HOME /opt/myapp
WORKDIR $MYAPP_HOME
COPY --from=myapp-build $MYAPP_HOME/target/*.jar $MYAPP_HOME/myapp.jar
ENTRYPOINT ["java", "-jar", "myapp.jar"]
```

##### FROM amazoncorretto:17: 

Starts the second stage of the build using Amazon Corretto 17, which is a production-grade Java environment. This image is used for running the application and does not include build tools like Maven.

##### ENV MYAPP_HOME /opt/myapp and WORKDIR $MYAPP_HOME:

These commands are repeated to set up the environment for the runtime stage.

##### COPY --from=myapp-build $MYAPP_HOME/target/*.jar $MYAPP_HOME/myapp.jar:

 Copies the JAR file from the build stage (myapp-build) to the runtime image. This is where the multistage build shines, as only the compiled JAR file is moved to the new stage, leaving behind all the build-specific tools and dependencies.

##### ENTRYPOINT ["java", "-jar", "myapp.jar"]:

 Sets the default command to run when the container starts, which is to execute the Java application.

 ## 1-3 Document docker-compose most important commands. 1-4 Document your docker-compose file.

 ### Docker Compose up

 Command to Builds, creates, starts, and attaches to containers for a service.

```bash
docker-compose up
```

 ### Docker Compose down

Command to stop containers and removes containers, networks, volumes and images created before by up

```bash
docker-compose down
```

### Documents of my docker-compose file

#### Backend Services

```dockerfile
services:
  backend:
    build:
      context: "C:\\Users\\betbe\\Desktop\\Montpellier cours\\DevOps\\simple-api-student-main"
    container_name: "simple_api_student2"
    networks:
      - app-network
    depends_on:
      - database
    environment:
      - SPRING_DATASOURCE_URL=jdbc:postgresql://mon_postgres3:5432/db
      - SPRING_DATASOURCE_USERNAME=usr
      - SPRING_DATASOURCE_PASSWORD=pwd
      - SPRING_JPA_HIBERNATE_DDL_AUTO=update
      - SPRING_JPA_DATABASE-PLATFORM=org.hibernate.dialect.PostgreSQLDialect
```

##### build.context: 

Specifies the directory containing the Dockerfile for building the backend image.

##### container_name: 

Names the container as simple_api_student2.
networks: Connects to the app-network.

##### depends_on: 

Indicates dependency on the database service, ensuring it starts first.

##### environment: 

Sets environment variables for the Spring application, configuring database connectivity and Hibernate behavior.

#### Database Services

```dockerfile
  database:
    build:
      context: "C:\\Users\\betbe\\Desktop\\Montpellier cours\\DevOps"
    container_name: "mon_postgres3"
    networks:
      - app-network
    environment:
      - POSTGRES_DB=db
      - POSTGRES_USER=usr
      - POSTGRES_PASSWORD=pwd
```

##### build.context:
 
 Directory containing the Dockerfile for the PostgreSQL database.

##### container_name: 

Sets the container name to mon_postgres3.

##### environment: 

Configures PostgreSQL with a specific database, user, and password.

#### HTTPD Service (Apache)

```dockerfile
    httpd:
    build:
      context: "C:\\Users\\betbe\\Desktop\\Montpellier cours\\DevOps\\http"
    ports:
      - "80:80"
    networks:
      - app-network
    depends_on:
      - backend
      - database
```

##### build.context: 

Path to the Dockerfile for the Apache HTTP server.

##### ports:

 Maps port 80 on the host to port 80 on the container, allowing access to the HTTP server.

##### depends_on: 

Ensures httpd starts after backend and database services are up.

#### Networks

Finally we create a network to facilitate the communication between the containers 

```dockerfile
networks:
  app-network:
```