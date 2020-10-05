FROM debian:buster-slim

RUN apt update && apt install -y --no-install-recommends mkdocs nginx make && mkdir /app && rm /var/www/html/index.nginx-debian.html
ADD oerb/Digitale_OERB_2020 /app/src
ADD nginx.conf /etc/nginx/sites-enabled/default
WORKDIR /app/src
RUN make && mv en/site /var/www/html/en && mv de/site /var/www/html/de
ENTRYPOINT nginx -g "daemon off;"
