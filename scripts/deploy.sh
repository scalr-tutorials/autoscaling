#!/bin/bash
set -o errexit
set -o nounset

DEFAULT_DEPLOY_PATH=/var/www
DEFAULT_APP_REPO=https://github.com/scalr-tutorials/autoscaling.git
DEFAULT_APP_BRANCH=master

: ${DEPLOY_PATH:="$DEFAULT_DEPLOY_PATH"}
: ${APP_REPO:="$DEFAULT_APP_REPO"}
: ${APP_BRANCH:="$DEFAULT_APP_BRANCH"}

# Install git
if [ -f /etc/debian_version ]; then
  apt-get install -y git stress
elif [ -f /etc/redhat-release ]; then
  yum -y install git stress
else
    echo "Unsupported OS"
    exit 1
fi

# Install or Update

if [ ! -d "$DEPLOY_PATH/.git" ]; then
  mkdir -p $DEPLOY_PATH
  rm -r $DEPLOY_PATH
  git clone --branch $APP_BRANCH $APP_REPO $DEPLOY_PATH
else
  cd $DEPLOY_PATH
  git pull --force
  git checkout --force $APP_BRANCH
fi
