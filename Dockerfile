# Ubuntu:latest는 20.04를 의미합니다.
FROM osrf/ros:melodic-desktop-full-bionic

# 작성자 이름입니다
MAINTAINER kbeom

# apt로 패키지 받을 때 interative하게 사용하는 기능들을 끕니다. Docker에서 로그를 넘길 때 문제가 생길 수 있으므로 이 옵션은 필수입니다!
ARG DEBIAN_FRONTEND=noninteractive
ARG HOST_USER
ARG UNAME=${HOST_USER}
ARG UID=1000
ARG GID=1000
ARG HOME=/home/${UNAME}


#RUN xhost +local:docker

# clean up first
RUN apt-get autoremove --purge --yes \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/ros/rosdep/sources.list.d/20-default.list

# 필수 유틸리티 설치
RUN apt-get update && apt-get install -y \
    terminator \
    curl \
    wget \
    vim \
    git \
    sudo \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    mesa-utils \
    unzip \
    locales \
    ntp \
    whois \
    net-tools \
    sudo


RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  


RUN rosdep init
RUN apt-get install ros-melodic-rqt* -y 
RUN apt-get install python3 python3-pip python-rosinstall python-rosdep python-rosinstall-generator -y

RUN mkdir -p /workspace && chmod -R +x /workspace
#COPY /home/${HOST_USER}/workspace/init-melodic.sh /workspace/

RUN useradd -rm -d ${HOME} -s /bin/bash -g root -G sudo,audio,video,plugdev -u ${UID} ${UNAME}
RUN mkdir -p /etc/sudoers.d && \
    echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME} && \
    chmod 0440 /etc/sudoers.d/${UNAME} 

USER ${UNAME}
WORKDIR $HOME

RUN rosdep update 
RUN rosdep fix-permissions 

COPY init-melodic.sh ./
#CMD ["/bin/bash", "init_tools.sh"]

RUN cd /

# 3
#RUN mkdir -p $HOME/catkin_ws/src && cd $HOME/catkin_ws/src 
#RUN catkin_init_workspace

# 소스코드 다운로드
#RUN cd $HOME/catkin_ws && catkin_make
#RUN source /opt/ros/$ROS_DISTRO/setup.bash
#RUN source /$HOME/catkin_ws/devel/setup.bash

#RUN echo "source /opt/ros/melodic/setup.bash" >> $HOME/.bashrc
#RUN echo "source /$HOME/catkin_ws/devel/setup.bash" >> $HOME/.bashrc
#RUN echo "export ROS_HOSTNAME=localhost" >> $HOME/.bashrc
#RUN echo "export ROS_MASTER_URI=http://localhost:11311" >> $HOME/.bashrc
#RUN echo "alias cw='cd ~/catkin_ws'" >> $HOME/.bashrc
#RUN echo "alias cs='cd ~/catkin_ws/src'" >> $HOME/.bashrc
#RUN echo "alias cm='cd ~/catkin_ws && catkin_make'" >> $HOME/.bashrc