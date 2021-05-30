---
title: 复习ES6(三)：字符串的扩展 
date: 2021-05-30 
tags:
- js
- es6
categories: js
cover: https://z3.ax1x.com/2021/05/30/2VB1zR.jpg
---

- 字符串的 unicode 表示法
- 字符串的遍历
- 字符串的分隔符
- 模板字符串
- 模板编译(暂跳过)
- 标签模板(暂跳过)
- 字符串的新增方法
  - String.fromCodePoint() unicode 码返回对应字符
  - String.raw() 还原原生 string 对象
  - str.codePointAt() 返回字符串的 unicode 码
  - uni.normalize() unicode 正规化，识别欧洲语言
  - str.includes()/str.startsWith()/str.endsWith() 字符串是否包含
  - str.repeat(n) 将字符串重复 n 次
  - str.padStart()/str.padEnd() 字符串补全
  - str.trimStart()/str.trimEnd() 消除首/尾空格
  - str.matchAll() 返回正则在当前字符的所有匹配
  - str.replaceAll() 一次替换所有匹配

ES6 加强了对 Unicode 的支持，允许采用\uxxxx 形式表示一个字符，其中 xxxx 表示字符的 Unicode 码点

```javascript
'\u0061';
// "a"
```

但是，这种表示法只限于码点在\u0000~\uFFFF 之间的字符。超出这个范围的字符，必须用两个双字节的形式表示。
ES6 对这一点做出了改进，只要将码点放入大括号，就能正确解读该字符

```javascript
'\u{1F680}' === '\uD83D\uDE80';
// true
```

有了这种表示法之后，JavaScript 共有 6 种方法可以表示一个字符。

```javascript
'z' === 'z'; // true
'\172' === 'z'; // true
'\x7A' === 'z'; // true
'\u007A' === 'z'; // true
'\u{7A}' === 'z'; // true
```

es6 中可以使用 for...of 进行遍历：

```javascript
for (let codePoint of 'foo') {
  console.log(codePoint);
}
// "f"
// "o"
// "o"
```

```javascript
let text = String.fromCodePoint(0x20bb7);

for (let i = 0; i < text.length; i++) {
  console.log(text[i]);
}
// " "
// " "

for (let i of text) {
  console.log(i);
}
// "𠮷"
```

JavaScript 规定有 5 个字符，不能在字符串里面直接使用，只能使用转义形式。
U+005C：反斜杠（reverse solidus)
U+000D：回车（carriage return）
U+2028：行分隔符（line separator）
U+2029：段分隔符（paragraph separator）
U+000A：换行符（line feed）
但 JSON 格式允许字符串里面直接使用 U+2028（行分隔符）和 U+2029（段分隔符），为了消除这个报错，ES2019 允许 JavaScript 字符串直接输入 U+2028（行分隔符）和 U+2029（段分隔符）

模板字符串支持插入变量，表达式，函数，甚至可以嵌套。

String.fromCodePoint()与 String.fromCharCode()类似，不同是可以返回识别码点大于 0xFFFF 的字符。

```javascript
String.fromCodePoint(0x20bb7);
// "𠮷"
String.fromCodePoint(0x78, 0x1f680, 0x79) === 'x\uD83D\uDE80y';
// true
```

注意，fromCodePoint 方法定义在 String 对象上，而 codePointAt 方法定义在字符串的实例对象上。

ES6 还为原生的 String 对象，提供了一个 raw()方法，该方法返回一个斜杠都被转义（即斜杠前面再加一个斜杠）的字符串，往往用于模板字符串的处理方法

```javascript
String.raw`Hi\n${2 + 3}!`;
// 实际返回 "Hi\\n5!"，显示的是转义后的结果 "Hi\n5!"

String.raw`Hi\u000A!`;
// 实际返回 "Hi\\u000A!"，显示的是转义后的结果 "Hi\u000A!"
```

```javascript
var s = '𠮷';

s.length; // 2
s.charAt(0); // ''
s.charAt(1); // ''
s.charCodeAt(0); // 55362
s.charCodeAt(1); // 57271
s.codePointAt(0); // 134071
s.codePointAt(1); // 57271
```

```javascript
let s = '𠮷a';

s.codePointAt(0).toString(16); // "20bb7"
s.codePointAt(2).toString(16); // "61"
```

codePointAt()方法是测试一个字符由两个字节还是由四个字节组成的最简单方法。

```javascript
function is32Bit(c) {
  return c.codePointAt(0) > 0xffff;
}

is32Bit('𠮷'); // true
is32Bit('a'); // false
```

```javascript
'x'.padStart(5, 'ab'); // 'ababx'
'x'.padStart(4, 'ab'); // 'abax'

'x'.padEnd(5, 'ab'); // 'xabab'
'x'.padEnd(4, 'ab'); // 'xaba'
```

padStart()的常见用途是为数值补全指定位数

```javascript
'12'.padStart(10, '0'); // "0000000012"
'123456'.padStart(10, '0'); // "0000123456"
```

另一个用途是提示字符串格式

```javascript
'12'.padStart(10, 'YYYY-MM-DD'); // "YYYY-MM-12"
'09-12'.padStart(10, 'YYYY-MM-DD'); // "YYYY-09-12"
```

ES2021 引入了 replaceAll()方法，可以一次性替换所有匹配。

```javascript
'aabbcc'.replaceAll('b', '_');
// 'aa__cc'
```

replaceAll()的第二个参数 replacement 是一个字符串，表示替换的文本，其中可以使用一些特殊字符串

```javascript
// $& 表示匹配的字符串，即`b`本身
// 所以返回结果与原字符串一致
'abbc'.replaceAll('b', '$&');
// 'abbc'

// $` 表示匹配结果之前的字符串
// 对于第一个`b`，$` 指代`a`
// 对于第二个`b`，$` 指代`ab`
'abbc'.replaceAll('b', '$`');
// 'aaabc'

// $' 表示匹配结果之后的字符串
// 对于第一个`b`，$' 指代`bc`
// 对于第二个`b`，$' 指代`c`
'abbc'.replaceAll('b', `$'`);
// 'abccc'

// $1 表示正则表达式的第一个组匹配，指代`ab`
// $2 表示正则表达式的第二个组匹配，指代`bc`
'abbc'.replaceAll(/(ab)(bc)/g, '$2$1');
// 'bcab'

// $$ 指代 $
'abc'.replaceAll('b', '$$');
// 'a$c'
```

replaceAll()的第二个参数 replacement 除了为字符串，也可以是一个函数

```javascript
'aabbcc'.replaceAll('b', () => '_');
// 'aa__cc'
```

这个替换函数可以接受多个参数。第一个参数是捕捉到的匹配内容，第二个参数捕捉到是组匹配（有多少个组匹配，就有多少个对应的参数）。此外，最后还可以添加两个参数，倒数第二个参数是捕捉到的内容在整个字符串中的位置，最后一个参数是原字符串。

```javascript
const str = '123abc456';
const regex = /(\d+)([a-z]+)(\d+)/g;

function replacer(match, p1, p2, p3, offset, string) {
  return [p1, p2, p3].join(' - ');
}

str.replaceAll(regex, replacer);
// 123 - abc - 456
```
