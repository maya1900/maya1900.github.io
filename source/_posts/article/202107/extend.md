---
title: 寄生组合继承
tags: js
categories: js
cover:
date: 2021-07-22
---

``` javascript
function Parent (name) {
  this.name = name
}
// 这里不能使用箭头函数
Parent.prototype.play = function() {
  console.log('play' + this.name)
}
function Child (name,age) {
  Parent.call(this, name)
  this.age = age
}
// 组合继承
Child.prototype = new Parent()
Child.prototype.constructor = Child

// function F() {}
// F.prototype = Parent.prototype
// let f = new F()
// f.constructor = Child
// Child.prototype = f

// 简写
Child.prototype = Object.create(Parent.prototype)
Child.prototype.constructor = Child
let children = new Child('tom')
children.play()
```
