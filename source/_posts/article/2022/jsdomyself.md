---
title: js手写系列
date: 2022-04-02
tags:
  - js
categories: js
cover: https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/boil.png
---

# 数组去重

## 方法

1. 双重for循环
2. filter + indexof
3. sort + for
4. filter + hasOwnPorperty
5. Set

测试：

`var arr = [1,1,'true','true',true,true,15,15,false,false, undefined,undefined, null,null, NaN, NaN,'NaN', 0, 0, 'a', 'a',{},{}]`

```JavaScript
function unique (arr) {
  for (var i = 0; i < arr.length; i++) {
    for (var j = i + 1; j < arr.length; j++) {
      if (arr[i] == arr[j]) {
        arr.splice(j, 1)
        j--
      }
    }
  }
  return arr
}
// [1, 'true', 15, false, undefined, NaN, NaN, 'NaN', 'a', {…}, {…}]
// NaN {} 无法去重，null消失
```

```JavaScript
function unique (arr) {
  return arr.filter((item, index) => arr.indexOf(item) === index)
}
// [1, 'true', true, 15, false, undefined, null, 'NaN', 0, 'a', {…}, {…}]
// {} 无法去重
```

```JavaScript
function unique (arr) {
  arr = arr.sort()
  var res = [], prev
  for (var i = 0; i < arr.length; i++) {
    if (prev != arr[i]) {
      res.push(arr[i])
    }
    prev = arr[i]
  }
  return res
}
//[0, 1, 15, NaN, NaN, 'NaN', {…}, {…}, 'a', false, null, 'true', true, undefined]
// NaN {} 无法去重
```

```JavaScript
function unique (arr) {
  var obj = {}
  return arr.filter((item, index, arr) => {
    return obj.hasOwnProperty(typeof item + item) ? false : (obj[typeof item + item] = true)
  })
}
// [1, 'true', true, 15, false, undefined, null, NaN, 'NaN', 0, 'a', {…}]
// 完全去重！！
```

```JavaScript
function unique (arr) {
  return [...new Set(arr)]
}
// [1, 'true', true, 15, false, undefined, null, NaN, 'NaN', 0, 'a', {…}, {…}]
// {} 无法去重
```

## 速度

双重 for 循环 > filter + indexOf > sort + for > filter + hasOwnProperty > Set 

# 深浅拷贝

## 浅拷贝

> 新对象复制已有对象的对象属性的引用。

只拷贝第一层的对象，对于属性值是对象的只拷贝一份内存地址。

### Object.assign()

```JavaScript
var target = {}
var source = { a: '1', b: { c: 2 } }
Object.assign(target, source)
target.a = 2
console.log(source, target); 
// { a: '1', b: { c: 2 } } { a: 2, b: { c: 2 } }
target.b.c = 3
console.log(source, target);
// { a: '1', b: { c: 3 } } { a: 2, b: { c: 3 } }
```

### slice

### concat

### 扩展运算符

```JavaScript
var obj = { a: 1, b: { c: 1 }}
var obj2 = {...obj}
obj2.b.c = 2
console.log(obj, obj2); 
// { a: 1, b: { c: 2 } } { a: 1, b: { c: 2 } }
```

## 深拷贝

### JSON.parse(JSON.stringify())

```JavaScript
var obj1 = { a: 1, b: { c: 2 } }
var obj2 = JSON.parse(JSON.stringify(obj1));
obj2.b.c = 3
console.log(obj1, obj2);
// { a: 1, b: { c: 2 } } { a: 1, b: { c: 3 } }

```

注意无法拷贝值是函数，Date/RegExp，原型链及循环引用。

### 手写

```JavaScript
function isObject(obj) {
  return typeof obj === 'object' && obj !== null
}
function deepClone(obj, map = new WeakMap()) {
  if (!isObject(obj)) return obj;
  var result = Array.isArray(obj) ? [] : {};
  if (map.get(obj)) {
    return map.get(obj)
  }
  map.set(obj, result)
  for (var key in obj) {
    if (isObject(obj[key])) {
      result[key] = deepClone(obj[key], map)
    } else {
      result[key] = obj[key]
    }
  }
  return result
}

var obj1 = { a: { b: 1 }, c: [1, 2, 3] }
obj1.d = obj1 // 循环引用
var obj2 = deepClone(obj1)
// var obj2 = JSON.parse(JSON.stringify(obj1))
// TypeError: Converting circular structure to JSON
obj2.a.b = 2
obj2.c[1] = 4
console.log(obj1, obj2);
// <ref *1> { a: { b: 1 }, c: [ 1, 2, 3 ], d: [Circular *1] } <ref *1> { a: { b: 2 }, c: [ 1, 4, 3 ], d: [Circular *1] }


```

### lodash

# 防抖节流

## 防抖

```JavaScript
function debounce(func, delay) {
  let timer;
  return function () {
    if (timer) {
      clearTimeout(timer);
    }
    timer = setTimeout(() => {
      func.apply(this, arguments);
    }, delay);
  }
}

function fn(a) {
  console.log(a);
}
window.addEventListener('scroll', debounce(() => {
  fn('hhh')
}, 1000))

```

## 节流

```JavaScript
function throttle(func, delay) {
  let start = Date.now();
  return function () {
    let end = Date.now();
    if (end - start >= delay) {
      func()
      start = Date.now();
    }
  }
}
```

# call/apply/bind

### call

```JavaScript
Function.prototype.myCall = function (context) {
  if (typeof this !== 'function') {
    console.error('type error')
  }
  context = context || window;
  context.fn = this;
  var args = [...arguments].slice(1)
  var result = context.fn(...args);
  delete context.fn
  return result
}

var obj = { a: 1 }
function obj2 (b) {
  console.log(this.a, b);
}
obj2.myCall(obj, 2) // 1 2

```

```JavaScript
Function.prototype.myCall = function (context) {
  if (typeof this !== 'function') {
    console.error('type error')
  }
  context = context || window;
  context.fn = this;
  var args = []
  for (var i = 1; i < arguments.length; i++) {
    args.push('arguments[' + i + ']')
  }
  var result = eval('context.fn(' + args + ')')
  delete context.fn
  return result
}

var obj = { a: 1 }
function obj2 (b) {
  console.log(this.a, b);
}
obj2.myCall(obj, 2) // 1 2

```

### apply

```JavaScript
Function.prototype.myApply = function (context, arr) {
  if (typeof this !== 'function') {
    console.error('type error')
  }
  var context = Object(context) || window;
  context.fn = this;
  var result;
  if (!arr) {
    result = context.fn();
  }
  else {
    var args = [];
    for (var i = 0, len = arr.length; i < len; i++) {
      args.push('arr[' + i + ']');
    }
    result = eval('context.fn(' + args + ')')
  }
  delete context.fn
  return result;

}

var obj = { a: 1 }
var obj2 = function (b, c) {
  console.log(this.a, b, c);
}
obj2.myApply(obj, [2, 3]) // 1 2 3

```

```JavaScript
Function.prototype.myApply = function (context) {
  if (typeof this !== 'function') {
    console.error('type error')
  }
  var context = Object(context) || window;
  context.fn = this;
  var result;
  if (!arguments[1]) {
    result = context.fn();
  } else {
    result = context.fn(...arguments[1])
  }
  delete context.fn
  return result;
}

var obj = { a: 1 }
var obj2 = function (b, c) {
  console.log(this.a, b, c);
}
obj2.myApply(obj, [2, 3]) // 1 2 3
```

### bind

```JavaScript
Function.prototype.myBind = function (context) {
  if (typeof this !== 'function') {
    console.error('type error')
  }
  var self = this;
  var args = Array.prototype.slice.call(arguments, 1);
  var fNop = function () { }
  var fBound = function () {
    var bindArgs = Array.prototype.slice.call(arguments)
    return self.apply(this instanceof fNop ? this : context, args.concat(bindArgs))
  }
  fNop.prototype = this.prototype
  fBound.prototype = new fNop()
  return fBound
}

var obj = { a: 1 }
function fun(b, c) {
  console.log(this.a, b, c);
}

var obj2 = fun.myBind(obj, 2)
// obj2(3)  // 1 2 3
var obj3 = new obj2(3) // undefined 2 3

```

```JavaScript
Function.prototype.myBind = function (context) {
  if (typeof this !== 'function') {
    console.error('type error')
  }
  var self = this;
  var args = [...arguments].slice(1)
  return function Fn() {
    return self.apply(this instanceof Fn ? this : context, args.concat(...arguments))
  }
}

var obj = { a: 1 }
function fun(b, c) {
  console.log(this.a, b, c);
}

var obj2 = fun.myBind(obj, 2)
obj2(3)  // 1 2 3
// var obj3 = new obj2(3) // undefined 2 3
```

# promise

## promise.all

```JavaScript
function promiseAll(promises) {
  return new Promise((resolve, reject) => {
    if (!Array.isArray(promises)) {
      throw new TypeError('promises must be an array')
    }
    var result = []
    var count = 0
    for (let i = 0; i < promises.length; i++) {
      Promise.resolve(promises[i]).then(res => {
        result[i] = res
        count++
        count === promises.length && resolve(result)
      }, err => {
        reject(err)
      })
    }
  })
}

var p1 = new Promise(resolve => {
  setTimeout(() => {
    resolve(1)
  }, 100)
})
var p2 = new Promise(resolve => {
  setTimeout(() => {
    resolve(2)
  }, 200)
})
promiseAll([p2, p1]).then(res => {
  console.log(res); // [2, 1]
})
```

## promise.finally

```JavaScript
// finally 无论Promise最后状态如何，都会执行的操作
// finally 没有参数，会传递值
Promise.prototype.myFinally = function (cb) {
  return this.then(res => {
    return Promise.resolve(cb()).then(() => res)
  }, err => {
    return Promise.reject(cb()).then(err => err)
  })
}

function fun() {
  console.log(11);
}
var p1 = Promise.resolve(1)
p1.myFinally(fun).then(res => {
  console.log(res); // 11 1
})
```

## promise.race

```JavaScript
function PromiseRace(promises) {
  return new Promise((resolve, reject) => {
    for (let i = 0; i < promises.length; i++) {
      Promise.resolve(promises[i]).then(res => {
        resolve(res)
      }, err => {
        reject(err)
      })
    }
  })
}
```

# sleep

```JavaScript
// sleep函数模拟线程挂起，等待时间后恢复
function timeout(time) {
  return new Promise(resolve => setTimeout(resolve, time * 1000))
}
async function sleep(time) {
  console.log('start');
  await timeout(time)
  console.log('end');
}

sleep(3)
```

# 模板字符串解析

```JavaScript
function render(template, data) {
  var reg = /\{\{(\w+)\}\}/g
  return template.replace(reg, function (match, key) {
    // console.log(match, key);
    return data[key]
  })
}

var ele = `我是{{name}}，性别{{sex}}，年龄{{age}}`
var obj = {
  name: 'tom',
  sex: 'male',
  age: 10
}
console.log(render(ele, obj));
// 我是tom，性别male，年龄10
```

# 快速排序

```JavaScript
function quickSort(arr) {
  if (arr.length <= 1) {
    return arr
  }
  var mid = Math.floor(arr.length / 2)
  var midNum = arr.splice(mid, 1)[0]
  var left = []
  var right = []
  for (var i = 0; i < arr.length; i++) {
    if (midNum > arr[i]) {
      left.push(arr[i])
    } else {
      right.push(arr[i])
    }
  }
  return quickSort(left).concat(midNum, quickSort(right))
}

var arr = [5,3,7,1,9,6]
console.log(quickSort(arr)); // [ 1, 3, 5, 6, 7, 9 ]
```

