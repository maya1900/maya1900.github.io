---
title: hexo博客docker部署阿里云的一点心得
date: 2022-07-30
tags:
  - 运维
  - docker
categories: 运维
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/image/neko.png
---

## 初衷：

自己的博客证书一直有问题，不管是宝塔里申请的 Let‘s encrypt，还是阿里云的免费证书，于是想到部署上 nginx 配置，再用 docker，多网站方便管理，就当学习了。

## 思路：

1. push 代码到 git 触发 action 动作，docker build 镜像到 docker hub；
2. 配置好 nginx，多域名分发；
3. 在阿里云上 pull 镜像，然后 run。

## 使用：

hexo、git actions、docker/docker-compose、docker hub、nginx、阿里云

## 过程：

### 1. docker 部分：

1. 代码根目录写好 Dockerfile；

```yml
# node环境镜像

FROM node:latest AS build-env

# 创建hexo-blog文件夹且设置成工作文件夹

RUN mkdir -p /usr/src/hexo-blog

WORKDIR /usr/src/hexo-blog

# 复制当前文件夹下面的所有文件到hexo-blog中

COPY . .

# 安装 hexo-cli

RUN npm --registry=https://registry.npm.taobao.org install hexo-cli -g && npm install

# 生成静态文件

RUN hexo clean && hexo g


# 配置nginx

FROM nginx:latest

ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /usr/share/nginx/html

# 把上一部生成的HTML文件复制到Nginx中

COPY --from=build-env /usr/src/hexo-blog/public /usr/share/nginx/html

EXPOSE 80
```

2. 注册一个 docker hub 账号；

### 2. git action 部分：

1. 在 github 项目设置里配置 secret，添加变量 DOCKER_USERNAME、DOCKER_PASSWORD，分别是 docker hub 的账号密码；
2. 在新建一个 node 的 action，提交动作后自动执行 action，此时镜像已经被打包到 docker hub 中，可上前查看，以后 push 代码自动触发 action。

```yml
# deploy.yml

name: deploy blog to dockerhub

on:

push:

branches:

- hexo

jobs:

build:

runs-on: ubuntu-latest

steps:

# 切换分支

- name: Checkout # 将仓库内master分支的内容下载到工作目录

uses: actions/checkout@v2 # 脚本来自 https://github.com/actions/checkout

# 发布

- name: docker build

run: |

echo ${{secrets.DOCKER_PASSWORD}} | docker login -u ${{secrets.DOCKER_USERNAME}} --password-stdin

docker build -t maya1900/may-blog:latest .

docker push maya1900/may-blog:latest

```

### 3. 阿里云部分：

1. 安装 docker、docker-compose、nginx
2. 写好 nginx 配置文件，一般在 usr/local/nginx/conf/nginx.conf，（安装了宝塔面板的，配置位置变了/www/server/nginx/conf/nginx.conf，或者直接在软件商店里配置）：

```yaml

#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}

http {
    server {
      listen 443 ssl;
      server_name  maya1900.top www.maya1900.top;
      root /usr/share/nginx/html;
      index index.html index.htm;
      ssl_certificate /usr/local/nginx/conf/cert/pem.pem;
      ssl_certificate_key /usr/local/nginx/conf/cert/key.key;

      default_type  application/octet-stream;
      gzip on;
      gzip_min_length 5k;
      gzip_buffers 4 16k;
      gzip_http_version 1.1;
      gzip_comp_level 3;
      gzip_types text/plain application/json application/javascript text/css application/xml text/javascript image/jpeg image/gif image/png;
      gzip_vary on;
      location / {
          proxy_pass http://127.0.0.1:8082;
      }
    }
    server {
      listen 80;
      server_name  maya1900.top www.maya1900.top;
      root /usr/share/nginx/html;
      index index.html index.htm;
      rewrite ^(.*)$ https://$host$1; #将所有HTTP请求通过rewrite指令重定向到HTTPS。
      default_type  application/octet-stream;
      location / {
          proxy_pass http://127.0.0.1:8082;
      }
    }
    server {
      listen 443 ssl;
      server_name  todo.maya1900.top;
      root /usr/share/nginx/html;
      index index.html index.htm;
      ssl_certificate /usr/local/nginx/conf/cert/pem.pem;
      ssl_certificate_key /usr/local/nginx/conf/cert/key.key;

      default_type  application/octet-stream;
      gzip on;
      gzip_min_length 5k;
      gzip_buffers 4 16k;
      gzip_http_version 1.1;
      gzip_comp_level 3;
      gzip_types text/plain application/json application/javascript text/css application/xml text/javascript image/jpeg image/gif image/png;
      gzip_vary on;
      location / {
          proxy_pass http://127.0.0.1:8083;
      }
    }
    server {
      listen 80;
      server_name  todo.maya1900.top;
      root /usr/share/nginx/html;
      index index.html index.htm;
      # rewrite ^(.*)$ https://$host$1; #将所有HTTP请求通过rewrite指令重定向到HTTPS。
      default_type  application/octet-stream;
      location / {
          proxy_pass http://127.0.0.1:8083;
      }
    }
}
```

3.  在服务器上随便找个地方新建 docker-compose.yml，写好文件：

```yml
version: '3.7'
services:
  blog:
    container_name: may-blog
    image: maya1900/may-blog:latest
    ports:
      - '8082:80'
    restart: on-failure
  todo:
    container_name: todo
    image: maya1900/todo:latest
    ports:
      - '8083:80'
    restart: on-failure
```

4. 在当前目录打开终端：

```shell
# 拉取镜像
docker-compose pull
# 运行镜像
docker-compose up -d
# 停止删除容器和镜像
docker-compose down
```

### 5. 证书问题

在 nginx 配置文件 443 那里配置好证书，同时在阿里云的 ssl 免费证书那再部署好，等待几分钟访问就没问题了

## 遇见的坑：

1. push 时 docker build 总是失败？
   路径不对
2. docker run 成功后访问没有站点了？
   1. 排查镜像是否正确
   2. nginx 配置是否正确
   3. 先用服务器 ip 地址访问是否成功，看域名解析是否正确
3. 能访问了证书还是不安全？
   1. 看是否在阿里云证书管理服务那进行了部署
4. "客户端和服务器不支持常用的 SSL 协议版本或密码套件"？
   1. 配置玩证书后出现的，过了一会好了...可能是需要个解析过程
5. 修改完 nginx 配置后不生效？
   1. 需要重启 nginx 服务

## 参考：

感谢各位前辈们的帮助！

[写给前端的 Docker 实战教程 - 掘金 (juejin.cn)](https://juejin.cn/post/6844903946234904583)
[手把手教你用 Docker 搭建 Hexo 博客 - 腾讯云开发者社区-腾讯云 (tencent.com)](https://cloud.tencent.com/developer/article/1563437)
[利用 GitHub Action 自动发布 Docker-阿里云开发者社区 (aliyun.com)](https://developer.aliyun.com/article/906895)
[阿里云安装 nginx，实现域名访问|服务器|proxy|ip\_网易订阅 (163.com)](https://www.163.com/dy/article/GHRPLG0C0511TVGO.html)
