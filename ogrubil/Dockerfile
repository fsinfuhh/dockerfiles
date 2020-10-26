FROM debian:buster

RUN apt update
RUN apt -y --no-install-recommends install python3 python3-pip uwsgi uwsgi-plugin-python3

COPY ogrubil /app/src/ogrubil

WORKDIR /app/src/ogrubil

RUN ln -sf /app/config/settings.py ogrubil/settings.py

RUN pip3 install poetry psycopg2-binary
RUN poetry export -nf requirements.txt > requirements.txt
RUN pip3 install -r requirements.txt

COPY run /usr/local/bin/run

CMD /usr/local/bin/run
