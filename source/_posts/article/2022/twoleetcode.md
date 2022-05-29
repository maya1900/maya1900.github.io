---
title: 两道leetcode题学到的
date: 2022-05-29
tags:
  - 算法
  - js
categories: 算法
cover: https://gitlab.com/maya1900/pic/-/raw/main/img/29_20_33_52_202205292033319.jpg
---

面试时有被这两题难到，于是特地找到了题，学习方法。

## leetcode43：字符串相乘

[43. 字符串相乘 - 力扣（LeetCode）](https://leetcode.cn/problems/multiply-strings/)

![](https://gitlab.com/maya1900/pic/-/raw/main/img/29_18_40_39_202205291840826.png)

初次拿到有点无从下手，不准用 bigInt，直接相乘肯定是科学计数法。

看了一些题解，使用我们小学计算时的竖式计算，看如何用编程的方式呢？

几个特点：

- 单个数字相乘最大只有 9x9=81；
- 两个数相乘后的数字长度 ≤ 两个数字长度相加
- 个位数是乘积%10，十位是乘积/10
- 把字符串拆分成数组，**`num1[i]`\*\*** 和 \***\*`num2[j]`\*\*** 的乘积对应的就是 \***\*`res[i+j]`\*\*** 和 \***\*`res[i+j+1]`\*\*** 这两个位置\*\*

```JavaScript
var multiply = function(num1, num2) {
  if (num1 === '0' || num2 === '0') {
    return '0'
  }
  var l1 = num1.length, l2 = num2.length, p = new Array(l1 + l2).fill(0)
  for (var i = l1;i--;) {
    for (var j = l2;j--;) {
      var tmp = num1[i] * num2[j] + p[i + j + 1]
      p[i + j + 1] = tmp % 10
      p[i + j] += 0 | tmp / 10
    }
  }
  while (p[0] === 0) {
    p.shift()
  }
  return p.join('')
}
```

这里有两个点：

- for 循环里的`i—`与`j—`，进入循环`i—`，正好`length - 1`对应数组下标；当`i—`为 1 时，i 变成 0，走最后一轮循环；`i—`为 0 时，判断条件为假，退出循环；
- `|`js 中 or 运算符，当数值为小数时会忽略小数部分，`0 | 任何数`都是在取整，效率高于`parseInt`

## leetcode165：比较版本号

[165. 比较版本号 - 力扣（LeetCode）](https://leetcode.cn/problems/compare-version-numbers/)

![](https://gitlab.com/maya1900/pic/-/raw/main/img/29_19_57_18_202205291957301.png)

思考：比较版本号，拆分数组比较每个对应下标的数字哪个大。

思考一：

1. 判断哪个长度长，for 循环
2. 对比对应数字，返回对应判断，超出补 0 判断
3. 都没有返回 0

思考二：

1. 判断哪个长度长，while 循环
2. 用 shift 取数字，满足条件做判断返回相应数字
3. 数组有剩下的，判断是否每位是 0，返回对应数字。

- 题解一：

```JavaScript
var compareVersion = function(version1, version2) {
    var arr1 = version1.split('.')
    var arr2 = version2.split('.')
    for (var i = 0; i < arr1.length || i < arr2.length; i++) {
        var n1 = arr1[i] ? arr1[i] * 1 : 0
        var n2 = arr2[i] ? arr2[i] * 1 : 0
        if (n1 > n2) return 1
        if (n1 < n2) return -1
    }
    return 0
};
```

- 题解二：

```JavaScript
var compareVersion = function(version1, version2) {
    var arr1 = version1.split('.')
    var arr2 = version2.split('.')
    while (arr1.length && arr2.length) {
        var n1 = arr1.shift() * 1
        var n2 = arr2.shift() * 1
        if (n1 > n2) return 1
        if (n1 < n2) return -1
    }
    if (arr1.length) return arr1.every(item => item * 1 === 0) ? 0 : 1
    if (arr2.length) return arr2.every(item => item * 1 === 0) ? 0 : -1
    return 0
};
```

题解二巧用 while 循环和 shift()处理数组，思路很好。
