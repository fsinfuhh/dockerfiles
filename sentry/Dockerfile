FROM getsentry/sentry:22.12.0

RUN apt-get update
RUN apt-get install -y gcc libldap2-dev libsasl2-dev

ADD . /usr/src/sentry
RUN if [ -s /usr/src/sentry/requirements.txt ]; then pip install -r /usr/src/sentry/requirements.txt; fi

