FROM ubuntu:20.04

RUN apt-get update && apt-get install -y apt-transport-https \
    ca-certificates \
    gnupg \
    software-properties-common \
    wget && \
    #wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    #apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main' && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update && apt-get install -y tzdata && apt-get install -y \
    build-essential \
    ca-certificates \
    #clang-format-10 \
    #cmake \
    curl \
    #fakeroot \
    #g++-10 --no-install-recommends \
    #gcc-10 \
    #gdb \
    git \
    java-common \
    #libc6-dev \
    #libgl1-mesa-dev \
    #libglu1-mesa-dev \
    #libisl-dev \
    #libopencv-dev \
    #libvulkan-dev \
    #libx11-dev \
    #libxcursor-dev \
    #libxi-dev \
    #libxinerama-dev \
    #libxrandr-dev \
    #make \
    #mesa-common-dev \
    openjdk-11-jdk \
    openssh-client \
    iputils-ping \
    #python-all-dev \
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

# Run WPILib Installer
RUN wget -q https://github.com/wpilibsuite/allwpilib/releases/download/v2022.4.1/WPILib_Linux-2022.4.1.tar.gz \
  && tar -xf WPILib_Linux-2022.4.1.tar.gz \
  && rm WPILib_Linux-2022.4.1.tar.gz \
  && mkdir -p /home/coder/wpilib/2022 \
  && cd WPILib_Linux-2022.4.1 \
  && tar -xf WPILib_Linux-2022.4.1-artifacts.tar.gz --directory=/home/coder/wpilib/2022 \
  && cd .. \
  && rm -rf WPILib_Linux-2022.4.1 \
  && rm -rf /home/coder/wpilib/2022/documentation

USER coder
WORKDIR /home/coder
