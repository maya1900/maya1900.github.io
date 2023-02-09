---
title: javascript基础整理
tags:
  - js
categories: js
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/big-dribbble.png
date: 2023-02-09 22:00:00
---

![](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202302092232548.png)

数据类型
    1. JavaScript有哪些数据类型，它们的区别？
        八种数据类型，分别是 Undefined、Null、Boolean、Number、String、Object、Symbol、BigInt。
        Symbol 代表创建后独一无二且不可变的数据类型，它主要是为了解决可能出现的全局变量冲突的问题。
        使用 BigInt 可以安全地存储和操作大整数
        数据可以分为原始数据类型和引用数据类型
            栈：原始数据类型
            堆：引用数据类型
        堆和栈的概念存在于数据结构和操作系统内存
            在数据结构中，栈中数据的存取方式为先进后出，堆是一个优先队列
            在操作系统中，内存被分为栈区和堆区，栈区内存由编译器自动分配释放，堆区内存一般由开发者分配释放。
    2. 数据类型检测的方式有哪些
        typeof
        instanceof
        constructor
        Object.prototype.toString.call()
    3. 判断数组的方式有哪些
        Object.prototype.toString.call()
        Array.isArray
        instanceof
        原型链
        Array.prototype.isPrototypeOf
    4. null和undefined区别
        undefined 代表的含义是未定义，null 代表的含义是空对象。
        null用于函数的参数不是对象，原型链的终点
        undefined函数没有返回值，函数参数没有提供，对象属性没有赋值，变量声明为赋值
    5. typeof null 的结果是什么
        早期js所有值存储在32位的内存单元中，其中前三位存储数据类型，其中000表示object，而null的机器码都是0，所以被认为是object
    6. intanceof 操作符的实现原理及实现
        表示右侧操作数的原型对象是否在左侧的原型链中
    7. 为什么0.1+0.2 ! == 0.3
        js的Number类型数据采用IEEE754双精度浮点数保存数据，双精度浮点数的小数部分最多只能保留52位，剩余的需要舍去，而0.1和0.2的二进制是无限循环，所以计算时被舍去
        toFixed(2)四舍五入
        ES6中提供了机器精度Number.EPSILON，值是2^-52，只要判断0.1+0.2-0.3是否小于它就行了。
    8. 如何获取安全的 undefined 值？
         void 0 来获得 undefined
    9. typeof NaN 的结果是什么？
        typeof NaN; // "number"
        NaN 是一个特殊值，它和自身不相等，用于指出数字类型中的错误情况
    10. isNaN 和 Number.isNaN 函数的区别？
        函数 isNaN 接收参数后，会尝试将这个参数转换为数值，任何不能被转换为数值的的值都会返回 true
        函数 Number.isNaN 会首先判断传入参数是否为数字，如果是数字再继续判断是否为 NaN 
    11. == 操作符的强制类型转换规则
        先判断类型，相同比较大小
        判断null和undefined，是返回true
        判断两者是否string和number，是字符串转换为number
        判断其中一个是bool，是把bool转换为number
        判断其中一个为object另一个为string、number或symbol，是object转换原始数据类型
    17. 什么是 JavaScript 中的包装类型？
        js中基本类型没有属性和方法的，在调用基本类型的属性或方法时 JavaScript 会在后台隐式地将基本类型的值转换为对象
        可以使用Object函数显式地将基本类型转换为包装类型
        也可以使用valueOf方法将包装类型倒转成基本类型
    18. JavaScript 中如何进行隐式类型转换
        ToPrimitive方法，这是 JavaScript 中每个值隐含的自带的方法，用来将值 （无论是基本类型值还是对象）转换为基本类型值。
        ToPrimitive(obj,type) type的值为number或者string
        隐式类型转换主要发生在+、-、*、/以及==、>、<这些运算符之间
        对象会被ToPrimitive转换为基本类型再进行转换
ES6
    1. let、const、var的区别
        块级作用域
        变量提升
        全局添加属性
        重复声明
        暂时性死区
        const初始值，不能改变
    3. 如果new一个箭头函数的会怎么样
        箭头函数是ES6中的提出来的，它没有prototype，也没有自己的this指向，更不可以使用arguments参数，所以不能New一个箭头函数。报错：not a constructor
        function mynew(Func, ...args) {    // 1.创建一个新对象    const obj = {}    // 2.新对象原型指向构造函数原型对象    obj.__proto__ = Func.prototype    // 3.将构建函数的this指向新对象    let result = Func.apply(obj, args)    // 4.根据返回值判断    return result instanceof Object ? result : obj}
    7. Proxy 可以实现什么功能？
        Vue3.0 中通过 Proxy 来替换原本的 Object.defineProperty 来实现数据响应式。
        Proxy 无需一层层递归为每个属性添加代理，一次即可完成get和set
        之前数组的更新检测不到，Proxy 可以完美监听到任何方式的数据改变
三、JavaScript基础
    2. map和Object的区别
        map默认不包含任何键，object有自己的原型
        map的键可以是任意值，object是string或symbol
        mapkey有序，object无序的
        map是可迭代的，object需要api
        性能上map好
    6. 对JSON的理解
        json是轻量级的数据交换方式，可以被任何语言读取
    7. JavaScript脚本延迟加载的方式
        defer 属性
        async 属性
        动态创建 DOM 方式
        使用 setTimeout 
        让 JS 最后加载
    9. 数组有哪些原生方法？
        slice、splice、sort、reverse、concat、forEach、map、every、some、filter、reduce
    17. JavaScript为什么要进行变量提升，它导致了什么问题？
        造成变量声明提升的本质原因是 js 引擎在代码执行前有一个解析的过程，创建了执行上下文，初始化了一些代码执行时需要用到的对象。
        为什么会进行变量提升：提高性能、容错性更好
            在JS代码执行之前，会进行语法检查和预编译，并且这一操作只进行一次。这么做就是为了提高性能，如果没有这一步，那么每次执行代码前都必须重新解析一遍该变量（函数），而这是没有必要的
            提高JS代码的容错性，使一些不规范的代码也可以正常执行，比如先使用，后定义的代码。
    ES6 Module和CommonJS模块的区别
        esm是对模块的引用，cjs是模块的拷贝
        esm编译时加载，cjs是运行时加载
        esm是异步，cjs是同步加载
        esm引用的值是只读的，cjs可以被修改
        循环引用时，cjs取值只能取到已经执行的部分；esm不关心循环，只是生成一个模块引用，取值不确定的，需要自己保证能取到值。
四、原型与原型链
    在JavaScript中是使用构造函数来新建一个对象的，每一个构造函数的内部都有一个 prototype 属性，它的属性值是一个对象，这个对象包含了可以由该构造函数的所有实例共享的属性和方法。当使用构造函数新建一个对象后，在这个对象的内部将包含一个指针，这个指针指向构造函数的 prototype 属性对应的值，在 ES5 中这个指针被称为对象的原型。ES5 中新增了一个 Object.getPrototypeOf() 方法，可以通过这个方法来获取对象的原型。
五、执行上下文/作用域链/闭包
    1. 对闭包的理解
        闭包是指有权访问另一个函数作用域中变量的函数，创建闭包的最常见的方式就是在一个函数内创建另一个函数，创建的函数可以访问到当前函数的局部变量。
        在函数外部能够访问到函数内部的变量，使用这种方法来创建私有变量。
        使已经运行结束的函数上下文中的变量对象继续留在内存中
    3. 对执行上下文的理解
        创建执行上下文有两个阶段：创建阶段和执行阶段
        在执行一点JS代码之前，需要先解析代码。解析的时候会先创建一个全局执行上下文环境，先把代码中即将执行的变量、函数声明都拿出来，变量先赋值为undefined，函数先声明好可使用。这一步执行完了，才开始正式的执行程序。
        在一个函数执行之前，也会创建一个函数执行上下文环境，跟全局执行上下文类似，不过函数执行上下文会多出this、arguments和函数的参数。
        全局上下文：变量定义，函数声明
        函数上下文：变量定义，函数声明，this，arguments
六、this/call/apply/bind
    1. 对this对象的理解
        函数调用，this指向全局
        方法调用，this指向这个对象
        构造函数调用，this指向新创建的对象
        apply、call、bind，this指向调用函数的this
    3. 实现call、apply 及 bind 函数
        （1）call 函数的实现步骤：
        （2）apply 函数的实现步骤：
        （3）bind 函数的实现步骤：
七、异步编程
    1. 异步编程的实现方式？
        回调函数
        Promise
        generator
        async
    7. 对async/await 的理解
        async/await其实是Generator 的语法糖，它能实现的效果都能用then链来实现，它是为优化then链而开发出来的。它可以使代码更简洁，错误处理和调试友好。
八、面向对象
    1. 对象创建的方式有哪些？
        一般使用字面量的形式直接创建对象
        可复用创建对象方式：
            工厂模式
            构造函数模式
            原型模式
            组合构造函数和原型模式
            动态原型模式
            寄生构造函数模式
    2. 对象继承的方式有哪些？
        原型链继承
        借用构造函数继承
        组合继承
        原型式继承
        寄生继承
        寄生组合式继承
九、垃圾回收与内存泄漏
    1. 浏览器的垃圾回收机制
        垃圾回收：JavaScript代码运行时，需要分配内存空间来储存变量和值。当变量不在参与运行时，就需要系统收回被占用的内存空间，这就是垃圾回收。
