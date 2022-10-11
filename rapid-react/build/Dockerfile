FROM wpilib/roborio-cross-ubuntu:2022-20.04

RUN apt-get update && apt-get install -y \
    vim \
  && rm -rf /var/lib/apt/lists/*

# Add a user `coder` so that you're not developing as the `root` user
RUN useradd coder \
    --create-home \
    --shell=/bin/bash \
    --uid=1000 \
    --user-group && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd


# Run WPILib Installer
RUN wget -q https://github.com/wpilibsuite/allwpilib/releases/download/v2022.4.1/WPILib_Linux-2022.4.1.tar.gz

RUN tar -xf WPILib_Linux-2022.4.1.tar.gz \
  && rm WPILib_Linux-2022.4.1.tar.gz \
  && mkdir -p /home/coder/wpilib/2022 \
  && cd WPILib_Linux-2022.4.1 \
  && tar -xf WPILib_Linux-2022.4.1-artifacts.tar.gz --directory=/home/coder/wpilib/2022 \
  && cd .. \
  && rm -rf WPILib_Linux-2022.4.1

USER coder
WORKDIR /home/coder
