---
title: 由公式字体引发的...
date: 2022-05-01
tags:
  - 前端
  - js
categories: js
cover: https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/202205021237783.jpg
---

# 引言

      工作时遇到这样的字符串`𝑀𝑜𝑛𝑖𝑡𝑜𝑟𝐿𝑜𝑡𝑇𝑖𝑚𝑒2𝐷𝑢𝑒`，测试让把这样的字符串做判断，如果是需要做提示，可是这玩意无论粘贴到哪里都是原样输出，很让人费解。

      询问了一下出处，是在ppt里粘贴过来的，于是ppt里捣鼓了半天，发现不是字体的问题，反倒和ppt里插入公式的字体有点像，又尝试插入一样的字符，发现样子一毛一样，因此断定是测试给的是公式字体。

![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/gif-2022-05-02.gif)

      在“低调务实优秀中国好青年”群里问了之后，@windling同学给出了答案：[追本溯源：字符串及编码 (qq.com)](https://mp.weixin.qq.com/s/7DupviMKtmUroKVA1ygCrw)，我才刹那明白，原来是编码问题。

# js 的字符编码

      在计算机中由二进制来保存数据，所有数据由0和1组成，每个0或者1叫1bit—位，`1byte(字节)=8bits`，`1KB = 1024 bytes`，`1MB(兆) = 1024KB`，`1GB = 1024MB`，`1TB = 1024GB`。

      国际标准组织为了统一世界各国的字符，把它们都放在了张表里，为每个字符都分配一个数字，这就是Unicode码表，这样，每个字符都对应了唯一的数字，这些数字又叫做码点(Code Point)。

      在javascript中使用UCS-2编码（后整合进了UTF-16，故和UTF-16编码方式相同），即16个bit位两个字节来表示一个码点，这16个bit位叫做代码单元(码元，code unit)。那么这样两个字节能够表示的最大数是65535(16进制0xFFFF)，如果超过的话，则使用两个码元表示一个字符。

# js 的字符串操作

## 字符转码点/码元

      在js中应该如何获得这些数字呢？

```JavaScript
// str.charCodeAt(pos) 获得码元
// str.codePointAt(pos) 获得码点 pos表示str中字符的位置 不写默认第0位
'abc'.charCodeAt(1) // 98
'123'.charCodeAt() // 49
'abc'.codePointAt(1) // 98
'123'.codePointAt() // 49
'𠮷'.charCodeAt() // 55362
'𠮷'.codePointAt() // 134071

```

      可以看到，在65535以内码元和码点的值是一样的。遇到超过65535外的字符charCodeAt就不能正确转换了，它实际上用了两个码元来表示，而charCodeAt只返回了一个码元，codePointAt则能正确表示。而事实上codePointAt是ES6为了对Unicode字符的支持增加的，兼容了charCodeAt，后文提到的fromCodePoint也是一样。

## 码元/码点转字符

      那么对应的，也应该有码元码点转字符的方法：

```JavaScript
// String.fromCharCode(num1,num2,...) 码元获得字符
// String.fromCodePoint(num1, num2,...) 码点获得字符
String.fromCharCode(48, 49, 50) // 012
String.fromCodePoint(97, 98, 99) // abc

```

# 判断

      好了，有了以上知识，那么判断这样的字符也很简单：

```JavaScript
const str = '𝑀𝑜𝑛𝑖𝑡𝑜𝑟𝐿𝑜𝑡𝑇𝑖𝑚𝑒2𝐷𝑢𝑒';
for (let s of str) {
  if (s.codePointAt() > 0xffff) {
    console.log(`${s} is a special character`);
  } else {
    console.log(`${s} is a normal character`);
  }
}
```

# 公式字符的互转

      这样工作似乎完成了？好奇的我又想了，如果想转换为普通字符呢？

      首先我需要知道它们的码点值，以 𝑀 为例，`'𝑀'.codePointAt(0) `拿到了它的码点是119872，那么一个普通字母M的码点值是77，相减得到一个差值，那么所有的大写字母不就都可以互相转换了吗？相应的小写字母也是如此。

```JavaScript
// 转普通字符
const str = '𝑀𝑜𝑛𝑖𝑡𝑜𝑟𝐿𝑜𝑡𝑇𝑖𝑚𝑒2𝐷𝑢𝑒';
function toNormalStr(str) {
  const result = [];
  for (const s of str) {
    const t = s.codePointAt();
    if (t >= 0x1d434 && t <= 0x1d44d) {
      result.push(String.fromCharCode(t - 119795));
    } else if (t >= 0x1d44e && t <= 0x1d467) {
      result.push(String.fromCharCode(t - 119789));
    } else {
      result.push(s);
    }
  }
  return result.join('');
}
console.log(toNormalStr(str)); // MonitorLotTime2Due
```

```JavaScript
// 转公式字符
const str = 'MonitorLotTime2Due';
function toSpecialStr(str) {
  const result = [];
  for (const s of str) {
    const t = s.charCodeAt();
    if (t >= 65 && t <= 90) {
      result.push(String.fromCodePoint(119795 + t));
    } else if (t >= 97 && t <= 122) {
      result.push(String.fromCodePoint(119789 + t));
    } else {
      result.push(s);
    }
  }
  return result.join('');
}
console.log(toSpecialStr(str)); // 𝑀𝑜𝑛𝑖𝑡𝑜𝑟𝐿𝑜𝑡𝑇𝑖𝑚𝑒2𝐷𝑢𝑒
```

      至于其他的一些数学符号就不搞了，也都是找差值计算。。

      另外去找[Unicode 14.0 字符代码表](https://www.unicode.org/charts/)里的[Mathematical Alphanumeric Symbols](https://www.unicode.org/charts/PDF/U1D400.pdf) 数学字母数字符号，可以找到更多，在js里使用`'𝑀'.codePointAt(0).toString(16)`得到16进制的值，再去对应找字符。

## 其他的一些？

      知道了16进制转字符？ 如：`"\u{1D4A5}\u{1D4A6}\u{1D4A7}\u{1D4A8}".toString()` 得到 `'𝒥𝒦𝒧𝒨'`

      知道了16进制转码点？ 如：`'\u{1D44e}'.codePointAt()`获得`119886`

      知道了码点转16进制？ 如：`Number(119863).toString(16)` 获得 `'1d437'`



      又想到：js中使用UTF-16的编码方式，那么一个字母占2个字节？是的。这和我们认知的一个英文字母数字占1个字节，一个中文字符占2个字节不太一样。

# 参考

[追本溯源：字符串及编码 (qq.com)](https://mp.weixin.qq.com/s/7DupviMKtmUroKVA1ygCrw)

[ES6 字符串操作讲解](https://www.cnblogs.com/laraLee/p/9156807.html)

[Unicode 与 JavaScript 详解 - 阮一峰的网络日志 (ruanyifeng.com)](http://www.ruanyifeng.com/blog/2014/12/unicode.html)

[String - JavaScript | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/String)

      没了？这就没了？emm...
