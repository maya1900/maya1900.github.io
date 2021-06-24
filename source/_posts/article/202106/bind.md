---
title: bind与vue bind
date: 2021-06-21
tags:
- vue
- js
categories: js
cover:
---

## vue bind

vue的固定作用域：在methds里，vue使this指向始终指向了vue实例。

思路：
- 1.判断是否支持bind
- 2.兼容写法里传入函数fn和对象ctx
- 3.返回一个新函数，调用函数时使用call方法直接绑定函数作用域为ctx(为什么要返回一个新函数？bind不是立即执行的，需要调用才能执行)

``` javascript
  // 兼容bind方法
  // 使用到了函数柯里化
  function polyfillBind(fn, ctx) {
    // a 是 bind 指向里的第一个参数
    // arguments 是bind指向里的参数集合
    function boundFn(a) {
      var l = arguments.length
      return l ? 
      (
        l > 1 ? 
        fn.apply(ctx, arguments) : fn.call(ctx, a)
      ) : fn.call(ctx)
    }
    boundFn._length = fn.length
    return boundFn
  }
  // 原生bind方法
  function nativeBind(fn, ctx) {
    return fn.bind(fn, ctx)
  }
  // 支持原生bind用原生，不支持用兼容方法
  var bind = Funtion.prototype.bind ? nativeBind : polyfillBind
```
思路：
- 1. 保存一份原函数
- 2. 拷贝原函数原型给新函数原型
- 3. 返回新函数
- 4.判断是否是新函数的实例
- 5.绑定this，执行结果


## 手写bind

bind的手写实现：

``` javascript
  Function.prototype.mybind = function (oThis) {
    // 保存原函数
    const thisFn = this
    // 保存原函数的所有参数，这里将参数类数组转化为数组
    let args = Array.prototype.slice.call(arguments, 1) 
    function boundFn () {
      // 判断是否使用new 关键字来创建
      const ctx = this instanceof boundFn ? this : Object(oThis)
      // 这里的arguments是调用函数传递的所有实参,这里的参数是函数柯里化后的第二个往后的参数，因此不需要再减1
      return thisFn.call(ctx, args.concat(Array.prototype.slice.call(arguments)))
    }
    // 这里不能直接相等，因为改变thisFn也会改变boundFn了
    boundFn.prototype = Object.create(thisFn.prototype)
    return boundFn
  }
```

## 函数柯里化

再来理解一遍：把接受多个参数的函数变换成接受一个单一参数的函数，并且返回接受余下参数而且返回结果的新函数的技术

``` javascript
  function add (x, y) {
    return x + y
  }
```

``` javascript
  function addc (x) {
    return function (y) {
      return x + y
    }
  }
```

```javascript
add(1,2)
addc(1)(2)
```

就是说只让函数每次接收一个参数，余下的参数由返回的新函数去接收.

在很多情况下，我们都不会一次只传递一个参数，于是有了通用curry：

1. 定长参数：

``` javascript
  function curry(fn) {
    // 得到参数长度
    let len = fn.length;
    // 得到一次传参
    let preArgs = Array.prototype.slice.call(arguments, 1);
    return function () {
      // 得到二次传参
      const restArgs = Array.prototype.slice.call(arguments)
      const args = [...restArgs, ...preArgs]
      // 如果长度等于原函数参数，则执行函数；否则继续柯里化
      if (args.length >= len) {
        return fn.apply(this, args);
      } else {
        return curry.call(null, fn, ...args);
      }
    }
  }
```
2. 不定长参数

``` javascript
  function curry(fn) {
    let preArgs = [].slice.call(arguments, 1);
    function curried () {
      let restArgs = [].slice.call(arguments)
      let args = [...preArgs, ...restArgs]
      return curry.call(null, fn, ...args)
    }
    // 重写toString方法
    curried.toString = function () {
      return fn.apply(null, preArgs)
    }
    return curried;
  }
  function dynamicAdd() {
    return [...arguments].reduce((pre, cur) => {
      return pre + cur
    }, 0)
  }
  var add = curry(dynamicAdd)
  add(1)(2)(3)(4) // 10
  add(1,2)(3,4)(5,6) //21
```
