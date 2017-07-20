#/bin/bash

mkdocs new mkdocs_build

#cd magestore_docs

# remote default doc
rm ./mkdocs_build/docs/index.md

#sed -i 's/site_name: \(.*\)/site_name: Magestore Docs/' ./mkdocs.yml

# copy to replace default mkdocs.yml
rm ./mkdocs_build/mkdocs.yml
copy ./mkdocs.yml ./mkdocs_build/

# clone magestore docs from github
sh ./app-build.sh

# run mkdocs with port
mkdocs serve -a 0.0.0.0:{$PORT}

