#!/bin/bash

source ./config.sh

parseParams() {
    if [ $# -lt 1 ]; then
        login
    else
        case $1 in
            -user)
                echo "setUserName ===>$2"
                sed -i '' "s/USER_NAME='$USER_NAME'/USER_NAME='$2'/g" config.sh
                exit;;
            -pwd)
                echo "setPassWord ===>$2"
                sed -i '' "s/USER_PASSWORD='$USER_PASSWORD'/USER_PASSWORD='$2'/g" config.sh
                exit;;
            -v | -version)
                echo $USER_NAME
                echo "connectService version: $VERSION"
                exit;;
            -u | -update)
                echo '已经是最新版本啦'
                exit;;
            -l | -login )
                login
                ;;
            -h | -help )
                echo '帮忙功能暂未开放'
                ;;
            * )
                echo '请输入正确的指令'
                exit;;
        esac
    fi
}

login() {
    echo USER_NAME
    if [ ! $USER_NAME ];then
        echo -e "\033[31m 请先设置用户名称 $ connectServer -user XXX \033[0m"  
        exit
    fi

    if [ ! $USER_PASSWORD ];then
        echo -e "\033[31m 请先设置用户密码 $ connectServer -pwd ****** \033[0m"
        exit
    fi

    echo -e "\033[32m -------------------------------------- \033[0m" 
    echo -e "\033[32m |        _____   _____   _   _       | \033[0m" 
    echo -e "\033[32m |       /  ___/ /  ___/ | | | |      | \033[0m" 
    echo -e "\033[32m |       | |___  | |___  | |_| |      | \033[0m" 
    echo -e "\033[32m |       \___  \ \___  \ |  _  |      | \033[0m" 
    echo -e "\033[32m |        ___| |  ___| | | | | |      | \033[0m" 
    echo -e "\033[32m |       /_____/ /_____/ |_| |_|      | \033[0m" 
    echo -e "\033[32m -------------------------------------- \033[0m" 


    echo -e "\033[32m -------------------------------------- \033[0m" 
    echo "please enter your Server:"
    echo " >>> (1) 120.78.154.36 (daily)"
    echo " >>> (2) 47.107.105.88 (public)"
    echo " >>> (3) exit"
    echo -e "\033[32m -------------------------------------- \033[0m" 
    read -p "请选择服务器:" input

    ssh=''

    case ${input} in
        1)
        echo -e "\033[35m 「daily登录」 \033[0m" 
        ssh="ssh $USER_NAME@120.78.154.36 -p 60022"
            sleep 1;;
        2)
        echo -e "\033[35m 「public登录」 \033[0m" 
        ssh="ssh $USER_NAME@47.107.105.88 -p 60022"
        sleep 1;;
        3)
        exit;;
    esac

    expect -c "
    spawn $ssh;
    sleep 1;
    send "$USER_PASSWORD\r"  
    expect {
        *password:* { send \"$USER_PASSWORD\r\" }  
    }
    interact
    "
}

main() {
    parseParams $1 $2
}

main "$@"