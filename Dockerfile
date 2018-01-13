###############################################################################
# Dockerfile to build a personal workspace container image
# Base on Ubuntu x86
# Maintain at github: git@github.com:HeWeiPing/mydockerfile_x86.git
###############################################################################

# base on ubuntu x86
FROM i386/ubuntu

# maintainer 
MAINTAINER hervey<hwp195@163.com>

# set the home dir, because container uses / as workdir when login
ENV HOME /root

# work dir
WORKDIR $HOME

# set all interactive installation to noninteractive
ENV	DEBIAN_FRONTEND noninteractive

# update the repo resource list
RUN apt-get update

# install tools: debconf & git
# It is important for installing thoes interactive installation software
RUN apt-get install -y debconf git

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
RUN apt-get install -y mysql-server && usermod -d /var/lib/mysql/ mysql
RUN apt-get install -y sqlite3

# install Go
RUN { \
	wget -c https://studygolang.com/dl/golang/go1.9.2.linux-386.tar.gz \
	&& rm -rf /usr/local/go \
	&& tar -C /usr/local -zxf go1.9.2.linux-386.tar.gz \
	&& rm  go1.9.2.linux-386.tar.gz \
}

# set env and personal configuration
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=$HOME/gocode
ENV PATH=$PATH:$GOPATH/bin

RUN git clone git@github.com:HeWeiPing/Vim.git && echo "runtime vimrc" > $HOME/.vimrc

RUN { \
echo 'source /usr/share/autojump/autojump.sh            ' \
echo '                                                  ' \
echo 'export LESS_TERMCAP_mb=$'\E[01;31m'               ' \
echo 'export LESS_TERMCAP_md=$'\E[01;31m'               ' \
echo 'export LESS_TERMCAP_me=$'\E[0m'                   ' \
echo 'export LESS_TERMCAP_se=$'\E[0m'                   ' \
echo 'export LESS_TERMCAP_so=$'\E[01;44;33m'            ' \
echo 'export LESS_TERMCAP_ue=$'\E[0m'                   ' \
echo 'export LESS_TERMCAP_us=$'\E[01;32m'               ' \
echo '                                                  ' \
echo 'export PS1="\e[31;1m<\e[34;1m\w\e[31;1m>\e[0m\n$" ' \
echo '                                                  ' \
echo '                                                  ' \
echo '# my alias                                        ' \
echo 'alias vi='vim'                                    ' \
echo 'alias ct='ctags --sort=foldcase -R .'             ' \
echo '                                                  ' \
echo 'alias ls='ls --color=auto'                        ' \
echo 'alias ll='ls -lhF'                                ' \
echo 'alias la='ls -lhA'                                ' \
echo 'alias l='ls -CF'                                  ' \
echo '                                                  ' \
echo 'alias sr='screen -r'                              ' \
echo 'alias sl='screen -ls'                             ' \
} | >> $HOME/.bashrc


# expose http port to host
EXPOSE 8080


