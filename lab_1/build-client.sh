#!/bin/bash

export ENV_CONFIGURATION=production

echo "Build environment is $ENV_CONFIGURATION"

FRONT_APP_DIR_NAME=front-app
PROJECT_DIR=./$FRONT_APP_DIR_NAME
BUILD_DIR=./dist/

app_build_file=$BUILD_DIR/client-app.zip

app_cloned=false
if [[ ! -d $PROJECT_DIR ]]; then
	mkdir $PROJECT_DIR
	git clone https://github.com/EPAM-JS-Competency-center/shop-angular-cloudfront.git $PROJECT_DIR
	app_cloned=true
	npm install
	echo "App cloned successfully"
fi

if ! $app_cloned; then
	cd $PROJECT_DIR
	git pull origin main
	npm install
	cd ..
	echo "App updated successfully"
fi

cd $PROJECT_DIR

if [ -e "${app_build_file}" ]; then
	rm "${app_build_file}"
	echo "Old version of the app was removed!"
fi

npm run build --configuration=$ENV_CONFIGURATION --output-path=$BUILD_DIR -y
7z a -tzip $app_build_file $BUILD_DIR/app/*
echo "Client app was built with $ENV_CONFIGURATION configuration."



