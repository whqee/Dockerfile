# Dev Env
FROM ubuntu:20.04

LABEL name=ubuntu

RUN echo \
"deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse\n\
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse\n\
\n\
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse     \n\
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse \n\
\n\
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse      \n\
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse  \n\
\n\
deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse     \n\
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse \n\
\n\
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse    \n\
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" \
> /etc/apt/sources.list

RUN apt-get update && \
while true; do \
apt-get -y install locales sudo aptitude curl vim bash-completion build-essential wget git-core iproute2 && break; \
done;

## for Yocto
# RUN apt-get update 
# RUN while (true) do \
# apt-get -y install gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio python python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping libsdl1.2-dev xterm tar locales && break;\
# done;

RUN rm /bin/sh && ln -s bash /bin/sh
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

## Modify user name here
ENV USER_NAME whqee

ARG host_uid=1001
ARG host_gid=1001

## create USER $USER_NAME and add it to group 'sudo' & 'uucp'
RUN groupadd -g $host_gid $USER_NAME && useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER_NAME
RUN usermod -aG sudo ${USER_NAME} && usermod -aG uucp ${USER_NAME}
RUN echo "${USER_NAME}:passwd" | chpasswd
RUN echo "root:passwd" | chpasswd
RUN mkdir -p /home/${USER_NAME}
ENV HOME=/home/${USER_NAME}
WORKDIR ${HOME}
USER $USER_NAME


# RUST Language Env setup
RUN export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
RUN export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
RUN curl https://sh.rustup.rs -sSf >sh.rustup.rs && sh sh.rustup.rs -y

RUN mkdir -p ${HOME}/.cargo && echo -e \
"\
[source.crates-io]\n\
registry = \"https://github.com/rust-lang/crates.io-index\"\n\
replace-with = 'ustc'\n\
[source.ustc]\n\
registry = \"git://mirrors.ustc.edu.cn/crates.io-index\"\n\
"\
>${HOME}/.cargo/config

RUN source $HOME/.cargo/env && rustup self update && rustup component add rls rust-analysis rust-src

