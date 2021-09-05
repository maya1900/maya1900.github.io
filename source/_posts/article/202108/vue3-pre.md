---
title: vue3源码的一些前置知识
date: 2021-08-31
tags:
- vue3
- 源码
categories: vue
cover: https://z3.ax1x.com/2021/09/06/hfNsAg.jpg
---

## 如何调试vue3 源码

在 package.json里追加`"dev:sourcemap": "node scripts/dev.js --sourcemap"`，然后执行 `yarn dev:sourcemap`，即生成sourcemap，在控制台输出类似`vue-next/packages/vue/src/index.ts → packages/vue/dist/vue.global.js`的信息。

新建`examples/index.html`，引入`packages/vue/dist/vue.global.js`，打断点调试即可。

## vue3 的工具函数

[https://maya1900.github.io/article/202108/vue-next/](https://maya1900.github.io/article/202108/vue-next/)

## vuejs的发布流程

> 1. 选取版本
> 2. 执行测试
> 3. 更新版本号
> 4. 打包编译包
> 5. 生成changelog
> 6. 提交代码
> 7. 发布包
> 8. 推送到github

## 调试 nodejs 代码

这里即调试发布代码`vue-next/scripts/release.js`

找到`vue-next/package.json` 文件

``` json
"script": {
	"release": "node scripts/release.js --dry"
}
```

// --dry 只调试,不执行测试和编译 、不执行 推送git等操作

在vscode里面，scripts的上一行有一个调试的小图标，点击选择release，即可进入调试模式。

## 优化代码发布

> release-it
> git flow 管理分支
> husky和lint-staged 提交commit时校验
> 单元测试jest
> conventional-changelog
> git-cz 交互式git commit

## 看不懂源码怎么办？

> 1. 调试
> 2. 搜索相关文章
> 3. 把不懂的地方记录下来，查阅文档
> 4. 总结

## koa 

koa的使用：

``` javascript
const Koa = require('koa');
const app = new Koa();
app.use(ctx => {
  ctx.body = 'Hello Koa';
});
app.listen(3000);
```

