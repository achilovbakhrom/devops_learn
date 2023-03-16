#!/bin/bash

FRONT_APP_DIR=./front-app

if [ -d $FRONT_APP_DIR ]; then
	cd $FRONT_APP_DIR && npm run lint && npm run test && npm run e2e
else
	echo "First run ./build-client.sh script"
fi
