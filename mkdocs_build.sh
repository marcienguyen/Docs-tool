#/bin/bash

MYAPP=/mkdocs/app
MYDOCS=/mkdocs/my-docs

# prepare github access token

git config --global credential.helper store
git config --global user.email "mrthinlt@gmail.com"
git config --global user.name "Mkdocs tool"

echo 'https://thinlt:3b56ffd5b88a495640a2ca29fc8583ca450bb141@github.com' > ~/.git-credentials


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
cd ${MYAPP} && mkdocs build -c

# Copy html built to github
echo "Copy from ${MYAPP}/site/* to /tmp/Docs/docs/"
git clone https://github.com/Magestore/Docs.git /tmp/Docs
rsync -aAh ${MYAPP}/site/ /tmp/Docs/docs/
#cp -Rf ${MYAPP}/site/* /tmp/Docs/docs/
cd /tmp/Docs \
   && git add . \
   && git commit -m "Build documents" \
   && git push origin master
