FROM nginx:1.23.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.9 \
    python3-pip \
    build-essential

COPY web/web-content/ /usr/share/nginx/html
# use this version locally, above for circleci
# COPY web-content/ /usr/share/nginx/html
COPY package.json /usr/share/nginx/html/package.json
COPY package-lock.json /usr/share/nginx/html/package-lock.json

COPY docker/bash-scripts/initial-load.sh /usr/initial-load.sh

RUN /usr/initial-load.sh

COPY web/docker/nginx.conf /etc/nginx/nginx.conf
# use this version locally, above for circleci
# COPY docker/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80