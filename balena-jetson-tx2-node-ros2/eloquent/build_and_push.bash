#!/bin/bash

docker login
docker build . -t dynorobotics/balena-jetson-tx2-node-ros2:eloquent
docker push dynorobotics/balena-jetson-tx2-node-ros2:eloquent
