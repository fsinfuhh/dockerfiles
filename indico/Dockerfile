FROM docker.io/python:3.12-bookworm

RUN apt update
RUN apt install -y libpq-dev nginx python3-dev python3-pip libxslt1-dev libxml2-dev libffi-dev libpcre3-dev libyaml-dev build-essential uwsgi uwsgi-plugin-python3 libjpeg62-turbo-dev libsasl2-dev libldap2-dev libssl-dev

ENV VERSION=3.3.6
RUN pip install uWSGI python-ldap
RUN pip install indico==$VERSION jsonschema==4.*

ADD uwsgi.ini /etc/uwsgi/apps-enabled/indico.ini
ADD nginx.conf /etc/nginx/sites-enabled/default
ADD run.sh /usr/local/bin/run

RUN mkdir -p /app /app/work /app/work/cache /app/work/tmp

# add image metadata
ENV INDICO_CONFIG=/app/config/indico.conf
VOLUME /app/config
VOLUME /app/log
VOLUME /app/data
EXPOSE 80/tcp
EXPOSE 3000/tcp
EXPOSE 3001/tcp
ENTRYPOINT /usr/local/bin/run
