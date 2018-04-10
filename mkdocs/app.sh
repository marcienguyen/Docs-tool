#!/usr/bin/env bash

# set environment to instance (use for cronjob script)
#export GITHUB_TOKEN=${GITHUB_TOKEN}

# prepare github access token
git config --global credential.helper store
git config --global user.email "${GITHUB_USER}@gmail.com"
git config --global user.name "Mkdocs tool"
echo "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com" > /root/.git-credentials
echo ${GITHUB_TOKEN} > ./GITHUB_TOKEN

## function check git status
_check_git() {
    UPSTREAM=${1:-'@{u}'}
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "$UPSTREAM")
    BASE=$(git merge-base @ "$UPSTREAM")

    if [ $LOCAL = $REMOTE ]; then
        echo "Up-to-date"
    elif [ $LOCAL = $BASE ]; then
        echo "pull"
    elif [ $REMOTE = $BASE ]; then
        echo "push"
    else
        echo "Diverged"
    fi
}

pushd ./data

# clone docs from github and build
ls -l /mkdocs
ls -l /mkdocs/data_docs
if [ ! -d /mkdocs/data_docs -o ! -d /mkdocs/data_docs/.git ]; then
  echo "Clone /mkdocs/data_docs/"
  ls -l /mkdocs/data_docs
  git clone -b master --depth=1 https://github.com/Magestore/Docs.git /mkdocs/data_docs
  ln -s /mkdocs/data_docs/extensions /mkdocs/data/docs
else
  echo "Pull from github"
  pushd /mkdocs/data_docs/
  git_status_check=$( git fetch && _check_git )
  if [ "$git_status_check" = "pull" ]; then
    echo "Pull from github"
    git pull
    git clean -fdx
  fi
  popd
fi

pushd /mkdocs/data
ls -l
popd

# copy theme
cp -rp /mkdocs/data/docs_theme/* /mkdocs/data/docs/

# build mkdocs
echo "MkDocs build"
pwd
ls -l
echo "---"
cd ./docs
ls -l 
sudo mkdocs build
sudo mkdocs gh-deploy -q --force --remote-name https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/Magestore/Docs.git
popd
echo "Build complete!"
