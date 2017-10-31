#######################################################################
# Dockerfile to build Nginx with mod security V3 Installed Containers #
# Based on ubuntu                                                     #
#######################################################################

# Set the base image to Ubuntu
FROM ubuntu

# File Author / Maintainer
MAINTAINER tatdat171, tatdat171@gmail.com

#Install necessary package
RUN apt-get update && apt-get install build-essential g++ flex bison curl doxygen libyajl-dev libgeoip-dev libtool dh-autoreconf libcurl4-gnutls-dev libxml2 libpcre++-dev libxml2-dev git -y

### Install library require for building nginx ###
#Install PCRE library

RUN cd /opt && wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.41.tar.gz && \
	tar -zxf pcre-8.41.tar.gz && \
	cd pcre-8.41 && ./configure && make && make install

#Install zlib library

RUN cd /opt && RUN wget http://zlib.net/zlib-1.2.11.tar.gz && \
	tar -zxf zlib-1.2.11.tar.gz && \
	cd zlib-1.2.11 && ./configure && make && make install

#Install OpenSSL library

RUN wget https://www.openssl.org/source/openssl-1.0.2l.tar.gz && \
	tar -zxf openssl-1.0.2k.tar.gz && \
	cd openssl-1.0.2k && ./config --prefix=/usr && make && make install

#Install lib modsecurity

RUN cd /opt/ && \
	git clone https://github.com/SpiderLabs/ModSecurity && \
	cd ModSecurity/ && \
	git checkout -b v3/master origin/v3/master && \
	sh build.sh && \
	git submodule init && \
	git submodule update && ./configure && make && make install && \

#Get Mod security for Nginx V3

RUN cd /opt/ && \
	git clone https://github.com/SpiderLabs/ModSecurity-nginx

#Install Nginx with Mod security V3 

RUN cd /opt && \
	wget http://nginx.org/download/nginx-1.12.2.tar.gz  && \
	tar zxf nginx-1.12.2.tar.gz
	cd nginx-1.12.2 && \
	./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/wsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-threads --with-stream --with-stream_ssl_module --with-http_slice_module --with-mail_ssl_module --with-file-aio --with-http_v2_module --with-ipv6 --with-pcre=../pcre-8.41 --with-zlib=../zlib-1.2.11 --with-http_ssl_module --with-stream --with-mail=dynamic --add-module=/opt/ModSecurity-nginx && \
   make && make install

#Enable nginx start automatic

RUN systemctl enable nginx

# Expose ports 80 443
EXPOSE 80
EXPOSE 80

# Set the default command to execute
# when creating a new container
CMD service nginx start