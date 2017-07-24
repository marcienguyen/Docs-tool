# Docs-tool

## How to use it:

```
  # docker build --rm -t docs_tool . \
    ; docker stop docs_tool && docker container rm docs_tool \
    ; docker run -it -d --rm --name docs_tool docs_tool
```

## If use with serve and port running

```
  # docker build --rm -t docs_tool . \
    ; docker stop docs_tool && docker container rm docs_tool \
    ; docker run -it -d -p 8002:8002 --name docs_tool --restart="on-failure" docs_tool
```

## If run one time and see what are runnings
```
  # docker build --rm -t docs_tool . \
    ; docker stop docs_tool && docker container rm docs_tool \
    ; docker run -it --rm -p 8002:8002 --name docs_tool docs_tool  
```

## If only run single app
```
  # docker run -it --rm -d --name docs_tool docs_tool
```
