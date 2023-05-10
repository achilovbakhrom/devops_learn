#!/bin/bash

docker build . -t my-rest-api

docker tag my-rest-api mailbak/my-rest-api:version1.0

docker push mailbak/my-rest-api:version1.0
