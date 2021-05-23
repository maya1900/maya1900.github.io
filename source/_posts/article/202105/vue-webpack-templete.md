---
title: 手动搭建vue开发环境
tags:
  - vue
  - 搭建
  - wepack
categories: vue
cover:
date: 2021-05-21
---

## 前言

根据[面试官：自己搭建过 vue 开发环境吗？](https://juejin.cn/post/6844903833160646663#heading-15) 这么一篇文章，于是自己开始动手一遍，发生了非常多的问题，同时也意识到 webpack 的学习还不够，准备写完这个后，再来深入学习一遍 webpack。

## 步骤

1. 初始化项目
2. 配置项目功能
   1. es6 转 es5
   2. scss 转 css
   3. postcss 添加后缀
   4. html-webpack-plugin 自动引入 js
   5. 配置 devServer 热更新
   6. 配置资源打包
3. 识别.vue 文件
4. 定义环境变量
5. 区分生产环境/开发环境
6. 集成 vue-router
7. 集成 vuex

这里主要就是照着博主的文章敲了一遍代码，整理下思路，主要写点遇到的问题。

## 版本

webpack 最大的问题就是版本问题，插件与 webpack 版本不匹配出现的错误也是使用 webpack 最多的，没有之一，故先列出本次使用版本。

```javascript
	// 使用版本
    "webpack": "^5.37.0",
    "webpack-cli": "^4.7.0",
    "webpack-dev-server": "^3.11.2",
```

## 遇到的问题

### 1. TypeError: webpack.NamedModulesPlugin is not a constructor

![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/Snipaste_2021-05-16_18-08-08.png)

- 原因：在 webpack5.x 中，webpack.NamedModulesPlugin 的功能已经内置

- 解决：删除 new webpack.NamedModulesPlugin(),

### 2. cache-loader 安装不上

![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/Snipaste_2021-05-16_18-09-41.png)

- 原因：版本问题，不兼容
- 解决：如提示的，安装时添加--legacy-peer-deps 选项(忽略依赖包上的对等依赖)

### 3. @intervolga/optimize-cssnano-plugin 安装不上

![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/Snipaste_2021-05-16_18-15-28.png)

- 原因同上
- 解决同上

### 4. wepack-dev-server 出错：Error: Cannot find module 'webpack-cli/bin/config-yargs'

![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/Snipaste_2021-05-16_18-51-20.png)

- 原因：webpack-dev-server 升级，与 webpack 不兼容
- 解决：二选一。
  - 1.  降 webpack-dev-server 版本到 3.3.12
  - 2.  修改启动方式：dev: webpack serve ...

### 5. TypeError: merge is not a function

![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/Snipaste_2021-05-16_19-06-50.png)

- 原因：webpack-merge 版本升级，修改了 merge 方法
- 解决：原本是直接使用，现在是方法使用 xxx.merge()

### 6. Invalid configuration object

![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/Snipaste_2021-05-16_19-12-15.png)

- 原因：webpack-cli 升级，devtool 属性值发生变化
- 解决：devtool: 'eval-cheap-module-source-map', 其他属性值见[webpack5 的的官网](https://webpack.js.org/configuration/devtool/)

### 7. options[0] missing the property 'patterns' . Should be:...

![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/Snipaste_2021-05-16_19-19-20.png)

- 原因：版本升级，CopyWebpackPlugin 的配置方法变化。
- 解决：参见[wepack 官网](https://webpack.js.org/plugins/copy-webpack-plugin/#root)，把原来的写法修改为：`new CopyWebpackPlugin({ patterns: [ { from: path.resolve(__dirname, '../public'), to: path.resolve(__dirname, '../dist') } ] }),`

### 8. Error in Conflict: Multiple assets emit different content to the same filename index.html

![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/Snipaste_2021-05-20_23-22-12.png)

- 这个问题是在 npm run build 时发生的，找了大半天， 问题没解决额，也就是说，只有 dev 成功，一直没 build 成功.....
- 哪位大神看到了，还请给看看 T_T...

## 练习 demo

[vue-webpack-templete](https://github.com/maya1900/vue-webpack-demo)

## 参考：

- [百度](baidu.com)
- [webpack 官网](https://webpack.js.org/)
