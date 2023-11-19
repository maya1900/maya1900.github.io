---
title: mac升级系统后ssh登录服务器问题
tags:
  - 运维
  - ssh
categories: 运维
date: 2023-11-19 12:27:00
---

### 问题复现：

```
ssh root@ip
```

提示：

```
ssh_exchange_identification: Connection closed by remote host
```

### 问题排查：

```
ssh -v root@password
```

提示：

```
kex_exchange_identification: Connection closed by remote host
...

debug1: Authenticator provider $SSH_SK_PROVIDER did not resolve; disabling
```

### 问题原因：

Mac os Ventura 13.0 升级了 ssh 到 9.0，ssl 到 3.3.6,而服务器上的 sshd 还是老版本；服务器上的老版本 ssh 和 ssl 无法和 mac 上的新版本 ssh 和 ssl 交互，新版本 ssh 加密算法有更改；需要在 mac 上添加一些兼容老版本的参数。

### 问题解决：

```
sudo vim /etc/ssh/ssh_config

写入以下内容
Host *
    SendEnv LANG LC_*
    #添加以下两行
    PubkeyAcceptedAlgorithms +ssh-rsa
    HostkeyAlgorithms +ssh-rsa
```

Host \* 说明对所有主机生效

HostKeyAlgorithms +ssh-rsa 是指定所有主机使用的都是 ssh-rsa 算法的 key

### 参考：

[SSH 连接调试：逐行解读 SSH -vvv 的输出信息\_ssh 调试-CSDN 博客](https://blog.csdn.net/qq_14829643/article/details/132842956)

[mac 升级系统后 ssh 登录服务器问题\_mac 升级 ssh_laocaibulao 的博客-CSDN 博客](https://blog.csdn.net/cai6595470/article/details/130712533)
