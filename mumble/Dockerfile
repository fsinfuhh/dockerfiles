FROM debian:buster-slim

RUN apt update && apt install -y mumble-server wget python2 python-ldap python-zeroc-ice zeroc-ice-slice libqt5sql5-psql
WORKDIR /app
RUN wget https://raw.githubusercontent.com/mumble-voip/mumble-scripts/master/Authenticators/LDAP/LDAPauth.py

COPY run /usr/local/bin/run
CMD /usr/local/bin/run
