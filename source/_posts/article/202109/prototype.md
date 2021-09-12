---
title: 跟着讶佬深入js--原型到原型链
date: 2021-09-07
tags:
- js
- 原型
categories: js
cover: https://z3.ax1x.com/2021/09/12/4pKHPA.jpg
---

原文: `https://github.com/mqyqingfeng/Blog/issues/2`

## prototype

prototype是函数才有的属性，每一个函数都有一个prototype属性，它指向了一个对象，这个对象是由构造函数创建出来的实例的原型。

那么什么是原型？每一个js对象在创建的时候就会关联另一个对象，这个对象就是它的原型，每一个对象都会从原型“继承”属性。

## \_\_proto__

每一个js对象（除null）都具有的一个属性，它指向了该对象的原型。

``` javascript
person1.__proto__ === Person.prototype  // true
```

## constructor

每个原型都有一个constructor属性指向原构造函数。

``` javascript
Person.prototype.constructor === Person  // true
```

## 原型链

当读取实例的属性时，如果找不到，就会查找 与对象关联的原型中的属性，如果还找不到，就会查找原型的原型，直到找到Object对象的原型，如果还没有，则会返回null。

``` javascript
Object.prototype.__proto__ === null // true
```

![绘图](./attachments/1630970399134.drawio.html)

## 其它

### constructor

``` javascript
person1.constructor === Person // true
```

实例上并没有constructor属性，实质上说的是：

``` javascript
person1.constructor === Person.prototype.constructor // true
Person.prototype.constructor === Person // true
```

### \_\_proto__

它是一个非标准的方法，使用它时，可以理解返回了Object.getPrototypeOf(obj)

### 真的是继承吗？

继承意味着复制操作，然而 JavaScript 默认并不会复制对象的属性，相反，JavaScript 只是在两个对象之间创建一个关联，这样，一个对象就可以通过委托访问另一个对象的属性和函数，所以与其叫继承，委托的说法反而更准确些。


``` javascript
function Person () {
}
Person.prototype.name = "tom";
let person1 = new Person();
let person2 = new Person();
console.log(person1.name);
console.log(person2.name);

console.log(person1.__proto__ === Person.prototype)  // true

console.log(Person.prototype.constructor === Person) // true

console.log(Object.prototype.__proto__ === null) // true

console.log(person1.constructor === Person) // true
console.log(person1.constructor === Person.prototype.constructor) // true
```
