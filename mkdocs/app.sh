#!/usr/bin/env bash

# set environment to instance (use for cronjob script)
#export GITHUB_TOKEN=${GITHUB_TOKEN}

# prepare github access token
git config --global credential.helper store
git config --global user.email "${GITHUB_USER}@gmail.com"
git config --global user.name "Mkdocs tool"
echo "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com" > /root/.git-credentials
echo ${GITHUB_TOKEN} > ./GITHUB_TOKEN

# pull docs-tool repo
git clone -b master --depth=1 ${IT_REPO}
cp -rf ./docs/* ./app/docs/

if [ -d ./mytheme ]; then
  echo "Copy custom_theme"
  mkdir -p ./app/mytheme
  cp -r ./mytheme/* ./app/mytheme/
else
  mkdir -p ./app/mytheme
fi


# clone docs from github and build
cp -f ./mkdocs_build.sh ./app/

# run build script
cd ./app/ && /bin/sh ./mkdocs_build.sh

#service cron restart
#sudo /etc/init.d/cron restart

# run mkdocs with port
#mkdocs serve -a 0.0.0.0:${PORT} --dirtyreload

# wait for docker container running in minutes
#sleep 1000
