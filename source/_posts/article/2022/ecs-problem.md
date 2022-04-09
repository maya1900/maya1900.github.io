---
title: hexo部署到阿里云ECS遇到的问题
date: 2022-04-01
tags:
  - hexo
categories: 建站
cover: https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/202204092143255.jpg
---

1. hexo 添加备案号

   在主题文件 footer 添加

2. hexo 移除 algolia
   在站点文件\_config 移除，主题文件\_config 设为 false

3. hexo-butterfly 本地搜索无效？
   未解决

4. 宝塔面板不支持根目录设置在…..文件下
   最后/var/..都换成/www/wwwroot/.. 目录
   /repo 和/hexo 都要给权限
   > [Hexo 部署至云服务器（宝塔面板） - 黑石博客 - Hexo 博客 (heson10.com)](https://www.heson10.com/posts/51315.html)
5. does not appear to be a git repository ?

   repo 一直以为是/hexo 那个目录导致出错。。

```JavaScript
deploy:
  type: git
  repo: git@服务器ip或域名:/var/repo/hexo.git
  branch: master

```

6. Please make sure you have the correct access rights and the repository exists
   目录权限问题。repo 目录和 hexo 目录都要给对所有者(git)和权限(755)

7. 宝塔面板重启打不开了？

   [Hexo 部署到阿里云服务器 ECS\_最小的帆也能远航的博客-CSDN 博客\_hexo 部署阿里云服务器](https://blog.csdn.net/weixin_44364444/article/details/117150609)

   service bt restart 后无法打开面板：ecs 服务器远程连接后,bt，选择开始面板服务

8. 部署成功网站打不开？

   服务器安全组配置入方向规则，快速添加 443 和 80 端口

9. fatal: sha1 file '' write error: Broken pipe，! [remote rejected] HEAD -> master (unpacker error)

   repo 目录没给权限

10. 在宝塔面板申请 ssl 证书，配置完不生效？

    申请免费 Let's Encrypt 证书，配置阿里云 dns 接口(控制台—头像—accesskey 管理获取)

    配置好后，点证书文件夹，刚刚配好的点部署，才能生效。同时安全组开启 443

参考链接：

[Hexo 部署至云服务器（宝塔面板） - 黑石博客 - Hexo 博客 (heson10.com)](https://www.heson10.com/posts/51315.html)

[Hexo 部署到阿里云服务器 ECS\_最小的帆也能远航的博客-CSDN 博客\_hexo 部署阿里云服务器](https://blog.csdn.net/weixin_44364444/article/details/117150609)

[使用 GithubActions 自动部署应用到自己的服务器（ECS） - 云+社区 - 腾讯云 (tencent.com)](https://cloud.tencent.com/developer/article/1720500)
