#######################################################################
# Dockerfile to build Nginx with mod security V3 Installed Containers #
# Based on ubuntu                                                     #
#######################################################################

# Set the base image to Ubuntu
FROM hackingteam/nginx-modsecurity:lastest

# File Author / Maintainer
MAINTAINER tatdat171, tatdat171@gmail.com

#Install necessary package
RUN apt-get update && apt-get install build-essential g++ flex bison curl doxygen libyajl-dev libgeoip-dev libtool dh-autoreconf libcurl4-gnutls-dev libxml2 libpcre++-dev libxml2-dev git wget libpcre3-dev vim net-tools -y

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf
COPY conf/default-ssl.conf /etc/nginx/conf.d/default-ssl.conf

#Enable nginx start automatic

RUN systemctl enable nginx

# Expose ports 80 443
EXPOSE 80
EXPOSE 80

# Set the default command to execute
# when creating a new container
CMD service nginx restart