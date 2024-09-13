FROM m.daocloud.io/docker.io/node:alpine
#FROM node:latest

ENV SERVER_PORT=8000
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8

WORKDIR /app

EXPOSE ${SERVER_PORT}

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk add --no-cache \
      make \
      tini && \
    npm config set registry https://registry.npmmirror.com && \
    npm install -g hexo-cli \
	  hexo-util

RUN apk add \
	  gcc \
	  g++ \
	  musl-dev \
	  ruby-dev && \
	gem source --add https://mirrors.tuna.tsinghua.edu.cn/rubygems/ \
	  --remove https://rubygems.org/ && \
	gem install bundler --verbose && \
	gem install jekyll --verbose


#npm install && \

#ENTRYPOINT ["/sbin/tini", "--"]
#CMD ["node", "server.js"]:w
