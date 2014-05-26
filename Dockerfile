### Dockerfile
#
# BaseJump PHP5.5 PHP-FPM and NGINX 

FROM basejump/build-base
MAINTAINER Devon Weller <dweller@atlasworks.com>

# nginx repo
ADD nginx-release.repo /etc/yum.repos.d/

# install nginx and PHP packages
RUN yum -y install nginx php55u php55u-devel php55u-mysqlnd php55u-gd php55u-pspell php55u-pecl-jsonc php55u-xml php55u-fpm python-pip

# Add yum repo for MariaDB
ADD mariadb.repo /etc/yum.repos.d/mariadb.repo

# Install MariaDB client only
RUN yum install -y MariaDB-client

# install supervisord
# RUN echo "NETWORKING=yes" > /etc/sysconfig/network
RUN pip install "pip>=1.4,<1.5" --upgrade
RUN pip install supervisor

# copy supervisd conf file
ADD supervisord.conf /etc/

# make nginx run in foreground
RUN echo "" >> /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# networking
EXPOSE 80

# run supervisord as the command
CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]


