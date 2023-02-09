---
title: 知识深度理解
tags:
  - js
categories: js
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/team-lily-bug.png
date: 2023-02-09 18:00:00
---

## js 内存泄露？

正常情况下，一个函数执行完其中的变量会被 js 垃圾回收。

但是在某些情况下变量销毁不了，比如：引用到了全局变量、闭包等。

早期的垃圾回收算法使用数据是否被引用来判断要不要回收：对象被变量引用，当对象没有被任何变量引用时会被回收，但是这样会有循环引用的问题。

（循环引用：对象内属性引用了另一个对象，另一个对象的属性又引用了当前对象）

现代浏览器使用标记-清除算法，根据“是否可获得”来判断是否回收：定期从根（即全局变量）开始向下寻找，能找到的保留，找不到的回收。

可以使用 Chrome devtools Performance 来检测内存变化。

闭包是内存泄露吗？

不是，闭包数据是不能被垃圾回收机制回收。因为它是符合开发者的预期的，本身就是这么设计的，而内存泄露是非预期的。

内存泄露的场景：

- 全局变量、函数
- 全局事件
- 全局定时器
- 自定义事件
- 闭包

WeakMap、WeakSet 弱引用，不会影响垃圾回收。wangEditor 多次销毁创建

## 浏览器和 nodejs 事件循环的区别

js 是单线程的，浏览器中 js 和 Dom 渲染线程互斥。

浏览器：

先执行主线程的同步任务，遇到异步任务放到任务队列里，当同步任务执行完后，异步任务有了结果放到主线程来执行。

异步任务分为宏任务和微任务，浏览器的宏任务主要有 setTimeout、网络请求等，微任务有 promise，先执行微任务，再执行宏任务。

nodejs：

nodejs 也是先执行宏任务，在执行微任务。nodejs 的宏任务主要有 setTimeout、setInterval；setImmediate、I/O 操作、Socker 连接；微任务主要有：promise、async、await、process.nextTick

nodejs 吧宏任务分了六种类型按照顺序来执行：

- timers 计时器
- I/O cb
- idle
- poll 轮询
- check 检查
- close cb

执行过程：

先执行同步代码，再执行 promise.nextTick 和微任务，然后按顺序执行 6 个类型的宏任务，每个宏任务执行前先检查有没有微任务，有的话就执行。

最新版 nodejs 不推荐使用 process.nextTick，使用 setImmediate 代替，因为 nextTick 是立即执行，会阻断 IO，setImmedite 更像是 setTimeout(fun,0)

## vdom 真的很快吗？

vue、react 的真正价值在于数据视图分离，数据驱动视图！开发者只需要关注业务数据，不用实时修改 dom。

vdom，用 js 对象来模拟 dom 数据、react 的 jsx 和 vue 的模板都是语法糖，本质上都是 render 函数。执行 render 返回一个 vdom 对象。

每次数据更新 render 都会生成 newVnode，然后对比 diff 算法，计算需要修改的 dom 节点，再修改 dom。

直接修改 dom 永远是最快的，但是在业务复杂时会导致许多无用的 dom 操作，dom 操作昂贵，相比之下 vdom 使用 js 运算，计算快，数据驱动视图可以精准操作 dom，成为了一个更优的选择。

svelte 它将组件修改编译为更精准的 dom 操作，设计思路不一样

# for 和 forEach 哪个快？

for 快。for 直接在当前函数中执行，forEach 每次都要创建一个函数，函数有单独的作用域和上下文，耗时更久。

但 forEach 的可读性高。

## nodejs 开启多进程？

进程：cpu 资源分配的基本单位，每个进程都有自己独立的内存区域，进程之间无法直接访问数据，通过进程通讯。

线程：cpu 运算调度的最小单位，一个进程可以有多个线程，线程之间可以共用进程数据。

执行一个 nodejs 文件就开启了一个进程。

服务器是多核 cpu，适合处理多进程，多进程才能充分利用服务器内存。

### 进程创建的四种方式

- child_process.spawn()：适用于返回大量数据
  ```jsx
  const spawn = require('child_process').spawn;
  const child = spawn('ls', ['-l'], { cwd: '/usr' });
  child.stdout.pipe(process.stdout);
  console.log(process.pid, child.pid);
  ```
- child_process.exec()：执行命令，有回调函数获知进程情况，可设置超时
  ```jsx
  const exec = require('child_process').exec;
  exec(`node -v`, (err, stdout, stderr) => {
    console.log({ err, stdout, stderr });
    // { err: null, stdout: 'v16.14.2\n', stderr: '' }
  });
  ```
- child_process.execFile()：执行可执行文件
  ```jsx
  const execFile = require('child_process').execFile;
  execFile('node', ['-v'], (error, stdout, stderr) => {
    console.log({ error, stdout, stderr });
  });
  ```
- child_process.fork()：执行 js 文件，衍生新的进程，每个进程都有自己的实例、内存
  ```jsx
  const fork = require('child_process').fork;
  fork('./worker.js');
  ```

传递消息：使用 send、on 传递消息。

nodejs 可使用 pm2 还开启多进程、进程守护。

## js-bridge 原理

JS 无法直接调用 app 的 API ，需要通过一种方式 —— 通称 js-bridge ，它也是一些 JS 代码。

- 注入 api
- 劫持 url scheme，自定义协议，`chrome://dino`
- 封装 sdk

## 是否了解过 requestIdleCallback ？

React 16 内部使用 Fiber ，即组件渲染过程可以暂停，先去执行高优任务，CPU 闲置时再继续渲染。其中用到的核心 API 就是 requestIdleCallback

**requestAnimationFrame 每次渲染都执行，高优，**

requestIdleCallback 会在网页渲染完成后，CPU 空闲时执行，不一定每一帧都执行。用于低优先级的任务处理

## Vue React diff 算法有什么区别

diff 算法优化：

- 只比较同一层级，不跨级比较
- tag 不同则删掉重建
- 子节点通过 key 区分

把时间复杂度将到了 O(n)

React diff：仅右移，不向左移动，右移之后，之前自然左移；

vue2 diff：双端比较，定义四个指针分别比较。

vue3 diff：最长递增子序列

## Vue-router 模式

- `mode: 'hash'` 替换为 `createWebHashHistory()`
- `mode: 'history'` 替换为 `createWebHistory()`
- `mode: 'abstract'` 替换为 `createMemoryHistory()`

window.onhashchange

`history.pushState`

abstract - 不修改 url ，路由地址在内存中，**但页面刷新会重新回到首页**。
