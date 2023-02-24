---
title: 性能优化部分
tags:
  - js
categories: js
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/107dd012176e5347dade6a2e4663e820.png
date: 2023-02-11 14:00:00
---

![](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202302111552089.png)

CDN 1. CDN 的概念
内容分发网络，通过互联网互相连接的电脑网络系统，利用最靠近每位用户的服务器，更快、更可靠地将音乐、图片、视频、应用程序及其他文件发送给用户，来提供高性能。
部分组成：
分发服务系统
负载均衡系统
运营管理系统
cdn 的作用：
用户内容加载更快
减少服务器的负载
防御 DDOS 攻击
cdn 的原理：
点击的 url，本地 dns 解析发现是 cdn 专用 dns 服务器，dns 系统将域名解析权交给 cName 指向的 dns 服务器
cdn 专用 dns 服务器将 cdn 负载均衡设备 ip 地址返回给用户
用户向负载均衡设备发起请求
全局负载均衡设备根据用户地址和内容 url，选择一台用户所属区域的区域负载均衡设备，
区域负载均衡设备选择一台合适的缓存服务器来提供服务，将缓存服务器 ip 返回给全局负载均衡设备
全局负载把服务器 ip 返回给用户
用户向这个缓存服务器发起请求，缓存服务器返回内容。
二、懒加载 3. 懒加载的实现原理
使用 HTML5 的 data-xxx 属性来储存图片的路径，在需要加载图片的时候，将 data-xxx 中图片的路径赋值给 src，这样就实现了图片的按需加载
元素顶部距离文档顶部的高度 offsetTop < 浏览器滚动的过的距离 scrollTop + 浏览器可视区的高度 innerHeight 4. 懒加载与预加载的区别
一个是提前加载，一个是迟缓甚至不加载。懒加载对服务器前端有一定的缓解压力作用，预加载则会增加服务器前端压力。
预加载能够减少用户的等待时间，提高用户的体验
三、回流与重绘
回流：当渲染树中部分或者全部元素的尺寸、结构或者属性发生变化时，浏览器会重新渲染部分或者全部文档的过程就称为回流。
重绘：当页面中某些元素的样式发生变化，但是不会影响其在文档流中的位置时，浏览器就会对元素进行重新绘制，这个过程就是重绘。 4. documentFragment 是什么？
一个轻量版的 Document 使用，不是真实 DOM 树的一部分，它的变化不会触发 DOM 树的重新渲染，且不会导致性能等问题。
在频繁的 DOM 操作时，我们就可以将 DOM 元素插入 DocumentFragment，之后一次性的将所有的子孙节点插入文档中，提高性能
四、节流与防抖
五、图片优化 1. 如何对项目中的图片进行优化？
不用图片使用 css
使用 cdn 加载
小图使用 base64 格式
雪碧图 2. 常见的图片格式
png、jpg、gif、bmp、webp、svg、avif、apng
六、Webpack 优化 1. 如何提⾼ webpack 的打包速度
优化 loader：搜索范围、缓存
threader 多线程
Dllplugin 可以将特定的类库提前打包然后引入
代码压缩 uglify 2. 如何减少 Webpack 打包体积
按需加载
treeshaking
提取公共第三方库
cdn 加速
代码分割 split 4. 如何提⾼ webpack 的构建速度？
多入口使⽤ CommonsChunkPlugin 来提取公共代码
通过 externals 配置来提取常⽤库
利⽤ DllPlugin 
多线程
提升 uglifyplugin 压缩
tree-shaking
vue 优化
代码层面优化
v-if 和 v-show 区分
computed 和 watch 区分
v-for 加 key
长列表优化：Ojbect.freeeze()
事件销毁
防抖节流
图片、路由懒加载
webpack 优化
thread-loader 多线程
缓存：terserPlugin，babel-load 开启缓存
sourcemap 优化
提取公共代码：splitChunks
使用分析工具：webpack-bundle-analyzer
web 技术优化
gzip 压缩
浏览器缓存
http2
cdn
preload(优先级高，加载必须资源)、prefetch(加载其他资源)
使用 chrome performance
首屏优化：
合理利用浏览器缓存：使用浏览器缓存可以减少服务器的请求次数，从而提升首屏加载速度。
按需加载：只加载用户需要的内容，减少不必要的资源加载，提高首屏加载速度。
压缩资源：对图片和 CSS、JS 进行压缩可以减少资源大小，从而提升首屏加载速度。
使用 CDN：使用 CDN 加速，可以减少服务器响应时间，从而提升首屏加载速度。
减少 HTTP 请求：尽量减少 HTTP 请求次数，从而提升首屏加载速度。
使用 SSR
