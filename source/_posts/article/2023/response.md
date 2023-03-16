---
title: 关于响应式布局
tags:
  - css
categories: css
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/5836a17eb9e7f5c4e2974b18f79717c0.png
date: 2023-02-16 16:00:00
---

## PC 端

### rem 布局

rem 单位是相对于根元素的 html 字体大小来决定的，只需要根据视图容器的大小，动态的改变根元素的字体大小即可。

可以将视图容器分为 10 分，font-size 用十分之一来表示，最后在 header 标签中执行这段代码，就可以动态定义 font-size 的大小。

使用 px2rem 插件去处理单位换算

### flex 布局

flex 布局能解决大多数情况下的响应式布局问题，但是对于一些特殊的场景，比如由于宽度缩小但是字体大小没有变化，这样就出现了问题。

## vw、vh 布局

vw 表示视图窗口宽度，vh 表示视图窗口高度。

单位换算也是使用 postcss-px-to-viewport 插件进行转化。

### 百分比布局

### 媒体查询

## 移动端

### 1. rem + pxtorem

### 2. vh+vw
