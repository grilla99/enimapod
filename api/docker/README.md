# Setting up the API container

### Install docker and dependencies
- Install Docker following the [official docs](https://docs.docker.com/get-docker/).

### Build the container image
- Ensure you're in `enimapod/api/`
- Run `sudo docker build -f docker/Dockerfile -t enimapod-api .`

### Run the container
- Start the container, removing any existing container - `sudo docker rm -f enimapod-api; sudo docker run --name enimapod-api -p 8081:8081 -d enimapod-api`

### Access the web server
- Go to `http://localhost:8081`
    - You should see the `index.html` page rendered.
    - Ensure you're using HTTP, your browser may try to redirect to HTTPS.

### Common commands
- List running containers - `sudo docker container ls` (add `-a` to include stopped containers)
- View container logs - `sudo docker logs enimapod-web`