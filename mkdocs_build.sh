#/bin/bash

# prepare github access token

git config --global credential.helper store
git config --global user.email "mrthinlt@gmail.com"
git config --global user.name "Mkdocs tool"

echo 'https://thinlt:3b56ffd5b88a495640a2ca29fc8583ca450bb141@github.com' > ~/.git-credentials


# clone docs from github and build

if [ ! -d ./my-docs ]; then
  git clone https://github.com/Magestore/Docs.git ./my-docs
else
  cd ./my-docs && git pull
  cd ..
fi

echo "Copy from ./my-docs/extensions/ to ./docs/"
cp -ri ./my-docs/extensions/* ./docs/

# start build
echo "MkDocs build"
mkdocs build

# Copy html built to github
cp -ri ./site/* ./my-docs/docs/
cd ./my-docs/ \
   && git add . \
   && git commit -m "Build documents" \
   && git push origin master
