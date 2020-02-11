#sentry-cli releases -o sentry-internal new -p bitpoll $VERSION

FROM registry.mafiasi.de/base-buster

ENV UID=2004

RUN usermod -u $UID -g www-data -d /opt/dashboard www-data
RUN apt update

# https://stackoverflow.com/questions/58160597/docker-fails-with-sub-process-usr-bin-dpkg-returned-an-error-code-1
RUN mkdir -p /usr/share/man/man1 

RUN apt-get -y --no-install-recommends install wget uwsgi uwsgi-plugin-python3 python3 python-virtualenv python3-pip virtualenv yui-compressor make git python3-bleach python3-pil python3-psycopg2 python3-gpg python3-pygraphviz python3-pypdf2 python3-magic gettext gcc python3-dev libldap2-dev libsasl2-dev make libgpgme-dev

#RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
#RUN apt-get install -y --no-install-recommends npm

#RUN npm install cssmin uglify-js -g

RUN wget -nv https://github.com/fsinfuhh/mafiasi/archive/master.tar.gz -O- | tar -xzC /opt 
RUN mv /opt/mafiasi-master /opt/dashboard

WORKDIR /opt/dashboard

RUN pip3 install -U pip setuptools
RUN pip3 install -r requirements.txt
RUN pip3 install -U 'Django<2.1'
RUN pip3 install django-ldapdb
RUN pip3 install uwsgi
RUN pip3 install requests  # for sentry

RUN ln -sf /opt/storage/static/ /opt/dashboard/_static
RUN ln -sf /opt/storage/.gnupg /opt/dashboard

RUN mv mafiasi/settings.py.example mafiasi/settings.py

RUN python3 manage.py compilemessages

RUN chown $UID -R _static
RUN chmod o+r -R .
RUN rm mafiasi/settings.py

RUN ln -sf /opt/config/settings.py /opt/dashboard/mafiasi/settings.py
RUN ln -s /opt/config/services.py /opt/dashboard/mafiasi/services.py
RUN ln -sf /opt/storage/media /opt/dashboard/_media

RUN apt-get -y purge yui-compressor git python-pip gcc python-dev libldap2-dev libsasl2-dev curl
RUN apt-get -y autoremove
RUN apt-get clean

COPY run /usr/local/bin
COPY uwsgi-dashboard.ini /etc/uwsgi/dashboard.ini
EXPOSE 3003/tcp
VOLUME /opt/static
VOLUME /opt/config
VOLUME /opt/log

USER www-data:www-data
CMD /usr/local/bin/run
