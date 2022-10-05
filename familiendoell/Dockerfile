FROM docker.io/tiangolo/uwsgi-nginx:python3.9

# prepare container
RUN pip3 install psycopg2-binary

# add application code
COPY prestart.sh /app/prestart.sh
COPY nginx.conf /app/nginx.conf
COPY uwsgi.ini /app/uwsgi.ini
COPY ./familiendOEll-auswerter/requirements.txt /app/src/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /app/src/requirements.txt
COPY ./familiendOEll-auswerter/familiendoellauswerter/ /app/src/
RUN ln -sf /app/config/settings.py /app/src/familiendoellauswerter/settings.py

# configure image
ENV UWSGI_INI /app/uwsgi.ini
EXPOSE 80/tcp
