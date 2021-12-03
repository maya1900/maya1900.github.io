---
title: 跟着讶佬深入js--词法作用域
date: 2021-09-08
tags:
- js
- 原型
categories: js
cover: https://z3.ax1x.com/2021/09/12/4pMp5j.jpg
---

- 原文: [https://github.com/mqyqingfeng/Blog/issues/3](https://github.com/mqyqingfeng/Blog/issues/3)
- 你不知道的javascript

## 编译原理

1. 分词/词法分析：将由字符组成的字符串分解成有意义的代码块，这些块被称为词法单元。
2. 解析/词法分析：将词法单元流（数组）转换成一个由元素嵌套组成的代表了程序语法的结构的树，这个树被称为”抽象语法树“(AST)。
3. 代码生成：将AST转换为执行代码的过程。

### LHS与RHS

LHS为赋值操作的目标，RHS为赋值操作的源头。
当变量出现在赋值操作的左侧时进行LHS查询，出现在右侧时进行RHS查询。
如果查找的目的是对变量进行赋值，那么使用LHS查询；如果目的是获取变量的值，就会使用RHS查询。

## 作用域链

引擎从当前的执行作用域开始查找变量，如果找不到，就向上一级继续查找，当抵达最外层的全局作用域时，无论是否找到，查找过程都会停止。由多个执行上下文的变量对象构成的链表叫做作用域链

## 词法作用域

目前大多数语言使用词法使用域，少数使用动态作用域（bash脚本、Perl中一些模式等）。

词法作用域就是定义在词法阶段的作用域。
无论函数在哪里被调用，它的词法作用域都只由函数被声明所处的位置决定。

``` javascript
var val = 1;
function foo() {
  console.log(val);
}
function bar() {
  var val = 2;
  foo();
}
bar();
```

打印结果：

``` javascript
// 1
```

## 执行上下文栈

每一次代码执行和函数调用都会产生一个执行环境，被称为执行上下文。
类型：全局执行上下文、函数执行上下文、eval执行上下文。
js引擎创建了执行上下文栈ECS来管理执行上下文。

js执行代码时，首先向ECS压入全局执行上下文，当执行一个函数的时候，就会创建一个执行上下文，并且压入ECS，当函数执行完毕时，就会从ECS弹出，它是一个先入后出的原则，最后整个应用程序结束的时候清空ECSstack。

``` javascript
function f3() {
  console.log('f3');
}
function f2 () {
  f3();
}
function f1() {
  f2();
}
f1();

// f1() 
ECStack.push(<f1> functionContext);
// 压入f2
ECStack.push(<f2> functionContext);
// 压入f3
ECStack.push(<f3> functionContext);
// 弹出 f3
ECStack.pop();
// 弹出f2
ECStack.pop();
// 弹出f1
ECStack.pop();
// 继续执行后面代码
```

## 变量对象

变量对象是与执行上下文相关的数据作用域，存储了在上下文中定义的变量和函数声明。

### 全局对象

1. 可以通过this引用 ，全局对象就是Window对象
2. 全局对象是由Object构造函数实例化的一个对象
3. 预定义了一大堆函数和属性。
4. 作为全局变量的宿主
5. 在客户端js中，全局对象有window属性指向自身。

``` javascript
console.log(this);
console.log(this instanceof Object);
console.log(Math.random());
var a = 1;
console.log(this.a);
console.log(window.a);
```

### 函数对象

在函数上下文中，一般用活动对象AO表示变量对象。

在执行时分为两个过程：进入执行上下文和代码执行。

函数上下文的变量对象初始化只包括arguments对象，在进入执行上下文时会给变量对象添加形参、函数声明、变量声明等初始的属性；在代码执行阶段，会再次修改变量对象的属性值。

在进入执行上下文时，首先会处理函数声明，其次会处理变量声明，如果变量名称和已经声明的形参或者函数相同，则变量声明不会影响已经存在的属性。

``` javascript
console.log(foo);  // 打印函数
function foo() {
console.log("foo")  
}
var foo = 1;
```

## 函数执行过程中的作用域链

1. 函数被创建，保存作用域链到内部属性[[scope]]
2. 执行函数，创建函数执行上下文，压入执行上下文栈；
3. 复制函数[[scope]]属性创建函数作用域链到函数上下文中；
4. arguments创建活动对象，初始化，加入形参、函数声明、变量声明
5. 将活动对象压入函数作用域链顶端；
6. 开始执行函数，修改AO属性值
7. 函数执行完毕，函数执行上下文出执行上下文栈中弹出。
