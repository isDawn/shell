#!/usr/bin/env bash

main() {

    # 检查 git 是否安装
    hash connectServer >/dev/null 2>&1 || [ -d ~/.connectServer ] || {
        echo -e "\033[31m Not install connectServer \033[0m"
        exit 1
    }

    # 删除软链接
    rm -rf /usr/local/bin/connectServer
    if [ $? != 0 ]; then
        echo -e "\033[31m delete symbolic failed  \033[0m"
        exit 1
    fi

    # 如果已经安装，删除
    if [ -d ~/.connectServer ]; then
        rm -rf ~/.connectServer
    fi

    if [ $? != 0 ]; then
        echo -e "\033[31m remove directory failed \033[0m"
        exit 1
    fi

    echo -e "\033[32m connectServer was uninstalled successfully\033[0m" 
}

main
