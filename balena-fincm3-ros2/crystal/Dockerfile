FROM balenalib/fincm3-ubuntu-node:latest-bionic-build

RUN [ "cross-build-start" ]

ENV CHOOSE_ROS_DISTRO crystal

# setup timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && apt-get install -q -y tzdata && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update && apt-get install -y \
  lsb-release \
  && rm -rf /var/likb/apt/lists/*


# setup ros2 keys
RUN curl http://repo.ros2.org/repos.key | sudo apt-key add -

# setup sources.list
RUN echo "deb http://packages.ros.org/ros2/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros2-latest.list

# install packages
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
  lsb-release \
  build-essential \
  cmake \
  git \
  # python3-colcon-common-extensions \
  python3-pip \
  # python3-rosdep \
  # python-vcstool \
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
  bash-completion \
  rosdep \
  catkin_pkg \
  lark-parser \
  colcon-common-extensions \
  && pip install -U vcstool \
  && rm -rf /var/likb/apt/lists/*

RUN curl -sL "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x5523BAEEB01FA116" | sudo apt-key add
RUN apt-get update && apt-get install -y \
  dirmngr \
  gnupg2 \
  libasio-dev \
  libtinyxml2-dev \
  # kmod \
  && rm -rf /var/likb/apt/lists/*

# bootstrap rosdep
ENV ROSDISTRO_INDEX_URL https://raw.githubusercontent.com/ros/rosdistro/master/index.yaml
RUN rosdep init \
    && rosdep update

# clone source
ENV ROS2_WS /opt/ros2_ws
RUN mkdir -p $ROS2_WS/src
WORKDIR $ROS2_WS
RUN wget https://raw.githubusercontent.com/ros2/ros2/$CHOOSE_ROS_DISTRO/ros2.repos \
    && vcs import src < ros2.repos

# install dependencies
RUN apt-get update && rosdep install -y \
    --from-paths src \
    --ignore-src \
    --rosdistro $CHOOSE_ROS_DISTRO \
    --skip-keys "qtbase5-dev libopensplice69 python3-catkin-pkg-modules python3-lark-parser console_bridge fastcdr fastrtps libopensplice67 rti-connext-dds-5.3.1 urdfdom_headers" \
    && rm -rf /var/lib/apt/lists/*

# build source
WORKDIR $ROS2_WS

# remove packages that depend on qtbase5-dev
RUN rm -r src/ros2/rviz src/ros-visualization

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

RUN [ "cross-build-end" ]

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
