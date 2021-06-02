---
title: 复习ES6(七)：对象的扩展
date: 2021-06-02
tags:
- es6
- js
categories: js
cover:
---

## 属性的简洁表示

S6 允许在大括号里面，直接写入变量和函数，作为对象的属性和方法。这样的书写更加简洁

``` javascript
const foo = 'bar';
const baz = {foo};
baz // {foo: "bar"}

// 等同于
const baz = {foo: foo};
```

``` javascript
const o = {
  method() {
    return "Hello!";
  }
};

// 等同于

const o = {
  method: function() {
    return "Hello!";
  }
};
```

简写的对象方法不能用作构造函数，会报错

## 属性名表达式

``` javascript
// 方法一
obj.foo = true;

// 方法二
obj['a' + 'bc'] = 123;
```

表达式还可以用于定义方法名

``` javascript
let obj = {
  ['h' + 'ello']() {
    return 'hi';
  }
};

obj.hello() // hi
```

属性名表达式与简洁表示法，不能同时使用，会报错

属性名表达式如果是一个对象，默认情况下会自动将对象转为字符串[object Object]

## 方法的name属性

函数的name属性，返回函数名。对象方法也是函数，因此也有name属性,方法的name属性返回函数名（即方法名）

如果对象的方法使用了取值函数（getter）和存值函数（setter），则name属性不是在该方法上面，而是该方法的属性的描述对象的get和set属性上面，返回值是方法名前加上get和set

``` javascript
const obj = {
  get foo() {},
  set foo(x) {}
};

obj.foo.name
// TypeError: Cannot read property 'name' of undefined

const descriptor = Object.getOwnPropertyDescriptor(obj, 'foo');

descriptor.get.name // "get foo"
descriptor.set.name // "set foo"
```

bind方法创造的函数，name属性返回bound加上原函数的名字；Function构造函数创造的函数，name属性返回anonymous。

## 属性的可枚举性和遍历

### 可枚举

对象的每个属性都有一个描述对象（Descriptor），用来控制该属性的行为。Object.getOwnPropertyDescriptor方法可以获取该属性的描述对象

``` javascript
let obj = { foo: 123 };
Object.getOwnPropertyDescriptor(obj, 'foo')
//  {
//    value: 123,
//    writable: true,
//    enumerable: true,
//    configurable: true
//  }
```

描述对象的enumerable属性，称为“可枚举性”，如果该属性为false，就表示某些操作会忽略当前属性

目前，有四个操作会忽略enumerable为false的属性。

for...in循环：只遍历对象自身的和继承的可枚举的属性。
Object.keys()：返回对象自身的所有可枚举的属性的键名。
JSON.stringify()：只串行化对象自身的可枚举的属性。
Object.assign()： 忽略enumerable为false的属性，只拷贝对象自身的可枚举的属性。

引入“可枚举”（enumerable）这个概念的最初目的，就是让某些属性可以规避掉for...in操作，不然所有内部属性和方法都会被遍历到

尽量不要用for...in循环，而用Object.keys()代替

### 属性的遍历

ES6 一共有 5 种方法可以遍历对象的属性。

（1）for...in

for...in循环遍历对象自身的和继承的可枚举属性（不含 Symbol 属性）。

（2）Object.keys(obj)

Object.keys返回一个数组，包括对象自身的（不含继承的）所有可枚举属性（不含 Symbol 属性）的键名。

（3）Object.getOwnPropertyNames(obj)

Object.getOwnPropertyNames返回一个数组，包含对象自身的所有属性（不含 Symbol 属性，但是包括不可枚举属性）的键名。

（4）Object.getOwnPropertySymbols(obj)

Object.getOwnPropertySymbols返回一个数组，包含对象自身的所有 Symbol 属性的键名。

（5）Reflect.ownKeys(obj)

Reflect.ownKeys返回一个数组，包含对象自身的（不含继承的）所有键名，不管键名是 Symbol 或字符串，也不管是否可枚举。

以上的 5 种方法遍历对象的键名，都遵守同样的属性遍历的次序规则。

首先遍历所有数值键，按照数值升序排列。
其次遍历所有字符串键，按照加入时间升序排列。
最后遍历所有 Symbol 键，按照加入时间升序排列。

``` javascript
Reflect.ownKeys({ [Symbol()]:0, b:0, 10:0, 2:0, a:0 })
// ['2', '10', 'b', 'a', Symbol()]
```

## super关键字

ES6 新增了另一个类似的关键字super，指向当前对象的原型对象

super关键字表示原型对象时，只能用在对象的方法之中，用在其他地方都会报错

目前，只有对象方法的简写法可以让 JavaScript 引擎确认，定义的是对象的方法。

``` javascript
const proto = {
  foo: 'hello'
};

const obj = {
  foo: 'world',
  find() {
    return super.foo;
  }
};

Object.setPrototypeOf(obj, proto);
obj.find() // "hello"
```

## 对象的扩展运算符

### 解构赋值

对象的解构赋值用于从一个对象取值，相当于将目标对象自身的所有可遍历的（enumerable）、但尚未被读取的属性，分配到指定的对象上面。所有的键和它们的值，都会拷贝到新对象上面

``` javascript
let { x, y, ...z } = { x: 1, y: 2, a: 3, b: 4 };
x // 1
y // 2
z // { a: 3, b: 4 }
```

解构赋值的拷贝是浅拷贝

扩展运算符的解构赋值，不能复制继承自原型对象的属性

``` javascript
let o1 = { a: 1 };
let o2 = { b: 2 };
o2.__proto__ = o1;
let { ...o3 } = o2;
o3 // { b: 2 }
o3.a // undefined
```

### 扩展运算符

对象的扩展运算符（...）用于取出参数对象的所有可遍历属性，拷贝到当前对象之中

``` javascript
let z = { a: 3, b: 4 };
let n = { ...z };
n // { a: 3, b: 4 }
```

对象的扩展运算符等同于使用Object.assign()方法

``` javascript
let aClone = { ...a };
// 等同于
let aClone = Object.assign({}, a);
```

如果想完整克隆一个对象，还拷贝对象原型的属性，可以采用下面的写法

``` javascript
// 写法一
const clone1 = {
  __proto__: Object.getPrototypeOf(obj),
  ...obj
};

// 写法二
const clone2 = Object.assign(
  Object.create(Object.getPrototypeOf(obj)),
  obj
);

// 写法三
const clone3 = Object.create(
  Object.getPrototypeOf(obj),
  Object.getOwnPropertyDescriptors(obj)
)
```

如果用户自定义的属性，放在扩展运算符后面，则扩展运算符内部的同名属性会被覆盖掉

``` javascript
let newVersion = {
  ...previousVersion,
  name: 'New Name' // Override the name property
};
```

如果把自定义属性放在扩展运算符前面，就变成了设置新对象的默认属性值

``` javascript
let aWithDefaults = { x: 1, y: 2, ...a };
// 等同于
let aWithDefaults = Object.assign({}, { x: 1, y: 2 }, a);
// 等同于
let aWithDefaults = Object.assign({ x: 1, y: 2 }, a);
```

## 链判断运算符

``` javascript
// 错误的写法
const  firstName = message.body.user.firstName;

// 正确的写法
const firstName = (message
  && message.body
  && message.body.user
  && message.body.user.firstName) || 'default';
```

``` javascript
const fooInput = myForm.querySelector('input[name=foo]')
const fooValue = fooInput ? fooInput.value : undefined
```

 ES2020 引入了“链判断运算符”（optional chaining operator）?.，简化上面的写法
 
 

``` javascript
const firstName = message?.body?.user?.firstName || 'default';
const fooValue = myForm.querySelector('input[name=foo]')?.value
```

``` javascript
链判断运算符有三种用法。

obj?.prop // 对象属性
obj?.[expr] // 同上
func?.(...args) // 函数或对象方法的调用
```

``` javascript
a?.b
// 等同于
a == null ? undefined : a.b

a?.[x]
// 等同于
a == null ? undefined : a[x]

a?.b()
// 等同于
a == null ? undefined : a.b()

a?.()
// 等同于
a == null ? undefined : a()
```

## Null判断运算符

``` javascript
const headerText = response.settings.headerText || 'Hello, world!';
const animationDuration = response.settings.animationDuration || 300;
const showSplashScreen = response.settings.showSplashScreen || true;
```

ES2020 引入了一个新的 Null 判断运算符??。它的行为类似||，但是只有运算符左侧的值为null或undefined时，才会返回右侧的值

``` javascript
const headerText = response.settings.headerText ?? 'Hello, world!';
const animationDuration = response.settings.animationDuration ?? 300;
const showSplashScreen = response.settings.showSplashScreen ?? true;
```

这个运算符的一个目的，就是跟链判断运算符?.配合使用，为null或undefined的值设置默认值。

``` javascript
const animationDuration = response.settings?.animationDuration ?? 300;
```

``` javascript
function Component(props) {
  const enable = props.enabled ?? true;
  // …
}
```

## Object.js()

相等运算符（ == ）和严格相等运算符（ === ）。它们都有缺点，前者会自动转换数据类型，后者的NaN不等于自身，以及+0等于-0

Object.is 用来比较两个值是否严格相等，与严格比较运算符（ === ）的行为基本一致。不同之处只有两个：一是+0不等于-0，二是NaN等于自身。

``` javascript
Object.is('foo', 'foo')
// true
Object.is({}, {})
// false
```

## Object.assign()

### 基本用法

Object.assign()方法用于对象的合并，将源对象（source）的所有可枚举属性，复制到目标对象（target）。

Object.assign()方法的第一个参数是目标对象，后面的参数都是源对象

### 注意

Object.assign()方法实行的是浅拷贝，而不是深拷贝。

一旦遇到同名属性，Object.assign()的处理方法是替换，而不是添加

Object.assign()可以用来处理数组，但是会把数组视为对象

Object.assign()只能进行值的复制，如果要复制的值是一个取值函数，那么将求值后再复制

### 常见用途

（1）为对象添加属性

``` javascript
class Point {
  constructor(x, y) {
    Object.assign(this, {x, y});
  }
}
```

（2）为对象添加方法

``` javascript
Object.assign(SomeClass.prototype, {
  someMethod(arg1, arg2) {
    ···
  },
  anotherMethod() {
    ···
  }
});

// 等同于下面的写法
SomeClass.prototype.someMethod = function (arg1, arg2) {
  ···
};
SomeClass.prototype.anotherMethod = function () {
  ···
};
```

（3）克隆对象

``` javascript
function clone(origin) {
  return Object.assign({}, origin);
}
```

采用这种方法克隆，只能克隆原始对象自身的值，不能克隆它继承的值。如果想要保持继承链，可以采用下面的代码

``` javascript
function clone(origin) {
  let originProto = Object.getPrototypeOf(origin);
  return Object.assign(Object.create(originProto), origin);
}
```

（4）合并多个对象

``` javascript
const merge =
  (target, ...sources) => Object.assign(target, ...sources);
```

（5）为属性指定默认值

``` javascript
const DEFAULTS = {
  logLevel: 0,
  outputFormat: 'html'
};

function processContent(options) {
  options = Object.assign({}, DEFAULTS, options);
  console.log(options);
  // ...
}
```

## Object.getOwnPropertyDescriptor()

ES5 的Object.getOwnPropertyDescriptor()方法会返回某个对象属性的描述对象（descriptor）。ES2017 引入了Object.getOwnPropertyDescriptors()方法，返回指定对象所有自身属性（非继承属性）的描述对象

``` javascript
const obj = {
  foo: 123,
  get bar() { return 'abc' }
};

Object.getOwnPropertyDescriptors(obj)
// { foo:
//    { value: 123,
//      writable: true,
//      enumerable: true,
//      configurable: true },
//   bar:
//    { get: [Function: get bar],
//      set: undefined,
//      enumerable: true,
//      configurable: true } }
```

该方法的引入目的，主要是为了解决Object.assign()无法正确拷贝get属性和set属性的问题

Object.getOwnPropertyDescriptors()方法配合Object.defineProperties()方法，就可以实现正确拷贝

``` javascript
const shallowMerge = (target, source) => Object.defineProperties(
  target,
  Object.getOwnPropertyDescriptors(source)
);
```

Object.getOwnPropertyDescriptors()方法的另一个用处，是配合Object.create()方法，将对象属性克隆到一个新对象。这属于浅拷贝

``` javascript
const clone = Object.create(Object.getPrototypeOf(obj),
  Object.getOwnPropertyDescriptors(obj));

// 或者

const shallowClone = (obj) => Object.create(
  Object.getPrototypeOf(obj),
  Object.getOwnPropertyDescriptors(obj)
);
```

Object.getOwnPropertyDescriptors()方法可以实现一个对象继承另一个对象。以前，继承另一个对象，常常写成下面这样。

``` javascript
const obj = {
  __proto__: prot,
  foo: 123,
};
```

``` javascript
const obj = Object.create(prot);
obj.foo = 123;

// 或者

const obj = Object.assign(
  Object.create(prot),
  {
    foo: 123,
  }
);
```

``` javascript
const obj = Object.create(
  prot,
  Object.getOwnPropertyDescriptors({
    foo: 123,
  })
);
```

##  \_\_proto\_\_ 属性,Object.setPrototypeOf(),Object.getPrototypeOf()

### \_\_proto__属性

\_\_proto__属性（前后各两个下划线），用来读取或设置当前对象的原型对象（prototype）

``` javascript
// es5 的写法
const obj = {
  method: function() { ... }
};
obj.__proto__ = someOtherObj;

// es6 的写法
var obj = Object.create(someOtherObj);
obj.method = function() { ... };
```

无论从语义的角度，还是从兼容性的角度，都不要使用这个属性，而是使用下面的Object.setPrototypeOf()（写操作）、Object.getPrototypeOf()（读操作）、Object.create()（生成操作）代替

### Object.setPrototypeOf()

Object.setPrototypeOf方法的作用与__proto__相同，用来设置一个对象的原型对象（prototype），返回参数对象本身

``` javascript
// 格式
Object.setPrototypeOf(object, prototype)

// 用法
const o = Object.setPrototypeOf({}, null);
```

``` javascript
let proto = {};
let obj = { x: 10 };
Object.setPrototypeOf(obj, proto);

proto.y = 20;
proto.z = 40;

obj.x // 10
obj.y // 20
obj.z // 40
```

### Object.getPrototypeOf()

该方法与Object.setPrototypeOf方法配套，用于读取一个对象的原型对象

``` javascript
Object.getPrototypeOf(obj);
```

``` javascript
function Rectangle() {
  // ...
}

const rec = new Rectangle();

Object.getPrototypeOf(rec) === Rectangle.prototype
// true

Object.setPrototypeOf(rec, Object.prototype);
Object.getPrototypeOf(rec) === Rectangle.prototype
// false
```

### Object.keys(), Object.values(), Object.entries()

### Object.keys()

ES5 引入了Object.keys方法，返回一个数组，成员是参数对象自身的（不含继承的）所有可遍历（enumerable）属性的键名

ES2017 引入了跟Object.keys配套的Object.values和Object.entries，作为遍历一个对象的补充手段，供for...of循环使用

``` javascript
let {keys, values, entries} = Object;
let obj = { a: 1, b: 2, c: 3 };

for (let key of keys(obj)) {
  console.log(key); // 'a', 'b', 'c'
}

for (let value of values(obj)) {
  console.log(value); // 1, 2, 3
}

for (let [key, value] of entries(obj)) {
  console.log([key, value]); // ['a', 1], ['b', 2], ['c', 3]
}
```

### Object.values()

Object.values方法返回一个数组，成员是参数对象自身的（不含继承的）所有可遍历（enumerable）属性的键值

### Object.entries()

Object.entries()方法返回一个数组，成员是参数对象自身的（不含继承的）所有可遍历（enumerable）属性的键值对数组

``` javascript
const obj = { foo: 'bar', baz: 42 };
Object.entries(obj)
// [ ["foo", "bar"], ["baz", 42] ]
```

Object.entries的基本用途是遍历对象的属性

Object.entries方法的另一个用处是，将对象转为真正的Map结构

### Object.fromEntries()

Object.fromEntries()方法是Object.entries()的逆操作，用于将一个键值对数组转为对象

``` javascript
Object.fromEntries([
  ['foo', 'bar'],
  ['baz', 42]
])
// { foo: "bar", baz: 42 }
```

该方法的主要目的，是将键值对的数据结构还原为对象，因此特别适合将 Map 结构转为对象

``` javascript
// 例一
const entries = new Map([
  ['foo', 'bar'],
  ['baz', 42]
]);

Object.fromEntries(entries)
// { foo: "bar", baz: 42 }

// 例二
const map = new Map().set('foo', true).set('bar', false);
Object.fromEntries(map)
// { foo: true, bar: false }
```

该方法的一个用处是配合URLSearchParams对象，将查询字符串转为对象

``` javascript
Object.fromEntries(new URLSearchParams('foo=bar&baz=qux'))
// { foo: "bar", baz: "qux" }
```
