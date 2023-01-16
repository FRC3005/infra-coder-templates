FROM ghcr.io/frc3005/frc-java/base:main

ENV CODER_IMAGE="charged-up"
ENV WPILIB_VERSION=2023.2.1
ENV WPILIB_BASE=/home/${USER}/wpilib/2023
USER root

# Run WPILib Installer
RUN wget -q https://github.com/wpilibsuite/allwpilib/releases/download/v${WPILIB_VERSION}/WPILib_Linux-${WPILIB_VERSION}.tar.gz \
    && tar -xf WPILib_Linux-${WPILIB_VERSION}.tar.gz \
    && rm WPILib_Linux-${WPILIB_VERSION}.tar.gz \
    && mkdir -p ${WPILIB_BASE} \
    && cd WPILib_Linux-${WPILIB_VERSION} \
    && tar -xf WPILib_Linux-${WPILIB_VERSION}-artifacts.tar.gz --directory=${WPILIB_BASE} \
    && cd .. \
    && rm -rf WPILib_Linux-${WPILIB_VERSION} \
    && rm -rf ${WPILIB_BASE}/documentation

USER coder
WORKDIR /home/${USER}
