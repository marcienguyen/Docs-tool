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

# this is faster via npm run build-docker
COPY package.json ./package.json
RUN npm install \
    && npm cache clean

# Copy source over and create configs dir
COPY . .
RUN mkdir -p /configs

EXPOSE 8080
ENV NODE_ENV=production

CMD ["npm", "start"]
