FROM ubuntu:20.04 as sys
WORKDIR $HOME
RUN apt update && apt upgrade -y
RUN apt install locales
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

FROM sys as pkgs
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt install -y make wget direnv npm curl git zlib1g-dev
RUN npm install --global yarn
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
RUN git -C ~/.rbenv/plugins/ruby-build pull
RUN ln -s $HOME/.rbenv/bin/rbenv /usr/bin/rbenv

FROM pkgs as build
RUN mkdir devdax
RUN eval "$(direnv hook bash)"
COPY . devdax
WORKDIR devdax

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install base dependencies
RUN apt-get update && apt-get install -y -q --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        libssl-dev \
        wget \
    && rm -rf /var/lib/apt/lists/*

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 16.13.1
ENV NVM_DIR /usr/local/nvm
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
RUN apt install nodejs -y

RUN make

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH
RUN make

