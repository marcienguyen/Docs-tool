#!/bin/sh

echo "-----------------------------------------"
echo "Build date ( $(date) )"

WORKDIR=/mkdocs
MYAPP=/mkdocs/app
MYDOCS=/mkdocs/data

# check token exist
GITHUB_TOKEN=$( cat ${WORKDIR}/GITHUB_TOKEN )
if [ $GITHUB_TOKEN != '' ]; then
  if [ $( grep -c 'http' /root/.git-credentials ) -eq 0 ]; then
    echo "Write token ${GITHUB_TOKEN} to /root/.git-credentials"
    sudo echo "https://thinlt:${GITHUB_TOKEN}@github.com" > /root/.git-credentials
  fi
fi

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

need_to_build=true

# clone docs from github and build
if [ ! -d $MYDOCS -o ! -d $MYDOCS/.git ]; then
  echo "Clone from github"
  git clone https://github.com/Magestore/Docs.git $MYDOCS
else
  echo "Fetch from github"
  git_status_check=$( cd $MYDOCS && git fetch && _check_git )
  if [ "$git_status_check" = "pull" ]; then
    echo "Pull from github"
    cd $MYDOCS && git pull
    cd $MYDOCS && git clean -fdx
  else
    need_to_build=false
  fi
fi

## Build mkdocs
if [ $need_to_build = true ]; then
  echo "Copy from ${MYDOCS}/extensions/ to ${MYAPP}/docs/"
  cp -Rf ${MYDOCS}/extensions/* ${MYAPP}/docs/
  # stop mkdocs
  # ps c | grep mkdocs | awk '{print $1}' | xargs kill -9
  # start build
  echo "MkDocs build"
  cd ${MYAPP} && sudo mkdocs build
  cd ${MYAPP} && sudo mkdocs gh-deploy -q --force --remote-name https://${GITHUB_TOKEN}@github.com/Magestore/Docs.git

  echo "---- Build complete ----"
else
  echo "---- No Build ----"
fi

## First build
if [ ! -f /mkdocs_first_build.flag ]; then
  touch /mkdocs_first_build.flag
  echo "MkDocs first build"
  cp -Rf ${MYDOCS}/extensions/* ${MYAPP}/docs/
  cd ${MYAPP} && sudo mkdocs build
  cd ${MYAPP} && sudo mkdocs gh-deploy -q --force --remote-name https://${GITHUB_TOKEN}@github.com/Magestore/Docs.git
  echo $(date) ' mkdocs rebuild.' >> ${MYDOCS}/build.log
fi

# start mkdocs
#mkdocs serve -a 0.0.0.0:8002

#echo "Build complete infomations:"
#echo "GITHUB_TOKEN: ${GITHUB_TOKEN}"
#echo "Token: $( cat /root/.git-credentials )"
#echo "My app dir ${MYAPP}"
#echo "My docs dir ${MYDOCS}"
#echo "---------------------"
exit
