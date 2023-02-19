---
title: 计算机网络
tags:
  - 网络
categories: 网络
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/1d9187ba800e078b3825ff3482ce80ab.png
date: 2023-02-15 14:00:00
---

![](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/2023021532584.png)

一、HTTP 协议 1. GET 和 POST 的请求的区别
get 是幂等请求，不会对服务器资源产生影响，post 不幂等
是否缓存
发送格式
安全性
请求长度

    3. 常见的HTTP请求头和响应头
        请求头：
            Accept
            Accept-encoding
            Accept-Language
            Cookie
            Host
            User-Agent

        响应头：
            Date
            server
            Connection
            Cache-Control
            content-type
                application/x-www-form-urlencoded
                multipart/form-data
                application/json
                text/xml



    7. HTTP 1.0 和 HTTP 1.1 之间有哪些区别
        keep-alive持久连接
        缓存控制策略
        请求方法，put、option、delete
        资源请求，引入range头域，只请求某个资源

    8. HTTP 1.1 和 HTTP 2.0 的区别
        二进制协议
        多路复用
        数据流
        头部压缩
        服务器推送

    9. HTTP和HTTPS协议的区别
        https需要ca证书
        http是超文本传输协议，https是安全的ssl加密协议
        http端口80，https443
        http协议是简单无状态的，https是ssl加密、身份认证的安全协议

    11. 当在浏览器中输入 Google.com 并且按下回车之后发生了什么？
        解析url
        缓存判断
        dns解析
        获取mac地址
        tcp三次握手
        https握手
        返回数据
        页面渲染：浏览器首先会根据 html 文件构建 DOM 树，根据解析到的 css 文件构建 CSSOM 树，如果遇到 script 标签，则判端是否含有 defer 或者 async 属性，要不然 script 的加载和执行会造成页面的渲染的阻塞。当 DOM 树和 CSSOM 树建立好后，根据它们来构建渲染树。渲染树构建好后，会根据渲染树来进行布局。布局完成后，最后使用浏览器的 UI 接口对页面进行绘制。
        tcp四次挥手

    20. URL有哪些组成部分
        http://www.aspxfans.com:8080/news/index.asp?boardID=5&ID=24618&page=1#name
        协议
        域名
        端口
        虚拟目录
        文件名
        锚
        参数部分

    21. 与缓存相关的HTTP请求头有哪些
        强缓存：
            Expires
            Cache-Control

        协商缓存
            Etag、If-None-Match
            Last-Modified、If-Modified-Since


    22. webworker、ShareWorker、ServiceWorker
        webworker运行在后台的js，不会影响页面性能
        shareworker共享线程
        serviceworker服务于多个页面，可以设置离线缓存数据

三、HTTP 状态码
204No Content
206 范围请求
301 永久重定向
302 临时重定向
304Not Modified
307 临时不会 post 变 get
400Bad Request
401 未授权
403 禁止访问
404Not Found
405Method Not Allowed
500 服务器错误
504 服务超时

四、DNS 协议 1. DNS 协议是什么
DNS 是域名系统 (Domain Name System) 的缩写，提供的是一种主机名到 IP 地址的转换服务

    3. DNS完整的查询过程
        浏览器缓存中查找
        请求发送本地dns服务器
        本地向根域名服务器
        本地向顶级
        本地向权威
        本地拿到结果保存在缓存
        本地将结果返回给浏览器

五、网络模型
OSI 七层模型
应用层
表示层
会话层
传输层
网络层
数据链路层
物理层

    TCP/IP五层协议
        应传网数物

六、TCP 与 UDP 1. TCP 和 UDP 的概念
UDP
无连接
单播、多播、广播
面向报文
不可靠性
头部开销小，传输高效

        TCP
            面向连接
            单播
            面向字节流
            拥塞机制
            全双工通信


    10. TCP粘包是怎么回事
        默认情况下, TCP 连接会启⽤延迟传送算法 (Nagle 算法), 在数据发送之前缓存他们. 如果短时间有多个数据发送, 会缓冲到⼀起作⼀次发送 (缓冲⼤⼩⻅ socket.bufferSize ), 这样可以减少 IO 消耗提⾼性能.
        解决方法
            间隔等待时间
            关闭Nagle算法
            进行封包、拆包

七、WebSocket 1. 对 WebSocket 的理解
服务器可以向客户端主动推动消息，客户端也可以主动向服务器推送消息。
客户端向 WebSocket 服务器通知（notify）一个带有所有接收者 ID（recipients IDs）的事件（event），服务器接收后立即通知所有活跃的（active）客户端，只有 ID 在接收者 ID 序列中的客户端才会处理这个事件。

    短轮询、长轮询、SSE 和 WebSocket 
        短轮询：浏览器每隔一段时间向浏览器发送 http 请求，服务器端在收到请求后，不论是否有数据更新，都直接进行响应。
        长轮询：客户端向服务器发起请求，当服务器收到客户端发来的请求后，服务器端不会直接进行响应，而是先将这个请求挂起，然后判断服务器端数据是否有更新。如果有更新，则进行响应，如果一直没有数据，则到达一定的时间限制才返回。
        SSE：服务器使用流信息向服务器推送信息，如视频
        ws全双工协议，通信双方是平等的，可以相互发送消息
