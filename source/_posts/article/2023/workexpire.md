---
title: 学习经验
tags:
  - 前端
categories: 前端
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/24a0b8950978a2f8a521b61d6afec01d.png
date: 2023-02-16 16:00:00
---

## H5 如何进行首屏优化？尽量说全

- SSR
- APP 预取
- 分页
- 图片 lazyload
- 离线包 hybrid：提前将 htmlcssjs 下载到 app，app 打卡页面时，webview 使用`file://` 协议加载本地的 html css js ，然后再 ajax 请求数据，再渲染。

## 渲染 10w 条数据

- 沟通需求和场景，给出自己合理的设计建议
- 虚拟列表
  - 只渲染可视区域 DOM
  - 其他隐藏区域不渲染，只用一个 `<div>` 撑开高度
  - 监听容器滚动，随时创建和销毁 DOM
  第三方库：vue-virtual-scroll-list、react-virtualized

## 前端常用的设计模式？什么场景？

设计原则是设计模式的基础，开放封闭原则是最重要的：对扩展开发，对修改封闭

1. 工厂模式：jQuery 创建实例；Vue 创建 vnode
2. 单例模式：vuex 和 redux 的 store；
3. 代理模式：ES proxy
4. 观察者模式：事件绑定
5. 发布订阅模式：自定义事件
6. 装饰器模式：ES 的 decorator

### MVC 和 MVVM 有什么区别

MVC 原理：

- View 传送指令到 Controller
- Controller 完成业务逻辑后，要求 Model 改变状态
- Model 将新的数据发送到 View，用户得到反馈

MVVM：

- view 是 vue template
- model 即 vue data
- vm 是其他核心功能，负责 View 和 Model 通讯

## vue 优化

- v-if 和 v-show
- v-for 使用 key
- computed 缓存
- keep-alive
- 异步组件
- 路由懒加载
- SSR

## Vue 遇到过哪些坑？

- 全局事件、自定义事件要在组件销毁时解除绑定
- Vue2.x 中，无法监听 data 属性的新增和删除，以及数组的部分修改
- 路由切换时，页面会 scroll 到顶部：在列表页缓存数据和 `scrollTop`

## react 优化？

循环使用 key

修改 css 模拟 `v-show`

使用 Fragment 减少层级

JSX 中不要定义函数

在构造函数 bind this

使用 shouldComponentUpdate 控制组件渲染

React.memo 缓存函数组件

useMemo 缓存数据

异步组件

路由懒加载

SSR

## React 遇到哪些坑？

JSX 中，自定义组件命名，开头字母要大写，html 标签开头字母小写

JSX 中 `for` 写成 `htmlFor` ， `class` 写成 `className`

state 作为不可变数据，不可直接修改，使用纯函数

JSX 中，属性要区分 JS 表达式和字符串

state 是异步更新的，要在 callback 中拿到最新的 state 值

`useEffect` 内部不能修改 state

## 如何统一监听 Vue 组件报错？

- window.onerror：可以监听当前页面所有的 js 报错
- `errorCaptured` 监听下级组件的错误，可返回 `false` 阻止向上传播
- `errorHandler` 监听 Vue 全局错误
- Promise 监听报错要使用 `window.onunhandledrejection`

一些重要的、复杂的、有运行风险的组件，可使用 `errorCaptured` 重点监听，然后用 `errorHandler` `window.onerror` 候补全局监听，避免意外情况。

## 如何统一监听 React 组件报错？

- ErrorBoundary 监听渲染时报错
- try-catch`和`window.onerror` 捕获其他错误

## 如果一个 h5 很慢，你该如何排查问题？

1. 拖过工具分析性能参数：Lighthouse、Performance
2. 识别问题：加载慢还是渲染慢？
3. 解决问题
4. 增加性能统计、持续跟进、优化

加载慢：

- 优化服务端接口
- 使用 cdn
- 压缩文件
- 拆包，异步加载

渲染慢（可参考“首屏优化”）

- 根据业务功能，继续打点监控
- 如果是 SPA 异步加载资源

## 项目冲突？

常见的冲突：

- 需求变更：PM 或者老板提出了新的需求
- 时间延期：上游或者自己延期了
- 技术方案冲突：如感觉服务端给的接口格式不合理

规避冲突：

- 预估工期留有余地
- 定期汇报个人工作进度，提前识别风险

## code review

CR 检查什么？

```markdown
- 代码规范（eslint 能检查一部分，但不是全部，如：变量命名）
- 重复逻辑抽离、复用
- 单个函数过长，需要拆分
- 算法是否可优化?
- 是否有安全漏洞?
- 扩展性如何？
- 是否和现有的功能重复了？
- 是否有完善的单元测试
- 组件设计是否合理
```

何时 CR？

提交 PR（或者 MR）时，看代码 diff 。

每周组织一次集体 CR ，拿出几个 PR 或者几段代码，大家一起评审。
