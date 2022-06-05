---
title: js函数式编程
date: 2022-06-05
tags:
  - js
categories: js
cover: https://gitlab.com/maya1900/pic/raw/main/img/6_7_43_3_202206060743022.jpg
---

# 函数式编程是什么？

函数式编程是一种编程范式，利用函数把运算过程封装起来，通过组合各种函数来得到结果。

> 编程范式：某种语言典型的编程风格或编程方式。常见的有：命令式编程、声明式编程、面向对象编程、函数式编程等。

# 为什么用函数式编程

1. 减少代码重复，提高开发速度
2. 接近自然语言，易于理解
3. 代码解耦，方便管理
4. 互不干扰，易于“并发编程”

# 函数是“一等公民”

“一等公民”指的是函数和其他数据类型一样，处于平等地位。可以赋值给其他变量，也可以作为参数，传入另一个函数，或者作为函数的返回值。

# 纯函数

相同的输入，一定产生相同的输出，并且在执行过程中，不产生副作用。

> 副作用：在执行函数时，除了产生返回值以外，还产生了其他附加的影响，比如修改参数或其他外部存储等。

- slice 返回数组中指定的部分，是纯函数；
- splice 返回了新数组，但对原数组产生了影响，是不纯的函数

# 柯里化

只传递函数一部分参数来调用它，让它返回一个函数去处理剩余的参数。

```JavaScript
// 未柯里化
var add1 = function (x, y, z) {
  return x + y + z
}
// 柯里化
function add2 (x) {
  return function (y) {
    return function (z) {
      return x + y + z
    }
  }
}
console.log(add(10)(20)(30))
```

## 为什么用柯里化？

- 希望函数处理问题单一
- 可以在单一的函数中处理参数
- 复用参数逻辑

## 栗子：打印日志

```JavaScript
var log = date => type => message => {
  console.log(`[${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}][${type}][${message}]`);
}
var logNow = log(new Date());
logNow("DEBUG")("点击无效bug")

var logBug = log(new Date())("DEBUG");
logBug("轮播图bug")
```

## 自动柯里化

把一个普通函数转换为柯里化函数：

```JavaScript
function currying(fn) {
  function curried(...args) {
    if (args.length >= fn.length) {
      return fn.apply(this, args);
    } else {
      return function (...args2) {
        return curried.apply(this, [...args, ...args2]);
      }
    }
  }
  return curried
}
```

# 组合函数

顾名思义，把两个函数组合调用。类似洋葱代码 p(h(g(x)))

```JavaScript
function compose(fn1, fn2) {
  return function (x) {
    return fn1(fn2(x))
  }
}
function add(num) {
  return num + 1;
}
function mul(num) {
  return num * 2
}
console.log(compose(add, mul)(1));
```

# 参考：

[JS 与函数式编程 - SegmentFault 思否](https://segmentfault.com/a/1190000040774009?utm_source=sf-similar-article)

[函数式编程 | 高阶函数 | 纯函数 | 闭包 | 柯里化 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/430126285)
