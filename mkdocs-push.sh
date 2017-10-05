#!/bin/sh

MYAPP=/mkdocs/app
MYDOCS=/mkdocs/my-docs

# Copy html built to github
echo "Copy from ${MYAPP}/site/* to /tmp/Docs/docs/"
git clone https://github.com/Magestore/Docs.git /tmp/Docs
rsync -aAh ${MYAPP}/site/ /tmp/Docs/docs/

cd /tmp/Docs \
   && git add . \
   && git commit -m "Build documents" \
   && git push origin master

rm -rf /tmp/Docs
