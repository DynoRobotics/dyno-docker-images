FROM dynorobotics/balena-aarch64-ros2:crystal

RUN [ "cross-build-start" ]

WORKDIR /usr/src

RUN git clone https://github.com/RobotWebTools/ros2-web-bridge.git \
  && cd ros2-web-bridge \
  && . /opt/ros/crystal/setup.sh \
  && npm install

RUN [ "cross-build-end" ]

WORKDIR /usr/src/ros2-web-bridge

CMD ["node", "bin/rosbridge.js"]
