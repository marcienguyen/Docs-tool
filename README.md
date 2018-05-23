# Use Guide

## Quick use:
### #Step 1 Install docker-ce
### #Step 2 Build and run:
```
$ git clone https://github.com/Magestore/Docs-tool.git
$ cd Docs-tool
$ cp .env.example .env # and modify environment variables
$ sudo docker-compose up
```

### # Other way:

1. Rebuild the docker image
```
$ cd Docs-tool
$ git pull
$ sudo docker-compose build
```
2. Or run command
```
$ sudo docker-compose up --build
```

-----------------------------------------------------------------------------

## Theme User Guide
- Read document https://realpython.com/blog/python/primer-on-jinja-templating/
- http://jinja.pocoo.org/docs/2.9/templates/#list-of-control-structures

## Clear old image and container

```
  # docker stop docs_tool && docker container rm docs_tool
```

## Setup mkdocs

On github repository https://github.com/Magestore/Docs
When run the command mkdocs gh-deploy, Mkdocs will push automatically to gh-pages branch.
To settup it. Go to Settings > GitHub Pages > Source choose gh-pages branch on dropdown and save. After that go to
domain manage to setup dns point to github dns.
