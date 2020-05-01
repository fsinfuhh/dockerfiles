FROM debian:bullseye

RUN apt update
RUN apt -y --no-install-recommends install python3 python3-pip python3-setuptools python3-wheel graphviz build-essential uwsgi uwsgi-plugin-python3

COPY stammbaum /app/src
RUN rm -rf /app/src/.pyenv

WORKDIR /app/src

RUN pip3 install -r requirements.txt
RUN pip3 install psycopg2-binary

RUN ln -sf /app/config/settings.py /app/src/settings.py

RUN apt remove -y --autoremove python3-pip python3-setuptools python3-wheel build-essential

COPY uwsgi-stammbaum.ini /etc/uwsgi/stammbaum.ini
COPY run /usr/local/bin/run

VOLUME /app/static
VOLUME /app/media
VOLUME /app/config

ENTRYPOINT /usr/local/bin/run
