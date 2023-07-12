#!/bin/bash
#set -x

# sudo usermod -aG docker $USER
# newgrp docker
sudo docker build --no-cache --force-rm -f Dockerfile --build-arg HOST_USER=$USER -t ros/melodic:base .

USER_UID=$(id -u)
TAG='11.8.0-cudnn8-devel-ubuntu18.04'
#IMAGE='ubuntu:18.04'
IMAGE='nvidia/cuda:11.8.0-cudnn8-devel-ubuntu18.04'
TTY='--device=/dev/ttyACM0'

#xhost +$(hostname -I | cut -d' ' -f1)

xhost +local:docker

echo "IMAGE=" $IMAGE
echo "TAG=" $TAG
echo "USER_UID=" $USER_UID
echo "USER=" $USER
echo "IPADDR=" $(hostname -I | cut -d' ' -f1)
echo "TTY=" $TTY

XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ]
    then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

docker run -it \
    --init \
    --ipc=host \
    --shm-size=8G \
    --privileged \
    --network=host \
    -e DISPLAY=$DISPLAY \
    -e XDG_RUNTIME_DIR=/run/user/1000 \
    -e QT_GRAPHICSSYSTEM=native \
    -e USER=$USER \
    --gpus all \
    --env=UDEV=1 \
    --env=LIBUSB_DEBUG=1 \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --env="XAUTHORITY=$XAUTH" \
    -v /home/$USER/Workspace:/home/$USER/Workspace \
    -v /dev:/dev \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    --volume="$XAUTH:$XAUTH" \
    --runtime=nvidia \
    --name=nvidia_ros \
    ros/melodic:base \
    bash
    
export containerId=$(docker ps -l -q)