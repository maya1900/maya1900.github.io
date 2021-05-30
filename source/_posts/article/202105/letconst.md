---
title: 复习ES6(一): let/const
date: 2021-05-30 
tags: 
- js
- es6
categories: js
cover: https://z3.ax1x.com/2021/05/30/2V07Ie.jpg
---

1. let/const

- var 和 let 的不同\*
- for 循环的特别之处\*
- let/const 不存在变量提升
- let 的暂时性死区\*
- 隐蔽的死区\*
- let/const 不允许重复声明
- let/const 块级作用域
- 块级作用域与函数声明\*
- const 的不得改动\*
- 顶层对象\*

```javascript
var a = [];
for (var i = 0; i < 10; i++) {
  a[i] = function () {
    console.log(i);
  };
}
a[6](); // 10
```

使用 var 声明时，i 被声明为全局变量，全局只有一个 i，因此循环完毕时全局变量 i 已经变为 10，此时再调用函数体时,i 已经变为 10。

```javascript
var a = [];
for (let i = 0; i < 10; i++) {
  a[i] = function () {
    console.log(i);
  };
}
a[6](); // 6
```

而使用 let，let 中的 i 只在本轮循环中有效，每次循环出的 i 都是一个新的变量，因此会输出 6。

```javascript
for (let i = 0; i < 3; i++) {
  let i = 'abc';
  console.log(i);
}
// abc
// abc
// abc
```

for 循环有个特别的地方：函数内部的变量 i 与循环变量 i 不在同一个作用域，它们有各自的单独作用域。

```javascript
if (true) {
  // 暂时性死区开始
  tmp = 'abc'; // ReferenceError
  console.log(tmp); // ReferenceError

  let tmp; // 暂时性死区结束
  console.log(tmp); // undefined

  tmp = 123;
  console.log(tmp); // 123
}
```

ES6 明确规定，如果区块中存在 let 和 const 命令，这个区块对这些命令声明的变量，从一开始就形成了封闭作用域。凡是在声明之前就使用这些变量，就会报错。

```javascript
function bar(x = y, y = 2) {
  return [x, y];
}

bar(); // 报错
```

上面例子中，x=y，但此时 y 还没有声明，所以报错；下面例子的 y=x，x 已经声明过了，所以没报错。

```javascript
function bar(x = 2, y = x) {
  return [x, y];
}
bar(); // [2, 2]
```

ES5 规定，函数只能在顶层作用域和函数作用域之中声明，不能在块级作用域声明。ES6 引入了块级作用域，明确允许在块级作用域之中声明函数。

考虑到环境导致的行为差异太大，应该避免在块级作用域内声明函数。如果确实需要，也应该写成函数表达式，而不是函数声明语句。

```javascript
// 块级作用域内部，优先使用函数表达式
{
  let a = 'secret';
  let f = function () {
    return a;
  };
}
```

ES6 的块级作用域必须有大括号，如果没有大括号，JavaScript 引擎就认为不存在块级作用域。

const 实际上保证的，并不是变量的值不得改动，而是变量指向的那个内存地址所保存的数据不得改动。

```javascript
const foo = {};
// 为 foo 添加一个属性，可以成功
foo.prop = 123;
foo.prop; // 123
// 将 foo 指向另一个对象，就会报错
foo = {}; // TypeError: "foo" is read-only
```

如果真的想将对象冻结，应该使用 Object.freeze 方法。

浏览器里面，顶层对象是 window，但 Node 和 Web Worker 没有 window。
浏览器和 Web Worker 里面，self 也指向顶层对象，但是 Node 没有 self。
Node 里面，顶层对象是 global，但其他环境都不支持。

ES2020 在语言标准的层面，引入 globalThis 作为顶层对象。也就是说，任何环境下，globalThis 都是存在的，都可以从它拿到顶层对象，指向全局环境下的 this。
