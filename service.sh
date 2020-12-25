#!/bin/bash

BKIT_PATH=/Users/$(whoami)/.connectServer

configAddr="$BKIT_PATH/./config.sh"

source $configAddr

parseParams() {
    if [ $# -lt 1 ]; then
        login
    else
        case $1 in
            -user)
                echo "setUserName ===>$2"
                setUserName $2
                exit;;
            -pwd)
                echo "setPassWord ===>$2"
                setPassWord $2
                exit;;
            -v | -version)
                echo $USER_NAME
                echo "connectService version: $VERSION"
                exit;;
            -u | -update)
                update
                exit;;
            -l | -login )
                login
                ;;
            -h | -help )
                vhelp
                ;;
            -g | -global )
                install
                ;;
            * )
                echo '请输入正确的指令'
                exit;;
        esac
    fi
}

setUserName() {
    echo $1
    sed -i '' "s/USER_NAME='$USER_NAME'/USER_NAME='$1'/g" $configAddr
}

setPassWord() {
    sed -i '' "s/USER_PASSWORD='$USER_PASSWORD'/USER_PASSWORD='$1'/g" $configAddr
}

install() {

    absDirPath=$(cd `dirname $0`; pwd);

    sourcePath="$absDirPath/service.sh"

    targetPath="/usr/local/bin/connectServer"

    # # # 判断符号链接是否存在
    if [ -L $targetPath ]; then
        rm -rf $targetPath
    fi

    echo -e "\033[32m 请输入您的本机电脑密码进行安装 \033[0m"

    # 创建软连接
    sudo ln -s $sourcePath $targetPath
    if [ ! -L $targetPath ]; then
        echo -e "\033[31m created symbolic link failed! \033[0m"
        return 0
    fi
    echo -e "\033[32m create success \033[0m" 
}

vhelp() {
    echo -e "\033[32m $ connectServer -user \033[0m"
    echo -e "\033[32m $ connectServer -pwd \033[0m"
    echo -e "\033[32m $ connectServer -v | -version \033[0m"
    echo -e "\033[32m $ connectServer -u | -update \033[0m"
    echo -e "\033[32m $ connectServer -l | login \033[0m"
    echo -e "\033[32m $ connectServer -h | help \033[0m"
}

update() {
    branch=$1
    if [[ $branch = '' ]]
    then
        branch='master'
    fi
    cd ~/.connectServer && git pull -p && git checkout ${branch} && git pull -p && cd -
}

login() {

    isSetStatus=''
    
    if [ ! $USER_NAME ];then
        read -p "请先设置用户名称:" user_name
        if [ ! ${user_name} ];then
            echo -e "\033[31m 请先设置用户名称 $ connectServer -user XXX \033[0m"  
            exit
        fi
        setUserName $user_name

    fi

    if [ ! $USER_PASSWORD ];then
        read -p "请先设置密码:" pass_word
        if [ ! $pass_word ];then
            echo -e "\033[31m 请先设置用户密码 $ connectServer -pwd ****** \033[0m"
            exit
        fi
        setPassWord $pass_word
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
    read -p  "请选择服务器:" input

    ssh=''

    if [ $user_name ];then
        USER_NAME=$user_name
    fi

    if [ $pass_word ];then
        USER_PASSWORD=$pass_word
    fi

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