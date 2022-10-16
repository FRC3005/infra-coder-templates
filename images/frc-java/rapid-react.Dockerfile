FROM ghcr.io/frc3005/frc-java/base:main

ENV CODER_IMAGE="rapid-react"
ENV WPILIB_BASE=/home/${USER}/wpilib/2022
USER root

# Run WPILib Installer
RUN wget -q https://github.com/wpilibsuite/allwpilib/releases/download/v2022.4.1/WPILib_Linux-2022.4.1.tar.gz \
    && tar -xf WPILib_Linux-2022.4.1.tar.gz \
    && rm WPILib_Linux-2022.4.1.tar.gz \
    && mkdir -p ${WPILIB_BASE} \
    && cd WPILib_Linux-2022.4.1 \
    && tar -xf WPILib_Linux-2022.4.1-artifacts.tar.gz --directory=${WPILIB_BASE} \
    && cd .. \
    && rm -rf WPILib_Linux-2022.4.1 \
    && rm -rf ${WPILIB_BASE}/documentation

USER coder
WORKDIR /home/${USER}