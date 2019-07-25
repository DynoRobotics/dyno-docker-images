FROM dynorobotics/balena-amd64-ros2:dashing

RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

RUN apt-get update && apt-get install -y \
  software-properties-common \
  && rm -rf /var/likb/apt/lists/*

RUN add-apt-repository universe

RUN apt-get update && apt-get install -y \
  apt-transport-https \
  dotnet-sdk-2.2 \
  && rm -rf /var/likb/apt/lists/*
