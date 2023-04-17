#基于官方dockerfile
#https://github.com/adoptium/containers/blob/main/8/jre/alpine/Dockerfile.releases.full
FROM alpine:3.17
# 作者信息
MAINTAINER lincl <lin2019000@163.com>

ENV JAVA_HOME /opt/java/openjdk
ENV PATH $JAVA_HOME/bin:$PATH

# Default to UTF-8 file.encoding
ENV LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh' LC_ALL='zh_CN.UTF-8'

#更新Alpine的软件源为阿里云
RUN echo https://mirrors.aliyun.com/alpine/v3.17/main/ > /etc/apk/repositories && \
    echo https://mirrors.aliyun.com/alpine/v3.17/community/ >> /etc/apk/repositories
#    apk update && apk upgrade; \
#    sed -i 's/https/http/' /etc/apk/repositories;
#    apk --no-cache add curl

# fontconfig and ttf-dejavu added to support serverside image generation by Java programs
RUN apk add --no-cache fontconfig libretls musl-locales musl-locales-lang ttf-dejavu tzdata zlib  \
    && rm -rf /var/cache/apk/* \
    && echo "Asia/Shanghai" > /etc/timezone \
    && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#apk add glibc-2.30-r0.apk && apk add glibc-bin-2.30-r0.apk && apk add glibc-i18n-2.30-r0.apk

#ENV JAVA_VERSION jdk8u362-b09