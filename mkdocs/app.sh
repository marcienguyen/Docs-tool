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
if [ ! -d /mkdocs/data_docs -o ! -d /mkdocs/data_docs/.git ]; then
  echo "Can not pull /mkdocs/data_docs/"
else
  echo "Pull from github"
  git_status_check=$( git fetch && _check_git )
  if [ "$git_status_check" = "pull" ]; then
    echo "Pull from github"
    pushd /mkdocs/data_docs/
    git pull
    git clean -fdx
    popd
  fi
fi

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
