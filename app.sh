#/bin/bash

# set environment to instance (use for cronjob script)
export GITHUB_TOKEN=${GITHUB_TOKEN}

# prepare github access token
git config --global credential.helper store
git config --global user.email "mrthinlt@gmail.com"
git config --global user.name "Mkdocs tool"
echo 'https://thinlt:${GITHUB_TOKEN}@github.com' > ~/.git-credentials

# create mkdocs app
mkdocs new app

# remote default doc
rm ./app/docs/index.md

#sed -i 's/site_name: \(.*\)/site_name: Magestore Docs/' ./app/mkdocs.yml

# copy to replace default mkdocs.yml
rm ./app/mkdocs.yml
cp -f ./mkdocs.yml ./app/
cp -rf ./docs/* ./app/docs/
mkdir ./app/custom_theme

# clone docs from github and build
cp -f ./mkdocs_build.sh ./app/

# run build script
cd ./app/ && /bin/sh ./mkdocs_build.sh

service cron restart

# run mkdocs with port
mkdocs serve -a 0.0.0.0:${PORT} --dirtyreload
