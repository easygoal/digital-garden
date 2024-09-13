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

## Mount Linux xfs disk
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

[[your-first-note|Back to Main]]
