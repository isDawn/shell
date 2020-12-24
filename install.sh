main () {

  # 如果 connectServer 已经安装，删除旧版本
  if [ -d ~/.connectServer ]; then
      rm -rf ~/.connectServer
  fi

  # 如果 $ZSH 为空
  if [[ ! -n "${connectServer}" ]]; then
      connectServer=~/.connectServer
  fi

  # umask 设置了用户创建文件的默认权限
  umask g-w,o-w


  #----------------------------------------------
  # 检查软件环境
  #----------------------------------------------
  uname="$(uname -s)"

  # 检查 git 是否安装
  hash git >/dev/null 2>&1 || {
      echo -e "\033[31m 错误: Git 没有安装，请先安装 Git \033[0m"
      exit 1
  }

  #----------------------------------------------
  # 下载代码
  #----------------------------------------------
  env git clone https://github.com/isDawn/shell.git ${connectServer} || {
      echo -e "\033[31m 错误: 克隆 BundleKit 仓库失败 \033[0m"
      exit 1
  }
  
  #----------------------------------------------
  # 安装 & 创建符号链接
  #----------------------------------------------
  pushd ${connectServer} >/dev/null 2>&1
  ./service.sh -g
  popd >/dev/null 2>&1
}

main