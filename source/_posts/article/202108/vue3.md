---
title: vue3的一些知识点
date: 2021-08-22
tags:
- vue3
categories: vue
cover: https://z3.ax1x.com/2021/08/22/hSw6bD.jpg
---

入口main.js:
``` javascript
// 引入createApp函数,创建对应的应用,产生应用的实例对象
import { createApp } from 'vue';
// 引入app组件(所有组件的父级组件)
import App from './App.vue';
// 创建app应用返回对应的实例对象,调用mount方法进行挂载  挂载到#app节点上去
createApp(App).mount('#app');
```

``` javascript
//Vue2组件中的html模板中必须要有一对根标签,Vue3组件的html模板中可以没有根标签
<template>
  <img alt="Vue logo" src="./assets/logo.png">
  <!-- 使用子级组件 -->
  <HelloWorld msg="Welcome to Your Vue.js + TypeScript App" />
</template>

App.vue
<script lang="ts">
// 这里可以书写TS代码

// defineComponent函数,目的是定义一个组件 内部可以传入一个配置对象
import { defineComponent } from 'vue';
//引入子级组件
import HelloWorld from './components/HelloWorld.vue';

// 暴露出去一个定义好的组件
export default defineComponent({
  // 当前组件的名字
  name: 'App',
  // 注册组件
  components: {
    // 注册一个子级组件
    HelloWorld,
  },
});
</script>
```

# Composition API

## setup

setup只在beforeCreate生命周期之前执行一次，所有的Composition API函数都在此使用。

### setup的参数(props,context)

- props: 是一个对象,里面有父级组件向子级组件传递的数据,并且是在子级组件中使用props接收到的所有的属性
- context：上下文对象，可以通过es6语法解构 setup(props, {attrs, slots, emit})

  - attrs: 获取当前组件标签上所有没有通过props接收的属性的对象, 相当于 this.$attrs
  - slots: 包含所有传入的插槽内容的对象, 相当于 this.$slots
  - emit: 用来分发自定义事件的函数, 相当于 this.$emit

## ref

定义一个响应式的数据(一般用来定义一个基本类型的响应式数据Undefined、Null、Boolean、Number和String)

``` javascript
const xxx = ref(initValue):
```

script中操作数据需要使用xxx.value的形式，而模板中不需要添加.value

### 获取dom节点

在Vue2中我们通过this.$refs来获取dom节点，Vue3中我们通过ref来获取节点

首先需要在标签上添加ref='xxx'，然后再setup中定义一个初始值为null的ref类型,名字要和标签的ref属性一致

## reactive

``` javascript
const proxy = reactive(obj)
```

定义多个数据的响应式，接收一个普通对象然后返回该普通对象的响应式代理器对象(Proxy)

## computed

与Vue2中的computed配置功能一致，返回的是一个ref类型的对象

``` javascript
const fullName1 = computed(() => {
  return user.firstName + user.lastName;
});

const fullName2 = computed({
  get() {
    return user.firstName + '_' + user.lastName;
  },
  set(val: string) {
    const names = val.split('_');
    user.firstName = names[0];
    user.lastName = names[1];
  },
});

```

## watch

与Vue2中的watch配置功能一致,监视指定的一个或多个响应式数据, 一旦数据变化, 就自动执行监视回调

``` js
watch(source, callback, [options])
```

- source: 可以支持 string,Object,Function,Array; 用于指定要侦听的响应式变量
- callback: 执行的回调函数
- options：支持 deep、immediate 和 flush 选项。

watch监听非响应式数据的时候需要使用回调函数的形式

``` javascript
watch([()=>user.firstName,()=>user.lastName,fullName3],()=>{console.log('我执行了')})
```

stop 停止监听:调用watch()函数的返回值

## watchEffect

监视数据发生变化时执行回调，不用直接指定要监视的数据, 回调函数中使用的哪些响应式数据就监视哪些响应式数据，默认初始时就会执行第一次, 从而可以收集需要监视的数据。

watchEffect 不需要手动传入依赖
watchEffect 会先执行一次用来自动收集依赖
watchEffect 无法获取到变化前的值， 只能获取变化后的值

## toRefs

把一个响应式对象转换成普通对象，该普通对象的每个属性都是一个 ref

利用toRefs可以将一个响应式 reactive 对象的所有原始属性转换为响应式的ref属性。

# 其它

## 自定义Hooks

## Teleport

Teleport 提供了一种干净的方法, 让组件的html在父组件界面外的特定标签(很可能是body)下插入显示 换句话说就是可以把 子组件 或者 dom节点 插入到任何你想插入到的地方去

## Suspense

它们允许我们的应用程序在等待异步组件时渲染一些后备内容，可以让我们创建一个平滑的用户体验

``` javascript
<Suspense>
    <template v-slot:default>
      <!-- 异步组件 -->
      <AsyncComp />
    </template>

    <template v-slot:fallback>
      <!-- 后备内容 -->
      <h1>LOADING...</h1>
    </template>
  </Suspense>
```

## 片段（Fragment）

在 Vue2.x 中， template中只允许有一个根节点，但是在 Vue3.x 中，你可以直接写多个根节点，

## Tree-Shaking

## 语法糖 script setup

只需要在script标签中添加setup，组件只需引入不用注册，属性和方法也不用返回，setup函数也不需要，甚至export default都不用写了，不仅是数据，计算属性和方法，甚至是自定义指令也可以在我们的template中自动获得。

setup script语法糖提供了三个新的API来供我们使用：defineProps、defineEmit和useContext

- defineProps 用来接收父组件传来的值props。
- defineEmit   用来声明触发的事件表。
- useContext  用来获取组件上下文context。

## 跨组件通讯mitt.js

## 自定义指令

bind => beforeMount
inserted => mounted
beforeUpdate: 新的钩子，会在元素自身更新前触发
update => 移除！
componentUpdated => updated
beforeUnmount: 新的钩子，当元素自身被卸载前触发
unbind => unmounted
