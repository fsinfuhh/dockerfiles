FROM debian:bullseye

RUN apt update
RUN apt -y --no-install-recommends install python3 python3-pip uwsgi uwsgi-plugin-python3 python3-setuptools python3-wheel

COPY oestatus-v3 /app/src

WORKDIR /app/src

RUN pip3 install -r requirements.txt

COPY uwsgi-oestatus.ini /etc/uwsgi/oestatus.ini
COPY run /usr/local/bin/run

VOLUME /app/config

CMD /usr/local/bin/run
