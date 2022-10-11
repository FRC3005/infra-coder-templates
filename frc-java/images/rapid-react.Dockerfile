FROM ghcr.io/frc3005/frc-java-base:main

USER root

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