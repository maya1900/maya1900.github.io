---
title: html基础回顾
tags:
  - html
categories: html
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/377d8c3a1e47d5760609873be26e4073.png
date: 2023-01-18 13:00:00
---

![](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202302081500005.png)

1. src 和 href 的区别
   src 资源引用，下载到当前位置
   超文本引用，指向网络资源
2. 对 HTML 语义化的理解
   内容语义化和代码语义化
   利于 seo，方便阅读
   常见：header、aside、main、footer、article、section、nav
3. DOCTYPE(⽂档类型) 的作⽤
文档类型声明
告诉浏览器（解析器）应该以什么样（html 或 xhtml）的文档类型定义来解析文档
<!Doctype html>的作用：<!doctype html> 的作用就是让浏览器进入标准模式，使用最新的 HTML5 标准来解析渲染页面
4. script 标签中 defer 和 async 的区别
   都是异步加载外部 js 脚本
   多个 async 不保证顺序，多个 defer 按顺序加载
   async 加载完后立即执行，defer 等到文档所有元素解析完成之后才执行，DOMContentLoaded 事件触发执行之前
5. 常⽤的 meta 标签有哪些
   charset 编码类型
   keywords
   description
   refresh
   viewport
   content
   width
   height
   initial-scale
   maximum-scale
   minimum-scale
   user-scalable
6. html5 新特性
   语义化标签
   媒体标签
   新增表单：email、url、search、range、color、time
   web 存储：localStorage、sessionStorage
   拖拽 api
   SVG 图形
   地理定位、websocket
   history api
7. img 的 srcset 属性
   用于设置不同屏幕密度下，img 会自动加载不同的图片。
8. 行内元素有哪些？块级元素有哪些？
   span、strong、b、img、input、a、i、em
   div、h1-h6、ul、li、ol、p、dt、dd
9. 说一下 web worker
   运行在后台的 js，独立于其他脚本，不会影响页面的性能。 并且通过 postMessage 将结果回传到主线程。
10. HTML5 的离线储存
    manifest 文件在页面头部加入 manifest 属性
    在线时请求 manifest 文件内容并存储，如果已经访问使用离线资源，对比新的和旧的文件，如果不一致则更新；离线时使用离线资源。
    13. iframe 有那些优点和缺点？
    优点
    加载速度较慢的内容
    脚本并行下载
    可以跨域通信
    缺点
    阻塞主页面的 load
    不会被搜索引擎识别
    产生很多页面，不便管理
11. label 的作用是什么？
    定义表单控件的关系：当用户选择 label 标签时，浏览器会自动将焦点转到和 label 标签相关的表单控件上。
12. Canvas 和 SVG 的区别
    svg 可缩放矢量图形
    不依赖分辨率
    适合大型渲染区域的程序
    渲染速度慢
    canvas 画布，逐像素渲染
    依赖分辨率
    不支持事件处理
    适合图像密集型的游戏
13. head 标签有什么作用，其中什么标签必不可少？
    定义文档头部，title 必须
14. 渐进增强和优雅降级之间的区别
    对低版本的浏览器进行功能开发，再向高版本浏览器进行改进追加
    一开始就构建完整功能，然后对低版本浏览器进行兼容
