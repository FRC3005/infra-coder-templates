FROM ghcr.io/frc3005/languages/base:main

# Install everything as root
USER root

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Set back to coder user
USER coder
