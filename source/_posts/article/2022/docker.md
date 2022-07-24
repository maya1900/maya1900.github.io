---
title: docker学习
date: 2022-07-30
tags:
  - 运维
  - docker
categories: 运维
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/image/neko.png
---

# 了解 Docker 的核心组成

## 四大组成对象

**镜像 ( Image )**、**容器 ( Container )**、**网络 ( Network )**、**数据卷 ( Volume )**

### 镜像

镜像，可以理解为一个只读的文件包，其中包含了**虚拟环境运行最原始文件系统的内容**。

### 容器

在容器技术中，容器就是用来隔离虚拟环境的基础设施，而在 Docker 里，它也被引申为隔离出来的虚拟环境。

### 网络

### 数据卷

理解为文件系统

## Docker Engine

docker 最核心的软件，用来实现 docker 容器化。

### docker daemon 和 docker CLI

提供了 docker 的核心服务

![](https://secure2.wostatic.cn/static/iFPVzp67DXyoEmYjdM2nNs/image.png)

提供了 Restful API 功能

![](https://secure2.wostatic.cn/static/9wLFns3z6yxDURZ6vYK7X1/image.png)

# 在 Windows 和 Mac 中使用 Docker

### 启动 Docker

打开 docker desktop，会自动启动 docker 服务。

# 镜像与容器

### 查看镜像

`docker images`,列出本地 Docker 中的所有镜像

# 从镜像仓库获得镜像

## 镜像仓库

Docker 里集中存放镜像的一个概念，也就是**镜像仓库**。

### 获取镜像

`docker pull xxx`，e.g. `docker pull ubuntu`

## Docker Hub

Docker Hub 是 Docker 官方建立的中央镜像仓库: [hub.docker.com/](https://hub.docker.com/)

## 管理镜像

`docker images`

`docker inspect`获得镜像详细信息

### 删除镜像

`docker rmi [name/id] [name/id] ...`

# 运行和管理容器

### 创建容器

`docker create` e.g. `docker create nginx:1.12`

`--name` 这个选项来配置容器名`docker create --name nginx nginx:1.12`

### 启动容器

`docker start [name/id]` e.g. `docker start nginx`

通过 `docker run` 这个命令将 `docker create` 和 `docker start` 这两步操作合成为一步: `docker run --name nginx -d nginx:1.12`

`docker run` 在启动容器时，会采用“前台”运行这种方式，通过 `-d` 或 `--detach` 这个选项告诉 Docker 在启动后将程序与控制台分离，使其进入“后台”运行。

### 管理容器

`docker ps` 列出 Docker **运行中**的容器

`-a` 或 `--all` 选项，列出所有状态的容器

### 停止和删除容器

`docker stop [name/id]`

`docker rm [name/id]`

增加 `-f` 或 `--force` 选项来让 `docker rm` 强制停止并删除**运行中的容器**

### 随手删除容器

Docker 的轻量级容器设计，讲究`随用随开，随关随删`。

容器删除，文件系统变动消失？

1.  为程序准备一些环境或者配置，打包到新镜像中；
2.  使用 docker 的数据卷单独存放数据，它独立于容器存在，不会随着容器的删除而丢失。

## 进入容器

`docker exec`

`more` 命令查看容器的主机名定义 e.g. `docker exec nginx more /etc/hostname`

启动 bash：`docker exec -it nginx bash`

`-i` ( `--interactive` ) 表示保持我们的输入流

`-t` ( `--tty` ) 表示启用一个伪终端

### 衔接到容器

`docker attach` 将当前的输入输出流连接到指定的容器 e.g. `docker attach nginx`

# 为容器配置网络

## 容器网络

![](https://secure2.wostatic.cn/static/nFXPmmcZkVLot4ncfGHbBn/image.png)

核心概念：**沙盒 ( Sandbox )**、**网络 ( Network )**、**端点 ( Endpoint )**

- **沙盒**提供了容器的虚拟网络栈，包含端口套接字、IP 路由表、防火墙等；
- **网络**可以理解为 Docker 内部的虚拟子网，网络内的参与者相互可见并能够进行通讯。
- **端点**是位于容器或网络隔离墙之上的洞，其主要目的是形成一个可以控制的突破封闭的网络环境的出入口

这三者形成了 Docker 网络的核心模型，也就是容器网络模型 ( Container Network Model )。

#### 浅析 Docker 的网络实现

![](https://secure2.wostatic.cn/static/3Jg1RyQpSBS84WEGRmBzok/image.png)

Docker 官方为我们提供了五种 Docker 网络驱动，分别是：**Bridge Driver**、**Host Driver**、**Overlay Driver**、**MacLan Driver**、**None Driver**。

## 容器互联

要让一个容器连接到另外一个容器，我们可以在容器通过 `docker create` 或 `docker run` 创建时通过 `--link` 选项进行配置

#### 暴露端口

端口的暴露可以通过 Docker 镜像进行定义，也可以在容器创建时进行定义。在容器创建时进行定义的方法是借助 `--expose` 这个选项

## 管理网络

通过 `docker inspect` 命令查看容器，可以在 Network 部分看到容器网络相关的信息。

#### 创建网络

`docker network create` e.g. `docker network create -d bridge individual`

`-d` 选项我们可以为新的网络指定驱动的类型

通过 `docker network ls` 或是 `docker network list` 可以查看 Docker 中已经存在的网络

之后在我们创建容器时，可以通过 `--network` 来指定容器所加入的网络

## 端口映射

需要在容器外通过网络访问容器中的应用。

在创建容器时使用 `-p` 或者是 `--publish` 选项

e.g. `docker run -d --name nginx -p 80:80 -p 443:443 nginx:1.12`

使用端口映射选项的格式是 `-p <ip>:<host-port>:<container-port>`

ip 是宿主操作系统的监听 ip，可以用来控制监听的网卡，默认为 0.0.0.0，也就是监听所有网卡。host-port 和 container-port 分别表示映射到宿主操作系统的端口和容器的端口

# 管理和存储数据

## 数据管理实现方式

### 挂载方式

三种适用于不同场景的文件系统挂载方式：**Bind Mount**、**Volume** 和 **Tmpfs Mount**。

- **Bind Mount** 能够直接将宿主操作系统中的目录和文件挂载到容器内的文件系统中
- **Volume** 也是从宿主操作系统中挂载目录到容器内，只不过这个挂载的目录由 Docker 进行管理，我们只需要指定容器内的目录
- **Tmpfs Mount** 支持挂载系统内存中的一部分到容器的文件系统里，其中的内容会随着容器的停止而消失。

## 挂载文件到容器

容器创建的时候通过传递 `-v` 或 `--volume` 选项来指定内外挂载的对应目录或文件。

e.g. `docker run -d --name nginx -v /webapp/html:/usr/share/nginx/html nginx:1.12`

`-v <host-path>:<container-path>` 或 `--volume <host-path>:<container-path>`，其中 host-path 和 container-path 分别代表宿主操作系统中的目录和容器中的目录

必须使用绝对路径

挂载选项 `-v` 后再接上 `:ro` 就可以只读挂载

`docker run -d --name nginx -v /webapp/html:/usr/share/nginx/html:ro nginx:1.12`

### 挂载临时文件目录

Tmpfs Mount 是一种特殊的挂载方式，它主要利用内存来存储数据。

通过 `--tmpfs` 这个选项来完成

`docker run -d --name webapp --tmpfs /webapp/cache webapp:latest`

### 使用数据卷

使用 `-v` 或 `--volume` 选项来定义数据卷的挂载

`docker run -d --name webapp -v /webapp/storage webapp:latest`

也可以通过 `-v <name>:<container-path>` 这种形式来命名数据卷。

`docker run -d --name webapp -v appdata:/webapp/storage webapp:latest`

`-v` 选项既承载了 Bind Mount 的定义，又参与了 Volume 的定义，所以其传参方式需要特别留意。前面提到了，`-v` 在定义绑定挂载时必须使用绝对路径，其目的主要是为了避免与数据卷挂载中命名这种形式的冲突。

### 共用数据卷

`docker run -d --name webapp -v html:/webapp/html webapp:latest`

`docker run -d --name nginx -v html:/usr/share/nginx/html:ro nginx:1.12`

通过 `docker volume create` 我们可以不依赖于容器独立创建数据卷。

`docker volume create appdata`

通过 `docker volume ls` 可以列出当前已创建的数据卷

### 删除数据卷

`docker volume rm` 来删除指定的数据卷

在 `docker rm` 删除容器的命令中，我们可以通过增加 `-v` 选项来删除容器关联的数据卷。

`docker volume prune` 删除那些没有被容器引用的数据卷

## 数据卷容器

`docker create --name appdata -v /webapp/storage ubuntu`

使用数据卷容器时通过对它的引用来完成对数据卷的引用。

创建新容器时使用专门的 `--volumes-from` 选项。

`docker run -d --name webapp --volumes-from appdata webapp:latest`

### 备份和迁移数据卷

要备份数据，我们先建立一个临时的容器，将用于备份的目录和要备份的数据卷都挂载到这个容器上。

使用 `/backup`

`docker run --rm --volumes-from appdata -v /backup:/backup ubuntu tar cvf /backup/backup.tar /webapp/storage`

恢复数据卷中的数据

`docker run --rm --volumes-from appdata -v /backup:/backup ubuntu tar xvf /backup/backup.tar -C /webapp/storage --strip`

## 另一个挂载选项

通过 `--mount` 这个选项配置挂载

`docker run -d --name webapp webapp:latest --mount 'type=volume,src=appdata,dst=/webapp/storage,volume-driver=local,volume-opt=type=nfs,volume-opt=device=<nfs-server>:<nfs-path>' webapp:latest`

在 `--mount` 中，我们可以通过逗号分隔这种 CSV 格式来定义多个参数。其中，通过 type 我们可以定义挂载类型，其值可以是：bind，volume 或 tmpfs。另外，`--mount` 选项能够帮助我们实现集群挂载的定义

# 保存和共享镜像

容器修改的内容保存为镜像的命令是 `docker commit`

`docker commit webapp`

### 为镜像命名

`docker tag` e.g.`docker tag 0bc42f7ff218 webapp:1.0`

对已有镜像命名：

`docker tag webapp:1.0 webapp:latest`

直接在 commit 时命名：

`docker commit -m "Upgrade" webapp webapp：2.0`

## 镜像的迁移

`docker save` 命令可以将镜像输出

`docker save webapp:1.0 > webapp-1.0.tar`

-o 选项，用来指定输出文件

`docker save -o ./webapp-1.0.tar webapp:1.0`

### 导入镜像

`docker load < webapp-1.0.tar`

`-i` 选项指定输入文件

`docker load -i webapp-1.0.tar`

### 批量迁移

`docker save -o ./images.tar webapp:1.0 nginx:1.12 mysql:5.7`

## 导出和导入容器

`docker export` 命令我们可以直接导出容器： `docker commit` 与 `docker save` 的结合体

`docker export -o ./webapp.tar webapp`

使用 `docker import` 导入。导入的结果其实是一个镜像，而不是容器。

`docker import ./webapp.tar webapp:1.0`

# 通过 Dockerfile 创建镜像

## 关于 Dockerfile

Dockerfile 是 Docker 中用于定义镜像自动化构建流程的配置文件

## 常见 Dockerfile 指令

### FROM

通过 FROM 指令指定一个基础镜像，接下来所有的指令都是基于这个镜像所展开的

```CSS
FROM <image> [AS <name>]
FROM <image>[:<tag>] [AS <name>]
FROM <image>[@<digest>] [AS <name>]
```

### RUN

用于向控制台发送命令的指令

```text
RUN <command>
RUN ["executable", "param1", "param2"]
```

RUN 指令是支持 \ 换行的

### ENTRYPOINT 和 CMD

基于镜像启动的容器，在容器启动时会根据镜像所定义的一条命令来启动容器中进程号为 1 的进程

```CSS
ENTRYPOINT ["executable", "param1", "param2"]
ENTRYPOINT command param1 param2

CMD ["executable","param1","param2"]
CMD ["param1","param2"]
CMD command param1 param2
```

当 ENTRYPOINT 与 CMD 同时给出时，CMD 中的内容会作为 ENTRYPOINT 定义命令的参数，最终执行容器启动的还是 ENTRYPOINT 中给出的命令。

### EXPOSE

为镜像指定要暴露的端口

`EXPOSE <port> [<port>/<protocol>...]`

### VOLUME

定义基于此镜像的容器所自动建立的数据卷

`VOLUME ["/data"]`

### COPY 和 ADD

直接从宿主机的文件系统里拷贝内容到镜像里的文件系统中

```CSS
COPY [--chown=<user>:<group>] <src>... <dest>
ADD [--chown=<user>:<group>] <src>... <dest>

COPY [--chown=<user>:<group>] ["<src>",... "<dest>"]
ADD [--chown=<user>:<group>] ["<src>",... "<dest>"]
```

两者的区别主要在于 ADD 能够支持使用网络端的 URL 地址作为 src 源，并且在源文件被识别为压缩包时，自动进行解压，而 COPY 没有这两个能力

## 构建镜像

`docker build` `docker build ./webapp`

`docker build` 可以接收一个参数，需要特别注意的是，这个参数为一个目录路径 ( 本地路径或 URL 路径 )

在默认情况下，`docker build` 也会从这个目录下寻找名为 Dockerfile 的文件，将它作为 Dockerfile 内容的来源

如果我们的 Dockerfile 文件路径不在这个目录下，或者有另外的文件名，我们可以通过 `-f` 选项单独给出 Dockerfile 文件的路径

`docker build -t webapp:latest -f ./webapp/a.Dockerfile ./webapp`

`-t` 选项，用它来指定新生成镜像的名称

# 常见 Dockerfile 使用技巧

## 构建中使用变量

用 ARG 指令来建立一个参数变量

```text
FROM debian:stretch-slim

## ......

ARG TOMCAT_MAJOR
ARG TOMCAT_VERSION

## ......

RUN wget -O tomcat.tar.gz "https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz"

## ......
```

在构建时通过 `docker build` 的 `--build-arg` 选项来设置参数变量

`docker build --build-arg TOMCAT_MAJOR=8 --build-arg TOMCAT_VERSION=8.0.53 -t tomcat:8.0 ./tomcat`

### 环境变量

环境变量的定义是通过 ENV 这个指令来完成的

```text
FROM debian:stretch-slim

## ......

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.53

## ......

RUN wget -O tomcat.tar.gz "https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz"
```

创建容器时使用 `-e` 或是 `--env` 选项，可以对环境变量的值进行修改或定义新的环境变量

`docker run -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:5.7`

ENV 指令所定义的变量，永远会覆盖 ARG 所定义的变量，即使它们定时的顺序是相反的。

## 合并命令

```SQL
RUN apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps; \
    rm -rf /var/lib/apt/lists/*;
```

### 构建缓存

不希望 Docker 在构建镜像时使用构建缓存，这时我们可以通过 `--no-cache` 选项来禁用它

`docker build --no-cache ./webapp`

## 搭配 ENTRYPOINT 和 CMD

用来指定基于此镜像所创建容器里主进程的启动命令的

两个指令的区别在于，ENTRYPOINT 指令的优先级高于 CMD 指令。

ENTRYPOINT 指令主要用于对容器进行一些初始化，而 CMD 指令则用于真正定义容器中主程序的启动命令

# 使用 Docker Compose 管理容器

### Docker Compose

将多个容器运行的方式和配置固化

## 安装 Docker Compose

`pip install docker-compose`

docker desktop/Docker Toolbox 内置了，windows、mac 不用安装。

## Docker Compose 的基本使用逻辑

1.  如果需要的话，编写容器所需镜像的 Dockerfile；( 也可以使用现有的镜像 )
2.  编写用于配置容器的 docker-compose.yml；
3.  使用 docker-compose 命令启动应用。

### 编写 Docker Compose 配置

```YAML
version: '3'

services:

  webapp:
    build: ./image/webapp
    ports:
      - "5000:5000"
    volumes:
      - ./code:/code
      - logvolume:/var/log
    links:
      - mysql
      - redis

  redis:
    image: redis:3.2

  mysql:
    image: mysql:5.7
    environment:
      - MYSQL_ROOT_PASSWORD=my-secret-pw

volumes:
  logvolume: {}
```

### 启动和停止

`docker-compose up` 命令类似于 Docker Engine 中的 `docker run`

默认情况下 `docker-compose up` 会在“前台”运行，我们可以用 `-d` 选项使其“后台”运行。

`docker-compose up -d`

可以通过选项 `-f` 来修改识别的 Docker Compose 配置文件，通过 `-p` 选项来定义项目名

`docker-compose -f ./compose/docker-compose.yml -p myapp up -d`

`docker-compose down` 命令用于停止所有的容器，并将它们删除

### 容器命令

`docker logs` 查看容器中主进程的输出内容

`docker-compose logs nginx`

# 常用的 Docker Compose 配置项

## 定义服务

```YAML
version: "3"

services:

  redis:
    image: redis:3.2
    networks:
      - backend
    volumes:
      - ./redis/redis.conf:/etc/redis.conf:ro
    ports:
      - "6379:6379"
    command: ["redis-server", "/etc/redis.conf"]

  database:
    image: mysql:5.7
    networks:
      - backend
    volumes:
      - ./mysql/my.cnf:/etc/mysql/my.cnf:ro
      - mysql-data:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=my-secret-pw
    ports:
      - "3306:3306"

  webapp:
    build: ./webapp
    networks:
      - frontend
      - backend
    volumes:
      - ./webapp:/webapp
    depends_on:
      - redis
      - database

  nginx:
    image: nginx:1.12
    networks:
      - frontend
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/conf.d:/etc/nginx/conf.d:ro
      - ./webapp/html:/webapp/html
    depends_on:
      - webapp
    ports:
      - "80:80"
      - "443:443"

networks:
  frontend:
  backend:

volumes:
  mysql-data:
```

### 指定镜像

一种是通过 image 这个配置，这个相对简单，给出能在镜像仓库中找到镜像的名称即可

另外一种指定镜像的方式就是直接采用 Dockerfile 来构建镜像

在 `docker build` 里我们还能通过选项定义许多内容

```YAML
## ......
  webapp:
    build:
      context: ./webapp
      dockerfile: webapp-dockerfile
      args:
        - JAVA_VERSION=1.6
## ......
```

### 依赖声明

只有当被依赖的容器完全启动后，Docker Compose 才会创建和启动这个容器。

depends_on 这个配置项，我们只需要通过它列出这个服务所有依赖的其他服务即可

## 文件挂载

### 使用数据卷

在上面的例子里，独立于 services 的 volumes 配置就是用来声明数据卷的。

如果我们想把属于 Docker Compose 项目以外的数据卷引入进来直接使用，我们可以将数据卷定义为外部引入，通过 external 这个配置就能完成这个定义。

```YAML
## ......
volumes:
  mysql-data:
    external: true
## ......
```

在加入 external 定义后，Docker Compose 在创建项目时不会直接创建数据卷，而是优先从 Docker Engine 中已有的数据卷里寻找并直接采用。

## 配置网络

要使用网络，我们必须先声明网络。声明网络的配置同样独立于 services 存在，是位于根配置下的 networks 配置。

除了简单的声明网络名称，让 Docker Compose 自动按默认形式完成网络配置外，我们还可以显式的指定网络的参数。

```YAML
networks:
  frontend:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 10.10.1.0/24
## ......
```

### 使用网络别名

```YAML
## ......
  database:
    networks:
      backend:
        aliases:
          - backend.database
## ......
  webapp:
    networks:
      backend:
        aliases:
          - backend.webapp
      frontend:
        aliases:
          - frontend.webapp
## ......
```

### 端口映射

ports 这个配置项，它是用来定义端口映射的

由于 YAML 格式对 xx:yy 这种格式的解析有特殊性，在设置小于 60 的值时，会被当成时间而不是字符串来处理，最好使用引号将端口映射的定义包裹起来，避免歧义

# 编写 Docker Compose 项目

[youmingdot/docker-book-for-developer-samples: 《开发者必备的 Docker 实践指南》示例 (github.com)](https://github.com/youmingdot/docker-book-for-developer-samples)
