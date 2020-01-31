FROM balenalib/jetson-tx2-ubuntu-node:10.16-bionic-build

ENV DEBIAN_FRONTEND=noninteractive

ENV CHOOSE_ROS_DISTRO dashing

# setup timezone and environment
RUN apt-get update && apt-get install -y \
  lsb-release \
  locales \
  curl \
  gnupg2 \
  && echo 'Etc/UTC' > /etc/timezone \
  && ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime \
  && apt-get install -q -y tzdata \
  && rm -rf /var/likb/apt/lists/*

RUN locale-gen --purge en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# install utility packages
RUN apt-get update && apt-get install -y \
  curl \
  wget \
  vim \
  less \
  python-pip \
  ranger \
  tmux \
  python3-matplotlib \
  libyaml-dev \
  libxaw7-dev \
  # clang-format \
  net-tools \
  iputils-ping \
  htop \
  can-utils \
  python3-matplotlib \
  libyaml-dev \
  libxaw7-dev \
  clang-format \
  net-tools \
  iputils-ping \
  htop \
  tig \
  can-utils \
  libsocketcan-dev \
  gdb \
  && rm -rf /var/likb/apt/lists/*

# setup ros2 keys
RUN curl http://repo.ros2.org/repos.key | sudo apt-key add -
RUN curl -sL "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x5523BAEEB01FA116" | sudo apt-key add

# setup sources.list
RUN echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list

# install ROS2 dependencies

RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  git \
  python3-colcon-common-extensions \
  python3-pip \
  python-rosdep \
  python3-vcstool \
  dirmngr \
  gnupg2 \
  libasio-dev \
  libtinyxml2-dev \
  libcunit1-dev \
  # kmod \
  && python3 -m pip install -U \
  argcomplete \
  flake8 \
  flake8-blind-except \
  flake8-builtins \
  flake8-class-newline \
  flake8-comprehensions \
  flake8-deprecated \
  flake8-docstrings \
  flake8-import-order \
  flake8-quotes \
  pytest-repeat \
  pytest-rerunfailures \
  pytest \
  pytest-cov \
  pytest-runner \
  setuptools \
  bash-completion \
  && rm -rf /var/likb/apt/lists/*

# clone source
ENV ROS2_WS /opt/ros2_ws
RUN mkdir -p $ROS2_WS/src
WORKDIR $ROS2_WS
RUN wget https://raw.githubusercontent.com/ros2/ros2/$CHOOSE_ROS_DISTRO/ros2.repos \
    && vcs import src < ros2.repos

# FIXME[sam]: the master branch seems broken at the time of writing, try to remove this later...
RUN cd /opt/ros2_ws/src/ros2/rmw_cyclonedds && git checkout 0.4.4

# bootstrap rosdep
ENV ROSDISTRO_INDEX_URL https://raw.githubusercontent.com/ros/rosdistro/master/index.yaml
RUN rosdep init \
    && rosdep update

# install dependencies
RUN apt-get update && rosdep install -y \
    --from-paths src \
    --ignore-src \
    --rosdistro $CHOOSE_ROS_DISTRO \
    --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 rti-connext-dds-5.3.1 urdfdom_headers" \
    && rm -rf /var/lib/apt/lists/*

# build source
WORKDIR $ROS2_WS
ARG CMAKE_BUILD_TYPE=Debug
RUN colcon build \
    --merge-install \
    --cmake-args \
    -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE

# Install nvm, Node.js and node-gyp
# NOTE(sam): This version is needed by rclnodejs

# ENV NODE_VERSION v10.16.2
# RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash \
#     && . $HOME/.nvm/nvm.sh \
#     && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION \
#     && npm install -g nodemon


RUN echo "source /opt/ros2_ws/install/local_setup.bash" >> $HOME/.bashrc

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
