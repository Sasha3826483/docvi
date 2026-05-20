#!/bin/bash

# # Подтягиваем окружение для работы псевдонимов
# source "/home/user/.bashrc"

pathToFile=$(realpath -e $1)

if [[ -w $1 ]]; then
    echo "$1 is a user-file"
    docker run --rm -it \
        -e HOME=/tmp \
        -u $(id -u):$(id -g) \
        -w /workspace \
        -v /:/workspace \
        -v ~/neovim_conf/:/tmp/.config/nvim \
        -v ~/.local-d/:/tmp/.local/ \
        nvim-dock:test \
        /workspace/$pathToFile
else
    echo "$1 is a root or non-user-file"
    docker run --rm -it \
        -w /workspace \
        -v /:/workspace \
        -v ~/neovim_conf/:/root/.config/nvim \
        -v ~/.local-dR/:/root/.local/ \
        nvim-dock:test \
        /workspace/$pathToFile
fi
