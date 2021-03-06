FROM registry.mafiasi.de/base-stretch

RUN apt update
RUN usermod -u 2009 -g 33 -d /opt/marv www-data

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y --no-install-recommends install dirmngr g++ git gnupg lsb-release uwsgi uwsgi-plugin-python libldap2-dev libsasl2-dev libssl-dev virtualenv ffmpeg jq less libcapnp-dev libffi-dev libfreetype6-dev libpng-dev libsasl2-dev libssl-dev libz-dev locales lsof python-cv-bridge python2.7-dev python-opencv python-pip rsync sqlite3 ssh unzip vim

RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt update
RUN apt install -y ros-melodic-ros-base ros-melodic-rosbag ros-melodic-cv-bridge

RUN git clone https://gitlab.com/timonegk/marv-robotics.git /opt/marv
WORKDIR /opt/marv
RUN git checkout ldap

RUN pip install wheel; \
    pip install -r requirements/marv-cli.txt; \
    pip install -r requirements/marv.txt; \
    pip install -r requirements/marv-robotics.txt; \
    pip install marv-ludwig PyYAML PyCrypto gnupg rospkg opencv-python

RUN mkdir -p /opt/marv/sites/cml
RUN ln -sf /opt/config/marv.conf /opt/marv/sites/cml/marv.conf; \
    ln -sf /opt/config/uwsgi.conf /opt/marv/sites/cml/uwsgi.conf; \
    cp -r requirements /requirements

RUN pip install --no-deps code/marv-cli; \
    pip install --no-deps code/marv;\
    pip install --no-deps code/marv-robotics

RUN apt -y autoremove; apt clean

COPY run /usr/local/bin/run
COPY update_db /usr/local/bin/update_db
COPY uwsgi.ini /etc/uwsgi/marv.ini
RUN echo 'source /opt/ros/melodic/setup.bash' >> /etc/bash.bashrc

VOLUME /opt/scanroot /opt/config /opt/log
USER www-data:www-data
ENTRYPOINT /usr/local/bin/run
