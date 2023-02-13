---
title: 知识广度
tags:
  - js
categories: js
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/2462401306aa800a3a5910d9c921956a.png
date: 2023-02-13 14:00:00
---

# Retina 屏 1px 像素问题，如何实现

- 使用transform缩小

如果有 `border-radius` 怎么办？可以使用 `box-shadow` 设置`box-shadow: 0 0 0 0.5px #d9d9d9`

## cookie 和 token 有何区别

cookie是http规范的浏览器缓存，可作为本地存储，有跨域限制，可以配合session实现登录。

token自定义标准，不在本地存储，无跨域限制，可以用于jwt登录

session：用户登录后服务器根据信息生成session保存，返回浏览器sessionid，以后发送请求将sessionid存储在cookie中发送

token：用户登录，后端验证成功返回token字符串，前端获取token储存，以后访问都在header里带上这段token。

session：原理简单，可以快速封禁某个登录用户；占用服务器内存，多进程不好同步

jwt：不占服务器内存、多进程不受限制，没有跨域问题，无法快速封禁登录用户。

单点登录：

登录系统1发现未登录，跳转sso登录系统，url携带系统1的地址，用户登录成功，保存cookie，带着token令牌跳转系统1，系统1校验令牌，有效返回受保护资源。系统2发现未登录，跳转sso登录系统，发现cookie，直接返回系统2，系统2校验token有效返回受保护资源。

系统1向sso发起注销，sso校验令牌有效销毁cookie，同时向所有注册系统发起注销请求，sso系统引导用户至登录页面。

OAuth2.0

OAuth 的核心就是向第三方应用颁发令牌，开放授权协议

## HTTP 和 UDP 有何区别

http在应用层，tcp和udp在传输层

http有连接的、可靠的，udp是无连接的、不可靠的

### **连环问：http 1.0 1.1 2.0 区别**

http 1.0 最基础的 http 协议

http1.1：

- 引入更多缓存策略ETag、cache-control
- 长连接keep-alive
- 增加新的方法：put、delete

http2.0

- 二进制协议
- 头部压缩
- 多路复用
- 服务器推送

## **https 中间人攻击**

http 是明文传输，传输的所有内容（如登录的用户名和密码），都会被中间的代理商（无论合法还是非法）获取到。

中间人攻击，就是黑客劫持网络请求，伪造 CA 证书。

解决方案：使用浏览器可识别的，正规厂商的证书（如阿里云），慎用免费证书。

## 前端攻击

- xss
- csrf
- 点击劫持
- DDOS
- sql注入

点击劫持：黑客在自己的网站，使用隐藏的 `<iframe>` 嵌入其他网页，诱导用户按顺序点击。增加 http header `X-Frame-Options:SAMEORIGIN` ，让 `<iframe>` 只能加载同域名的网页。

DDOS：分布式拒绝服务。向一个域名或者 IP 发送大规模恶意网络请求。只能选用商用防火墙。

防止sql注入：特殊字符替换。

## webSocket 和 http 协议有何区别？有和应用场景？

场景：消息通知，直播讨论区，聊天室，协同编辑

先发起一个 http 请求，根服务端建立连接。连接成功之后再升级为 webSocket 协议，然后再通讯。

区别：

- 协议名称不同
- http只能客户端发起请求，ws可以双端发起请求
- ws没有跨域限制
- ws使用send和onmessage进行通讯，http使用req和res通讯。

ws和长轮询的区别？

http长轮询：发起http请求，server不立即返回，等待有结果在返回，期间tcp连接不关闭，阻塞式

ws：发起一次请求完毕，连接关闭，非阻塞。

## **输入 url 到页面展示**

- 离线缓存
- dns解析，获得ip
- http三次握手
- 发送请求
- 接受内容，解析网页内容

## **网页多标签页之间的通讯**

- websocket，无跨域限制
- localStorage监听
- SharedWorker

**iframe 通讯？**

使用window.postMessage

## **koa2 洋葱模型**

app.use() 把中间件函数存储在`middleware`数组中，最终会调用`koa-compose`导出的函数`compose`返回一个`promise`，中间函数的第一个参数`ctx`是包含响应和请求的一个对象，会不断传递给下一个中间件。`next`是一个函数，返回的是一个`promise`。

中间件链错误会由`ctx.onerror`捕获

`co`的原理是通过不断调用`generator`函数的`next`方法来达到自动执行`generator`函数的，类似`async、await`函数自动执行。

## **为何需要 nodejs**

nodejs 有一定的技术优势，但它真正的优势在于使用 JS 语法，前端工程师学习成本低，能提高研发效率。
