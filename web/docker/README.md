# Setting up the Web container

### Install docker and dependencies
- Install Docker following the [official docs](https://docs.docker.com/get-docker/).

### Build the container image
- Ensure you're in `enimapod/web/`
- Run `sudo docker build -f docker/Dockerfile -t enimapod-web .`

### Run the container
- Start the container, removing any existing container - `sudo docker rm -f enimapod-web; sudo docker run --name enimapod-web -p 8080:80 -d enimapod-web`

### Access the web server
- Go to `http://localhost:8080`
  - You should see the `index.html` page rendered.
  - Ensure you're using HTTP, your browser may try to redirect to HTTPS.

### Common commands
- List running containers - `sudo docker container ls` (add `-a` to include stopped containers)
- View container logs - `sudo docker logs enimapod-web`

### Pushing image to ECR
- [Build the container image](#build-the-container-image)
- `docker tag enimapod-web:latest 342715877717.dkr.ecr.eu-west-2.amazonaws.com/enimapod-web-server-repository:latest`
- `docker push 342715877717.dkr.ecr.eu-west-2.amazonaws.com/enimapod-web-server-repository:latest`