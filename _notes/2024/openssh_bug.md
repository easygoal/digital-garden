---
title: OpenSSH and cwrsync in Windows
---

使用 [[09-05_scoop|scoop]] 安装 openssh 和 cwrsync 之后，会发生 cwrsync 复制出错的问题
需要在 ``rsync`` 命令的时候加上合适的参数，例如：
```sh
rsync -e 'c:/tools/scoop/apps/cwrsync/current/bin/ssh.exe' -avP user@source <dest>
```

或者需要修改 ``scoop/shims/ssh.shim`` 中 ssh 命令的路径，使用 cwrsync 配套的ssh 可执行文件

[[your-first-note|Back to Main]]
