---
title: 项目的一些重难点
date: 2021-10-24
tags:
  - idea
categories: 其他
cover: https://z3.ax1x.com/2021/09/12/4pMp5j.jpg
---

## 前言

3 月进入公司，现在 10 月中了，很快呀，期间做了两个项目，记录下工作上的重难点，以免忘记。

项目一：

## 重点

1. 项目搭建，axios 封装，权限
2. 与后台接口请求，请求类型，get/post/put/delete，数据类型，query/body 请求体，编码类型，x-www-form-urlencoded/json
3. 前台部署，jenkins 的使用，docker/k8s 的了解
4. jsplumb 的使用，可视化流程图
5. jquery-ui 拖拽
6. 画布滚动、放大缩小，小地图导航，通过定位的方式不去控制画布大小
7. 参数自动提示 codemirror
8. d3.js 滚动缩放
9. vuex 数据的持久化存储 sessionStorage 一个插件
10. echarts 的使用，统计流程状态数量

## 难点

1. 手写树结构文件夹分类
2. 组件自己调用自己
3. 切割组件，在一个组件上的操作影响另一个上的内容
4. 通过连线传递参数
5. 线上的文字及样式 connect.getOverlay(id).setLabel(str) connect.\_jsplumb.overlays.canvas.label.cssName
6. 动态调整组件大小 自定义指令
7. 画布框选内容
8. 函数式组件的使用

## 其他小技巧

1. 使用导航做路由跳转时，path 只写到父级，然后通过重定向到目标页面，这样写的好处是只要在父级路由里，导航上的样式都在；
2. 调试的方法 console debugger vscode 断点
3. 判断数据类型 Object.prototype.toString.call()
4. clip-path（部分支持）裁剪元素形状
5. ~@代替 src

项目二：

## 重点

1. 甘特图 dhtmlx-gantt 的使用
2. gantt 左侧样式调整，不再是树型结构，修改总分结构，左右颜色根据自定义设置进行调整
3. gantt 图的封装,根据数据调整 gantt 样式
4. sort.js 元素排序

## 难点

1. 动态路由显示，导航组件封装
2. store 的封装,使用 getter 来获取 state 值
3. 使用 tabview 实现页签跳转，调整与 element 相同样式
4. 使用 monaco-editor 实现代码格式化，高亮，自定义主题，参数自定义提示
5. 实现组件间拖拽功能，参数拖入编辑器光标位置
6. 利用 vue 源码 parseHTML 方法完成表达式正确性校验
