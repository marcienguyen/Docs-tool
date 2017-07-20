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
  git clone https://github.com/Magestore/Docs.git $MYDOCS
else
  cd $MYDOCS && git pull
  cd ..
fi

echo "Copy from ${MYDOCS}/extensions/ to ${MYAPP}/docs/"
cp -R ${MYDOCS}/extensions/* ${MYAPP}/docs/

# start build
echo "MkDocs build"
cd ${MYAPP} && mkdocs build

# Copy html built to github
cp -R ${MYAPP}/site/* ${MYDOCS}/docs/
cd ${MYDOCS} \
   && git add . \
   && git commit -m "Build documents" \
   && git push origin master
