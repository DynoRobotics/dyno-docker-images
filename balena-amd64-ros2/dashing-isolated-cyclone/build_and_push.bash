#!/bin/bash

docker login
docker build . -t dynorobotics/balena-amd64-ros2:dashing-isolated-updated-cyclone
docker push dynorobotics/balena-amd64-ros2:dashing-isolated-updated-cyclone
