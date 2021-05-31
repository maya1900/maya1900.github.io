---
title: 复习ES6(四)：数值的扩展
date: 2021-05-30
tags:
  - js
  - es6
categories: js
cover: https://z3.ax1x.com/2021/05/31/2mI0xI.jpg
---

### 二进制与八进制表示法

ES6 提供了二进制和八进制数值的新的写法，分别用前缀 0b（或 0B）和 0o（或 0O）表示

```javascript
0b111110111 === 503; // true
0o767 === 503; // true
```

### Number.isFinite()/Number.isNaN()

Number.isFinite()用来检查一个数值是否为有限的（finite），即不是 Infinity.

如果参数类型不是数值，Number.isFinite 一律返回 false

```javascript
Number.isFinite(15); // true
Number.isFinite(0.8); // true
Number.isFinite(Infinity); // false
Number.isFinite(-Infinity); // false
Number.isFinite('foo'); // false
Number.isFinite('15'); // false
```

Number.isNaN()用来检查一个值是否为 NaN

它们与传统的全局方法 isFinite()和 isNaN()的区别在于，传统方法先调用 Number()将非数值的值转为数值，再进行判断，而这两个新方法只对数值有效

```javascript
isFinite(25); // true
isFinite('25'); // true
Number.isFinite(25); // true
Number.isFinite('25'); // false

isNaN(NaN); // true
isNaN('NaN'); // true
Number.isNaN(NaN); // true
Number.isNaN('NaN'); // false
```

### Number.parseInt(), Number.parseFloat()

ES6 将全局方法 parseInt()和 parseFloat()，移植到 Number 对象上面，行为完全保持不变

### Number.isInteger()

Number.isInteger()用来判断一个数值是否为整数

### Number.EPSILON

常量，根据规格，它表示 1 与大于 1 的最小浮点数之间的差

Number.EPSILON 实际上是 JavaScript 能够表示的最小精度。引入一个这么小的量的目的，在于为浮点数计算，设置一个误差范围。

Number.EPSILON 可以用来设置“能够接受的误差范围”。比如，误差范围设为 2 的-50 次方（即 Number.EPSILON \* Math.pow(2, 2)），即如果两个浮点数的差小于这个值，我们就认为这两个浮点数相等

```javascript
function withinErrorMargin(left, right) {
  return Math.abs(left - right) < Number.EPSILON * Math.pow(2, 2);
}

0.1 + 0.2 === 0.3; // false
withinErrorMargin(0.1 + 0.2, 0.3); // true
```

### 安全整数和 Number.isSafeInteger()

JavaScript 能够准确表示的整数范围在-2^53 到 2^53 之间（不含两个端点），超过这个范围，无法精确表示这个值。

ES6 引入了 Number.MAX_SAFE_INTEGER 和 Number.MIN_SAFE_INTEGER 这两个常量，用来表示这个范围的上下限

Number.isSafeInteger()则是用来判断一个整数是否落在这个范围之内。

```javascript
Number.isSafeInteger(9007199254740990); // true
Number.isSafeInteger(9007199254740992); // false
```

### Math 对象的扩展

### 指数运算符

ES2016 新增了一个指数运算符（\*\* ）

```javascript
2 ** 2; // 4
2 ** 3; // 8
```

### BigInt 数据类型

为了与 Number 类型区别，BigInt 类型的数据必须添加后缀 n

```javascript
const a = 2172141653n;
const b = 15346349309n;

// BigInt 可以保持精度
a * b; // 33334444555566667777n

// 普通整数无法保持精度
Number(a) * Number(b); // 33334444555566670000
```

### BigInt 对象

```javascript
BigInt(123); // 123n
BigInt('123'); // 123n
BigInt(false); // 0n
BigInt(true); // 1n
```

```javascript
Boolean(0n); // false
Boolean(1n); // true
Number(1n); // 1
String(1n); // "1"
```
