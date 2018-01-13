###############################################################################
# Dockerfile to build a personal workspace container image
# Base on Ubuntu x86
# Maintain at github: git@github.com:HeWeiPing/mydockerfile_x86.git
###############################################################################

# base on ubuntu x86
FROM i386/ubuntu

# maintainer 
MAINTAINER hervey<hwp195@163.com>

# work dir
WORKDIR ~/

# set all interactive installation to noninteractive
ENV	DEBIAN_FRONTEND noninteractive

# update the repo resource list
RUN apt-get update

# install tools: debconf. 
# It is important for installing thoes interactive installation software
RUN apt-get install debconf

# install tools: wget gcc vim net-tool
RUN apt-get install -y wget gcc vim

# install database: mysql sqlite3
#  an error occur by flow RUN-> debconf: unable to initialize frontend: Dialog
#RUN { \
#	echo mysql-community-server mysql-community-server/data-dir select ''; \
#	echo mysql-community-server mysql-community-server/root-pass password ''; \
#	echo mysql-community-server mysql-community-server/re-root-pass password ''; \
#	echo mysql-community-server mysql-community-server/remove-test-db select false; \
#	} | debconf-set-selections && apt-get install -y mysql-server
RUN apt-get install -y mysql-server
RUN apt-get install -y sqlite3

# install Go
RUN wget -c https://studygolang.com/dl/golang/go1.9.2.linux-386.tar.gz
RUN rm -rf /usr/local/go
RUN tar -C /usr/local -zxf go1.9.2.linux-386.tar.gz
RUN rm  go1.9.2.linux-386.tar.gz

# set env
ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH $HOME/gocode

# expose http port to host
EXPOSE 8080


