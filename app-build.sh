#/bin/bash

# prepare github access token

git config --global credential.helper store

echo 'https://thinlt:3b56ffd5b88a495640a2ca29fc8583ca450bb141@github.com' > ~/.git-credentials


# clone docs from github and build

git clone https://github.com/Magestore/Docs.git

copy -r ./Docs/extensions/ ./docs/

mkdocs build

copy -r ./site/ ./Docs/docs/


