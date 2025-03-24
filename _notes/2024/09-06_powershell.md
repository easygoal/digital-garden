---
title: PowerShell
---

## PowerShell tips

编辑 ``%UserProfile%\Documents\WindowsPowerShell\profile.ps1``

```sh
### use gcm for details
function which($cmd) {
  Get-Command $cmd | Select-Object -ExpandProperty Definition
}
```
### rename
[Rename-Item](https://learn.microsoft.com/zh-cn/powershell/module/Microsoft.PowerShell.Management/rename-item?view=powershell-7.4)
```bash
ls *.* | ren -NewName { $_.Name -replace 'ALL','All' }
```

## Mount Linux xfs disk
Use [[scoop 软件包|scoop]] to install sudo pkg

```sh
### In PowerShell with admin permission
### Identify disk
GET-CimInstance -query "SELECT * from Win32_DiskDrive"

### mount
wsl --mount \\.\PHYSICALDRIVExx --bare

### WSL
# check filetype
sudo blkid <BlockDevice>
# mount with filetype
sudo mount -t xfs /dev/sdd1 /mnt/diskX
```

## Windows CMD
- create a new file with ``default.cmd`` as example
- regedit 
- Then navigate to ``Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor``.
- Right click on the Command Processor folder and click New -> String Value.
- Enter AutoRun and press enter.
- Now double-click on AutoRun and type in the full path to your bashrc.cmd file and then click OK.

[[09-05_scoop|使用scoop 安装 windows 环境]]

## 无管理员权限设置用户环境变量
1. Win+R 弹出对话框
2. 输入：``rundll32.exe sysdm.cpl,EditEnvironmentVariables``，弹出编辑窗口，仅可编辑当前用户设置
3. 修改完成确定退出

## wget
```
wget -r -c -nH -np -R "*.zip,*.tar" [链接]/[文件夹]

-r 表示下载指定文件夹
-c 表示断点可以续传(断网或者ctrl-c掉，也可以重新输入命令接着之前的下载)
-R 表示过滤掉某些类型文件(当有多种类型的时候，可以用 , 隔开)
-np 表示不到上一层子目录去(没明白，带上就行了)
-nH 表示不要将文件保存到主机名文件夹(不加的话，会自动把下载的东西放在一个ip地址文件下)

下载文件夹可能会多一些 index文件，可以用-R过滤掉
wget -r -c -nH -np -R "index.html*" [链接]/[文件夹]
```

最后的文件夹路径，要以 / 结尾

[[your-first-note|Back to Main]]
