FROM ubuntu:20.04

ENV CODER_IMAGE="base"

RUN apt-get update && apt-get install -y apt-transport-https \
  ca-certificates \
  gnupg \
  software-properties-common \
  wget && \
  add-apt-repository ppa:git-core/ppa && \
  apt-get update && apt-get install -y tzdata && apt-get install -y \
  build-essential \
  curl \
  git \
  java-common \
  openjdk-11-jdk \
  openssh-client \
  iputils-ping \
  python3-dev \
  python3-pip \
  python3-setuptools \
  sudo \
  unzip \
  vim \
  wget \
  zip \
  && rm -rf /var/lib/apt/lists/*

# Add a user `coder` so that you're not developing as the `root` user
RUN useradd coder \
  --create-home \
  --shell=/bin/bash \
  --uid=1000 \
  --user-group && \
  echo "coder ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV USER=coder
USER ${USER}
