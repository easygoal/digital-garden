---
title: Copy in Linux
---

如何在 Linux 下复制大量数据

### 使用 cp
使用 ``cp`` 命令，速度感人，基本无法使用

### 使用 rsync
```sh
rsync -avPz <source_path> <dest_path>
```

### 使用 tar 与管道
```sh
cd source/; tar cf - . | (cd target/; tar xvf -)
```
一边使用打包，另一边解包，应该比单纯``rsync``更快

### 观察磁盘IO性能
```sh
iotop -oP
```

[[your-first-note|Back to Main]]
