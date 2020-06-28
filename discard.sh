#!/bin/bash

docker-compose down
rm -rf ./master/data/* ./slave/data/*

exit 0