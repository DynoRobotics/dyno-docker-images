FROM balenalib/amd64-ubuntu-node:latest-bionic-build

# RUN [ "cross-build-start" ]

# setup timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && apt-get install -q -y tzdata && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# TODO(sam): remove unused stuff to reduce size

# terminal utils
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
  && rm -rf /var/likb/apt/lists/*

# ROS 2
RUN apt-get update && apt-get install -q -y \
    dirmngr \
    gnupg2 \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# setup ros2 keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

# setup sources.list
RUN echo "deb http://packages.ros.org/ros2/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros2-latest.list

RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  git \
  python3-colcon-common-extensions \
  python3-pip \
  python3-rosdep \
  python-vcstool \
  wget \
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
  pytest-watch \
  pytest-runner \
  setuptools \
  # kmod \
  && rm -rf /var/likb/apt/lists/*


# bootstrap rosdep
ENV ROSDISTRO_INDEX_URL https://raw.githubusercontent.com/ros/rosdistro/master/index.yaml
RUN rosdep init \
    && rosdep update

# install python packages
RUN pip3 install -U \
    argcomplete

# install packages
RUN apt-get update && apt-get install -q -y \
    bash-completion \
    dirmngr \
    git \
    gnupg2 \
    libasio-dev \
    libtinyxml2-dev \
    lsb-release \
    python3-pip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# clone source
ENV ROS2_WS /opt/ros2_ws
RUN mkdir -p $ROS2_WS/src
WORKDIR $ROS2_WS
RUN wget https://raw.githubusercontent.com/ros2/ros2/release-latest/ros2.repos \
    && vcs import src < ros2.repos

# install dependencies
RUN apt-get update && rosdep install -y \
    --from-paths src \
    --ignore-src \
    --rosdistro crystal \
    --skip-keys "console_bridge fastcdr fastrtps libopensplice67 rti-connext-dds-5.3.1 urdfdom_headers" \
    && rm -rf /var/lib/apt/lists/*

# build source
WORKDIR $ROS2_WS
RUN colcon \
    build \
    --cmake-args -DSECURITY=ON --no-warn-unused-cli \
    --merge-install

COPY ./dyno_dependencies.repos $ROS2_WS
RUN vcs import src < dyno_dependencies.repos

RUN colcon \
    build \
    --cmake-args -DSECURITY=ON --no-warn-unused-cli \
    --merge-install

# install ros2 packages
# ENV ROS_DISTRO crystal
# RUN apt-get update && apt-get install -y \
#     ros-crystal-ros-base=0.6.1-0* \
#     && rm -rf /var/lib/apt/lists/*


# RUN [ "cross-build-end" ]

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
