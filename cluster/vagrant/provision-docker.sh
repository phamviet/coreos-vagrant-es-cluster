#!/bin/bash

# Loop
echo "Importing dockerfile/redis image..."
docker load < ~/share/docker/redis.tar

echo "Importing google/golang image..."
docker load < ~/share/docker/google.golang.tar