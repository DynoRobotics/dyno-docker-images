#!/bin/bash

docker login
docker build . -t dynorobotics/balena-amd64-node-ros2:foxy
docker push dynorobotics/balena-amd64-node-ros2:foxy
