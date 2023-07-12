#!/bin/bash

sudo apt-get install -y \
    tmux \
    curl \
    wget \
    vim \
    git \
    sudo \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    mesa-utils \
    unzip \
    ntp \
    whois \
    sudo \
    net-tools \
    locales \
    ssh


sudo locale-gen en_US.UTF-8


# ROS 설치 과정
# ubuntu version fixed: bionic
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt install curl
sudo curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt update


sudo apt-get install ros-melodic-desktop-full -y

## Gazebo simulator dependencies
sudo apt-get install -y \
    protobuf-compiler \
    libeigen3-dev \
    libopencv-dev \
    python-catkin-tools \
    ros-melodic-rqt*


sudo apt-get install python3 python3-pip python-rosinstall python-rosdep python-rosinstall-generator -y


sudo rosdep init
rosdep update 
rosdep fix-permissions 

# 3
source /opt/ros/melodic/setup.bash
mkdir -p $HOME/catkin_ws/src && cd $HOME/catkin_ws/src && catkin_init_workspace

# 소스코드 다운로드

cd $HOME/catkin_ws && catkin_make

echo "source /opt/ros/melodic/setup.bash" >> $HOME/.bashrc
echo "source $HOME/catkin_ws/devel/setup.bash" >> $HOME/.bashrc
echo "export ROS_HOSTNAME=localhost" >> $HOME/.bashrc
echo "export ROS_MASTER_URI=http://localhost:11311" >> $HOME/.bashrc
echo "alias cw='cd ~/catkin_ws'" >> $HOME/.bashrc
echo "alias cs='cd ~/catkin_ws/src'" >> $HOME/.bashrc
echo "alias cm='cd ~/catkin_ws && catkin_make'" >> $HOME/.bashrc
echo "export LIBGL_ALWAYS_INDIRECT=1" >> $HOME/.bashrc

source /opt/ros/$ROS_DISTRO/setup.bash
source /$HOME/catkin_ws/devel/setup.bash

IPADDR=$(hostname -I | cut -d' ' -f1)
echo "USER=$USER"
echo "HOME=$HOME"
echo "IPADDR=$IPADDR"
echo "ROS_ROOT=$ROS_ROOT"
echo "ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH"
echo "ROS_HOSTNAME=$ROS_HOSTNAME"
echo "ROS_MASTER_URI=$ROS_MASTER_URI"

gazebo


