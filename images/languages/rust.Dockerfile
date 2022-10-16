FROM ghcr.io/frc3005/languages/base:main

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/${USER}/.cargo/bin:${PATH}"
