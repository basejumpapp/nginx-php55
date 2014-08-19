### Dockerfile
#
# Basejump PHP5.5 PHP-FPM and NGINX 

FROM basejump/build-base
MAINTAINER Devon Weller <dweller@atlasworks.com>

# python-pip for supervisord
RUN yum -y install python-pip

# install supervisord
RUN pip install "pip>=1.4,<1.5" --upgrade
RUN pip install supervisor

# nginx repo
ADD nginx-release.repo /etc/yum.repos.d/

# install nginx
RUN yum -y install nginx

# make nginx run in foreground
RUN echo "" >> /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf


# Add yum repo for MariaDB
ADD mariadb.repo /etc/yum.repos.d/mariadb.repo

# Install MariaDB client only
RUN yum install -y MariaDB-client


# install PHP packages
RUN yum -y install php55u-cli php55u-fpm php55u-devel php55u-mysqlnd php55u-pspell php55u-pecl-jsonc php55u-xml php55u-mbstring php55u-gd


# Other packages (tar)
RUN yum -y install tar


# copy supervisord conf file
ADD supervisord.conf /etc/

# add a default basejump user for access
RUN useradd -u 1001 basejump

# networking
EXPOSE 80

# run supervisord as the command
CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]


