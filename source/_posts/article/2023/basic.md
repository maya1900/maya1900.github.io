---
title: 基础知识巩固
tags:
  - js
categories: js
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/dribbble%20(1).png
date: 2023-02-07 09:00:12
---

## Ajax、Fetch 和 Axios 的区别

Ajax：Asynchronous Javascript and XML，js 的异步请求，使用 XMLHttpRequest 底层 api

fetch：浏览器原生 es6 新标准，语法简洁，支持 Promise，对 400、500 都当成成功的请求

axios：是第三方库，支持 promise，ajax 的封装

## 防抖和节流的区别

防抖：多次执行事件变为最后一次执行

```jsx
function debounce(fn, delay) {
  let timer;
  return function () {
    if (timer) clearTimeout(timer);
    timer = setTimeout(() => {
      fn.apply(this, arguments);
    }, delay);
  };
}
```

场景：

- 输入框查询
- 按钮提交
- 结果式，一次调用

节流：每隔一段时间调用一次函数

```jsx
function throttle(fn, delay) {
  const preTime = Date.now();
  return function () {
    const curTime = Date.now();
    if (curTime - preTime >= delay) {
      preTime = Date.now();
      fn.apply(this, arguments);
    }
  };
}
```

场景：

- DOM 拖拽
- scroll 滚动
- 计算鼠标移动距离
- 过程式，需要持续一个过程，一次不够

## px % em rem vw、vh 的区别

px 像素基本单位

%相对于父元素的尺寸

em 相对于当前元素的 font-size

rem 相对于根元素的 font-size

vwvh 相对于屏幕宽度高度的 1%

## 箭头函数的缺点

1. 没有自己的 this，根据所在上下文的 this 作为自己的 this；
2. 不能作为构造函数，不可以使用 new；
3. 不能改变 this 指向；
4. 没有原型对象；

注意：class 中使用箭头函数没问题！因此 react 中可以使用箭头函数。

## 三次握手和四次挥手

三次握手：

客户端向服务器发送 syn 数据包；

服务端收到后，回传一个 syn+ack 的数据包确认信息；

客户端再向服务器发送一个 ack 的数据包，建立连接。

四次挥手：

客户端发送 fin 关闭传送，客户端进入 fin_wait_1；

服务器收到，发送 ack 给客户端，服务端进入 close_wait；

服务端再发送 fin 关闭传送，服务器进入 last_ack 状态；

客户端收到进入 time_wait 状态，发送 ack，服务器进入 closed 状态

## for…in 和 for…of 的区别

for…in 遍历一个对象的可枚举属性，如对象数组字符串，可以获得 key；

enumerable: true

for…of 遍历一个可迭代对象，如数组字符串 MapSet，可以获得 value

实现了[Symbol.iterator]方法

for awat…of：遍历异步请求的可迭代对象。

使用 promise.all 执行相同效果。

## HTMLCollection 和 NodeList

HTMLCollection 是 Element 元素的集合，NodeList 是 Node 节点的集合。

DOM 的所有节点都是 Node，包括：document、元素

文本、注释、fragment 等等。

## computed 和 watch 的区别

都是通过 Watcher 来实现的，computed 用于数据的二次处理，有缓存，data 不变缓存不失效，computed 不支持异步；

watch 用于监听已有数据的数据变化，支持异步。

methods 是简单的方法调用

## vue 组件通讯

父子：

- props、emits
- $attrs(v-bind=”attrs”向下传递)
- $parent、refs

组件上下级：

- inject、provide

跨级：

- 自定义事件
- vuex、pinia

## js 严格模式

js 设计之初的不合理不安全的地方，使用 use strict 规避问题。

- 全局变量必须声明
- 函数参数不能重名
- 禁止使用 with
- 可以创建 eval 作用域
- 禁止 this 指向全局作用域
