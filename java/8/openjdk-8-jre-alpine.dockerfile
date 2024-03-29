#基于官方dockerfile
#https://github.com/adoptium/containers/blob/main/8/jre/alpine/Dockerfile.releases.full
FROM alpine:3.19.1
# 作者信息
MAINTAINER lincl <lin2019000@163.com>

ENV JAVA_HOME /opt/java/openjdk
ENV PATH $JAVA_HOME/bin:$PATH

# Default to UTF-8 file.encoding
ENV LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh' LC_ALL='zh_CN.UTF-8'

#更新Alpine的软件源为阿里云
RUN echo https://mirrors.aliyun.com/alpine/v3.19/main/ > /etc/apk/repositories && \
    echo https://mirrors.aliyun.com/alpine/v3.19/community/ >> /etc/apk/repositories

# fontconfig and ttf-dejavu added to support serverside image generation by Java programs
RUN apk add --no-cache fontconfig libretls musl-locales musl-locales-lang ttf-dejavu tzdata zlib  \
    && rm -rf /var/cache/apk/* \
    && echo "Asia/Shanghai" > /etc/timezone \
    && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ENV JAVA_VERSION jdk-8u402b06

RUN set -eux; \
    ARCH="$(apk --print-arch)"; \
    case "${ARCH}" in \
       amd64|x86_64) \
         ESUM='abc7861abda181ffe4527997ef8267e701385f11b82d91bc3a56077be228b0e0'; \
         BINARY_URL='https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u402-b06/OpenJDK8U-jre_x64_alpine-linux_hotspot_8u402b06.tar.gz'; \
         ;; \
       *) \
         echo "不适合架构: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
	  wget -O /tmp/openjdk.tar.gz ${BINARY_URL}; \
	  echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
	  mkdir -p "$JAVA_HOME"; \
	  tar --extract \
	      --file /tmp/openjdk.tar.gz \
	      --directory "$JAVA_HOME" \
	      --strip-components 1 \
	  ; \
    rm -f /tmp/openjdk.tar.gz ${JAVA_HOME}/src.zip ${JAVA_HOME}/COPYRIGHT ${JAVA_HOME}/LICENSE ${JAVA_HOME}/README ${JAVA_HOME}/release; \
    rm -rf ${JAVA_HOME}/man /var/cache/*; \
    echo '检查安装...' \
#    && fileEncoding="$(echo 'System.out.println(System.getProperty("file.encoding"))' | jshell -s -)"; [ "$fileEncoding" = 'UTF-8' ]; rm -rf ~/.java \
    && echo java -version && java -version \
    && echo '成功'