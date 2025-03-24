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

### 快速大量小文件复制
```sh
# copy directory
tar cvf - /path/src_dir | tar xvf - -C /path/dst

# copy files
tar cf - access.log | tar xf - -C /path/dst

# generate filelist
find . -regex '.*\.png|.*\.jpeg\|.*\.jpg' -print > img.txt
# split img.txt
split -l 500000 ../ img.txt -d -a 4 xiu_
# tar ball according to filelist, don't use -v arg
tar -cf jpg.tar.gz -T yourfile

# count files inside a tarball
tar tvf file.tar | grep "^-" | wc -l
# count directory inside a tarball
tar tvf file.tar | grep "^d" | wc -l
```
### 快速删除大量文件
```sh
rsync -h | grep delete

# make an empty dir
mkdir -p /tmp/del_blank
# don't forget the '/' in the tail, which can improve performance
rsync --delete-before -aHvP --stats /tmp/del_blank/ /path/del_data/
```

[[your-first-note|Back to Main]]
