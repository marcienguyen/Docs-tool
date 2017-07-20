# Docs-tool

## How to use it:

```
  # docker build -t docs_tool . \
    && docker stop docs_tool && docker container rm docs_tool \
    && docker run -it -d -p 8002:8002 --name docs_tool --restart="on-failure" docs_tool
```

## If run one time and see what are runnings
```
  # docker build -t docs_tool . \
    && docker stop docs_tool && docker container rm docs_tool \
    && docker run -it --rm -p 8002:8002 --name docs_tool docs_tool  
```
