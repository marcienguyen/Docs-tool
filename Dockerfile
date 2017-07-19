FROM debian:latest

LABEL maintainer "Robert <mrthinlt@gmail.com>"

#
RUN apt-get update && apt-get install -y --no-install-recommends \
      bzip2 \
      ca-certificates \
      curl \
      git \
      nodejs \
      build-essential
      
RUN npm i -g npm

RUN mkdir -p /opt/app/configs

# Copy source over and create configs dir
COPY . /opt/app/
COPY package.json /opt/app/package.json

WORKDIR /opt/app

RUN npm install \
    && npm cache clean

EXPOSE 8080
ENV NODE_ENV=production

CMD ["npm", "start"]
