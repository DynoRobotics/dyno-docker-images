#!/bin/bash

docker login
docker build . -t dynorobotics/balena-amd64-node-ros2:eloquent
docker push dynorobotics/balena-amd64-node-ros2:eloquent
