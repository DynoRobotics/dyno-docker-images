FROM dynorobotics/balena-amd64-node-ros2:eloquent

RUN apt-get update && apt-get install -y \
    software-properties-common \
    mesa-utils \
  && add-apt-repository ppa:graphics-drivers -y \
  && apt-get update \
  && apt-get install -y nvidia-driver-440 \
  && rm -rf /var/likb/apt/lists/*