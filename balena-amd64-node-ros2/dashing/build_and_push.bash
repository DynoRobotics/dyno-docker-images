#!/bin/bash

docker login
docker build . -t dynorobotics/balena-amd64-node-ros2:dashing
docker push dynorobotics/balena-amd64-node-ros2:dashing
