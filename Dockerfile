FROM ubuntu:xenial
MAINTAINER Tim Cera <tim@cerazone.net>

RUN echo "deb     http://qgis.org/ubuntugis xenial main\n" >> /etc/apt/sources.list
RUN echo "deb     http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu xenial main\n" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key 089EBE08314DF160
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key CAEB3DC3BDF7FB45

RUN    apt-get -y update
RUN    apt-get -y install libgdal-dev=2.2.1 gdal-bin=2.2.1 qgis python-qgis qgis-plugin-grass grass 
RUN    apt-get -y install python-requests python-numpy python-pandas python-scipy python-matplotlib

# For TauDEM
RUN    apt-get -y install libopenmpi-dev
RUN    apt-get -y install build-essential g++

RUN    apt-get clean \
    && apt-get purge

# Download and build taudem
RUN wget -qO- https://api.github.com/repos/dtarb/TauDEM/TauDEM/tarball \
    | tar -xzC /usr/src \
    # Remove the TestSuite directory because it contains large files
    # that we don't need.
    && rm -rf /usr/src/TauDEM-*/TestSuite \
    && cd /usr/src/TauDEM-*/src \
    && make \
    && make clean
RUN ln -s /usr/src/TauDEM-* /opt/taudem
ENV PATH /opt/taudem:$PATH

# Called when the Docker image is started in the container
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD /start.sh
