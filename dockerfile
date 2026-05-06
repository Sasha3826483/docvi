# Используем легковесный образ Debian Stable
FROM debian:stable-slim

# Загружаем бинарную сборку Neovim v0.12.2 для ARM64, распаковываем и создаем симлинк в /usr/local/bin
RUN apt-get update && apt-get install -y \
    wget \
    && wget https://github.com/neovim/neovim/releases/download/v0.12.2/nvim-linux-arm64.tar.gz \
    && tar -xzf nvim-linux-arm64.tar.gz \
    && rm nvim-linux-arm64.tar.gz \
    && mv nvim-linux-arm64 /opt/nvim \
    && ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim

# Обновляем пакеты и устанавливаем необходимые утилиты
# Очищаем кэш apt для уменьшения размера образа
RUN apt-get install -y \
    git \
    clangd \
    clang-format \
    shfmt \
    ripgrep \
    fd-find \
    wl-clipboard \
    pipx \
    npm \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g bash-language-server \
    tree-sitter-cli \
    pyright \
    && pipx install black

RUN ln -s /tmp/.local/bin/black /usr/local/bin/black

# Определяем переменную окружения HOME для того, чтобы Neovim мог писать свои данные без root-прав
ENV HOME=/tmp

# Рабочая директория, в которой будут находится редактируемые файлы
WORKDIR /workspace

# Запускаем Neovim при старте контейнера
ENTRYPOINT ["nvim"]
