---
title: scoop 软件包
---

[link](https://zhuanlan.zhihu.com/p/594363658)

# Overview
- [官网](https://github.com/ScoopInstaller/Scoop)
- [安装教程](https://github.com/ScoopInstaller/Scoop/wiki)
- [国内镜像](https://gitee.com/scoop-installer/scoop)

## 安装
1. 打开Powershell 相关权限: ``set-executionpolicy remotesigned -scope currentUser``
2. 默认安装路径: ``C:\Users\<username>\scoop``
3. 自定义安装路径: `` $env:SCOOP=`C:\scoop` ``
4. 执行安装脚本: ``iwr -useb get.scoop.sh | iex``
5. ``scoop update``
6. 切换国内镜像: ``scoop config SCOOP_REPO https://gitee.com/scoop-installer/scoop``
7. 切换官方镜像: ``scoop config SCOOP_REPO https://github.com/ScoopInstaller/Scoop``

## 使用
```sh
scoop help
scoop update
scoop bucket add extras

scoop search xxx
scoop install xxx
scoop install xxx@1.0
scoop uninstall xxx

scoop status       ## check updatable apps
scoop cleanup xxx  ## remove old version

### bucket command
scoop bucket add versions
scoop bucket add dorado https://github.com/chawyehsu/dorado

### 国内 bucket
scoop bucket add extras https://gitee.com/scoop-bucket/extras.git
```

## 常用软件
```sh
scoop install 7zip btop cmake cwrsync grep gdu git git-lfs sudo
scoop install openssh findutils uutils-coreutils vim wget winget
scoop install q-dir everything coretemp
scoop install v2rayn vscode snipaste
scoop install w64devkit hwinfo lxrunoffline ctags
scoop install mpc-hc-fork ffmpeg musicbee
scoop install xmedia-recode fancontrol tsukimi
scoop install mill oss-cad-suite-nightly
```

## FAQ
### GIMP install workaround
```sh
scoop bucket add versions
scoop uninstall innounp
scoop install innounp-unicode
scoop install gimp
```

For more information, please refer to [[scoop-dev]]

[[your-first-note|Back to Main]]
