FROM python:3.5

LABEL maintainer "Robert <mrthinlt@gmail.com>"

# install app
RUN apt-get update && apt-get install -y --no-install-recommends \
      sudo \
      curl \
      git \
      cron \
      vim \
      rsync

#RUN apt-get install -y sudo

RUN mkdir -p /mkdocs/data
WORKDIR /mkdocs

# Install Mkdocs http://www.mkdocs.org/#installation
RUN chmod +x get-pip.py
RUN python get-pip.py
RUN pip install --upgrade pip
RUN pip install mkdocs
RUN mkdocs --version

# create mkdocs app
mkdocs new data
# remote default doc
RUN rm ./data/docs/index.md

# Copy source over and create configs dir
COPY mkdocs.yml /mkdocs/data/mkdocs.yml
COPY mkdocs_build.sh /mkdocs/mkdocs_build.sh
COPY mkdocs_push.sh /mkdocs/mkdocs_push.sh
COPY get-pip.py /mkdocs/get-pip.py
COPY app.sh /mkdocs/app.sh
COPY docs /mkdocs/docs
COPY mytheme /mkdocs/mytheme
COPY other_themes /mkdocs/other_themes

# Install cronjob
#RUN echo "* * * * *     root      cd /mkdocs/app/ && /bin/sh ./mkdocs_build.sh 2>&1 1>>/mkdocs/cron.log &" >> /etc/crontab
#RUN echo "* * * * *     root      /bin/sh /mkdocs/update_docs.sh 2>&1 1>>/mkdocs/cron.log &" >> /etc/crontab
#RUN service cron start

ENV PORT=8002

EXPOSE $PORT

CMD ["/bin/sh", "app.sh"]
