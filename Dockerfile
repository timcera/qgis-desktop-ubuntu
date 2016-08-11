FROM ubuntu:xenial
MAINTAINER Tim Cera <tim@cerazone.net>

RUN echo "deb     http://qgis.org/ubuntugis xenial main\n" >> /etc/apt/sources.list
RUN echo "deb     http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu xenial main\n" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key 3FF5FFCAD71472C4
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key 089EBE08314DF160

RUN    apt-get -y update
RUN    apt-get -y install qgis python-qgis qgis-plugin-grass
RUN    apt-get -y install python-requests python-numpy python-pandas python-scipy python-matplotlib

RUN    apt-get clean \
    && apt-get purge

# Called when the Docker image is started in the container
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD /start.sh
