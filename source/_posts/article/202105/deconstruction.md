---
title: 复习ES6(二): 变量的解构
date: 2021-05-30 
- js
- es6
categories: js
cover: https://z3.ax1x.com/2021/05/30/2V0xqf.jpg
---

- 数组解构
- 对象解构
- 对象解构的机制
- 对象解构的嵌套
- 对象解构的继承
- 字符串的解构
- 函数参数的解构
- 解构的用途\*
  - 交换变量
  - 函数多个返回值
  - 函数参数的定义
  - 提取 json 数据
  - 函数参数默认值
  - 遍历 map 结构
  - 输入模块的指定方法

```javascript
let [a, b, c] = [1, 2, 3];
```

只要某种数据结构具有 Iterator 接口，都可以采用数组形式的解构赋值。

ES6 内部使用严格相等运算符，判断一个位置是否有值。所以，只有当一个数组成员严格等于 undefined，默认值才会生效。

```javascript
let { foo, bar } = { foo: 'aaa', bar: 'bbb' };
foo; // "aaa"
bar; // "bbb"
```

对象的解构与数组有一个重要的不同。数组的元素是按次序排列的，变量的取值由它的位置决定；而对象的属性没有次序，变量必须与属性同名，才能取到正确的值。

```javascript
let { foo: baz } = { foo: 'aaa', bar: 'bbb' };
baz; // "aaa"
foo; // error: foo is not defined
```

对象的解构赋值的内部机制，是先找到同名属性，然后再赋给对应的变量。真正被赋值的是后者，而不是前者。

```javascript
let obj = {
  p: ['Hello', { y: 'World' }],
};
let {
  p: [x, { y }],
} = obj;
x; // "Hello"
y; // "World"
```

这时 p 是模式，不是变量，因此不会被赋值。如果 p 也要作为变量赋值，可以写成下面这样

```javascript
let obj = {
  p: ['Hello', { y: 'World' }],
};
let {
  p,
  p: [x, { y }],
} = obj;
x; // "Hello"
y; // "World"
p; // ["Hello", {y: "World"}]
```

```javascript
const obj1 = {};
const obj2 = { foo: 'bar' };
Object.setPrototypeOf(obj1, obj2);

const { foo } = obj1;
foo; // "bar"
```

对象的解构赋值可以取到继承的属性。

```javascript
const [a, b, c, d, e] = 'hello';
a; // "h"
b; // "e"
c; // "l"
d; // "l"
e; // "o"
```

字符串被转换成了一个类似数组的对象。

```javascript
function add([x, y]) {
  return x + y;
}

add([1, 2]); // 3
```

函数的参数也可以使用解构赋值

```javascript
function move({ x = 0, y = 0 } = {}) {
  return [x, y];
}

move({ x: 3, y: 8 }); // [3, 8]
move({ x: 3 }); // [3, 0]
move({}); // [0, 0]
move(); // [0, 0]
```

```javascript
function move({ x, y } = { x: 0, y: 0 }) {
  return [x, y];
}

move({ x: 3, y: 8 }); // [3, 8]
move({ x: 3 }); // [3, undefined]
move({}); // [undefined, undefined]
move(); // [0, 0]
```

以上两条的不同在于，上一条是为参数的 x,y 进行解构；下一条是为整个参数指定默认值

1. 交换变量

```javascript
let x = 1;
let y = 2;

[x, y] = [y, x];
```

2. 函数多个返回值

```javascript
function example() {
  return {
    foo: 1,
    bar: 2,
  };
}
let { foo, bar } = example();
```

3. 函数参数的定义

```javascript
// 参数是一组无次序的值
function f({x, y, z}) { ... }
f({z: 3, y: 2, x: 1});
```

4. 提取 json 数据

```javascript
let jsonData = {
  id: 42,
  status: 'OK',
  data: [867, 5309],
};

let { id, status, data: number } = jsonData;
console.log(id, status, number);
// 42, "OK", [867, 5309]
```

5. 函数参数默认值

```javascript
jQuery.ajax = function (
  url,
  {
    async = true,
    beforeSend = function () {},
    cache = true,
    complete = function () {},
    crossDomain = false,
    global = true,
    // ... more config
  } = {}
) {
  // ... do stuff
};
```

6. 遍历 map 结构

任何部署了 Iterator 接口的对象，都可以用 for...of 循环遍历

```javascript
const map = new Map();
map.set('first', 'hello');
map.set('second', 'world');

for (let [key, value] of map) {
  console.log(key + ' is ' + value);
}
// first is hello
// second is world
```

```javascript
// 获取键名
for (let [key] of map) {
  // ...
}

// 获取键值
for (let [, value] of map) {
  // ...
}
```

7. 输入模块的指定方法

```javascript
const { SourceMapConsumer, SourceNode } = require('source-map');
```
