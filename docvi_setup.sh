#!/bin/bash
# Определяем, строка после nvim это опция или файл
if [[ "$1" =~ ^-[^[:space:]]*$ ]]; then
    docker run --rm \
        -v ~/neovim_conf/:/tmp/.config/nvim \
        -v ~/.local-d/:/tmp/.local/ \
        nvim-dock:test \
        $1
else
    pathToFile="/workspace/$(realpath -e $1)"
    if [[ -w $1 ]]; then
        docker run --rm -it \
            -e HOME=/tmp \
            -u $(id -u):$(id -g) \
            -w /workspace \
            -v /:/workspace \
            -v ~/neovim_conf/:/tmp/.config/nvim \
            -v ~/.local-d/:/tmp/.local/ \
            nvim-dock:test \
            $pathToFile
    else
        docker run --rm -it \
            -w /workspace \
            -v /:/workspace \
            -v ~/neovim_conf/:/root/.config/nvim \
            -v ~/.local-dR/:/root/.local/ \
            nvim-dock:test \
            $pathToFile
    fi
fi
