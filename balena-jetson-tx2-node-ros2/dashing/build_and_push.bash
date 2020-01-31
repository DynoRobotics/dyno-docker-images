#!/bin/bash

docker login
docker build . -t dynorobotics/balena-jetson-tx2-node-ros2:dashing
docker push dynorobotics/balena-jetson-tx2-node-ros2:dashing
