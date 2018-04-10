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

# Install Mkdocs http://www.mkdocs.org/#installation
COPY get-pip.py /mkdocs/get-pip.py
RUN chmod +x /mkdocs/get-pip.py
RUN python /mkdocs/get-pip.py
RUN pip install --upgrade pip
RUN pip install mkdocs
RUN mkdocs --version

# Pull Docs from github
RUN mkdir -p /mkdocs/data
RUN git clone -b master --depth=1 https://github.com/Magestore/Docs.git /mkdocs/data
RUN ln -s /mkdocs/data/extensions /mkdocs/data/docs

WORKDIR /mkdocs

# create mkdocs app
#mkdocs new data
# remove default doc
#RUN rm ./data/docs/index.md

# Copy source over and create configs dir
COPY mkdocs_build.sh /mkdocs/mkdocs_build.sh
COPY mkdocs_push.sh /mkdocs/mkdocs_push.sh
COPY app.sh /mkdocs/app.sh
COPY mkdocs.yml /mkdocs/data/mkdocs.yml
COPY docs /mkdocs/data/docs
COPY mytheme /mkdocs/data/mytheme
COPY other_themes /mkdocs/data/other_themes

# Install cronjob
#RUN echo "* * * * *     root      cd /mkdocs/app/ && /bin/sh ./mkdocs_build.sh 2>&1 1>>/mkdocs/cron.log &" >> /etc/crontab
#RUN echo "* * * * *     root      /bin/sh /mkdocs/update_docs.sh 2>&1 1>>/mkdocs/cron.log &" >> /etc/crontab
#RUN service cron start

ENV PORT=8002

EXPOSE $PORT

CMD ["/bin/bash", "app.sh"]
