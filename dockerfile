# Базовый минималистичный образ Debian Stable.
FROM debian:stable-slim

# Каталог, где pipx хранит виртуальные окружения установленных Python-приложений.
ENV PIPX_HOME=/opt/pipx

# Каталог, куда pipx создает симлинки на исполняемые файлы.
ENV PIPX_BIN_DIR=/usr/local/bin

# Установка системных пакетов через apt
RUN apt-get update \
    && apt-get install -y \
    wget \
    curl \
    git \
    clangd \
    clang-format \
    shfmt \
    ripgrep \
    fd-find \
    pipx \
    shellcheck \
    npm \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g \
    bash-language-server \
    tree-sitter-cli \
    pyright \
    && npm cache clean --force

# Установка Neovim
# RUN wget https://github.com/neovim/neovim/releases/download/v0.12.2/nvim-linux-arm64.tar.gz \
#     && tar -xzf nvim-linux-arm64.tar.gz \
#     && mv nvim-linux-arm64 /opt/nvim \
#     && ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim \
#     && rm nvim-linux-arm64.tar.gz
RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    case "$arch" in \
        amd64)  nvim_arch="linux-x86_64" ;; \
        arm64)  nvim_arch="linux-arm64" ;; \
        *) echo "Unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    wget "https://github.com/neovim/neovim/releases/download/v0.12.2/nvim-${nvim_arch}.tar.gz"; \
    tar -xzf "nvim-${nvim_arch}.tar.gz"; \
    mv "nvim-${nvim_arch}" /opt/nvim; \
    ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim; \
    rm "nvim-${nvim_arch}.tar.gz"

# Установка Python formatter'а Black через pipx
RUN pipx install black

# Команда, запускаемая при старте контейнера
ENTRYPOINT ["nvim"]
