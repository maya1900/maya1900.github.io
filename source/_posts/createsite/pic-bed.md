---
title: github+picgo+jsDelivr做图床
tags:
  - github
  - picgo
  - jsDelivr
  - 图床
categories: 博客
abbrlink: f34089d7
date: 2021-05-04 23:06:00
cover:
---

## 前言

开始写博客就需要上图了，把图片与文章放一起也不太好，再者对于免费的图床也不踏实，于是在参考了各路大神之后还是觉得这个方法比较好一些，特此记录。

## 一、github 部分

1. 不用多说新建一个仓库，起个名字，比如 pic：
2. settings--develper settings--personal access tokens,新建一个 token,只需要给上面的权限：
   ![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/20210504231326.png)

## 二、picgo 部分

1. 下载 picgo，https://picgo.github.io/PicGo-Doc/zh/guide/
2. 打开 picgo,选 github 图床，配置按它的提示就好，自定义域名先空(下面讲)：
   ![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/20210504232113.png)
3. picgo 的插件按需取：
   ![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/20210504232442.png)

## 三、jsDelivr 部分

自定义域名，这里使用 jsDelivr，因为它能加速 github 里的文件，填写如下：

```javascript
https://cdn.jsdelivr.net/gh/用户名/仓库名@master
```

好，这样就成功了，测试：
![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/QQ20210504-2347061.gif)
