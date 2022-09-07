# Running the Hello World Example Directly
---
### Prerequisites
- Install Maven Version 3.8.6
    - OS X: `brew install maven`
- Install Spring Version 2.7.3 and Spring Boot
    - OS X: `brew tap spring-io/tap`
    - OS X: `brew install spring-boot`

### Running the example
- Maven uses pom.xml to build / run projects, so commands need to be executed from the directory containing this.
- Inside this folder run `mvn spring-boot:run`
- Visit localhost:8080 to see the hello world output (might clash with the Docker port)

### Packaging as a JAR
- Run `mvn package` from the command line in the api folder
- Inside target directory will find file output called similar to: `api-x.x.x-SNAPSHOT.jar`
- To run the jar use the JAR command:
    - `java -jar target/api-0.0.1-SNAPSHOT.jar`

# Running the Hello World Example Using Docker

### Install docker and dependencies
- Install Docker following the [official docs](https://docs.docker.com/get-docker/).

### Build the container image
- Ensure you're in `enimapod/api/`
- Run `sudo docker build -f docker/Dockerfile -t enimapod-api .`

### Run the container
- Start the container, removing any existing container - `sudo docker rm -f enimapod-api; sudo docker run --name enimapod-api -p 8080:80 -d enimapod-api`

### Access the web server
- Go to `http://localhost:8080`
  - You should see the `index.html` page rendered.
  - Ensure you're using HTTP, your browser may try to redirect to HTTPS.

### Common commands
- List running containers - `sudo docker container ls` (add `-a` to include stopped containers)
- View container logs - `sudo docker logs enimapod-web`