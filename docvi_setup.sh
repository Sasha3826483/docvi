#!/bin/bash

#-------------------------------------------------------------
# docvi_setup.sh:   Определяет конфигурацию контейенера в
#                   зависимости от указанного файла и прав
#                   доступа
#-------------------------------------------------------------

# Определяем констанды и переменные
declare -r workSpace="/workspace"
declare -r pathToData="$(dirname "$(readlink -f \
    /usr/local/bin/docvi)")"
pathToFile=
pathToDir=

# root-режим
docviRoot() {
    docker run --rm -it \
        -w "$2" \
        -v /:$workSpace \
        -v "$pathToData"/data/neovim-conf/:/root/.config/nvim \
        -v "$pathToData"/data/localR/:/root/.local/ \
        docvi \
        "$1"
    return
}

# user-режим
docviUser() {
    docker run --rm -it \
        -e HOME=/tmp \
        -u $(id -u):$(id -g) \
        -w "$2" \
        -v /:$workSpace \
        -v "$pathToData"/data/neovim-conf/:/tmp/.config/nvim \
        -v "$pathToData"/data/localU/:/tmp/.local/ \
        docvi \
        "$1"
    return
}

# режим для проверок: --version и прочего
docviCheck() {
    docker run --rm \
        -v "$pathToData"/data/neovim-conf/:/tmp/.config/nvim \
        -v "$pathToData"/data/localU/:/tmp/.local/ \
        docvi \
        "$1"
    return
}

# Определяем какую группу параметров юзать:
#   1. опция/и + файл
#   2. опция/и без файла
#   * Опции нормально обработаются только в виде -abc, а не -a -b -c (таких ситуаций-то и нет, но все же)
if [[ "$1" =~ ^-.*$ ]]; then
    if [[ -n "$2" ]]; then
        if [[ -e "$2" ]]; then
            pathToFile=""$1" $workSpace$(realpath -e "$2")"
            pathToDir="$workSpace$(dirname "$(realpath -e "$2")")"
        else
            pathToFile=""$1" $workSpace$(pwd)/"$2""
            pathToDir="$workSpace$(dirname "$(realpath -e "$2")")"

        fi
        # скорректируем "$1" для путей: "$1" теперь path
        shift
    else
        docviCheck "$1"
        exit
    fi
else
    if [[ -e "$1" ]]; then
        pathToFile="$workSpace$(realpath -e "$1")"
        pathToDir="$workSpace$(dirname "$(realpath -e "$1")")"
    else
        pathToFile="$workSpace$(pwd)/"$1""
        pathToDir="$workSpace$(dirname "$(realpath -e "$1")")"
    fi
fi

# Запускаем контейнер в зависимости от предоставленных прав
if [[ $(id -u) -eq 0 ]]; then
    docviRoot "$pathToFile" "$pathToDir"
else
    if [[ -e "$1" && ! -w "$1" ]]; then
        echo "ПермишьOн деньюИд (говорит по-французски)"
        exit 1
    fi
    docviUser "$pathToFile" "$pathToDir"
fi
