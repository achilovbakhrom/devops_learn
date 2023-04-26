#!/bin/bash

SERVER_HOST_DIR=$(pwd)/nestjs-rest-api
CLIENT_HOST_DIR=$(pwd)/shop-angular-cloudfront

SERVER_REMOTE_DIR=/var/www/html/shop-app/api
CLIENT_REMOTE_DIR=/var/www/html/shop-app/front

check_remote_dir_exists() {
  echo "Check if remote directories exist"
  if ssh ubuntu-sshuser "[ ! -d $1 ]"; then
    echo "Creating: $1"
  ssh -t ubuntu-sshuser "sudo bash -c 'mkdir -p $1 && chown -R sshuser: $1'"
  else
    echo "Clearing: $1"
    ssh ubuntu-sshuser "sudo -S rm -r $1/*"
  fi
}

check_remote_dir_exists $SERVER_REMOTE_DIR
check_remote_dir_exists $CLIENT_REMOTE_DIR

echo $SERVER_HOST_DIR

cd $SERVER_HOST_DIR && npm run build

scp -Cr dist/ package.json ubuntu-sshuser:$SERVER_REMOTE_DIR

cd $CLIENT_HOST_DIR && npm run build && cd ../
scp -Cr $CLIENT_HOST_DIR/dist/* ubuntu-sshuser:$CLIENT_REMOTE_DIR
echo "Transfering COMPLETE"