---
title: 从浏览器到堆栈
date: 2022-05-22
tags:
  - 浏览器
  - 堆栈
  - js
categories: js
cover: https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/202205050819751.gif
---

# 浏览器的理解

浏览器的功能是将用户选择的 web 资源呈现出来，需要从服务器请求资源，并将其显示到浏览器窗口中，资源的格式通常是 HTML，也包括 PDF、image 及其他格式。用户用 URI（Uniform Resource Identifier 统一资源标识符）来指定所请求资源的位置。

W3C 组织对 html 和 css 做了规范，规范中规定了浏览器解释 html 的方式，但是浏览器厂商纷纷做了扩展，并不严格遵循规范，因此出现了很多兼容性问题。

浏览器主要分为两部分：shell 和内核。shell 指浏览器的外壳，主要是提供用户界面操作；内核是浏览器的核心，是解析标记语言的程序或模块。

# 浏览器内核的理解

## 内核组成：

内核分为两部分：

- 渲染引擎：渲染浏览器窗口显示的内容，包括 html、xml 文档及图片，借助插件显示其他类型数据，如 pdf 等；
- js 引擎：用来解析和执行 javascript，实现网页的动态效果。

## 常见内核：

- Trident：IE 内核，长期不更新与 W3C 规范脱节，大量 Bug 问题未解决；
- Gecko：Firefox 内核，功能强大，但耗费资源；
- Presto：Opera 内核，速度快牺牲了兼容性，现转用 Blink；
- Webkit：Safari 内核，速度较快，但兼容性低；
- Blink：Chrome 内核，Webkit 的一个分支。

# 浏览器的工作原理

从输入 url 后发生了什么？（烂大街的问题）

解析 Url → 缓存判断 → DNS 解析 → 获取 mac 地址 → tcp 三次握手 → https 四次握手 → 返回数据 → 页面渲染 → 四次挥手。

# 浏览器渲染原理

- 解析 html 构建 dom 树；
- 解析 css 构建 css 树；
- 根据 dom 树和 css 树附加到一起，生成渲染树 Render Tree；
- 生成 Render Tree 后，元素还没有在页面上确定位置大小，需要 Layout 布局操作，过程中发生重绘回流；
- 绘制阶段，根据渲染树调用 paint 方法进行页面绘制，在 display 显示。

![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/202205200812178.jpeg)

# js 引擎

## 为什么需要 js 引擎？

javascript 一个高级编程语言，需要转换为最终的机器指令来执行。

js 代码可以有浏览器或者 node 执行，但底层最终都有 cpu 执行，cpu 只认识自己的指令集，js 引擎就是将 js 代码翻译为机器语言，有 cpu 来执行。

## 常见的 js 引擎

- SpiderMonkey：第一款 js 引擎，由 js 原作者 Brendan Eich 开发；
- Chakra：IE 使用，微软开发；
- JavascriptCore：Webkit 使用，苹果开发；
- V8：谷歌使用，谷歌开发

# V8 引擎

目前最强大的 js 引擎，日常开发常用的 Google 浏览器即使用它，因此有必要做一了解。

V8 引擎是 C++编写的 Google 高性能 Javascript 和 WebAssembly 引擎，用于 Chrome 浏览器和 Nodejs 中，可以独立运行，也可以嵌入到 C++的应用程序中。

![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/202205221010901.png)

## V8 引擎架构

V8 的底层架构主要有三个核心模块（Parse、Ignition 和 TurboFan）。

- Parse 模块：经过词法分析（对每一个词、符号解析，生成很多 tokens）和语法分析（根据 tokens 对象不同类型再进一步分析具体语法）[AST explorer](https://astexplorer.net/)，将 js 代码转换为 AST；
- Igination 模块：解释器，将 ast 转换成 ByteCode（字节码：一种包含程序，由一序列的 op 代码或数据组成的二进制文件，是一种中间码），同时收集 TurboFan 需要优化的信息；
- TurboFan 模块：编译器，将字节码编译为 CPU 执行的机器码。
  - 如果一个函数被多次调用，就会标记为热点函数，经过 TurboFan 优化的机器码，提高代码执行性能；
  - 如执行函数过程中，变量类型发生改变，机器码又会逆向转换为字节码

## V8 的解析过程

![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/202205221039904.png)

- Blink 将源码交给 V8 引擎，Stream 获取源码进行转换；
- Scanner 会进行词法分析，将代码转换为 tokens；
- tokens 转换为 AST，经过 Parser 和 PreParser；
  - Parser 直接将 tokens 转换为 AST 结构；
  - PreParser 预解析，并不是所有的 js 代码一开始就执行，对所有的代码解析影响执行效率；因此 V8 对不必要先执行的函数进行 Lazy Parsing 延迟解析，先解析暂时需要的内容，等函数执行时再全量解析；
- 生成 AST 后，就是转换为字节码了，之后就是代码的执行过程。

# js 代码的执行过程

- 初始化全局对象：在执行代码前，先在堆内存创建一个全局对象 global object(GO)；
  - 所有作用域(scope)都可以访问；
  - 里面有 Date、Array、String、Number、setTimeout 等；
  - 还有一个 window 属性指向自己；
- 创建全局执行上下文 global execution context(GEC)，把 GEC 放入执行上下文栈中；
  - 执行上下文：当前代码执行的环境，抽象概念；
  - 执行上下文栈：执行代码的调用栈，用来管理执行上下文
  - 全局执行上下文有三个部分内容：
    - 在 parser 转换 AST 过程中，创建变量对象 VO，加入全局对象 GO，全局声明的变量、函数等，但不会赋值，这里发生变量作用域提升(hositing)
    - 作用域链：由 VO 组成；
    - this：此时是 window
- 执行全局代码，修改变量的值；
- 遇到函数时，创建函数执行上下文 functional execution context(FEC)，压入执行上下文栈中；
  - 函数执行上下文有三个部分内容：
    - 解析 AST 时，创建一个 activation object(AO)，AO 包含形参、arguments、函数声明、变量声明等；
    - 作用域链：由 variable object(函数中 AO)和父级 VO 组成，查找是一层一层找；
    - this：this 绑定的值
- 代码执行时，修改变量的值，执行结果，函数执行完毕，从执行上下文栈中弹出。
- 全部代码执行完毕，全局执行上下文从执行上下文栈中弹出，内存销毁。

# js 变量到底存在栈上还是堆上？

从开始学就讲 js 基本数据类型存在栈上，引用类型存在堆上。

那么真是这样吗？如果定义了一个超过栈内存的字符串那它还存栈上吗？显然是不可能的，那么原来说基本数据类型存在栈上显然有误了。这是例外呢还是这句话本身就是错的呢，再来探究一下。

## 栈和堆

要区分具体场景，一般情况下有两层含义：

- 在程序内存里，栈和堆表示两种内存管理方式；
- 在数据结构里，栈和堆是两种常用的数据结构。

栈和堆的概念，通常用于经典的系统语言中 C 或者 C++，在其他语言中，可能为了优化性能而偏离。

## **V8 引擎**中 js 变量存在堆上

先说结论：**在 V8 引擎中，js 变量存在堆上**。

js 变量的存储位置，基于 js 引擎的实现方式，因为 js 代码需要 js 引擎来编译执行。

支撑的理论：

1. 看 V8 源码(太难...)
2. 看 js 代码的执行过程：通过上述分析可以看到，js 代码执行使用抽象的执行上下文与执行上下文栈，那么在系统的函数调用时应该也是值包含函数的引用，而真正值是放堆上；
3. js 变量存在哪个位置，要取决于 js 引擎在编译执行代码的时候把变量放在了什么位置。而就目前用做最广泛的 V8 引擎来说，V8 引擎基于 C++开发，在 C++（如 C）将数据结构存储在堆上，并且仅在堆栈中使用指向它的指针。因此每当 V8 分配一个新变量时，就会分配一个新结构，它包含了数据及在堆上的附加信息。
4. ~~js 是存在垃圾回收机制的，GC 执行时意味着需要分散清理不可达数据，而在栈中是有严格的数据排序及存取的，那么数据可能是存栈上吗？~~（垃圾回收发生在堆空间）

那么基于以上，可以认为在 V8 中，js 变量存在堆上。

# 后记：

一些 js 可视化的网站，帮助我们更好的了解 js：

AST 语法树解析：[AST explorer](https://astexplorer.net/)

Event Loop 可视化：[latentflip.com/loupe](http://latentflip.com/loupe/?code=JC5vbignYnV0dG9uJywgJ2NsaWNrJywgZnVuY3Rpb24gb25DbGljaygpIHsKICAgIHNldFRpbWVvdXQoZnVuY3Rpb24gdGltZXIoKSB7CiAgICAgICAgY29uc29sZS5sb2coJ1lvdSBjbGlja2VkIHRoZSBidXR0b24hJyk7ICAgIAogICAgfSwgMjAwMCk7Cn0pOwoKY29uc29sZS5sb2coIkhpISIpOwoKc2V0VGltZW91dChmdW5jdGlvbiB0aW1lb3V0KCkgewogICAgY29uc29sZS5sb2coIkNsaWNrIHRoZSBidXR0b24hIik7Cn0sIDUwMDApOwoKY29uc29sZS5sb2coIldlbGNvbWUgdG8gbG91cGUuIik7!!!PGJ1dHRvbj5DbGljayBtZSE8L2J1dHRvbj4=)

js 异步：[JS Visualizer 9000 (jsv9000.app)](https://www.jsv9000.app/)

Javascript Visualizer：[JavaScript Visualizer (ui.dev)](https://ui.dev/javascript-visualizer)

js 运行可视化：[JavaScript Tutor](https://pythontutor.com/javascript.html#mode=edit)

# 参考：

[深入浏览器工作原理和 JS 引擎](https://baijiahao.baidu.com/s?id=1721190621764271745&wfr=spider&for=pc)

[JavaScript 深入之执行上下文](https://github.com/mqyqingfeng/Blog/issues/8)

邂逅 JavaScript 高级语法-codewhy

[JavaScript 中变量存储在堆中还是栈中？](https://www.zhihu.com/question/482433315)

[JavaScript 是否使用堆栈或堆进行内存分配或两者兼而有之？](https://hashnode.com/post/does-javascript-use-stack-or-heap-for-memory-allocation-or-both-cj5jl90xl01nh1twuv8ug0bjk)

[v8/objects.h v8/v8 (github.com)](https://github.com/v8/v8/blob/c736a452575f406c9a05a8c202b0708cb60d43e5/src/objects.h#L9368)