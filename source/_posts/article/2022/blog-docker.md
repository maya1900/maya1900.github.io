---
title: hexo博客使用docker自动化部署阿里云
date: 2022-08-06
tags:
  - 运维
  - docker
categories: 运维
---

![](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202208052205279.jpeg)

# 起因

接上一篇[hexo 博客 docker 部署阿里云的一点心得](https://www.maya1900.top/article/2022/docker-blog/) 之后，第二次上传文章的时候发现，从 dockerhub 仓库拉取自己的镜像非常慢，而且基本都是 timeout 拉不下来，尝试改镜像源什么的没啥效果。

在修改镜像源的过程中发现了阿里云容器镜像服务，发现它个人版还是免费的，经测试，拉取镜像速度很快，于是就用上了它。

又想到，每次发文章都要 push 代码，然后登陆 ecs 再用 docker pull 下来，然后再 run 起来.......是不是太麻烦了，是不是可以一步到位，只要 push 完代码就行了，其他的交给 git action。

自己在本地登录 ecs 是需要输入密码的，在 gitaction 上是通过脚本执行，怎么做呢？在网上找了后发现也有教程案例，那就是使用 ssh 密钥来登陆 ecs，然后执行登陆后的操作。

# 思路

1. push 代码
2. 触发 git action
3. 使用阿里云容器镜像服务保存镜像
4. 使用 ssh 远程登录 ecs，从阿里云的镜像上 pull 镜像，然后 run

# 过程

## 一、使用阿里云容器镜像服务

登陆阿里云，搜索容器镜像服务，创建一个个人版镜像仓库，记住命名空间和仓库名称，选择类型时选择公开。

仓库管理--访问凭证设置一个固定密码。

至此，这里需要用到：

- 容器镜像用户名（阿里账户全名）
- 容器镜像密码（设置好的固定密码）
- 个人镜像的命名空间
- 镜像仓库名称

## 二、在 ecs 上建立 ssh 密钥

登陆可以使用密码登陆，也可以使用 ssh 密钥登陆，为了安全，使用 ssh 密钥。

1. 登陆 ecs，执行
   ```shell
   mkdir -p ~/.ssh && cd ~/.ssh
   ssh-keygen -t rsa
   ```
2. 执行命令，一路回车，得到 id_rsa 和 id_rsa.pub，其中 id_rsa 是私钥，id_rsa.pub 是公钥
3. 在服务器上安装公钥，设置好权限：
   ```shell
   cat id_rsa.pub >> authorized_keys
   chmod 600 authorized_keys
   chmod 700 ~/.ssh
   ```
4. 设置 ssh，打开密钥登陆：
   ```shell
   # 编辑 /etc/ssh/sshd_config 文件,进行如下设置
   RSAAuthentication yes
   PubkeyAuthentication yes
   ```

后面两步验证即可，后面也是查了才知道，默认情况下都是正确的。

查看私钥文件，复制备用。

## 三、配置 git secrets

在 github 上打开项目目录，Settings -> Secrets -> actions，添加好需要用到的参数：

- REGISTRY_USERNAME ：镜像仓库用户名
- REGISTRY_PASSWORD：镜像仓库密码
- SERVER_HOST：服务器地址
- SERVER_USER：服务器用户名
- SERVER_TOKEN：ssh 私钥

![](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/20220805215339.png)

## 四、编写 git actions

actions 中新建一个 action 动作，选择 nodejs 模版，然后编写内容：

```yml
# deploy.yml
name: deploy blog to dockerhub
on:
  push:
    branches:
      - hexo # 上传到此分支触发
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      # 检查代码
      - name: Checkout # 将仓库内master分支的内容下载到工作目录
        uses: actions/checkout@v2 # 脚本来自 https://github.com/actions/checkout
      # 发布
      - name: Login to Aliyun Container Registry (ACR)
        uses: aliyun/acr-login@v1 # 使用阿里云镜像服务action
        with:
          login-server: registry.cn-shenzhen.aliyuncs.com # 务必正确填写镜像容器服务的登录地址
          region-id: cn-shenzhen # 务必正确填写镜像容器服务的登录地址
          username: '${{ secrets.REGISTRY_USERNAME }}' # 引用GitHub repo设置的镜像容器服务用户名
          password: '${{ secrets.REGISTRY_PASSWORD }}' # 引用GitHub repo设置的镜像容器服务密码
      - name: Build and Push Docker Image
        env:
          app_name: 'my-blog'
          app_space: 'maya1900'
          app_url: 'registry.cn-shenzhen.aliyuncs.com'
        run: |
          docker build -t $app_url/$app_space/$app_name:latest .
          docker push $app_url/$app_space/$app_name:latest
      # 部署
      - name: Login aliEcs
        uses: appleboy/ssh-action@master
        env:
          app_name: 'my-blog'
          app_space: 'maya1900'
          app_url: 'registry.cn-shenzhen.aliyuncs.com'
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SERVER_TOKEN }}
          port: 22
          script: |-
            app_name="my-blog"
            app_space="maya1900"
            if test -n "$(docker ps -a |grep $app_name)"; then
              echo "停止并且删除容器和上版本镜像"
              docker stop $app_name
              docker rm $app_name
              docker rmi registry.cn-shenzhen.aliyuncs.com/$app_space/$app_name:latest
            else
              echo "未检查到$app_name容器运行"
            fi

            echo "获取最新的镜像"
            docker pull registry.cn-shenzhen.aliyuncs.com/$app_space/$app_name:latest
            echo "启动服务"
            docker run --name $app_name -p 8082:80 -d registry.cn-shenzhen.aliyuncs.com/$app_space/$app_name:latest
```

保存后，action 就应该第一次启动了（当然我试了 n 次才成功...）。

以后 push 完代码就可以等代码部署到网站了。（里面使用到的 docker 命令与上一篇文章有关，有兴趣可自行查看）

# 遇到的坑：

1. 镜像推到阿里云上，拉取不下来？
   1. 把仓库设置为公开
   2. 拉取路径有问题，先在本地尝试
2. 使用了阿里镜像服务，执行时还在 dockerhub 上拉取？
   1. 因为上一篇中使用了 docker-compose，pull 完后就 docker-compose up，执行 docker-compose 里的指令，这里其实设置 images 时使用阿里镜像的地址，一样使用 docker-compose，为了直接使用脚本，就不另外建文件了
3. linux 使用变量总是出错？
   1. 在给镜像地址一个变量时(这里是 registry.cn-shenzhen.aliyuncs.com)，总是出错，执行 app_url="registry.cn-shenzhen.aliyuncs.com"才发现这条出错，于是把它直接写死里面了。。

# 发现还需要学的：

- linux 操作学习
- 脚本语言学习

最后，感谢前辈们的无私分享，谢谢。

# 参考

1. [使用 GitHub Action 自动构建和推送 Docker 镜像\_BulletTech2021 的博客-CSDN 博客\_github 自动构建 docker](https://blog.csdn.net/BulletTech2021/article/details/121444287)
2. [Java 项目基于 github actions、dockerhub、aliyunECS 构建 CICD 流水线 - 掘金 (juejin.cn)](https://juejin.cn/post/6996096550468321294)
3. [使用 GitHub Actions 实现博客自动化部署 | Frost's Blog (frostming.com)](https://frostming.com/2020/04-26/github-actions-deploy/)
