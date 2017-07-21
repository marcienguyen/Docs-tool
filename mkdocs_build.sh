#!/bin/sh

echo "Build date -------- ( $(date) ) ---------"

MYAPP=/mkdocs/app
MYDOCS=/mkdocs/my-docs

# clone docs from github and build
if [ ! -d $MYDOCS ]; then
  echo "Clone from github"
  git clone https://github.com/Magestore/Docs.git $MYDOCS
else
  echo "Pull from github"
  cd $MYDOCS && git pull
  cd ..
fi

echo "Copy from ${MYDOCS}/extensions/ to ${MYAPP}/docs/"
cp -Rf ${MYDOCS}/extensions/* ${MYAPP}/docs/

# start build
echo "MkDocs build"
cd ${MYAPP} && sudo mkdocs build
cd ${MYAPP} && sudo mkdocs gh-deploy -q --force --remote-name https://${GITHUB_TOKEN}@github.com/Magestore/Docs.git

echo "Build infomations:"
echo "Token thinlt:${GITHUB_TOKEN}"
echo "My app dir ${MYAPP}"
echo "My docs dir ${MYDOCS}"
echo "---------------------"
exit
