#!/bin/bash

set -euo pipefail

# ------------------------------------------------------------
# docvi_build.sh:   Клонирует репо конфигом nvim
#                   и собирает образ для запуска контейнера
# ------------------------------------------------------------

createDir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        echo "OK: Директория $dir успешно создана"
    else
        echo "ATT: Директория $dir уже создана"
    fi
}

# Две директории для кэша неовима: для root-ружима и user-режима
createDir ./data/localU
createDir ./data/localR

# Конфиг неовима
if [[ ! -d ./data/neovim-conf ]]; then
    git clone https://github.com/Sasha3826483/NeovimConfig \
        ./data/neovim-conf
    echo "OK: Конфигурация neovim успешно зазружена"
else
    echo "ATT: Конфигурация уже загружена"
fi

# Сборка образа
docker build -t docvi .

# Создание симки для запуска neovim из любого места ФС
if [[ ! -e /usr/local/bin/docvi ]]; then
    sudo ln -s "$(realpath ./docvi_setup.sh)" /usr/local/bin/docvi
    echo "OK: docvi готов к работе (/usr/local/bin)"
else
    echo "ATT: docvi уже существует"
fi
