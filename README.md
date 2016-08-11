docker-qgis-desktop-ubuntu
==========================

Instead of compiling, this image is a "apt-get install" from
http://qgis.org/ubuntugis of the latest QGIS.

This also includes installation of gdal-bin and python-gdal.

# Getting the image

## Use the docker repository:

```
docker pull timcera/qgis-desktop-ubuntu:latest
```

Required Manual Installation
----------------------------
To run a container create a shell script similar to below, perhaps called 
'qgis', but you can call it anything you want.

```
#!/bin/sh

# Should be platform neutral - at least working on Linux and Windows
USER_NAME=`basename $HOME`

# HHHOME is used to pass the HOME directory of the user running qgis
# and is used in "start.sh" to create the same user within the container.

# Users home is mounted as home
# --rm will remove the container as soon as it ends
docker run --rm \
    -i -t \
    -v ${HOME}:/home/${USER_NAME} \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=unix$DISPLAY \
    -e HHHOME=${HOME} \
    timcera/qgis-desktop-ubuntu:latest
```

Be sure to make the "qgis" script (or whatever you called your script) an executable.
```
chmod a+x qgis
```

The above is the content of qgis so you can just
```
./qgis
```

The "-v ${HOME}:/home/${USER_NAME}" option will mount your home directory in
the container.  If you have other mount points, add "-v" options as necessary.

Put into a directory listed in your PATH environment variable.
```
sudo cp qgis /usr/local/bin
```
Note that your home directory will be mounted in the container and thus
accessible to QGIS. If you want other directories to be available, just add
then to qgis script with -v flags. 

If QGIS crashes or hangs it might leave an orphan docker process running. If
you see the process with 
```
docker ps
```
Then run 
```
docker stop <process id or container name>
```
Else run 
```
docker ps -a
```
then
```
docker rm <process id or container name>
```

-----------

Tim Cera (tim@cerazone.net)
