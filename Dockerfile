FROM alpine:3.19.1
MAINTAINER lincl <lin2019000@163.com>

ENV NGINX_VERSION=1.26.1
ENV LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh' LC_ALL='zh_CN.UTF-8'
# 设置工作目录
WORKDIR /usr/local/nginx

# 更新Alpine的软件源为阿里云
RUN echo https://mirrors.aliyun.com/alpine/v3.19/main/ > /etc/apk/repositories && \
    echo https://mirrors.aliyun.com/alpine/v3.19/community/ >> /etc/apk/repositories && \
    echo "Asia/Shanghai" > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 安装编译依赖
RUN apk add --no-cache build-base pcre-dev zlib-dev openssl-dev

# 下载并解压Nginx源码
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -zxvf ./nginx-${NGINX_VERSION}.tar.gz

RUN mkdir -p /tmp/nginx/client_body /tmp/nginx/proxy /tmp/nginx/fastcgi /var/log/nginx /var/lock/nginx
# 配置并编译Nginx
RUN  cd ./nginx-${NGINX_VERSION} && \
     ./configure \
     --prefix=/usr/local/nginx \
#     --group=nginx \
#     --user=nginx \
     --sbin-path=/usr/local/nginx/sbin/nginx \
     --conf-path=/etc/nginx/nginx.conf \
     --error-log-path=/var/log/nginx/error.log \
     --http-log-path=/var/log/nginx/access.log \
     --http-client-body-temp-path=/tmp/nginx/client_body \
     --http-proxy-temp-path=/tmp/nginx/proxy \
     --http-fastcgi-temp-path=/tmp/nginx/fastcgi \
     --pid-path=/var/run/nginx.pid \
     --lock-path=/var/lock/nginx \
     --with-http_stub_status_module \
     --with-http_ssl_module \
     --with-http_gzip_static_module \
     --with-pcre \
     --with-http_realip_module \
     --with-stream \
     --with-stream_ssl_module \
     --with-stream_realip_module \
     --with-stream_ssl_preread_module \
     --with-threads \
     --with-http_sub_module \
     --with-http_gunzip_module \
     --with-http_auth_request_module \
     --with-http_slice_module \
     --with-http_v2_module \
     --with-http_addition_module  \
     && make && make install && \
     make clean && apk del build-base

ENV PATH="/usr/local/nginx/sbin:$PATH"

# 设置容器启动后执行的命令
CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80 80
