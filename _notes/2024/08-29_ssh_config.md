---
title: 高效使用SSH
---

[link](https://zhuanlan.zhihu.com/p/716963359)

## 背景

起因就是我发现大部分人对 SSH 只会基本的 `ssh user@ip` 的方式登录服务器，至多再会个配置免密，而对 SSH config 几乎不了解。事实上 SSH 可以灵活批量配置服务器信息，配置跳板等等。本文努力普及一些使用细节，希望有一天大家都熟练了 SSH config，以后我就可以直接给别人发送 SSH config 配置项而不需要作任何解释了。

## SSH config

SSH config 作用就是可以把 SSH 相关的信息都记录到一个配置文件，可以简化操作、节约时间。

SSH config 有一个系统级的，一个用户级的。一般普通用户只关注用户级的。文件路径为 `~/.ssh/config` 。

### 基本写法

一般一个服务器写成一小段，形如：
```bash
Host Server1
    Hostname 172.16.0.1
    User zhangsan
    Port 22
    ServerAliveInterval 180
    IdentityFile ~/.ssh/secret_key.pem
```
这段的含义为有一个服务器：

1. 我们为它起了个名字叫 Server1
2. 它的 IP 是 172.16.0.1（也可以填 Hostname）
3. 我在上面的用户名是 zhangsan
4. SSH 服务监听端口号为 22（即默认值，也可以不写这一行）
5. ServerAliveInterval 180 表示在建立连接后，每 180 秒客户端会向服务器发送一个心跳，避免用户长时间没操作连接中断
6. 最后一行表示使用一个专用的密钥，如果没有专用的密钥则删除该行即可。

登录这台服务器的话，输入：
```bash
$ ssh Server1
```
拷贝文件（反过来就是从服务器往本地下载文件）：
```bash
$ scp /path/to/local/file Server1:/path/to/remote/
```
可以看到，这样的好处有：（1）简洁，不需要记忆 IP 地址、端口号。（2）可以保持连接。

配置免密也相同，输入以下命令并输入密码：
```bash
$ ssh-copy-id Server1
```
### 通配符
如果有一批服务器都是相同的配置，更是可以用通配符统一处理：
```bash
Host Server*
    User zhangsan
    Port 22
    ServerAliveInterval 180

Host Server1
    Hostname 172.16.0.1

Host Server2
    Hostname 172.16.0.2

Host Server3
    Hostname 172.16.0.3
```
相信读者已经猜到其中的含义。第一段表示所有名字为 Server 开头的服务器，他们的用户名都是 zhangsan，端口都是 22，同时都有保持连接的心跳。然后下面列了 3 台服务器，我们只需要指定它们的 IP 地址。

### 多文件管理
如果需要管理非常多的服务器，全写到一个文件里会很乱很难维护，也不方便共享。事实上，`~/.ssh/config` 中支持引用其它文件。我一般习惯新建一个这样的配置 `~/.ssh/config-cluster-shanghai` ，在其中编写类似上文的内容。然后在 `~/.ssh/config` 的开头加入如下一行即可：
```bash
Include config-cluster-shanghai
```
事实上这里也可以用通配符，比如：
```bash
Include config-*
```
这样 ~/.ssh/ 目录下的所有 config- 开头的文件都会被引用到。

### 跳板

很多集群需要跳板机才可登录，我们需要先登录跳板机，再从跳板机登录内部机器。这会引入两个麻烦，一是登录要两次，如果配置 SSH config 还需要在跳板机也配置一份儿；二是拷贝文件十分麻烦，要拷贝两次。

对此可以这样写配置：
```bash
Host Jumper
    Hostname 1.2.3.4
    User zhangsan

Host Server*
    User zhangsan
    ProxyJump Jumper
    ServerAliveInterval 180

Host Server1
    Hostname 172.16.0.1

Host Server2
    Hostname 172.16.0.2
```
第一段为跳板机的登录方式，第二段中新增了一个 ProxyJump 字段，表示所有 Server 开头的服务器，在登录的时候都要从 Jumper 这个服务器跳转一下。这时候我们想登录 172.16.0.1，只需要直接输入：
```bash
$ ssh Server1
$ scp /path/to/local/file Server1:/path/to/remote/
```
注意一个细节是，这种配置下我们是直接从本地登录内部服务器，所以在配置免密时，是需要把本地的公钥放到内部服务器的。

## SCP 服务器间拷贝文件
scp 的基本用法相信大家都会，上文也多次提到。但如果想在两台服务器之间拷贝文件，事实上是可以在本地执行 scp 的：
```bash
$ scp Server1:/path/to/file Server2:/path/to/file2
```
这个命令要求 Server1 可以直接访问 Server2。如果不满足这个条件，可以用本机转发，只需要增加一个参数 -3 表示用本地机器当转发机：
```bash
$ scp -3 Server1:/path/to/file Server2:/path/to/file2
```

## 批量操作 PSSH
如果有一组机器要做相同的操作，可以使用 PSSH 工具。

很遗憾的是，这个工具原作者已经不维护了，但 GitHub 上散落着原仓库的副本，同时也有大家新增的逻辑。
安装：
```bash
$ python3 -m pip install pssh
```
准备一个 iplist：
```bash
$ cat iplist
Server1
Server2
```
批量操作：
```bash
$ pssh -ih iplist echo Hello
[1] 14:27:50 [SUCCESS] Server1
Hello
[2] 14:27:50 [SUCCESS] Server2
Hello
```
-i 表示把 stdout 输出，否则只会显示命令执行是否成功。-h 表示 host 的列表，后接 iplist 这个文件名。pssh 默认会在命令超时后强制结束， 不希望超时，可以加一个 -t 0 表示超时时间为 0 秒，0 表示无穷大。

PSSH 也可以把每个服务器的结果输出到不同的目录、可以单独指定 Host 等等，大家可以参考 manpage：
```bash
$ man pssh
```
