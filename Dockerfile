###############################################################################
# Dockerfile to build a personal workspace image
# Maintain at github: https://github.com/hwp9527/myDockerfile.git
###############################################################################

# base image
FROM i386/ubuntu

# maintainer 
MAINTAINER hervey<hwp195@163.com>

# set the home dir as workdir, because docker build will uses / as default
ENV HOME /root
WORKDIR $HOME

# set all interactive installation to noninteractive
ENV	DEBIAN_FRONTEND noninteractive


# install tools
# debconf: An important tool for installing software that need to interactive
RUN apt-get update && apt-get install -y \
		debconf \
		gcc     \
		git     \
		wget    \
		vim     \ 
		sqlite3 \
		autojump

# install mysql and fix an error of mysql server when starting
RUN apt-get install -y mysql-server && usermod -d /var/lib/mysql/ mysql

# install database: mysql sqlite3
#  an error occur by flow RUN-> debconf: unable to initialize frontend: Dialog
#RUN { \
#	echo mysql-community-server mysql-community-server/data-dir select ''; \
#	echo mysql-community-server mysql-community-server/root-pass password ''; \
#	echo mysql-community-server mysql-community-server/re-root-pass password ''; \
#	echo mysql-community-server mysql-community-server/remove-test-db select false; \
#	} | debconf-set-selections && apt-get install -y mysql-server
#RUN apt-get install -y mysql-server && usermod -d /var/lib/mysql/ mysql
#RUN apt-get install -y sqlite3

# install Go
RUN wget -c https://studygolang.com/dl/golang/go1.9.2.linux-386.tar.gz && \
	rm -rf /usr/local/go && \
	tar -C /usr/local -zxf go1.9.2.linux-386.tar.gz && \
	rm  go1.9.2.linux-386.tar.gz

# set env and personal configuration
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=$HOME/gocode
ENV PATH=$PATH:$GOPATH/bin

RUN git clone https://github.com/hwp9527/.vim.git && \
	echo "runtime vimrc" > $HOME/.vimrc
RUN git clone https://github.com/hwp9527/myBashCfg.git &&\
	cat myBashCfg/mybashrc.cfg >> $HOME/.bashrc && \
	rm -rf myBashCfg



# expose http port to host
EXPOSE 8080


