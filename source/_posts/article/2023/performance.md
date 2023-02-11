---
title: 性能优化部分
tags:
  - js
categories: js
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/107dd012176e5347dade6a2e4663e820.png
date: 2023-02-11 14:00:00
---

![](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202302111552089.png)

CDN
    1. CDN的概念
        内容分发网络，通过互联网互相连接的电脑网络系统，利用最靠近每位用户的服务器，更快、更可靠地将音乐、图片、视频、应用程序及其他文件发送给用户，来提供高性能。
        部分组成：
            分发服务系统
            负载均衡系统
            运营管理系统
        cdn的作用：
            用户内容加载更快
            减少服务器的负载
            防御DDOS攻击
        cdn的原理：
            点击的url，本地dns解析发现是cdn专用dns服务器，dns系统将域名解析权交给cName指向的dns服务器
            cdn专用dns服务器将cdn负载均衡设备ip地址返回给用户
            用户向负载均衡设备发起请求
            全局负载均衡设备根据用户地址和内容url，选择一台用户所属区域的区域负载均衡设备，
            区域负载均衡设备选择一台合适的缓存服务器来提供服务，将缓存服务器ip返回给全局负载均衡设备
            全局负载把服务器ip返回给用户
            用户向这个缓存服务器发起请求，缓存服务器返回内容。
二、懒加载
    3. 懒加载的实现原理
        使用HTML5 的data-xxx属性来储存图片的路径，在需要加载图片的时候，将data-xxx中图片的路径赋值给src，这样就实现了图片的按需加载
        元素顶部距离文档顶部的高度offsetTop < 浏览器滚动的过的距离scrollTop + 浏览器可视区的高度innerHeight
    4. 懒加载与预加载的区别
        一个是提前加载，一个是迟缓甚至不加载。懒加载对服务器前端有一定的缓解压力作用，预加载则会增加服务器前端压力。
        预加载能够减少用户的等待时间，提高用户的体验
三、回流与重绘
    回流：当渲染树中部分或者全部元素的尺寸、结构或者属性发生变化时，浏览器会重新渲染部分或者全部文档的过程就称为回流。
    重绘：当页面中某些元素的样式发生变化，但是不会影响其在文档流中的位置时，浏览器就会对元素进行重新绘制，这个过程就是重绘。
    4. documentFragment 是什么？
        一个轻量版的 Document使用，不是真实 DOM 树的一部分，它的变化不会触发 DOM 树的重新渲染，且不会导致性能等问题。
        在频繁的DOM操作时，我们就可以将DOM元素插入DocumentFragment，之后一次性的将所有的子孙节点插入文档中，提高性能
四、节流与防抖
五、图片优化
    1. 如何对项目中的图片进行优化？
        不用图片使用css
        使用cdn加载
        小图使用base64格式
        雪碧图
    2. 常见的图片格式
        png、jpg、gif、bmp、webp、svg、avif、apng
六、Webpack优化
    1. 如何提⾼webpack的打包速度
        优化loader：搜索范围、缓存
        threader多线程
        Dllplugin可以将特定的类库提前打包然后引入
        代码压缩uglify
    2. 如何减少 Webpack 打包体积
        按需加载
        treeshaking
        提取公共第三方库
        cdn加速
        代码分割split
    4. 如何提⾼webpack的构建速度？
        多入口使⽤ CommonsChunkPlugin 来提取公共代码
        通过 externals 配置来提取常⽤库
        利⽤ DllPlugin 
        多线程
        提升uglifyplugin压缩
        tree-shaking
vue优化
    代码层面优化
        v-if和v-show区分
        computed和watch区分
        v-for加key
        长列表优化：Ojbect.freeeze()
        事件销毁
        防抖节流
        图片、路由懒加载
    webpack优化
        thread-loader多线程
        缓存：terserPlugin，babel-load开启缓存
        sourcemap优化
        提取公共代码：splitChunks
        使用分析工具：webpack-bundle-analyzer
    web技术优化
        gzip压缩
        浏览器缓存
        http2
        cdn
        preload(优先级高，加载必须资源)、prefetch(加载其他资源)
        使用chrome performance
