#!/bin/sh

echo "           ------------------------------"
echo "Build date -------- ( $(date) ) ---------"

WORKDIR=/mkdocs
MYAPP=/mkdocs/app
MYDOCS=/mkdocs/my-docs

# check token exist
GITHUB_TOKEN=$( cat ${WORKDIR}/GITHUB_TOKEN )
if [ $GITHUB_TOKEN != '' ]; then
  if [ $( grep -c 'http' /root/.git-credentials ) -eq 0 ]; then
    echo "Write token ${GITHUB_TOKEN} to /root/.git-credentials"
    sudo echo "https://thinlt:${GITHUB_TOKEN}@github.com" > /root/.git-credentials
  fi
fi

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

# stop mkdocs
#ps c | grep mkdocs | awk '{print $1}' | xargs kill -9
# start build
echo "MkDocs build"
cd ${MYAPP} && sudo mkdocs build
cd ${MYAPP} && sudo mkdocs gh-deploy -q --force --remote-name https://${GITHUB_TOKEN}@github.com/Magestore/Docs.git
# start mkdocs
#mkdocs serve -a 0.0.0.0:8002

# Copy html built and push to github
echo "Copy from ${MYAPP}/site/* to /tmp/Docs/docs/"
git clone https://github.com/Magestore/Docs.git /tmp/Docs
rsync -aAh ${MYAPP}/site/ /tmp/Docs/docs/

cd /tmp/Docs \
   && git add . \
   && git commit -m "Build documents" \
   && git push origin master

rm -rf /tmp/Docs

echo "Build infomations:"
echo "GITHUB_TOKEN: ${GITHUB_TOKEN}"
echo "Token: $( cat /root/.git-credentials )"
echo "My app dir ${MYAPP}"
echo "My docs dir ${MYDOCS}"
echo "---------------------"
exit
