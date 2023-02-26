---
title: 浏览器渲染流程和性能优化
tags:
  - 浏览器
  - 渲染
categories: 浏览器
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/281c3ac5c2f9a4e16854b10710a02a7c.png
date: 2023-02-26 16:00:12
---

## 浏览器中的进程

- 浏览器进程：负责界面显示、用户交互、子进程管理，同时提供存储等功能。
- 渲染进程：核心任务是将 HTML、CSS 和 JavaScript 转换为用户可以与之交互的网页。
- GPU 进程：网页、Chrome 的 UI 界面都选择采用 GPU 来绘制
- 网络进程：主要负责页面的网络资源加载。
- 插件进程：主要是负责插件的运行。

## 渲染进程中的线程

- **GUI 渲染线程：**负责渲染浏览器界面，解析 HTML，CSS，构建 DOM 树和 RenderObject 树，布局和绘制等。
- **JS 引擎线程：**也称为 JS 内核，负责解析 Javascript 脚本，运行代码。
- **事件触发线程：**归属于浏览器内核而不是 JS 引擎，用来控制事件循环
- **定时器触发线程：**setInterval 与 setTimeout 所在线程
- **异步 http 请求线程：**在 XMLHttpRequest 在连接后是通过浏览器新开一个线程请求

## 页面渲染流程

1. 构建 DOM 树
2. 构建 CSS 树
3. 合成 render 树
4. 根据渲染树来布局，计算每个节点的几何信息
5. 将各个节点绘制到屏幕上

## 进程之间的通信方式

管道通信、消息队列通信、信号量通信、共享内存通信、套接字通信

## 浏览器多个标签页之间的通信？

websocket、sharedWorker、localStorage、postMessage

## Service Workder 的理解

Service Worker 是运行在浏览器背后的**独立线程**，一般可以用来实现缓存功能。使用 Service Worker 的话，传输协议必须为  **HTTPS**。因为 Service Worker 中涉及到请求拦截，所以必须使用 HTTPS 协议来保障安全。

Service Worker 实现缓存功能一般分为三个步骤：首先需要先注册 Service Worker，然后监听到  `install`  事件以后就可以缓存需要的文件，那么在下次用户访问的时候就可以通过拦截请求的方式查询是否存在缓存，存在缓存的话就可以直接读取缓存文件，否则就去请求数据。

## 浏览器资源缓存的位置

- Service Worker
- Memory Cache 内存缓存
- Disk Cache

Disk Cache：Push Cache 是 HTTP/2 中的内容，当以上三种缓存都没有命中时，它才会被使用。\*\*并且缓存时间也很短暂，只在会话（Session）中存在，一旦会话结束就被释放

## Performance 性能指标

FP：首次绘制时间，页面第一次绘制像素的时间

FCP：首次内容绘制时间，页面第一次绘制文本、图片、非空白元素的时间

FMP：首次有效绘制时间。主要元素绘制完成时间

LCP：最大内容绘制时间

CLS：累计位移偏移。页面上非预期的位移波动。计算方式为：位移影响的面积 \* 位移距离

TTI：首次可交互时间。

FID：首次输入延迟。FCP 和 TTI 之间用户首次与页面交互时响应的延迟

TBT：阻塞总时间。FCP 到 TTI 之间所有长任务的阻塞时间总和

## 渲染优化

- 针对 js
  - js 脚本放 body 最后
  - js 延迟加载
- 针对 css
  - 使用 link 而不用 import
  - css 少可以使用内嵌
- 针对 dom、css 树
  - html 层级不要太深
  - 语义化标签
  - 减少 css 的层级
- 减少回流和重绘
  - 不使用 table 布局
  - 不频繁操作元素样式，可以修改类名
  - 使用绝对定位脱离文档流
  - 创建 documentFragment 完成所有 dom 操作
  - 设置元素 displaynone 操作完成后再回显
  - 将多个 dom 操作放在一起完成

## 如何优化关键渲染路径？

能阻塞网页首次渲染的资源称为`关键资源`，为尽快完成首次渲染，我们需要最大限度减小以下三种可变因素：

- **关键资源的数量：**可能阻止网页首次渲染的资源
- **关键路径长度**：获取所有关键资源所需的往返次数或总时间
- **关键字节的数量**：实现网页首次渲染所需的总字节数

方法有：

1. 优化 DOM：缩小文件尺寸、使用 gzip 压缩、使用缓存
2. 优化 cssDom：首屏渲染需要使用的 CSS 通过 style 标签内嵌到 head 标签中，其余 CSS 资源使用异步的方式非阻塞加载、避免使用 import
3. 异步 js
4. preload、prefetch 预加载资源

## 参考：

[浏览器渲染流程和性能优化](https://zhuanlan.zhihu.com/p/516574343)

[优化关键渲染路径](https://zhuanlan.zhihu.com/p/57752042)
