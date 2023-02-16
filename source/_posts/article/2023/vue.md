---
title: vue知识整理
tags:
  - vue
categories: vue
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/baby.png
date: 2023-02-16 19:00:00
---

![](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202302162008787.png)

一、Vue 基础 1. Vue 的基本原理
当一个 Vue 实例创建时，Vue 会遍历 data 中的属性，用 Object.defineProperty（vue3.0 使用 proxy ）将它们转为 getter/setter，并且在内部追踪相关依赖，在属性被访问和修改时通知变化。 每个组件实例都有相应的 watcher 程序实例，它会在组件渲染的过程中把属性记录为依赖，之后当依赖项的 setter 被调用时，会通知 watcher 重新计算，从而致使它关联的组件得以更新。
对象内部通过 defineReactive 方法，使用 Object.defineProperty 将属性进行劫持（只会劫持已经存在的属性），数组则是通过重写数组方法来实现。当页面使用对应属性时，每个属性都拥有自己的 dep 属性，存放他所依赖的 watcher（依赖收集），当属性变化后会通知自己对应的 watcher 去更新(派发更新)。

    2. 双向数据绑定的原理
        采用数据劫持结合发布者-订阅者模式的方式，通过Object.defineProperty()来劫持各个属性的setter，getter，在数据变动时发布消息给订阅者，触发相应的监听回调。主要分为以下几个步骤：
        Observer，用来劫持并监听所有属性，如果有变动的，就通知订阅者。
        Compile，解析模板指令，并替换模板数据，初始化视图；将模板指令对应的节点绑定对应的更新函数，初始化相应的订阅器
        Watcher订阅者是Observer和Compile之间通信的桥梁，主要做的事情是: ①在自身实例化时往属性订阅器(dep)里面添加自己 ②自身必须有一个update()方法 ③待属性变动dep.notice()通知时，能调用自身的update()方法，并触发Compile中绑定的回调
        MVVM作为数据绑定的入口，整合Observer、Compile和Watcher三者，通过Observer来监听自己的model数据变化，通过Compile来解析编译模板指令，最终利用Watcher搭起Observer和Compile之间的通信桥梁，达到数据变化 -> 视图更新；视图交互变化(input) -> 数据model变更的双向绑定效果。

    4. MVVM、MVC的区别
        MVC是Model-View-Controller的简写,Model就是模型，对应后端数据，View就是视图对应用户界面，Controller就是控制器，对应页面的业务逻辑。
        MVC的工作机制原理就是，用户操作会请求服务器路由，路由就会调用对应的控制器来处理，控制器就会获取后台数据，将结果返回给前端，进行页面渲染。
        MVVM是Model-View-ViewModel的简写。它本质上就是MVC的改进版，M和V是一样的，ViewModel的存在目的是抽离Controller中展示的业务逻辑，其它的业务逻辑还是在控制器中，整体和MVC差不多。
        最大的区别就是：
            第一，MVC是单向的，而MVVM是双向的，并且是自动的，也就是数据发生变化自动同步视图，视图发生变化自动同步数据。
            第二个，解决了 MVC 中大量的 DOM 操作使页面渲染性能降低，加载速度变慢，影响用户体验等问题。
            第三个，在数据频繁更新的时候，采用了虚拟DOM，减少过度渲染，提高性能。


    7. slot是什么？有什么作用？
        Vue的内容分发机制，组件内部的模板引擎使用slot元素作为承载分发内容的出口。
        插槽slot是子组件的一个模板标签元素，而这一个标签元素是否显示，以及怎么显示是由父组件决定的。slot又分三类，默认插槽，具名插槽和作用域插槽。

    8. 过滤器的作用
        过滤器是用来过滤数据的，在Vue中使用filters来过滤数据，filters不会修改数据，而是过滤数据，改变用户看到的输出（计算属性 computed ，方法 methods 都是通过修改数据来处理数据格式的输出显示）。

    9. 如何保存页面的当前的状态
        状态存储在LocalStorage / SessionStorage
        keep-alive

    11. v-if、v-show、v-html 的原理
        v-if会调用addIfCondition方法，生成vnode的时候会忽略对应节点，render的时候就不会渲染；
        v-show会生成vnode，render的时候也会渲染成真实节点，只是在render过程中会在节点的属性中修改show属性值，也就是常说的display；
        v-html会先移除节点下的所有节点，调用html方法，通过addProp添加innerHTML属性，归根结底还是设置innerHTML为v-html的值。

    17. 对keep-alive的理解
        如果需要在组件切换的时候，保存一些组件的状态防止多次渲染，就可以使用 keep-alive 组件包裹需要保存的组件。
        keep-alive有以下三个属性：
            include 字符串或正则表达式，只有名称匹配的组件会被匹配；
            exclude 字符串或正则表达式，任何名称匹配的组件都不会被缓存；
            max 数字，最多可以缓存多少组件实例。

        keep-alive 具体是通过 cache 数组缓存所有组件的 vnode 实例。当 cache 内原有组件被使用时会将该组件 key 从 keys 数组中删除，然后 push 到 keys数组最后，以便清除最不常用组件。

    18. $nextTick 原理及作用
        extTick 中的回调是在下次 DOM 更新循环结束之后执行的延迟回调。在修改数据之后立即使用这个方法，获取更新后的 DOM。主要思路就是采用微任务优先的方式调用异步方法去执行 nextTick 包装的方法

    22. Vue template 到 render 的过程
        调用parse方法将template转化为ast（抽象语法树）
        对静态节点做优化
        生成代码

    24. 简述 mixin、extends 的覆盖逻辑
        mixins 接收一个混入对象的数组，其中混入对象可以像正常的实例对象一样包含实例选项，这些选项会被合并到最终的选项中。Mixin 钩子按照传入顺序依次调用，并在调用组件自身的钩子之前被调用。
        extends 主要是为了便于扩展单文件组件，接收一个对象或构造函数。

    25. 描述下Vue自定义指令
        有的情况下，你仍然需要对普通 DOM 元素进行底层操作，这时候就会用到自定义指令。
        自定义指令基本内容
            全局定义：Vue.directive("focus",{})
            局部定义：directives:{focus:{}}
            钩子函数：指令定义对象提供钩子函数

        使用案例
            鼠标聚焦
            下拉菜单
            相对时间转换
            滚动动画


    28. 对 React 和 Vue 的理解，它们的异同
        相同点：
            都将注意力集中保持在核心库
            都有自己的构建工具
            都使用了Virtual DOM
            都有props的概念，允许组件间的数据传递
            都鼓励组件化应用

        不同点：
            Vue默认支持数据双向绑定，而React一直提倡单向数据流
            React而言，每当应用的状态被改变时，全部子组件都会重新渲染
            vue使用模板，react使用jsx
            vue使用监听，react使用比较引用
            react可以通过高阶组件（HOC）来扩展，而Vue需要通过mixins来扩展。
            有自己的构建工具和跨平台


    33. 什么是 mixin ？
        Mixin 使我们能够为 Vue 组件编写可插拔和可重用的功能。
        在日常的开发中，我们经常会遇到在不同的组件中经常会需要用到一些相同或者相似的代码，这些代码的功能相对独立，可以通过 Vue 的 mixin 功能抽离公共的业务逻辑，原理类似“对象的继承”，当组件初始化时会调用 mergeOptions 方法进行合并，采用策略模式针对不同的属性进行合并。当组件和混入对象含有同名选项时，这些选项将以恰当的方式进行“合并”。

    35. 对SSR的理解
        SSR也就是服务端渲染，也就是将Vue在客户端把标签渲染成HTML的工作放在服务端完成，然后再把html直接返回给客户端
        ssr可以更好地seo，首屏加载速度更快
        更多的服务端负载，开发条件限制，只支持beforeCreate和created两个钩子

二、生命周期
三、组件通信
四、路由 2. 路由的 hash 和 history 模式的区别
hash 模式的主要原理就是 window.onhashchange()事件
history 的 pushstate

五、Vuex
六、Vue 3.0 1. Vue3.0 有什么更新
Composition API
SFC Composition API 语法糖、
Teleport 传送门（可以将指定内容渲染到特定容器中，而不受 DOM 层级的限制）、
Fragments 片段、
Emits 选项（和 data、methods 一样）、
自定义渲染器、
SFC CSS 变量、
Suspense（等待异步组件时渲染一些额外内容，让应用有更好的用户体验）。。

    3. Vue3.0 为什么要用 proxy？
        1、Proxy 可以直接监听对象而非属性；
        2、Proxy 可以直接监听数组的变化；
        3、Proxy 有多达 13 种拦截方法,不限于 apply、ownKeys、deleteProperty、has 等等是Object.defineProperty 不具备的；
        4、Proxy 返回的是一个新对象,我们可以只操作新的对象达到目的,而 Object.defineProperty 只能遍历对象属性直接修改；

七、虚拟 DOM
