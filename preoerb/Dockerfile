FROM debian:buster-slim

RUN apt update && apt install -y --no-install-recommends python3-pip python3-setuptools python3-wheel nginx make && mkdir /app && rm /var/www/html/index.nginx-debian.html && pip3 install mkdocs
ADD oerb/Digitale_OERB /app/src
ADD nginx.conf /etc/nginx/sites-enabled/default
WORKDIR /app/src
RUN make && mv en/site /var/www/html/en && mv de/site /var/www/html/de
ENTRYPOINT nginx -g "daemon off;"
