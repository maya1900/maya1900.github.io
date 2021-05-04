---
title: vue调试的三种方法
tags:
  - vue
  - 调试
categories: vue
cover: 'https://z3.ax1x.com/2021/05/04/gnL9sO.png'
keywords:
  - vue
  - 调试
abbrlink: 4f07cdd0
date: 2021-05-04 00:00:00
---

## 一、console.log

这个开始学就会，不演示了。重要的是需要养成这样的能力，代码出了问题，光看是看不出来问题的。

## 二、debugger方法

1. vscode安装插件，debugger for chrome;
[![gnH1oR.png](https://z3.ax1x.com/2021/05/04/gnH1oR.png)](https://imgtu.com/i/gnH1oR)
2. 在代码需要打断点的位置，写上debugger(如果安装eslint可能报错，这时鼠标移到代码出现小灯泡，点击选第一项忽略即可);
[![gn7rxU.png](https://z3.ax1x.com/2021/05/04/gn7rxU.png)](https://imgtu.com/i/gn7rxU)
3. npm run serve启动，到了断点位置浏览器会停下来;
[![gnHezT.png](https://z3.ax1x.com/2021/05/04/gnHezT.png)](https://imgtu.com/i/gnHezT)
4. 在浏览器里使用步进开始调试。

## 三、vscode里断点调试

1. 在需要的位置打断点(每行行号前面)；

[![gnqM5R.png](https://z3.ax1x.com/2021/05/04/gnqM5R.png)](https://imgtu.com/i/gnqM5R)
2. 点击菜单栏--运行--启动调试，在弹出的框里选chrome，进入launch配置，配置好url，再次启动调试就打开一个调试窗口；

[![gnqaad.png](https://z3.ax1x.com/2021/05/04/gnqaad.png)](https://imgtu.com/i/gnqaad)
3. 操作到我们打断点的位置，就可以看到vscode代码运行停止到断点位置，然后我们再进行自己的代码调试。

[![gnq0PI.png](https://z3.ax1x.com/2021/05/04/gnq0PI.png)](https://imgtu.com/i/gnq0PI)
