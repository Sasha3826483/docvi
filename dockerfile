# Используем легковесный образ Debian Stable
FROM debian:stable-slim

# Обновляем пакеты и устанавливаем необходимые утилиты
# Очищаем кэш apt для уменьшения размера образа
RUN apt-get update && apt-get install -y \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Загружаем бинарную сборку Neovim v0.12.2 для ARM64, распаковываем и создаем симлинк в /usr/local/bin
RUN wget https://github.com/neovim/neovim/releases/download/v0.12.2/nvim-linux-arm64.tar.gz \
    && tar -xzf nvim-linux-arm64.tar.gz \
    && rm nvim-linux-arm64.tar.gz \
    && mv nvim-linux-arm64 /opt/nvim \
    && ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim

# Определяем переменную окружения HOME для того, чтобы Neovim мог писать свои данные без root-прав
ENV HOME=/tmp

# Рабочая директория, в которой будут находится редактируемые файлы
WORKDIR /workspace

# Запускаем Neovim при старте контейнера
ENTRYPOINT ["nvim"]
