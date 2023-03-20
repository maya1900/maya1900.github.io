---
title: 关于三道手写题求解
tags:
  - js
categories: js
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/5836a17eb9e7f5c4e2974b18f79717c0.png
date: 2023-03-20 16:00:00
---

## 前言

去一家公司面试，给了三道手写题，当时有点蒙，三道写了一道，还觉得自己是对的，回来一看发现，其实每道题需要一点技巧，简单的竟然是第三道。

## 1. 封装一个方法，解决数组去重：

```jsx
var list = [
  { a: 1, b: 2 },
  { b: 2, a: 1 },
  { a: 1, b: 2, c: { a: 1, b: 2 } },
  { b: 2, a: 1, c: { b: 2, a: 1 } },
];
var newlist = [
  { a: 1, b: 2 },
  { a: 1, b: 2, c: { a: 1, b: 2 } },
];
```

乍一看，数组去重，里面嵌套的是对象，但是顺序不对。当时一想数组循环，再对象循环？不对。回来才想到，需要先排序对象属性，在转化为字符串判断属性不得了吗？

同时还要对如果值是对象还得递归。

代码：

```jsx
function uniqueArray(arr) {
  const res = [];
  const map = {};
  for (const item of arr) {
    let stringifyItem = item;
    if (typeof item === 'object') {
      if (Array.isArray(item)) {
        stringifyItem = JSON.stringify(item);
      } else {
        stringifyItem = sortKey(item);
      }
    }
    if (!map[stringifyItem]) {
      map[stringifyItem] = true;
      res.push(item);
    }
  }
  return res;
}
function sortKey(obj) {
  const newObj = {};
  Object.keys(obj)
    .sort()
    .forEach((key) => {
      const item = obj[key];
      let stringifyItem = item;
      if (typeof item === 'object') {
        if (Array.isArray(item)) {
          stringifyItem = JSON.stringify(item);
        } else {
          stringifyItem = sortKey(item);
        }
      }
      newObj[key] = stringifyItem;
    });
  return JSON.stringify(newObj);
}
var list = [
  { a: 1, b: 2 },
  { b: 2, a: 1 },
  { a: 1, b: 2, c: { a: 1, b: 2 } },
  { b: 2, a: 1, c: { b: 2, a: 1 } },
];

var uniqueList = uniqueArray(list);
console.log(uniqueList); // [{ a: 1, b: 2 }, { a: 1, b: 2, c: { a: 1, b: 2}}]
```

## 2. 封装一个方法，求得后面的值。

```jsx
function add() {}
add(1); // 1
add(1)(2); // 3
add(1)(2)(3); // 6
add(1)(2)(3)(10); // 16
```

当时还以为是要写柯里化呢，写了一个还磕磕绊绊，回来发现其实我做错了。。人家是想封装这个加法的函数

然后这个看了一下才懂，需要改写 toString 或者 valueOf 的方法，使用加法运算符时调用从而返回想要的值。

哎，没做对啊。。。

```jsx
function add(x) {
  var sum = x;
  function innerAdd(y) {
    sum += y;
    return innerAdd;
  }
  innerAdd.toString = function () {
    return sum;
  };
  return innerAdd;
}

console.log(+add(1)); // 1
console.log(+add(1)(2)); // 3
console.log(+add(1)(2)(3)); // 6
console.log(+add(1)(2)(3)(10)); // 16
```

## 3. 封装一个方法，转成树状结构。

```jsx
const data = [
  { id: 1, pid: 0, value: '浙江省' },
  { id: 11, pid: 1, value: '杭州市' },
  { id: 12, pid: 1, value: '宁波市' },
  { id: 111, pid: 11, value: '西湖区' },
  { id: 2, pid: 0, value: '江苏省' },
  { id: 21, pid: 2, value: '苏州市' },
];
```

这个题其实很简单的，当时怎么想的呢？想着定义一个对象，然后怎么嵌套 children 呢？害，脑子被糊住了。。

其实就是定义对象后，遍历数组，把 id 属性的值设为 item，再遍历数组，判断 pid，为每个有 pid 的加上它的 children。

代码：

```jsx
function arrToTree(data) {
  const res = [];
  const map = {};
  data.forEach((item) => {
    map[item.id] = item;
  });
  data.forEach((item) => {
    let parent = map[item.pid];
    if (parent) {
      (parent.children || (parent.children = [])).push(item);
    } else {
      res.push(item);
    }
  });
  return res;
}
const data = [
  { id: 1, pid: 0, value: '浙江省' },
  { id: 11, pid: 1, value: '杭州市' },
  { id: 12, pid: 1, value: '宁波市' },
  { id: 111, pid: 11, value: '西湖区' },
  { id: 2, pid: 0, value: '江苏省' },
  { id: 21, pid: 2, value: '苏州市' },
];
console.log(JSON.stringify(arrToTree(data))); // [{ "id": 1, "pid": 0, "value": "浙江省", "children": [{ "id": 11, "pid": 1, "value": "杭州市", "children": [{ "id": 111, "pid": 11, "value": "西湖区" }] }, { "id": 12, "pid": 1, "value": "宁波市" }] }, { "id": 2, "pid": 0, "value": "江苏省", "children": [{ "id": 21, "pid": 2, "value": "苏州市" }] }]
```

## 总结

都需要一点技巧，还是想的太少，想的太少，想的太少。。
