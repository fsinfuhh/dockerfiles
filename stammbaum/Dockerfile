FROM debian:bullseye

RUN apt update
RUN apt -y --no-install-recommends install python3 python3-pip python3-setuptools python3-wheel graphviz build-essential uwsgi uwsgi-plugin-python3

COPY stammbaum /opt/stammbaum
RUN rm -rf /opt/stammbaum/.pyenv

WORKDIR /opt/stammbaum

RUN pip3 install -r requirements.txt
RUN pip3 install psycopg2-binary

RUN ln -sf /opt/config/settings.py /opt/stammbaum/settings.py
RUN ln -sf /opt/static/ /opt/stammbaum/static

RUN apt remove -y --autoremove python3-pip python3-setuptools python3-wheel build-essential

COPY uwsgi-stammbaum.ini /etc/uwsgi/stammbaum.ini
COPY run /usr/local/bin/run

VOLUME /opt/static
VOLUME /opt/media
VOLUME /opt/config

ENTRYPOINT /usr/local/bin/run
