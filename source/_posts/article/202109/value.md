---
title: 跟着讶佬深入js--按值传递/call/apply/bind/new
date: 2021-09-13
tags:
- js
- 原型
categories: js
cover: https://z3.ax1x.com/2021/09/19/48dSAS.jpg
---

## 按值传递

> ECMAScript中所有函数的参数都是按值传递的。

在值传递的参数，进入函数相当于复制值给另外一个变量。

``` javascript
function foo(a) {
  a = 22
}
var a = 11
foo(a);
console.log(a)  // 11
```

``` javascript
function change(obj1, obj2) {
  obj1.value = 'new'
  obj2 = 'zs'
}
var obj1 = {value: 'old'}
var obj2 = {value: 'old'}
change(obj1, obj2)

console.log(obj1, obj2)  // { value: 'new' } { value: 'old' }
```

而对象在传递参数时使用的是按共享传递。

> 对于传递到函数的对象类型，如果直接改变了拷贝的引用，那么是不会影响到原来的那个对象；如果是通过拷贝的引用，去进行内部的值的操作，那么就会改变到原来的对象的。

## call 

call做的五件事：改变this指向，函数执行了，call可以添加参数，this也可以是null，可以有返回值。

``` javascript
function fun() {
  console.log(this.value)
}
var obj = { value: 1 }
fun.call(obj) 
```

``` javascript
var obj = {
  value: 1,
  fun: function () {
    console.log(this.value)
  }
}
obj.fun()
```

``` javascript
Function.prototype.call2 = function (context) {
  context.fn = this;
  context.fn();
  delete context.fn
}
var obj = { value: 1 };
function fun() {
  console.log(this.value)
}

fun.call2(obj)
```

``` javascript
Function.prototype.call2 = function (context) {
  var context = context || window;
  context.fn = this;
  var args = [];
  for (let i = 1; i < arguments.length; i++) {
    args.push('arguments[' + i + ']');
  }
  var result = eval('context.fn(' + args + ')');
  delete context.fn;
  return result;
}

var obj = { value: 1 };
function fun(name, age) {
  console.log(name,age)
}

fun.call2(obj, 'sz', 18)
```

## apply

``` javascript
Function.prototype.apply2 = function (context, arr) {
  var context = context || window;
  context.fn = this;

  if (!arr) {
    result = context.fn()
  } else {
    var args = []
    for (let i = 0; i < arr.length; i++) {
      args.push('arr[' + i + ']');
    }
    result = eval('context.fn(' + args + ')')
  }
  delete context.fn;
  return result;
}

var obj = { value: 1 };
function fun(name, age) {
  console.log(name,age, this.value)
}

fun.apply2(obj, ['sz', 18])
```

## bind

bind做的四件事：改变this指向，函数在调用时执行，在使用bind和调用时都可以增加参数，bind可以是构造函数。

``` javascript
var foo = { value: 1 };
function bar() {
  console.log(this.value); // 1
}
var bindFoo = bar.bind(foo);
bindFoo();
```

``` javascript
Function.prototype.bind2 = function(context) {
  var self = this;
  return function() {
    return self.apply(context)
  }
}
var foo = { value: 1};
function bar() {
  return this.value;
}
var bindFoo = bar.bind2(foo);
console.log(bindFoo());
```

``` javascript
var foo = { value: 1 };
function bar(name, age) {
  console.log(this.value); // 1
  console.log(name); // daisy
  console.log(age); // 18
}
var bindFoo = bar.bind(foo,'daisy');
bindFoo('18');
```

``` javascript
Function.prototype.bind2 = function (context) {
  var self = this;
  // 获取bind2函数从第二个参数到最后一个参数
  var args = Array.prototype.slice.call(arguments, 1);
  return function () {
    // 这个时候的arguments是指bind返回的函数传入的参数
    var bindArgs = Array.prototype.slice.call(arguments);
    return self.apply(context, args.concat(bindArgs));
  }
}
```

``` javascript
var value = 2;
var foo = { value: 1 };
function bar(name, age) {
  this.habit = 'shopping';
  console.log(this.value);  // undefined
  console.log(name); // daisy
  console.log(age); // 18
}
bar.prototype.friend = 'kevin';
var bindFoo = bar.bind(foo, 'daisy');
var obj = new bindFoo('18');  

console.log(obj.habit); // shopping
console.log(obj.friend); // kevin
```

``` javascript
Function.prototype.bind2 = function(context) {
  var self = this;
  var args = Array.prototype.slice.call(arguments, 1);
  var fBound = function () {
    var bindArgs = Array.prototype.slice.call(arguments);
    // 当作为构造函数时，this指向实例，
    // 当作为普通函数时，this 指向window,
    return self.apply(this instanceof fBound ? this : context, args.concat(bindArgs));
  }
  fBound.prototype = this.prototype;
  return fBound;
}
```

``` javascript
Function.prototype.bind2 = function(context) {
  var self = this;
  var args = Array.prototype.slice.call(arguments, 1);
  var fNOP = function () {};
  var fBound = function() {
    var bindArgs = Array.prototype.slice.call(arguments);
    return self.apply(this instanceof fNOP ? this : context, args.concat(bindArgs))
  }
  fNOP.prototype = this.prototype
  fBound.prototype = new fNOP();
  return fBound;
}
```

``` javascript
var value = 2;
var foo = {
  value: 1,
  bar: bar.bind(null)
}
function bar() {
  console.log(this.value); // 2
}
foo.bar();
```

``` javascript
Function.prototype.bind2  = function(context) {
  if (typeof this !== "function") {
    throw new TypeError("Function.prototype.bind - what is trying to be bound is not callable");
  }
  var self = this;
  var args = Array.prototype.slice.call(arguments, 1);
  var fNOP = function() {};
  var fBound = function() {
    var bindArgs = Array.prototype.slice.call(arguments);
    return self.apply(this instanceof fNOP ? this : context, args.concat(bindArgs));
  }
  fNOP.prototype = this.prototype
  fBound.prototype = new fNOP();
  return fBound;
}
```

## new

new做了两件事：
继承构造函数里的属性和方法，继承原型中的属性和方法

``` javascript
function foo(name,age) {
  this.name = name;
  this.age = age;
  this.habit = "games";
}
foo.prototype.strength = 80;
foo.prototype.sayYourName = function() {
  console.log('I am ' + this.name);
}

var person = new foo('kevin', 18)
console.log(person.name);
console.log(person.age);
console.log(person.strength);
person.sayYourName();
```

``` javascript
function objectFactory() {
  // 用new Object()的方式新建了一个对象obj
  // obj的原型指向构造函数，这个obj就可以访问到构造函数的原型属性
  var obj = new Object();
  Constructor = [].shift.call(arguments);
  obj.__proto__ = Constructor.prototype;
  Constructor.apply(obj, arguments);
  return obj;
}
function foo(name, age) {
  this.name = name;
  this.age = age;
  this.habit = "games";
}
foo.prototype.strength = 80;
foo.prototype.sayYourName = function () {
  console.log('I am ' + this.name);
}

var person = objectFactory(foo, 'daisy', 18)
console.log(person.name);
console.log(person.age);
console.log(person.strength);
person.sayYourName();
```

``` javascript
function objectFactory() {
  var obj = new Object();
  Constructor = [].shift.call(arguments);
  obj.__proto__ = Constructor.prototype;
  var ret = Constructor.apply(obj, arguments);
  return typeof ret === 'object' ? ret : obj; 
}
```
