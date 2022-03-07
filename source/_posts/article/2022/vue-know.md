---
title: 再次深入git
date: 2022-03-07
tags:
  - vue
categories: 前端
cover: http://image.maya1900.top/202203072208288.jpg
---

![](http://image.maya1900.top/202203072201229.png)

# Vue.js知识点整理

## 原生DOM vs jQuery函数库 vs Vue框架

### 原生DOM

- 浏览器/平台已实现的，咱们可直接使用的现成的函数
- 问题：代码繁琐

### jQuery函数库

- 基于原生DOM基础上，进一步封装的，更简化的一组函数的集合
- 优点

  - 对每一步原生DOM操作都进行了简化

- 缺点

  - 但是，步骤并没有简化，依然包含大量重复劳动

### 框架（framework）

- 前人将多次成功项目的经验总结起来，形成的半成品项目
- 优: 项目整体代码和做事的步骤极简化，不再需要大量重复手工劳动，只需要添加个性化的功能即可
- 缺: 需要改变原有的做事方法，习惯上难以接受

## 概述

### 中文官网：https://cn.vuejs.org/

### Vue.js: 一个渐进式(Progressive)的，基于MVVM设计模式的纯前端JavaScript 框架

- 渐进式: 虽然提供了很多的组成部分，但不强迫必须全部使用，可轻松与其他技术混用。
- 纯前端

  - 单靠浏览器就可以执行，不需要nodejs等后端技术，也可学好和用好vue框架

### 适用于以数据操作为主的项目(WEB、APP)。以数据增删改查操作为主，多数应用都是以数据操作为主的。

### 安装

- 兼容性: 不支持IE8及以下版本
- 当前单独下载的js文件版本: 2.6
- 脚手架版本: 3.0

###  如何使用: 两种方法：

- 1. 直接下载，并使用script引入vue.js文件——前3天

  - 在全局创建一个种新的类型Vue: 构造函数和原型对象
  - 2个版本: 开发版 强调：有错误提示！
        生产版 强调: 没有错误提示！

- 2. 使用Vue-CLI脚手架工具——后2天

## Vue做事的步骤

### 1. 定义界面

- 整个界面只能包含在一个统一的父元素下

  - <div id="app">

- 界面中所有可能发生变化的地方,都要用绑定语法代替

  - {{变量名}}, : , v-show , ...

- 如果元素需要绑定事件

  - 就要用@事件名="函数调用语句"

### 2. 定义一个数据对象,来包含页面上所有可能变化的位置所需的变量和初始值

- var data={ 变量名: 初始值, ... : ... , ...}

### 3. 创建Vue类型的实例对象

- new Vue({
  el:"#app", //找到要监事的父元素
  data:data, //将数据对象引入到new Vue中
  //到此,就将内存中的数据变量和界面绑定起来
  //绑定的结果: 只要new Vue中data中的变量被改变,页面自动变化.
  methods:{ //如果界面上需要事件处理函数,就需要定义在new Vue的methods属性中集中保存
    doit(i){
      this.n+=i;
      this.n<0&&(this.n=0)
    }
  }
  })

## MVVM框架

### 旧的网页组成：3部分

- HTML：提供网页的内容
- CSS：为内容提供样式
- JS：为内容提供行为/数据
- 问题: HTML和CSS功能太弱，不包含程序必要的要素(变量，分支，循环)，生活不能自理。所有改变都需要js来实现。代码繁琐，重复代码量大

### 重新划分

- View：界面，指网页中的元素和样式，一般指HTML+CSS

  - 但是，HTML是增强版的HTML，支持变量，js表达式，分支和循环等程序要素。无需编写js，就可以在html上执行部分程序的操作。所以，可简化js程序的编写,避免大量重复编码

- Model：模型，指程序中创建的或从服务端获取的数据，一般用JS中的一个对象来保存。数据内容会显示到界面View中。

  - 页面中有几处变化, 需要几个变量,模型对象中就要对应着定义几个变量来支持页面

- ViewModel：视图模型，替代之前手写的DOM/JQUERY操作，把模型中的数据和界面中的HTML元素“绑定”在一起: 

  - 什么是绑定: 不需要写一行代码，就可让页面元素内容和js程序中的数据联动变化
  - new Vue()创建的就是这样一种强大的ViewModel对象，可自动同步数据和页面元素

### ViewModel绑定原理：

- 1.	响应系统(Reactivity System):

  - new Vue()将data{}对象引入new Vue()中并打散data{}对象，使data{}对象中每个属性都变为单独的属性，并直接隶属于new Vue()对象下。
  - 然后new Vue()给data中每个属性添加访问器属性（请保镖），今后，操作data中的属性，其实自动都是通过操作访问器属性实现的
  - 最后，new Vue()给data中每个属性请的保镖中set()函数内，都有通知机制。只要试图修改data中属性的值，都会自动调用属性的set()函数，并自动发出通知。告知vue对象，哪个变量发生了变化

- 2.	虚拟DOM (Virtaul DOM): 

  - 什么是

    - 只保存可能变化的节点的简化版DOM树
    - new Vue()时，vue对象通过扫描真实DOM树，只将可能变化的元素，保存到虚拟DOM树上。

  - 当收到变量改变的通知时

    - vue会快速遍历虚拟DOM树，找到受影响的元素，调用已经封装好的DOM函数，只更新页面中受影响的元素。不受影响的元素，不会改变

  - 为什么:

    - 1. 小，仅保存可能变化的元素
    - 2. 快， 遍历快，查找快
    - 3. 自动，已经封装了DOM操作，自动修改页面。避免了大量重复的DOM操作

- 

## 绑定

### 只要元素的内容可能变化，就用{{ }}语法绑定

- {{ }}：双括号语法，也叫大胡子语法（Mustache）,
      官方名字: Interpolation 补缺，插值的意思
- 如何: {{表达式}}其中的表达式可以是：

  - 同es6模板字符串一样，只要有返回值的变量或js表达式，都可放在{{}}内
  - 不能放程序结构(if/for等)

- 问题: 只能绑定元素的内容,无法绑定元素的属性值

### 指令(directive)

- 什么是: Vue.js提供的，专门增强html功能的特殊HTML属性
- 为什么: html本身是静态的，写死的，没有任何动态生成内容的能力
- 包括

  - 只要元素的属性值可能发生变化: v-bind

    - 如何: <any v-bind:属性=”数据变量” 
    - 强调: 不用写{{}}
    - 简写: v-bind可省略,  仅:    :属性=”数据变量”

  - 控制一个元素显示隐藏: v-show

    - 如何: <元素 v-show="条件">
    - 原理： 每次扫描时，如果条件为true，就保持当前元素原样显示。如果条件为false，则自动为当前元素加上display:none，隐藏该元素
    - vs  v-if: 通过添加/删除元素来控制显示隐藏。

  - 控制两个元素二选一显示: v-if v-else

    - 如何: <元素1 v-if="条件1">
      <元素2 v-else>

      - 两个元素之间不能插入其它元素，必须紧挨着写。
      - 和js程序一样，v-else后不需要写任何条件

    - 原理: 每次扫描时判断条件的值，如果条件为true，就显示元素1，删除元素2；如果条件为false，就显示元素2，删除元素1
    - 强调: 不是用display:none隐藏，而是彻底删除不显示的元素

  - 控制多个元素多选一显示: v-else-if

    - <any v-if="条件"></any>
      <any v-else-if="条件"></any>
      <any v-else></any>

      - 多个元素之间不能插入其它元素，必须紧挨着写。

    - 原理: 每次扫描时判断条件的值，哪个元素条件为true，就显示哪个元素，并删除其它元素；如果之前所有条件都不满足，就显示最后一个元素，删除之前所有元素

  - 绑定事件都用: v-on  简化为 @

    - 如何

      - <元素 @事件名="处理函数(实参值,...)">
      - new Vue({
        el:"#app",
        data: { ... },
        methods:{
        处理函数(形参){
         //this->当前new Vue()对象
         //可用this.变量名方式访问data中的变量，因为methods中的方法，也是被打散后直接隶属于new Vue()的。其实和data中的变量打散后是平级的。都直接隶属于new Vue()对象
        }
        }
        })
      - 其实,如果不传参,则@事件名="函数"后不需要加()

    - 传参

      - <元素 @事件名="处理函数(实参值,...)">
      - methods:{
        处理函数(形参值){
         //this->当前new Vue()对象
         //可用this.变量名方式访问data中的变量，因为methods中的方法，也是被打散后直接隶属于new Vue()的。其实和data中的变量打散后是平级的。都直接隶属于new Vue()对象
        }
        }

    - 获得事件对象

      - 只获得事件对象，不需要传其它自定义参数时

        - <元素 @事件名="处理函数">

          - 一定不要加()，因为加()是调用函数且不传参数的意思
          - 不加()是绑定事件处理函数的意思

        - 只有不加()时，vue才会像DOM一样自动将事件对象以处理函数第一个参数方式，传入处理函数
        - methods:{
              event
                 ↓
          处理函数(e){
           e自动获得事件对象。获得的事件对象，和DOM中的事件对象完全一样
          }
          }

      - 既需要获得事件对象，又需要传入自定义参数

        - <元素 @事件名="处理函数($event, 其它实参值,...)">

          - 因为加了()，就无法自动传入事件对象了
          - 所以，必须手动传入事件对象和其它实参值
          - $event是vue将DOM中事件对象重新封装过的一个代表事件对象的关键词
          - vue中所有$开头的关键词，都不能改名

        - methods:{
              $event 其它实参
                 ↓          ↓
          处理函数(e,     其它形参,....){
           e自动获得事件对象。获得的事件对象，和DOM中的事件对象完全一样
          }
          }

  - 只要根据数组反复生成多个相同结构的元素时: v-for

    -  如何: <any v-for="(value, i)  of 数组/对象/字符串" :key="i">

       - of可改为in，但是in和of效果是一样的。只是为了满足不同人的习惯而已

    -  强调: v-for要写在要重复生成的元素上，而不是父元素上。
    -  原理

       - of可自动遍历数组/对象，并取出数组/对象中每个元素的值(value)和下标(i)保存到左边的变量中
       - v-for，每遍历数组或对象中一个成员，就会创建一个当前HTML元素的副本。
       - v-for里of前写的变量，在当前元素内部可用于绑定语法。v-for反复生成元素过程中，就会将绑定语法中的变量替换为变量值，固定在元素上

    -  :key="i"

       - 不加:key="i"

         - 反复生成的元素是无差别的，如果将来数组或对象中某一个成员值发生了改变，就无法精确找到并区分要更改的是哪一个元素，只能将这组元素全部重新生成一遍——效率低

       - 加:key="i"

         - 等于对每个元素加上一个不重复的标识i
         - 如果将来数组或对象中某一个成员值发生了改变，即可根据key属性的值精确找到要更改的一个HTML元素，只更改受影响的一个HTML元素即可，不用将这组HTML元素全部重新生成一遍——效率高

    -  坑

       - 当数组中保存的是原始类型的值时

         - 在程序中修改数组中某个元素值时,不能使用[下标]方式访问
         - 因为此时下标方式是不受监控的
         - 结果: 即使修改成功,也不会自动更新
         - 应该用.splice(i,1,"新值") 代替

           - 删除现在i位置的值,替换为一个新值
           - 所有数组函数,都是受监控的
           - 结果: 只要一修改, 界面上自动变化

       - 但是，如果数组中保存的是引用类型的对象，则可以用[下标]修改

    -  v-for还会数数

       - <元素 v-for="i of 整数">
       - 结果: of会从1开始，循环到这个整数，循环了几次，就将当前HTML元素重复创建几次。of前的i会依次获得 1 2 3 4 5 可用于绑定在元素的内容中。比如分页按钮

  - 要绑定的内容是HTML片段时: v-html

    - 问题:

      - 因为{{}}绑定html片段内容时，会保持html片段原样显示，而不是翻译为页面元素。所以{{}}不能用于绑定HTML片段内容

    - 解决

      - v-html绑定html片段时，会将HTML片段交给浏览器去解析为页面元素

  - 避免用户短暂看到{{}}

    - v-cloak：(哈利波特的隐身斗篷) 强调: 不是clock!!!

      - 问题: 首次记载页面时，如果加载稍微延迟，用户就可能看到{{}}语法！
      - 什么是v-cloak: 让当前元素默认隐藏，直至内容准备就绪，才自动显示出来
      - 如何: 2步: 必须配合css使用

        - <要隐藏的元素  v-cloak>

          - 强调: VUE官方本身，没有提供v-cloak的隐藏样式，所以，必须我们自己写。

        - 在CSS中必须添加: [v-cloak] { display: none; }

          - 用属性选择器找到所有带有v-cloak的元素，让其暂时隐藏

        - 当new Vue()加载完成，就会找到页面中所有v-cloak属性，并移除他们。这样，暂时隐藏的元素，就都显示出来了。
        - VUE只负责自动移除v-cloak属性，所以v-cloak不能改名

    - v-text：使用模型数据替换当前元素的innerText

      - <元素 v-text="变量或js表达式"></元素>
      - 将原本用{{}}绑定的内容，放在指令中绑定。效果是一样的
      - 但是，因为指令属于属性，即使暂时没有加载完，用户也不会看到属性部分的内容。所以，起到了避免用户看到双花括号的作用

  - 仅在页面加载时，绑定一次。之后变量修改，也不更新页面: v-once

    - 底层原理：只在首次加载时，一次性将模型数据显示在当前元素 。不会将当前元素加入到虚拟DOM树中
    - 优化: 减少被监视的元素个数，可以优化页面绑定的效率。

  - v-pre：保留当前元素中的{{}}语法，不进行绑定渲染

    - 何时: 如果元素内容中，有{{}}原文，但不想作为绑定语法解析时，可用v-pre，保留{{}}为原文，不再编译。

## 双向绑定(重点)

### 什么是: 

- 既可把程序中Model数据绑定到表单元素中显示；——第一个方向: M => V
- 同时, 又可把表单元素中修改的新值，绑定回程序中Model数据变量上保存。——第二个方向: V => M

### 为什么: 

- {{}}和v-bind仅是单向绑定。只能将Model数据的值，绑定到页面的表单元素上，用于显示(M => V)
- 而页面上的更改，无法对应修改到Model数据中(V =X> M)

### 何时: 

- 今后，只要希望修改表单元素的值后，也能自动修改对应模型数据的值，则用v-model指令进行绑定

### 如何: 

- 绑定文本框和文本域

  - <input type="text" v-model:value="变量">

  - <textarea v-model:value="变量"></textarea>

  - 结果: 文本框内容一更新，立刻将新值自动更新回程序中的变量里

  - 原理: 

    - v-model:value会被自动翻译为oninput="function(){...}"事件绑定代码，并在事件处理函数中封装修改data中变量的代码
    - 只要文本框内容被修改，就触发DOM的oninput事件，自动执行修改data中变量的代码

- 绑定select元素

  - 特殊

    - 用不是直接修改select元素的文本,而是通过选择option来改变select的value

  - <select v-model:value="orderStatus">
    <option value="10">未付款</option>
    <option value="20">已付款</option>
    <option value="30">已发货</option>
    <option value="40">已签收</option>
    </select>

  - 结果: select的选中项的值改变,就会立刻将新选中的option的value值更新回内存中的程序里

  - 原理

    - 单向绑定时

      - 将Model中的变量值赋值给select的value属性.然后, select元素会拿获得value属性值去和每个option的value值做比较.哪个option的value等于select的value,就选中哪个option

    - 修改时

      - <select v-model:value="xxx",会被自动翻译为: <select onchange=" vue对象.变量=当前select元素的value属性值 "

- 绑定radio元素

  - 特殊

    - 备选项的value都是固定不变的, 所以肯定绑定的不是value属性
    - 选中与不选中radio改变的其实是它的checked属性

  - <label><input type="radio" value="1" v-model:checked="sex">男</label>
    <label><input type="radio" value="0" v-model:checked="sex">女</label>
  - 原理: 

    - 单向绑定时

      - v-model会拿checked属性绑定的变量值和当前radio的value属性进行比较. 如果绑定的变量的值等于当前radio的value,就选中该radio.否则,如果绑定的变量值,不等于当前radio的value,就不选中该radio

- 绑定checkbox元素单用

  - 特殊

    - 不需要和value做比较,直接用checked属性绑定到一个bool值变量即可

  - <input type="checkbox" v-model:checked="isAgree">同意<br>
  - 原理: 

    - 单向绑定时

      - 绑定的变量值返回true,就选中,返回false,就不选中

    - 修改时

      - 直接将checkbox当前的选中状态checked属性值更新回魔心变量上

- 可简写为: 只写v-model=”模型变量”，省略:value

  - v-model其实会自动根据当前所在的不同表单元素,切换不同的属性绑定

### 监视函数: 

- 什么是: 在模型数据发生变化时，自动执行的函数
- 何时: 只要希望在模型数据变化时，立刻执行一项操作时，需要监视函数监控模型变量
- 如何: 

  - new Vue({
        el: “xxx”,
        data: { … },
        watch:{
           模型变量名(){
              this.模型变量名 … 
           }
        }
    })

    - 监事函数的函数名,必需是要监事的变量名

## 绑定class和style属性:

### 绑定内联样式

- 方式1：把style属性作为普通字符串属性进行绑定

  - <元素 :style="变量">
  - data:{
    变量: "left:100px; top:50px"
    }
  - 结果

    - <元素 style="left:100px; top:50px">

  - 问题

    - 如果希望仅修改其中一个css属性值,就很不方便

- 方式2：用对象绑定style

  - <元素 :style="变量"
  - data:{
    变量: {
       left:"100px",
       top:"50px"
    }
    }
  - 结果

    - Vue绑定语法会将对象翻译为style属性规定的字符串格式
    - <元素 style="left:100px; top:50px">

  - 简写: 

    - <元素 :style="{left: 变量1, top: 变量2}"
    - data:{
      变量1:"100px",
      变量2:"50px"
      }
    - <元素 style="left:100px; top:50px">

  - 有些内联样式不变,而有些变化

    - <元素 style="不变的css样式" :style="变量"
    - 结果:

      - vue会先绑定:style,翻译为字符窜,然后再和不带:的style拼接为一个style

    - 所以,今后不需要动态绑定的css内联样式属性,就可放在不带:的style中. 只有那些需要动态改变的css属性,才放在带: 的style中

### 绑定class属性

- 方式1：把class属性作为普通字符串属性进行绑定

  - <元素 :class="变量">
  - data:{
    变量: "class1 class2 ..."
    }
  - 结果

    - <元素 class="class1 class2 ...">

  - 问题

    - 如果希望仅修改其中一个class,就很不方便

- 方式2：用对象绑定class

  - <元素 :class="变量"
  - data:{
    变量: {
       class1:true或false,
       class2:true或false
    }
    }
  - 结果

    - Vue绑定语法会将对象翻译为class字符串,但是只有那些值为true的class,才会存在于最后的class中.值为false的class,表示不启用

  - 简写: 

    - <元素 :class="{class1: 条件1, class2: 条件2}"

  - 有些class不变,而有些变化

    - <元素 class="不变的class" :class="变量"
    - 结果:

      - vue会先绑定:class,翻译为字符窜,然后再和不带:的class拼接为一个class作用在元素上

    - 所以,今后不需要动态绑定的class,就可放在不带:的class中. 只有那些需要动态改变的class,才放在带: 的class中

## 自定义指令

### Vue.js中，除了预定义的13个指令外，还允许用户自定义扩展指令。

### 创建自定义指令

- Vue.directive('指令名', {
      inserted( el ){ //当元素被加载到DOM树时触发
          //el 可自动获得当前写有指令的这个DOM元素对象
          //函数中，可对这个写有指令的DOM元素执行原生的DOM操作
      }
  })
- 强调: 

  - 因为指令不是只给一个页面或一个功能添加的,应该是所有Vue的对象都可使用.所以,应该是数组Vue大家庭的.所以创建时,要用Vue.directive()来创建
  - ‘指令名’不用加v-前缀!  只有在html中使用时，才加v-前缀

### 使用自定义指令

-  <元素   v-指令名>
-  强调: 使用指令时必须前边加v-

## 计算属性:

### 什么是: 不实际存储属性值，而是根据其它数据属性的值，动态计算获得。

### 为什么: 有些属性的值，不能直接获得，需要经过其它属性的值的计算后，才能获得

### 何时: 今后，只要一个属性的值，依赖于其它数据属性的值，动态计算获得, 就要用计算属性。

### 如何实现计算属性：

- 定义时:  

  - new Vue({
    el: “xxx”,
    data: { … },
    methods:{ … },
    watch: { … },
    computed: {
        新属性名(){
            return 用现有数据属性执行计算
        }
    }
    })

- 绑定时: 和普通数据属性一样！{{计算属性}}
- 强调: 不加()! 虽然是方法，但是用法同普通属性完全一样。

## methods  vs  watch  vs  computed

### methods

- 保存自定义方法,

  - 要么作为事件绑定,在事件触发时才执行
  - 要么主动加()调用执行

- 问题

  - vue不会缓存methods中方法的执行结果,重复调用几次,就重复计算几次-效率低

### computed

- 保存自定义计算属性

  - 不会自己手动调用
  - 都是通过在页面上使用绑定语法自动触发执行, 且不用加()

- 优点

  - vue会缓存computed属性的计算结果, 只要所依赖的其他变量值不变,则computed就不会重复计算.而是优先使用缓存中保存的值- 效率高
  - 只有所依赖的其他属性值发生变化,才自动重新计算计算属性的结果

### watch

- 保存所有监事函数

  - 不需要自己调用,也不需要绑定.
  - 只要被监事的变量值改变,就自定触发

### 总结: 

- 更侧重于获得计算结果时,优先使用computed
- 不关系计算结果,单纯执行一项操作时, 应该使用methods
- 只要希望变量值每次改变时,都自动执行一项操作，就用watch

## 过滤器(Filter)

### 什么是: 在接收原始数据后，对原始数据执行再加工的函数。

### 为什么

- 有些原始数据，不能直接显示给用户，需要加工后，人才能看懂

  - 性别
  - 日期

### 何时:  只要原始数据不能直接显示给用户时，都要定义过滤器，加工后，再显示给用户

### 强调: vue官方没有提供任何预定义过滤器，只能自定义

### 如何

- 创建自定义过滤器

  - Vue.filter('过滤器名', function(val){ 
    // val 接收当前要处理的模型数据的原始值
    return 对原始值进行加工后的新值; 
    })

- 使用自定义过滤器

  - 方法1： {{ 数据 | 过滤器名 }}
  - 方法2： <any :title="数据 | 过滤器名">

### 创建带参数过滤器

- Vue.filter('过滤器名', function(val, 参数1, …){ 
  // val 接收当前要处理的模型数据的原始值
    //参数1 接收到调用过滤器时，临时传来的参数
    return 根据不同的参数对原始值进行加工后的不同新值; 
  })
- 使用带参过滤器: 

  -      {{ 数据 | 过滤器名(参数值1,…) }}

- 坑: 

  - 定义过滤器时，自定义形参是从形参列表第二个位置开始定义的。
  - 而传递实参时，却是从实参列表第一个位置开始写的自定义参数
  - 因为过滤器的第一个实参值，其实默认是原变量的原始值

### 过滤器可以像管道一样连接起来，先后执行

- {{ 数据 | 过滤器1 | 过滤器2 | … }}
- 特别注意: 

  - 排在第一个过滤器之后的其他过滤器，获得的参数值已经不是原始值，而是前一个过滤器加工过的中间产物

## Axios

### 什么是:

- Axios是基于Promise的专门发送ajax请求的第三方函数库

### 为什么:

- 浏览器中发送ajax请求: 4种方案:

  - (1)使用原生XHR对象——麻烦
  - (2)使用jQuery的封装函数——大材小用

    - Vue中很少使用DOM操作，或者几乎不用，所以没必要引入jQuery
    - 如果仅仅为了使用$.ajax一个函数而引入整个庞大的jQuery函数库，不划算

  - (3)使用官方提供的VueResource组件——官方废弃
  - (4)使用第三方工具Axios——本身与Vue没任何关系

### 何时:

- 只要在vue中发送ajax请求，都用axios
- 其实，在任何位置任何框架中都可通过axios发送ajax请求，甚至在nodejs服务端也可以用axios请求另一个服务端的数据

### 如何:

- 1.	在HTML页面中引入JS文件

  - <script src="js/axios.min.js"></script>

  - 在全局添加axios对象，包含发送http请求的api

- 2.	调用axios，发起异步请求

  - Get请求:

    - axios.get(“url”,{ 
      params: {
           //写在这里的参数值，会自动拼接到url结尾?后，随url发送给服务器端
      }
      }).then(res=>{ … })

  - Post请求: 

    - axios.post(
      “url”, 
      “变量=值&变量=值&…”//这里的参数会放在请求体中发送给服务器端
      ).then(res=>{ ... })

    - 问题: 

      - axios.post()默认不支持对象语法传参，只支持字符串传参

    - 解决: 

      - 引入qs模块

        - 专门将对象格式转为查询字符串格式

        - <script src="js/qs.min.js"

      - 使用

        - axios.post(“url”, Qs.stringify({ 参数: 值, 参数: 值, ... })).then()
        - 结果: 

          - stringify会将对象转化为queryString语法

  - 坑！！！：获得响应主体的数据: 数据不是直接返回，而是包裹在一个对象的data属性中返回。

    - res，不是服务器端响应结果
    - res.data，才能获得服务器端真正的响应结果

### 公司中做事

- 服务端基础地址，必须只能定义在一个位置，其它位置引用使用

  - config.js

    - const baseURL="http://localhost:5050"

  - axios.get(baseURL+"/index")

- 公司里都会先将每个服务端接口，封装在一个请求函数中，然后在需要发送请求时，通过调用函数发送请求，通过回调函数或Promise传入对响应结果的处理

  - 新建独立的js文件，保存操作一种东西的所有发送请求的函数

    - apis/product.js

      - const product={
        getIndex(){
        return axios.get(baseURL+"/index")
        //reutrn new Promise()
        },
        getDetailsById(id){

  }
  }

  - 引入独立的js模块，获得对象，解构出对象中想用的函数成员

    - 页面.js中

      - const {getIndex, getDetailsById}=product;
        getIndex().then(res=>{
        console.log(res.data)
        });

## 组件(Component)

### 什么是: 

- 拥有专属的HTML，CSS，js和数据的，可重用的页面独立区域
- 一个页面由多个组件聚合而成一个大型的页面
- 在代码层面上，一个组件就是一个可反复使用的自定义标签。

### vs jq插件 vs boot组件

- boot插件: 虽然可重用，但仍需要大量工作亲力亲为  且，不能绑定数据，比如: 轮播图，如果图片变化，就得改HTML，无法根据数据库变化，自动动态变化。

### 为什么:  

- 松散耦合，便于重用，便于大项目维护，便于协作开发

### 何时: 

- 今后，所有页面，都是由多个组件组合而成。      
  凡是重用的，必须先定义为组件，再使用

### 如何:

- (1)创建一个组件：

  - 根组件

    - <div id="app">
      ...

<div>
new Vue({
   el:"#app",
   data: { ... }
})
		- 一个SPA项目，只有一个new Vue()


	- 全局组件
	
		- Vue.component( '组件名' , {

   template: `HTML片段`,
   data(){  return {....} },
   methods:{ },
   computed: { },
   watch: { }
} )

			- Vue.component('组件名', {  
	
				- //组件名推荐写法: xz-counter  用横线分割多个单词，不推荐使用驼峰命名。因为组件名其实就是今后的HTML标签名。HTML标签是不区分大小的。单靠大小写不能唯一标识组件名
	
			- template: `
	
				- 不用el，是因为组件并不是一开始就在界面上的，是无法查找到的
				- 组件每使用一次，就会创建一次HTML片段的副本。最初定义的这一次HTML片段就称为之后组件的模板
				- //强调: 组件模板中，必须只能有一个父级根元素
	
					- //如果不加唯一父元素，报错: Component template should contain exactly one root element.
	
			- /*data:{  count: 1  }*/
	
				- //报错: The "data" option should be a function that returns a per-instance value in component definitions.
				- 因为每个组件要求必须有一个专属的data对象副本，而不是多个组件公用一个data对象
	
			- data: function(){  

  return { 
  }
}

				- 每使用一次组件，会自动调用data()函数，为本次组件副本创建一个data对象副本。来保证每个组件都有一个专属的data对象副本，互不影响

- (2)在视图中使用组件：

  - 组件其实就是一个可反复使用的HTML标签

    - <div id="app">
      <组件名></组件名>
      </div>

  - 原理: 

    - new Vue()扫描页面时，会发现不认识的标签。
    - 只要发现不认是的标签，就去Vue家里找有没有同名的组件。
    - 如果找到同名的组件，就用组件中的template模板创建HTML片段，添加到页面上，替换组件标签的位置
    - 并为这个区域定义组件对象，保存专属的data对象，添加数据绑定
    - 结果: 这次 创建的组件对象副本，就监控了这个组件的HTML区域

  - 其实: var vm=new Vue({ 

    - //也是一个组件，而且是整个页面的根组件

  - el:

    - //只有根组件，才能使用el属性来绑定根元素
    - //其它自定义子组件中，都必须使用template属性代替el:
    - //其余以下属性，子组件也可使用

## 组件化开发(重点&难点)

### 组件Component：是页面中的一块独立的，可重用的区域

- HTML中, 是一个可复用的用户自定义的扩展标签，运行时，被替换为组件对象内的HTML模板内容
- JS中，是一个可复用的Vue实例，包含独立的HTML模板，模型数据和功能

### 组件化开发

- 一个页面，都是由多块区域，多级组件组成的。

### 如何:

- 拿到一个网页后，先划分区域。每个区域，包括其子区域，都可以做成一个独立的组件。
- 面向组件式的开发：

  - 
  - 把大网页划分为若干组件组成的区域。
  - 每个区域都有专属性数据、HTML元素、CSS样式。

### 自定义组件有两种：

- (1)全局组件：可以在页面中任何一部分使用的组件

  - Vue.component('comp-name', {
    template: '  ',			//组件模板
    data: function(){
    	return { }			//专有的Model数据
    },
    props: ['属性1', '属性2', ...]	//自定义属性(也是Model)
    })

- (2)子组件：只能用于特定的父组件内的组件

  - 2步

    - 1. 先定义子组件对象

      - var xzChild1={		
        template: '',
        data: function(){return {}}
        }

        - 子组件命名，强烈建议用驼峰命名
        - //内容和Vue.component中的内容是一样的

    - 2. 将子组件对象添加到父组件中

      - Vue.component('父组件', {
        template: ' … … <子组件名/>… … ',  //包含局部组件元素的父组件模板HTML
        components: { //专门用于包含子组件的定义
        xzChild1,  //vue会自动将驼峰翻译为-分割。<xz-child1>
            ...
        }
        })

### 组件间的通信/数据传递( 难点 )

- 2大类

  - 父子间

    - 2种: 

      - 父->子

        - props down

          - 2步

            - 先在父组件中给子组件的自定义属性绑定一个父组件的变量

              - <template id="父">
                ... ...
                 <child :自定义属性名="父组件的变量"></child>

              - 结果: 将父组件中一个变量的值保存在子组件的一个自定义属性上

            - 子组件

              - var child={
                ... ...
                props:["自定义属性名"]
                }
              - 结果: 子组件对象中，可取出父组件放在子组件自定义属性上的变量值
              - props中的变量用法和data中变量用法完全一样，只不过值的来源不同

          - 如果父给子传递的是原始类型的值，其实传递的是原值的一个副本。所以在子组件中修改变量的值，不影响父组件。

          - 如果父给子传递的是一个引用类型的对象或数组，其实传递的是对象的地址。在子组件中修改变量，会影响父组件

      - 子->父

        - event up

          - 2步

            - 父组件

              - <template id="父">
                ... ....
                <child   @自定义事件="父的处理函数"

Vue.component("父",{
    ...
    methods:{
       父的处理函数(参数){
          参数得到子组件触发事件($emit)时，传递过来的数据
       }
    }
})

						- 子组件
	
							- js中，任何时候: this.$emit("自定义事件",this.数据)
	
	- 兄弟间
	
		- 数据总线机制
	
			- 3步
	
				- 创建全局空的Vue实例：bus
	
					- var bus=new Vue()
	
				- 接收者
	
					- 在bus上绑定自定义事件，并提供处理函数
					- Vue.component("...",{
	... ...
	mounted(){
	   //this->当前组件对象
	   bus.$on("自定义事件",(参数)=>{ //必须用箭头函数: 内外公用this！
	       //要求this->当前组件对象
	       //参数: 将会得到将来兄弟传来的值
	   })
	}

})

				- 发送者
	
					- 可在任意时候，触发bus上的别人自定义的事件: bus.$emit("别人自定义的事件",this.数据)

### 子主题 6

## 组件的生命周期(重点理论)

### 问题: 页面加载后执行:  window有onload，jQuery有$(document).ready()

但Vue是局部的，是组件式的，一个Vue组件何时加载完成？分几步？

### 类似于: 一个普通的HTML页面，加载过程会经历两个加载完成事件: DOMContentLoaded在仅DOM内容加载完就自动触发；window.onload在整个页面加载完才自动触发。

### 问题：如果希望一个VUE组件加载完成时，也能自动执行一个操作，应该怎么写？

### 1. 什么是: 一个组件从创建，到加载完成的整个过程。

### 2. 何时: 只要希望在组件加载过程中，某个阶段自动执行一项任务时，就要用到生命周期。

### 3. 包括: 4个阶段: 

- (1). 创建阶段(create): 创建组件对象，创建data对象，但是，在这个阶段还未创建虚拟DOM树

  - 可以操作data中的数据: 比如发送ajax请求
  - 不可以执行DOM操作

- (2). 挂载阶段(mount): 创建虚拟DOM树

  - 既可以操作data中的数据，比如发送ajax请求
  - 又可以执行DOM操作

- ================组件首次加载完成==============
- (3). 更新阶段(update): 只要data中的数据被改变，就会自动触发更新阶段。
- (4). 销毁阶段(destroy): 只有主动调用$destroy()方法销毁一个组件时才会自动触发——用的少

### 为了监听四个阶段，Vue.js提供了八个钩子函数

- 在组件加载过程中，自动执行的一种回调函数，称为钩子函数。不叫事件处理函数。
- 包括

  - beforeCreate(){ }

    - 组件创建之前自动调用 —— $el: undefined, data: undefined

  - created(){ }

    - 组件创建完成自动调用 —— $el: undefined, data: { … } ——已可以获取或操作模型数据——可ajax请求

  - beforeMount(){ }

    - 组件挂载到DOM树之前调用 —— $el: undefined, data: { … }

  - mounted(){ }

    - 组件挂载到DOM树之后调用 —— $el: DOM, data: { … } ——可ajax请求数据，也可操作页面元素

  - beforeUpdate(){ }

    - 组件中模型数据发生改变需要更新DOM之前调用

  - updated(){ }

    - 组件中模型数据发生改变需要更新DOM之后调用

  - beforeDestroy(){ }

    - 组件被从DOM上销毁之前调用

  - destroyed(){ }

    - 组件被从DOM上销毁之后调用

- 如果路由跳转时，并未更换页面组件，而是在同一个页面组件中，仅更换部分值，则不会重复执行创建和挂载阶段的。导致放在created中和mounted中的axios请求，不会重复发送，也就无法自动获得新的查询结果。

## SPA应用

### 单页面应用

- 整个应用程序只有一个完整的.html文件
- 切换不同的"页面"， 其实是在切换不同的组件。只是用不同的组件，替换唯一的.html中指定区域的内容而已

### vs 多页面应用

- 1. 页面个数

  - 多页面

    - 多个.html文件

  - 单页面

    - 只有一个完整的.html文件，其余"页面"，其实都是组件

- 2. 页面跳转

  - 多页面

    - 删除整棵DOM树，重新下载新的.html文件，重建新的DOM树

  - 单页面

    - 重新加载一个页面组件，不需要重建整棵DOM树，而是局部替换原DOM树中指定元素位置即可

- 3. 资源重用

  - 多页面

    - 即使有可重用的资源(css或js)，每个页面也必须重新请求一次

  - 单页面

    - 只在首次加载时，就请求一次。之后切换页面，不需要重新请求。

- 4. 页面切换动画

  - 多页面

    - 不可能实现

  - 单页面

    - 轻松实现

### 如何实现

- 1. 创建一个唯一完整的支持vue的html页面

  - 引入vue-router.js组件，并在<body>中用<router-view>为之后的页面组件预留空间
  - 引入其它页面组件
  - 引入其它公用的资源css或js

- 2. 为每个页面都创建一个页面组件

  - 其实就是子组件，只不过当做一个页面用而已
  - 每个页面组件还可继续包含子组件(components)

- 3. 创建路由器

  - 3.1 先创建路由字典

    - 路由字典是包含相对路径和页面组件间对应关系的数组
    - var routes=[
      {path:"/", component: 默认首页的页面组件 },
       {path:"/相对路径", component: 页面组件 },
       ... ...
       {path:"*", component:notFound}
      ]

  - 3.2 创建路由器对象

    - var router=new VueRouter({ routes })

  - 结果： 

    - router对象监控着地址栏中的路径
    - 只要地址栏中路径变化，就拿新的路径在路由字典中查找是否有匹配的路由
    - 如果有匹配的路由，就找到该路由对应的页面组件对象
    - 用页面组件对象代替唯一完整的.html文件中<router-view>预留的位置

- 4. 将路由器对象引入到唯一完整的html页面中
     new Vue({ 
       ...,
       router
     })

- 5. 如果有全局组件，不需要创建为子组件，依然用Vue.component()创建。全局组件可在任意"页面"组件或唯一完整的html文件中引用。

### 页面跳转

- html中

  - <router-link to="/相对路径">文本</router-link>
  - 运行时，会被翻译为<a href="#/相对路径">文本</a>
  - 因为将来路径中不一定总带#。如果用a，必须自己记住该不该加#。如果用router-link，可自动判断自动添加#。

- js中

  - this.$router.push("/相对路径")
  - $router就是new VueRouter()创建的路由器router对象，专门执行"页面"间跳转动作

- 路由参数

  - 1. 路由字典中，让当前路劲支持传参: 

    - {path:"/相对路径/:参数名", component:xxx, props:true}

  - 2. 在页面组件中添加同名自定义属性

    - props:["参数名"]

  - 3. 跳转时

    - /相对路径/参数值

  - 结果

    - 参数值会自动传给props中的参数名属性，在页面组件中，可用this.参数名方式，访问参数值！

### $router vs $route

- 1. $router是路由器对象，专门执行跳转动作！

- 2. $route是保存地址栏中信息的对象。只要希望获得地址栏中的信息时，才适用$route。类似于bom中的location.href。

  - 比如: 获得路由地址中的参数，不一定非要用props，还可以:

    - this.$route.params.lid

### 子主题 5

## Vue-CLI脚手架

### 已经包含核心功能的半成品项目。开发人员只需要添加个性化功能即可

### 为什么

- 为了统一所有vue项目的标准结构，便于分工协作

### 何时

- 今后企业中项目，都是先创建半成品脚手架代码，再在统一的脚手架代码结构基础上，添加个性化的功能

### 使用步骤

- (1)安装可以反复生成脚手架代码的命令行工具

  - npm  i   -g  @vue/cli

- (2)运行命令行工具，为一个项目创建脚手架代码

  - vue  create  my_project

- (3)进入项目文件夹内(看到package.json文件)，运行该项目

  - npm   run   serve

    - 1. 启动一个简易的开发服务器(类似于live server)
    - 2. 编译脚手架中代码为传统的HTML CSS和js代码

  - vs code中按住ctrl 点连接地址，就打开浏览器和示例网页
  - 之后每次修改源代码，run serve会自动监视代码修改，自动重新编译项目，自动刷新已经打开的浏览器窗口

- (4)手动访问该项目

  - http://127.0.0.1:8080

### 补充安装axios

- npm i -s axios
- 在main.js中，先配置axios的基础路径，再将axios添加到Vue的原型对象中

  - import axios from "axios"
    import {baseURL} from "./assets/js/config"

axios.defaults.baseURL=baseURL;
axios.defaults.withCredentials=true;

Vue.prototype.axios=axios;

- 结果: 

  - 在所有组件的任何位置，都可以使用this.axios.get()或this.axios.post()

### 项目结构 vs spa

- 1. 创建唯一完整的html文件

  - spa中

    - index.html
      <html>

 <head>
  <link>
  <script>
 </head>

 <body>

  <div id="app">
   <router-view>
  </div>
  <script>
   new Vue({
     ... ...
   })
 </body>



	- 脚手架中
	
		- public文件夹/

  imgs/当前项目用到的所有图片
  css/ 当前项目公用的第三方css，比如bootstrap.min.css
  js/ 当前项目公用的第三方js，比如: jquery.min.js, bootstrap.min.js
  index.html 唯一完整的html文件，只包含<div id="app">，不包含<router-view>和new Vue()

src/文件夹下
 App.vue

  <div id="app">
   <router-view>
  可能还包含所有网页公用的样式和公用的组件，比如页头.
 main.js
  new Vue({...})
总结: App.vue+main.js，放入index.html后，才相当于咱们做的完整的index.html



- 2. 创建页面组件

  - spa中

    - index.js
      var index={
      template:`html片段`,
      data(){ return {}},
      methods:{ },
      ... ...
      }
      details.js
      notFound.js


	- 脚手架中
	
		- src/文件夹下

  views/文件夹下
  放所有页面组件
  有几个页面，就要有几个组件
  每个组件都是一个.vue文件。每个vue文件由三部分组成: 

  <template>
    当前组件的HTML片段，要求只能有一个统一的父元素包裹。
  </tempalte>
  <script>
    export default {
      没有template，
      组件结构:
      data(){return {}},
      methods:{...},
      watch:{ ... },
      computed:{ ... },
      components:{ }
    }
  </script>
  <style scoped>
    仅当前组件使用的css
  </style>
每个.vue文件，最后都会被编译为传统的html,css和js，才能被浏览器认识



- 3. 创建路由器

  - spa中

    - 在index.html顶部用script src="index.js"引入页面组件对象
      然后
      router.js
      var routes=[
      ... 
      ];
      var router=
      new VueRouter({routes})


	- 脚手架中
	
		- src/文件夹下

  router/文件夹
    index.js
     先引入页面组件
     import 页面组件 from "./views/页面组件.vue"

     new VueRouter({[
       路由字典
     ]})


- 4. 将router加入new Vue()

  - spa中

    - 手动加入index.html中的new Vue()中

  - 脚手架

    - src/main.js 自动添加
      new Vue({ router ,..})

- 5. 全局组件

  - spa中

    - my-header.js
      Vue.component()

  - 脚手架中

    - src/文件夹下
      components/
       my-header.vue
       每个组件的组成三部分，和页面组件的三部分是完全一样的


- 6. 自己编写的公用的css和js

  - 脚手架中

    - src/文件夹下
      assets/文件夹
      css/ 自己编写的所有页面公用的css
      js/ 自己编写的所有页面公用的js


## es6模块化开发

### 1. 什么是: 将一个功能的代码，保存在一个模块中，通过引用的方式，使用。

### 2. 回顾:node中的模块化: 

- (1). node中每个.js文件，就是一个模块，但是模块内的代码是自有的。模块外默认用不了！
- (2). 每个js文件中的代码(方法，属性)必须导出后，才能被其它模块使用: 

  - module.exports={ 要导出的方法名和属性名 }

- (3). 其它模块想用这个模块的成员，必须先引入，再使用: 

  - var 变量=require("./模块所在文件的相对路径")
  - 变量.成员

### 3. ES6中的模块化: 

- (1). ES6中也规定了模块化开发，但是浏览器都不支持！目前只有脚手架才支持。
- (2). 和node一样，每个.js或.vue都是一个模块对象。每个模块对象，要想让别人使用，也必须先导出: 

  - export const 变量名=值
  - export function 函数名(){ ... }
  - 一个文件中可以包含很多export xxx

- (3). 其它模块要想使用这个模块的成员，也必须先引入后才能使用

  - import {成员名1, 成员名2, ...} from "./模块所在文件的相对路径"
  - 成员1()

### 4. 脚手架中的模块化: 

- (1). 每个页面或者组件都是一个.vue文件，每个.vue文件都是一个模块。要想让别人知道有这个模块，必须先导出才行: 

  - views/index.vue中

    - <script>
      export default {
       data(){ ... },
       methods:{ ... },
       ... ...
      }
      </script>

- (2). 如果在路由器router.js文件中，想使用某个页面组件，必须先引入，再放到路由字典中: 

  - import Index from "./views/index.vue"

new VueRouter({[
    {path:"/", component:Index}
]})

- (3). 全局组件: 

  - a. 在定义全局组件时，和普通页面组件、子组件没有任何差别。其实也只是一个普通的对象模块。

    - components/MyHeader.js

    - <script>
      export default {
      ... ...
      }
      </script>

  - b. 如果要让这个组件变成全局组件

    - 1). 先将组件对象引入到main.js中: 
    - 2). 让组件对象变成全局组件
    - main.js中

      - import MyHeader from "./components/MyHeader.vue"
      - Vue.component("my-header",MyHeader)
      - MyHeader才会成为全局组件

- (4). 调用对象模块

  - assets/js/apis/index.js中

    - export {
      getIndex(){
       ... ...
      }
      }

  - Index.vue中

    - 先引入

      - import {getIndex} from "../assets/js/apis/index.js"
      - 再getIndex().then(result=>{})
      - 强调: 

        - 必须使用箭头函数，为了保证回调函数内的this和vue中的this保持一致

## 六. 封装axios请求函数: 

### 1. 定义模块专门保存服务器端基础地址: 

- src/assets/js/config.js中:
- export const baseURL="http://localhost:5050"

### 2. 定义访问某个接口的函数: 

- src/assets/js/apis/index.js中：
- (1). 先引入axios和config.js

  - import axios from "axios"

    - 需要先在main.js中

      - import axios from "axios"
      - axios.defaults.baseURL=baseURL

    - 因为模块化开发采用单例模式，每个模块在内存中只有一份，所以，在main.js中设置的baseURL，今后在其他文件中，引入axios时，依然可用

  - import {baseURL} from "../config.js"
  - 强调: import后不要为模块对象起别名，而是直接用解构语法取出对象中的成员。

- (2). 在定义支持promise的函数，专门向一个接口发送请求: 

  - function getIndex(){
    return new Promise(
    	function(resolve,reject){
    		axios.get(baseURL+"/index")
    		.then(result=>{
    			resolve(result.data)
    		})
    	}
    )
    }


- (3). 导出函数: export { getIndex }

### 3. 在组件中引入函数，并调用函数发送请求，获得响应结果继续操作

- (1). 先引入包含函数的模块

  - import {getIndex} from '../assets/js/apis/index.js'

- (2). 在组件代码中调用函数
- getIndex().then(result=>{
  //将result中的数据，放到data中
  })

### 强调: 

- 1. 一定要用箭头函数！保持回调函数中的this和vue中this保持一致，都指向当前组件对象。
- 2. result已经时返回的结果了，不用再result.data。

## 路由懒加载

### 问题: webpack如果把所有的js文件都打成一个js文件，包会很大，严重影响页面首屏加载速度

### 解决

- 懒加载

  - 把不同路由对应的组件分割成不同的代码块
  - 当路由被访问时，才动态加载对应组件文件

### 如何

- router.js中或router/index.js中的路由列表routes数组里，需要懒加载的路由地址

  - 不要过早import，应该是在路由首次被访问到时，才import
  - {
    path: '/about',
    name: 'about',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/About.vue')
    }

    - 其中/**/注释是webpack专用数值，其中的chunkname:"名称"作为将来webpack打包时的分文件名，所以，这个注释中的名字要尽量和当前路由或页面组件名保持一致

### 坑

- 仅使用上边一步是无法实现动态懒加载的
- 原因

  - 脚手架默认采用babel翻译js代码，要想懒加载，必须让babel知道才行

- 解决

  - 手动安装一个babel的插件 

    - npm i -save @babel/plugin-syntax-dynamic-import

### 结果: 

- npm run build

  - 编译完成的结果中应该可以看到以要懒加载的组件命名的独立js文件

- 浏览器网站时，打开network，只监控js文件，刷新页面

  - 如果不访问懒加载的页面，是不会加载独立.js文件的
  - 只有访问到要懒加载的页面，才会动态加载独立.js文件

### 问题

- 虽然实现了懒加载，但是，其实独立.js文件还会在后台自动下载
- <link href="/js/about.js" rel="prefetch">

  - 其中prefetch意思是，一旦网络空闲，就自动下载独立.js文件
  - 悄悄的浪费手机流量！

- 解决

  - 项目的根目录(不是src下)

    - 新建vue.config.js文件

      - 是vue/cli 3.0版本的新的webpack配置文件

    - 在vue.config.js中

      - module.exports={
        chainWebpack:config=>{
        config.plugins.delete("prefetch")
        }
        }

- 结果: 

  - 页面的head中，再看不到<link href="/js/about.js" rel="prefetch">

## history路由模式

### vue-router中默认的路由模式采用hash模式，也就是#/路由地址

### 启用history路由模式，就不会看到#，仅剩/路由地址

### 问题

- 客户端也有路由地址，服务端也有路由地址，而且有可能重名

  - 服务端: /index
  - VUE中: /index

- 浏览器只要看到不带#的地址，都会发送给服务器端

### 解决: 

- 在服务器端配置重定向

  - 发现来源的域名地址不是服务器端域名地址，只是相对路径相同，则重新返回给浏览器，请浏览器解析
  - 比如

    - 服务器端地址: http://xzserver.applinzi.com/index
    - 客户端地址: http://localhost:8080/index
    - 当服务端接收到http://localhost:8080/index，地址时，就不再解析，而是返回给客户端浏览器，请客户端浏览器中的vue-router解析

### 如何

- vue脚手架中

  - router.js或router/index.js中

    - new VueRouter({
      mode:"history",
       routes
      })

- nodejs

  - 安装一个专门支持histroy重定向的中间件

    - npm i -s connect-history-api-fallback

  - 在app.js中

    - 先引入history模块

      - require("connect-history-api-fallback")

    - var app=express()后, 插入app.use(history())

### 虽然改成history模式，但是依然可用#/方式和不带#方式并存

### 遗留问题

- 重定向后，刷新页面，会导致样式和图片路径都找不到

- 解决

  - 1. 所有图片和可直接使用的第三方的js和css文件，都放在public下

    - public
      /css
      bootstrap.min.css
       /js
      jquery-3.4.1.min.js
      bootstrap.min.js
       /img
      logo.png
       index.html
      src/
      ...

  - 2. 在唯一完整的index.html网页中，引入public下的第三方js和css文件时必须以/开头，不能用相对路径

    - <link rel="stylesheet" href="/css/bootstrap.min.css"

    - <script src="/js/jquery-3.4.1.min.js">

  - 3. 所有<img>的src属性，必须以/开头，也不能用相对路径, 比如 <img src="/img/logo.png"

  - 4. 服务器端请求来的src属性的地址，如果不带/开头，需要先通过遍历或字符串拼接方式，把src属性值前拼上"/"+xxx

## keep-alive缓存和路由守卫

### keep-alive

- 可以缓存组件的内容，避免组件反复加载，影响效率
- 何时

  - 只要我们希望一个组件的内容，不要重复加载时

- 如何缓存页面

  - router.js或router/index.js中

    - 在需要缓存的路由上添加meta:{keepAlive:true}

      - {
        path: '/',
        name: 'home',
        component: Home,
        meta:{
        keepAlive:true
        }
        }
      - 其中,

        - meta不能改名！因为meta是路由对象专门定义，用来保存自定义的属性值的配置项
        - 但是keepAlive是自定义的属性，可以改名

  - 在App.vue中

    - 如果当前路由需要缓存($route.meta.keepAlive==true)，就放在keep-alive包裹的一个router-view中
    - 如果当前路由不需要缓存($route.meta.keepAlive==false)，就放在keep-alive外的一个router-view上
    - <keep-alive>
      <router-view v-if="$route.meta.keepAlive"/>
      </keep-alive>
      <router-view v-if="!$route.meta.keepAlive"></router-view>

- 结果: 

  - 带有keepAlive:true的路由对应的页面，只在首次请求时，渲染一次内容。之后后退，跳转回来，都不再重新渲染内容

- 问题: 

  - 虽然是同一个页面，但是有时数据需要缓存，有时数据不需要缓存
  - 比如: 

    - 假如有一个商品列表页面，可以根据关键词，查询商品列表
    - 如果从首页跳转过来，说明用户新输入了查询条件，需要更新查询结果
    - 如果从详情页跳转过来，说明用户从商品列表页面跳出去的，现在又返回商品列表页面，那么应该保留之前的搜索结果。

### 路由守卫/路由钩子函数

- 在发生路由跳转时，自动执行的回调函数
- 何时: 

  - 如果希望在跳进跳出一个路由时，自动执行一项任务

- 包括:

  - 导航被触发。
    在失活的组件里调用离开守卫beforeRouteLeave。
    调用全局的 beforeEach 守卫。
    在重用的组件里调用 beforeRouteUpdate 守卫 (2.2+)。
    在路由配置里调用 beforeEnter。
    解析异步路由组件。
    在被激活的组件里调用 beforeRouteEnter。
    调用全局的 beforeResolve 守卫 (2.5+)。
    导航被确认。
    调用全局的 afterEach 钩子。
    触发 DOM 更新。
    用创建好的实例调用 beforeRouteEnter 守卫中传给 next 的回调函数。

- 比如： 

  - 从首页进入商品列表页面时，不需要缓存，需要重新搜索

    - Home.vue中

      - beforeRouteLeave(to,from,next){
        console.log(`路由离开home...`);
        //如果从首页跳到products
        if(to.name=="products"){
        to.meta.keepAlive=false;
        }
        next();
        }

  - 从商品列表页面跳到详情页，需要设置当前商品列表页面被缓存

    - Products.vue中

      - beforeRouteLeave(to, from , next){
        console.log("离开商品列表页面");
        if(to.name=="details"){
        from.meta.keepAlive=true;
        }
        next();
        }

  - 从详情页跳回商品列表页面时，需要设置商品列表页面缓存

    - Details.vue

      - beforeRouteLeave(to, from, next){
        console.log(`路由离开details...`);
        if(to.name=="products"){
        to.meta.keepAlive=true;
        }
        next();
        },

