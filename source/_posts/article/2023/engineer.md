---
title: 前端工程化
tags:
  - 前端
  - 工程化
categories: 前端
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/team-lily-bug.png
date: 2023-02-13 16:00:00
---

![](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202302131715865.png)

一、Git
    1. git 和 svn 的区别
         git 是分布式的，而 svn 是集中式的
        svn 中的分支是整个版本库的复制的一份完整目录，而 git 的分支是指针指向某次提交
        GIT把内容按元数据方式存储，而SVN是按文件
二、Webpack
    1. webpack与grunt、gulp的不同？
        Grunt**、Gulp是基于任务运⾏的⼯具**： 它们会⾃动执⾏指定的任务，就像流⽔线，把资源放上去然后通过不同插件进⾏加⼯
        Webpack是基于模块化打包的⼯具: ⾃动化处理模块，webpack把⼀切当成模块
    2. webpack、rollup、parcel优劣？
        webpack适⽤于⼤型复杂的前端站点构建
        rollup适⽤于基础库的打包
        parcel适⽤于简单的实验性项⽬
    3. 有哪些常⻅的Loader？
        file-loader
        url-loader
        source-map-loader
        babel-loader
        css-loader
        style-loader
        eslint-loader
    4. 有哪些常⻅的Plugin？
        html-webpack-plugin
        uglifyjs-webpack-plugin
        webpack-bundle-plugin
        mini-css-extract-plugin
    6. Loader和Plugin的不同？
        Loader的作⽤是让webpack拥有了加载和解析⾮JavaScript⽂件的能⼒。
        Plugin可以扩展webpack的功能， 在 Webpack 运⾏的⽣命周期中会⼴播出许多事件，Plugin 可以监听这些事件，在合适的时机通过 Webpack 提供的 API 改变输出结果。
    7. webpack的构建流程
        初始化参数：从配置⽂件和 Shell 语句中读取与合并参数，得出最终的参数；
        开始编译：⽤上⼀步得到的参数初始化 Compiler 对象，加载所有配置的插件，执⾏对象的 run ⽅法开始执⾏编译；
        确定⼊⼝：根据配置中的 entry 找出所有的⼊⼝⽂件；
        编译模块：从⼊⼝⽂件出发，调⽤所有配置的 Loader 对模块进⾏翻译，再找出该模块依赖的模块，再递归本步骤直到所有⼊⼝依赖的⽂件都经过了本步骤的处理；
        完成模块编译：在经过第4步使⽤ Loader 翻译完所有模块后，得到了每个模块被翻译后的最终内容以及它们之间的依赖关系；
        输出资源：根据⼊⼝和模块之间的依赖关系，组装成⼀个个包含多个模块的 Chunk，再把每个 Chunk 转换成⼀个单独的⽂件加⼊到输出列表，这步是可以修改输出内容的最后机会；
        输出完成：在确定好输出内容后，根据配置确定输出的路径和⽂件名，把⽂件内容写⼊到⽂件系统。
    8. 编写loader或plugin的思路？
        loader 其实是一个函数，对匹配到的内容进行转换，将转换后的结果返回。
        plugin 是一个插件，这个插件也就是一个类，基于事件流框架 Tapable 实现。需要在原型上定义 apply(compliers) 函数。同时指定要挂载的 webpack 钩子，功能完成后调用 webpack 提供的回调。
    9. webpack的热更新是如何做到的？
        监听到文件改变，根据配置对模块打包
        通过sockjs在浏览器与服务器建立一条ws长连接，传递新模块的hash值
        客户端收到hash，发送ajax请求服务端返回一个json，再次通过jsonp请求获取到最新代码
        HMR对新旧模块对比，更新模块
        HMR失败刷新浏览器获取最新代码
    10. 如何⽤webpack来优化前端性能？
        压缩代码
        提取第三方库
        代码分割
        treeshaking
        cdn加速
    Babel的原理是什么
        解析parse
        转换transform
        生成generate
