---
title: 复习ES6(五)：函数的扩展
date: 2021-05-31
tags:
  - es6
  - js
categories: js
cover: https://z3.ax1x.com/2021/05/31/2mIcdS.jpg
---

## 函数参数的默认值

ES6 允许为函数的参数设置默认值，即直接写在参数定义的后面

- 参数变量是默认声明的，所以不能用 let 或 const 再次声明
- 使用参数默认值时，函数不能有同名参数

### 与解构赋值默认值结合使用

下面两种写法的区别：

```javascript
// 写法一
function m1({ x = 0, y = 0 } = {}) {
  return [x, y];
}

// 写法二
function m2({ x, y } = { x: 0, y: 0 }) {
  return [x, y];
}
```

第一种是给了解构赋值的默认值，并给参数一个默认空值；
第二种是给了参数的默认值，没有给解构赋值的默认值

```javascript
// 函数没有参数的情况
m1(); // [0, 0]
m2(); // [0, 0]

// x 和 y 都有值的情况
m1({ x: 3, y: 8 }); // [3, 8]
m2({ x: 3, y: 8 }); // [3, 8]

// x 有值，y 无值的情况
m1({ x: 3 }); // [3, 0]
m2({ x: 3 }); // [3, undefined]

// x 和 y 都无值的情况
m1({}); // [0, 0];
m2({}); // [undefined, undefined]

m1({ z: 3 }); // [0, 0]
m2({ z: 3 }); // [undefined, undefined]
```

### 函数的 length 属性

指定了默认值以后，函数的 length 属性，将返回**==没有指定默认值的参数个数 #F44336==** 。如果设置了默认值的参数不是尾参数，那么 length 属性也不再计入后面的参数了

```javascript
(function (a) {}
  .length(
    // 1
    function (a = 5) {}
  )
  .length(
    // 0
    function (a, b, c = 5) {}
  )
  .length(
    // 2

    function (a = 0, b, c) {}
  )
  .length(
    // 0
    function (a, b = 1, c) {}
  ).length); // 1
```

### 作用域

一旦设置了参数的默认值，**函数进行声明初始化时，参数会形成一个单独的作用域（context）。等到初始化结束，这个作用域就会消失**。这种语法行为，在不设置参数默认值时，是不会出现的。

```javascript
var x = 1;

function f(x, y = x) {
  console.log(y);
}

f(2); // 2
```

上面例子，参数 y 默认值始终指向 x，当没给 x 赋值时，y 的值就是 x 的值。

```javascript
let x = 1;

function f(y = x) {
  let x = 2;
  console.log(y);
}

f(); // 1
```

上面例子，在调用 f() 时，y 的默认值为 x，而此时的 x 正是全局变量 x 的 1, 因此内部变量 x 与 y 已经没有什么关系了，输出 y 为 1

```javascript
function f(y = x) {
  let x = 2;
  console.log(y);
}

f(); // ReferenceError: x is not defined
```

上面例子，y 的默认值是 x，此时 x 并未赋值（下一步才给 x 赋值）,存在暂时性死区。

```javascript
var x = 1;
function foo(
  x,
  y = function () {
    x = 2;
  }
) {
  var x = 3;
  y();
  console.log(x);
}

foo(); // 3
x; // 1
```

上面例子，foo 的参数会形成一个单独的作用域，因此内外的 x 都不受影响。

```javascript
var x = 1;
function foo(
  x,
  y = function () {
    x = 2;
  }
) {
  x = 3;
  y();
  console.log(x);
}

foo(); // 2
x; // 1
```

上面例子，如果将 var x = 3 的 var 去除，那么内部的 x 指向了参数的 x，那么 x 将输出参数的 x=2，而外部 的也不受影响

### 应用

利用参数默认值，可以指定某一个参数不得省略，如果省略就抛出一个错误

## rest 参数

ES6 引入 rest 参数（形式为...变量名），用于获取函数的多余参数，这样就不需要使用 arguments 对象了

```javascript
function add(...values) {
  let sum = 0;

  for (var val of values) {
    sum += val;
  }

  return sum;
}

add(2, 5, 3); // 10
```

函数的 length 属性，不包括 rest 参数

```javascript
(function (a) {}
  .length(
    // 1
    function (...a) {}
  )
  .length(
    // 0
    function (a, ...b) {}
  ).length); // 1
```

## 严格模式

es6 规定只要函数参数使用了默认值、解构赋值、或者扩展运算符，那么函数内部就不能显式设定为严格模式，否则会报错

## name 属性

函数的 name 属性，返回该函数的函数名

```javascript
function foo() {}
foo.name; // "foo"
```

Function 构造函数返回的函数实例，name 属性的值为 anonymous
bind 返回的函数，name 属性值会加上 bound 前缀

## 箭头函数

ES6 允许使用“箭头”（=>）定义函数

```javascript
var f = (v) => v;

// 等同于
var f = function (v) {
  return v;
};
```

如果箭头函数不需要参数或需要多个参数，就使用一个圆括号代表参数部分

```javascript
var sum = (num1, num2) => num1 + num2;
// 等同于
var sum = function (num1, num2) {
  return num1 + num2;
};
```

由于大括号被解释为代码块，所以如果箭头函数直接返回一个对象，必须在对象外面加上括号

```javascript
// 报错
let getTempItem = id => { id: id, name: "Temp" };

// 不报错
let getTempItem = id => ({ id: id, name: "Temp" });
```

箭头函数的一个用处是简化回调函数

```javascript
// 普通函数写法
[1, 2, 3].map(function (x) {
  return x * x;
});

// 箭头函数写法
[1, 2, 3].map((x) => x * x);
```

```javascript
// 普通函数写法
var result = values.sort(function (a, b) {
  return a - b;
});

// 箭头函数写法
var result = values.sort((a, b) => a - b);
```

### 箭头函数注意：

（1）箭头函数没有自己的 this 对象（详见下文）。

（2）不可以当作构造函数，也就是说，不可以对箭头函数使用 new 命令，否则会抛出一个错误。

（3）不可以使用 arguments 对象，该对象在函数体内不存在。如果要用，可以用 rest 参数代替。

（4）不可以使用 yield 命令，因此箭头函数不能用作 Generator 函数。

除了 this，以下三个变量在箭头函数之中也是不存在的，指向外层函数的对应变量：arguments、super、new.target。

由于箭头函数没有自己的 this，所以当然也就不能用 call()、apply()、bind()这些方法去改变 this 的指向

### 不适用场合

第一个场合是定义对象的方法，且该方法内部包括 this

```javascript
const cat = {
  lives: 9,
  jumps: () => {
    // xxxxx
    this.lives--;
  },
};
```

第二个场合是需要动态 this 的时候，也不应使用箭头函数

```javascript
var button = document.getElementById('press');
button.addEventListener('click', () => {
  // xxxxx
  this.classList.toggle('on');
});
```

## 尾调用优化

尾调用（Tail Call）是函数式编程的一个重要概念，本身非常简单，一句话就能说清楚，就是指某个函数的最后一步是调用另一个函数

```javascript
function f(x) {
  return g(x);
}
```

以下三种情况，都不属于尾调用

```javascript
// 情况一
function f(x) {
  let y = g(x);
  return y;
}

// 情况二
function f(x) {
  return g(x) + 1;
}

// 情况三
function f(x) {
  g(x);
}
```

“尾调用优化”（Tail call optimization），即只保留内层函数的调用帧。注意，目前只有 Safari 浏览器支持尾调用优化，Chrome 和 Firefox 都不支持。

### 尾递归

函数调用自身，称为递归。如果尾调用自身，就称为尾递归。

```javascript
function factorial(n) {
  if (n === 1) return 1;
  return n * factorial(n - 1);
}

factorial(5); // 120
```

上面代码是一个阶乘函数，计算 n 的阶乘，最多需要保存 n 个调用记录，复杂度 O(n) 。如果改写成尾递归，只保留一个调用记录，复杂度 O(1) 。

```javascript
function factorial(n, total) {
  if (n === 1) return total;
  return factorial(n - 1, n * total);
}

factorial(5, 1); // 120
```

### 递归函数的改写

```javascript
function tailFactorial(n, total) {
  if (n === 1) return total;
  return tailFactorial(n - 1, n * total);
}

function factorial(n) {
  return tailFactorial(n, 1);
}

factorial(5); // 120
```

函数式编程有一个概念，叫做柯里化（currying），意思是将多参数的函数转换成单参数的形式。

```javascript
function currying(fn, n) {
  return function (m) {
    return fn.call(this, m, n);
  };
}

function tailFactorial(n, total) {
  if (n === 1) return total;
  return tailFactorial(n - 1, n * total);
}

const factorial = currying(tailFactorial, 1);

factorial(5); // 120
```

```javascript
function factorial(n, total = 1) {
  if (n === 1) return total;
  return factorial(n - 1, n * total);
}

factorial(5); // 120
```

## 函数参数的尾逗号

ES2017 允许函数的最后一个参数有尾逗号

```javascript
function clownsEverywhere(param1, param2) {
  /* ... */
}
```

## Funtion.prototype.toString()

toString()方法返回函数代码本身,
ES2019 的函数实例的 toString()方法会要求返回一模一样的原始代码。

## catch 命令的参数省略

ES2019 允许 catch 语句省略参数
