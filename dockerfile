FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home

RUN wget github.com/neovim/neovim/releases/download/v0.12.2/nvim-linux-arm64.tar.gz && \
    tar -xzf nvim-linux-arm64.tar.gz -C /home && \
    ln -s /home/nvim-linux-arm64/bin/nvim /usr/local/bin/nvim

ENTRYPOINT ["nvim"]
