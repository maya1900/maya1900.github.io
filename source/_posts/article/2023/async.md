---
title: async原理解析
tags:
  - js
categories: js
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/neko.png
date: 2023-03-14 09:00:12
---

async 用同步的方式，执行异步的操作，他是 generator 函数的语法糖。

## async 的用法

```jsx
function get(num) {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(num * 2);
    }, 1000);
  });
}
get(1).then((res1) => {
  console.log(res1); // 1s 输出2
  get(2).then((res2) => {
    console.log(res2); // 2s 输出4
  });
});
async function fn() {
  const res1 = await get(5);
  const res2 = await get(res1);
  console.log(res2); // 2s 输出20
}
fn();
```

async 执行完返回一个什么东西呢？

```jsx
async function fn() {}
console.log(fn); // [AsyncFunction: fn]
console.log(fn()); // Promise {<fulfilled>: undefined}
```

自动返回一个状态为 fulfilled 的 Promise 对象，函数有返回值时返回返回值。

### 总结：

1. async 函数出现是为了优化 then 链式调用而存在；
2. await 只能在 async 函数中使用，不然报错；
3. async 返回一个 Promise 对象，有无值看有无 return 值；

## generator 函数

和普通函数的区别是多了一个星号。

### 基本用法

```jsx
function* gen() {
  yield 1;
  yield 2;
  yield 3;
}
const g = gen(); // 只是调用没有向下执行
console.log(g.next()); // { value: 1, done: false }
console.log(g.next()); // { value: 2, done: false }
console.log(g.next()); // { value: 3, done: false }
console.log(g.next()); // { value: undefined, done: true }
```

第一次调用 g=gen()时函数没有继续向下执行，只有是 next 的时候才会执行 yield 和之前的语句。

最后一个是 undefined，这取决于你 generator 函数有无返回值

```jsx
function* gen() {
  yield 1;
  yield 2;
  yield 3;
  return 4;
}
const g = gen();
console.log(g.next()); // { value: 1, done: false }
console.log(g.next()); // { value: 2, done: false }
console.log(g.next()); // { value: 3, done: false }
console.log(g.next()); // { value: 4, done: true }
```

### yield 后面接函数

yield 后面接函数的话，到了对应暂停点 yield，会马上执行此函数，并且该函数的执行返回值，会被当做此暂停点对象的`value`

```jsx
function fn(num) {
  console.log(num);
  return num;
}
function* gen() {
  yield fn(1);
  yield fn(2);
  return 3;
}
const g = gen();
console.log(g.next());
// 1
// { value: 1, done: false }
console.log(g.next());
// 2
//  { value: 2, done: false }
console.log(g.next());
// { value: 3, done: true }
```

### yield 接 promise

函数执行返回值会当做暂停点对象的 value 值，前两个返回的都是 pending 状态的 promise 对象。

```jsx
function fn(num) {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(num);
    }, 1000);
  });
}
function* gen() {
  yield fn(1);
  yield fn(2);
  return 3;
}
const g = gen();
console.log(g.next()); // { value: Promise { <pending> }, done: false }
console.log(g.next()); // { value: Promise { <pending> }, done: false }
console.log(g.next()); // { value: 3, done: true }
```

如果我们想得到对应的值怎么办呢？使用 then 方法就可以了：

```jsx
const g = gen();
const next1 = g.next();
next1.value.then((res1) => {
  console.log(next1); // 1秒后输出 { value: Promise { 1 }, done: false }
  console.log(res1); // 1秒后输出 1

  const next2 = g.next();
  next2.value.then((res2) => {
    console.log(next2); // 2秒后输出 { value: Promise { 2 }, done: false }
    console.log(res2); // 2秒后输出 2
    console.log(g.next()); // 2秒后输出 { value: 3, done: true }
  });
});
```

### next 方法传参

next 方法可以传参，执行顺序是先执行 yield，后左边接受参数。

```jsx
function* gen() {
  const num1 = yield 1;
  console.log(num1);
  const num2 = yield 2;
  console.log(num2);
  return 3;
}
const g = gen();
console.log(g.next());
// { value: 1, done: false }
console.log(g.next(11));
// 11
//  { value: 2, done: false }
console.log(g.next(22));
// 22
// { value: 3, done: true }
```

### promise 和 next 传参

```jsx
function fn(nums) {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(nums * 2);
    }, 1000);
  });
}
function* gen() {
  const num1 = yield fn(1);
  const num2 = yield fn(num1);
  const num3 = yield fn(num2);
  return num3;
}
const g = gen();
const next1 = g.next();
next1.value.then((res1) => {
  console.log(next1); // 1秒后同时输出 { value: Promise { 2 }, done: false }
  console.log(res1); // 1秒后同时输出 2

  const next2 = g.next(res1); // 传入上次的res1
  next2.value.then((res2) => {
    console.log(next2); // 2秒后同时输出 { value: Promise { 4 }, done: false }
    console.log(res2); // 2秒后同时输出 4

    const next3 = g.next(res2); // 传入上次的res2
    next3.value.then((res3) => {
      console.log(next3); // 3秒后同时输出 { value: Promise { 8 }, done: false }
      console.log(res3); // 3秒后同时输出 8

      // 传入上次的res3
      console.log(g.next(res3)); // 3秒后同时输出 { value: 8, done: true }
    });
  });
});
```

## 实现 async/await

```jsx
function generatorToAsync(generatorFn) {
  return function () {
    const gen = generatorFn.apply(this, arguments); // gen有可能传参

    // 返回一个Promise
    return new Promise((resolve, reject) => {
      function go(key, arg) {
        let res;
        try {
          res = gen[key](arg); // 这里有可能会执行返回reject状态的Promise
        } catch (error) {
          return reject(error); // 报错的话会走catch，直接reject
        }

        // 解构获得value和done
        const { value, done } = res;
        if (done) {
          // 如果done为true，说明走完了，进行resolve(value)
          return resolve(value);
        } else {
          // 如果done为false，说明没走完，还得继续走

          // value有可能是：常量，Promise，Promise有可能是成功或者失败
          return Promise.resolve(value).then(
            (val) => go('next', val),
            (err) => go('throw', err)
          );
        }
      }

      go('next'); // 第一次执行
    });
  };
}
```

```jsx
function fn(nums) {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(nums * 2);
    }, 1000);
  });
}
```

### 实例：

async/await 版本

```jsx
async function asyncFn() {
  const num1 = await fn(1);
  console.log(num1); // 2
  const num2 = await fn(num1);
  console.log(num2); // 4
  const num3 = await fn(num2);
  console.log(num3); // 8
  return num3;
}
const asyncRes = asyncFn();
console.log(asyncRes); // Promise
asyncRes.then((res) => console.log(res)); // 8
```

generatorToAsync 函数版本：

```jsx
function* gen() {
  const num1 = yield fn(1);
  console.log(num1); // 2
  const num2 = yield fn(num1);
  console.log(num2); // 4
  const num3 = yield fn(num2);
  console.log(num3); // 8
  return num3;
}

const genToAsync = generatorToAsync(gen);
const asyncRes = genToAsync();
console.log(asyncRes); // Promise
asyncRes.then((res) => console.log(res)); // 8
```

### 补充：

generator 其实就是 JS 在语法层面对协程的支持，协程就是主程序和子协程直接控制权的切换，并伴随通信的过程，那么，从 generator 语法的角度来讲，yield，next 就是通信接口，next 是主协程向子协程通信，而 yield 就是子协程向主协程通信
