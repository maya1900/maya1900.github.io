---
title: 理解koa原理
date: 2022-05-05
tags:
  - nodejs
  - koa
categories: nodejs
cover: https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/202205050819751.gif
---

精简的 web 框架，功能：

- 为 request 和 response 赋能，并封装成 context 对象；
- async/await 的中间件机制。

# 源码的四个文件

## appliction.js

- lib/application.js：

```JavaScript
const response = require('./response');
const compose = require('koa-compose');
const context = require('./context');
const request = require('./request');
const Emitter = require('events');
const convert = require('koa-convert');

module.exports = class Application extends Emitter {  // 继承Emitter，处理异步
  constructor() {
    super();
    this.middleware = [];  // 存放use进来的函数
    this.context = Object.create(context);
    this.request = Object.create(request);
    this.response = Object.create(response);
  }

  // 创建服务器
  listen(...args) {
    const server = http.createServer(this.callback());  // 对应(req, res) => {}
    return server.listen(...args);
  }

  // 定义use方法
  use(fn) {
    if (typeof fn !== 'function') throw new TypeError('middleware must be a function!');
    if (isGeneratorFunction(fn)) { // 判断是否generator函数，是则使用co转换
      fn = convert(fn);
    }
    this.middleware.push(fn);
    return this;
  }

  callback() {
    const fn = compose(this.middleware);  // koa-compose洋葱模型的实现
    if (!this.listenerCount('error')) this.on('error', this.onerror);
    const handleRequest = (req, res) => {
      const ctx = this.createContext(req, res); // 封装context
      return this.handleRequest(ctx, fn);
    };
    return handleRequest;
  }

  // 处理请求
  handleRequest(ctx, fnMiddleware) {
    const res = ctx.res;
    res.statusCode = 404;
    const onerror = err => ctx.onerror(err);
    const handleResponse = () => respond(ctx);
    onFinished(res, onerror);
    return fnMiddleware(ctx).then(handleResponse).catch(onerror);
  }

  // 定义context封装
  createContext(req, res) {
    const context = Object.create(this.context);
    const request = context.request = Object.create(this.request);
    const response = context.response = Object.create(this.response);
    context.app = request.app = response.app = this;
    context.req = request.req = response.req = req;
    context.res = request.res = response.res = res;
    request.ctx = response.ctx = context;
    request.response = response;
    response.request = request;
    context.originalUrl = request.originalUrl = req.url;
    context.state = {};
    return context;
  }

  // 错误机制处理
  onerror(err) {
    if (!(err instanceof Error)) throw new TypeError(util.format('non-error thrown: %j', err));
    if (404 == err.status || err.expose) return;
    if (this.silent) return;
    const msg = err.stack || err.toString();
    console.error();
    console.error(msg.replace(/^/gm, '  '));
    console.error();
  }
};
```

主要做了四件事：

- 启动框架
- 实现 compose 洋葱模型
- 错误机制处理
- 封装 context

## context.js

- lib/context.js

```JavaScript
const proto = module.exports = {
  onerror(err) {
    this.app.emit('error', err, this);
  },
};

delegate(proto, 'response')
  .method('attachment')
...
  .access('status')
...
  .getter('headerSent')
...

delegate(proto, 'request')
  .method('acceptsLanguages')
...
  .access('querystring')
...
  .access('accept')
  .getter('origin')
...
```

主要做了两件事：

- 错误机制处理
- 代理 request 和 response 对象的属性到自身

## request.js

- lib/request.js

```JavaScript
module.exports = {

  // 在application.js的createContext函数中，会把node原生的req作为request对象(即request.js封装的对象)的属性
  // request对象会基于req封装很多便利的属性和方法
  get header() {
    return this.req.headers;
  },

  set header(val) {
    this.req.headers = val;
  },

  // 省略了大量类似的工具属性和方法
};
```

request 对象基于 node 原生 req 封装了一系列便利属性和方法，供处理请求时调用

## response.js

与 request.js 类似。

# koa 启动流程

```JavaScript
const Koa = require('koa');
const app = module.exports = new Koa();

app.use(async function(ctx) {
  ctx.body = 'Hello World';
});

if (!module.parent) app.listen(3000);
```

## 初始化

实例 koa 时，初始化了许多属性，其中包括 context、request、response，这三个使用了 Object.create(xx)的方式，那么新创建的 this.context 这些继承了封装好的属性和方法就可以使用了。

## app.use

执行 app.use 时做了两件事：

- 一是判断是否是 generator 函数，是则执行 koa-convert 转换；
- 而是将 use 里的函数加入 middleware 数组中

### koa-convert

核心：

```JavaScript
function convert(){
 return function (ctx, next) {
    return co.call(ctx, mw.call(ctx, createGenerator(next)))
  }
  function * createGenerator (next) {
    return yield next()
  }
}
```

### co

通过[co](https://github.com/tj/co)这个库来进行转换。

co 的核心思想是，把 generator 函数封装在 promise 中，在 promise 内部再把 gen.next()也封装 promise，等 promise 执行完重复调用 gen.next()，让 generator 函数自动执行。

```JavaScript
function co(gen) {
  var ctx = this;
  var args = slice.call(arguments, 1)

  return new Promise(function(resolve, reject) {
    // 把参数传递给gen函数并执行
    if (typeof gen === 'function') gen = gen.apply(ctx, args);
    // 如果不是函数 直接返回
    if (!gen || typeof gen.next !== 'function') return resolve(gen);

    onFulfilled();

    function onFulfilled(res) {
      var ret;
      try {
        ret = gen.next(res);
      } catch (e) {
        return reject(e);
      }
      next(ret);
    }

    function onRejected(err) {
      var ret;
      try {
        ret = gen.throw(err);
      } catch (e) {
        return reject(e);
      }
      next(ret);
    }

    // 反复执行调用自己
    function next(ret) {
      // 检查当前是否为 Generator 函数的最后一步，如果是就返回
      if (ret.done) return resolve(ret.value);
      // 确保返回值是promise对象。
      var value = toPromise.call(ctx, ret.value);
      // 使用 then 方法，为返回值加上回调函数，然后通过 onFulfilled 函数再次调用 next 函数。
      if (value && isPromise(value)) return value.then(onFulfilled, onRejected);
      // 在参数不符合要求的情况下（参数非 Thunk 函数和 Promise 对象），将 Promise 对象的状态改为 rejected，从而终止执行。
      return onRejected(new TypeError('You may only yield a function, promise, generator, array, or object, '
        + 'but the following object was passed: "' + String(ret.value) + '"'));
    }
  });
}
```

## app.listen

listen 时创建了 htpp 服务器并启动监听。createServer 时传入参数 this.callback()

```JavaScript
callback() {
    // compose处理所有中间件函数。洋葱模型实现核心
    const fn = compose(this.middleware);

    // 每次请求执行函数(req, res) => {}
    const handleRequest = (req, res) => {
      // 基于req和res封装ctx
      const ctx = this.createContext(req, res);
      // 调用handleRequest处理请求
      return this.handleRequest(ctx, fn);
    };

    return handleRequest;
  }

 handleRequest(ctx, fnMiddleware) {
    const res = ctx.res;
    res.statusCode = 404;

    // 调用context.js的onerror函数
    const onerror = err => ctx.onerror(err);

    // 处理响应内容
    const handleResponse = () => respond(ctx);

    // 确保一个流在关闭、完成和报错时都会执行响应的回调函数
    onFinished(res, onerror);

    // 中间件执行、统一错误处理机制的关键
    return fnMiddleware(ctx).then(handleResponse).catch(onerror);
  }
```

主要做了三件事：

- koa-compose 洋葱模型实现
- 封装 context
- 错误处理

### koa-compose

```JavaScript
function compose (middleware) {
  if (!Array.isArray(middleware)) throw new TypeError('Middleware stack must be an array!')
  for (const fn of middleware) {
    if (typeof fn !== 'function') throw new TypeError('Middleware must be composed of functions!')
  }

 //  传入对象 context 返回Promise
  return function (context, next) {
    let index = -1
    return dispatch(0)
    function dispatch (i) {
      if (i <= index) return Promise.reject(new Error('next() called multiple times'))
      index = i
      let fn = middleware[i]
      if (i === middleware.length) fn = next
      if (!fn) return Promise.resolve()
      try {
        return Promise.resolve(fn(context, dispatch.bind(null, i + 1)));
      } catch (err) {
        return Promise.reject(err)
      }
    }
  }
}
```

类似于这样的结构：

```JavaScript
const [fn1, fn2, fn3] = this.middleware;
const fnMiddleware = function(context){
    return Promise.resolve(
      fn1(context, function next(){
        return Promise.resolve(
          fn2(context, function next(){
              return Promise.resolve(
                  fn3(context, function next(){
                    return Promise.resolve();
                  })
              )
          })
        )
    })
  );
};
fnMiddleware(ctx).then(handleResponse).catch(onerror);
```

从 compose 返回了一个 promise 对象，promise 中取出第一个函数，传入 context 和 next 函数来执行；

next()执行时又返回一个 promise 对象，promise 中取出第二个函数，传入 context 和 next 函数来执行...

直到所有的函数执行完，执行 promise.resolve()

### 单一 context 原则

每一个请求都有唯一的 context 共享全局中间件使用，当所有的中间件执行完后，会将所有的数据**统一交给 res**进行**返回**。

context 在封装时，拥有了 req、res、app 等所有的属性，当用户访问时，只需要 ctx 就可以获取 koa 提供的所有数据和方法。

**为什么 app、req、res、ctx 也存放在了 request、和 response 对象中呢**？

使它们同时共享一个 app、req、res、ctx，是为了将处理职责进行转移，这样职责得到了分散，降**低**了**耦合**度，同时共享所有资源使 context 具有**高内聚**的性质，内部元素互相能访问到。

### 错误处理

koa 文档的三种错误处理方式：

- `ctx.onerror` 中间件中的错误捕获
- `app.on('error', (err) => {})` 最外层实例事件监听形式
- `app.onerror = (err) => {}` 重写`onerror`自定义形式

koa 做错误处理时，只需要在实例上监听 onerror 事件就可以了，中间件所有的逻辑错误都会被捕获，在这里做了处理：

```JavaScript
handleRequest(ctx, fnMiddleware) {
    const res = ctx.res;
    res.statusCode = 404;
    // application.js也有onerror函数，但这里使用了context的onerror，
    const onerror = err => ctx.onerror(err);
    const handleResponse = () => respond(ctx);
    onFinished(res, onerror);

    // 这里是中间件如果执行出错的话，都能执行到onerror的关键！！！
    return fnMiddleware(ctx).then(handleResponse).catch(onerror);
  }
```

ctx.onerror 的 onerror 实际上也是触发了实例上的 onerror 事件

```JavaScript
module.exports = {
  onerror(){
    // delegate
    // app 是在new Koa() 实例
    this.app.emit('error', err, this);
  }
}
```

# 总结

- koa 四个核心概念：洋葱模型、context 请求上下文、request 请求对象、response 响应对象
- 洋葱模型的实现：使用 app.use 将所有中间件储存在 middleware 数组中，使用 koa-compose 最终返回一个 promise 对象，dispatch 执行时，context 不断传给下一个中间件，next 函数执行时又会执行 dispatch 并返回 promise，直到所有中间件执行完 promise.resolve()，又会一层一层的向上一级回归。
- koa 错误机制：使用 onerror 事件监听，内部在中间件执行时通过 ctx.onerror 捕获，ctx.onerror 实际上也是触发了 app.emit 事件执行，koa 继承了 events 事件，所以有 on/emit 事件。
- co 的原理：内部通过不断的调用 generator 的 next 方法来实现自动执行 generator 函数的目的，类似于 async/await。

# 参考

[lxchuan12/koa-analysis: 学习源码整体架构系列多篇之 koa 源码](https://github.com/lxchuan12/koa-analysis)

[可能是目前最全的 koa 源码解析指南 | 微信开放社区 (qq.com)](https://developers.weixin.qq.com/community/develop/article/doc/0000e4c9290bc069f3380e7645b813)

[index API](https://github.com/demopark/koa-docs-Zh-CN/blob/master/api/index.md)| [context API](https://github.com/demopark/koa-docs-Zh-CN/blob/master/api/context.md)| [request API](https://github.com/demopark/koa-docs-Zh-CN/blob/master/api/request.md)| [response API](https://github.com/demopark/koa-docs-Zh-CN/blob/master/api/response.md)
