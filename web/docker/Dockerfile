FROM nginx:1.23.1

#COPY web/web-content/ /usr/share/nginx/html
# use this version locally, above for circleci
COPY web-content/ /usr/share/nginx/html

#COPY web/docker/nginx.conf /etc/nginx/nginx.conf
# use this version locally, above for circleci
COPY docker/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80