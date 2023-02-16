---
title: vue源码知识点
tags:
  - vue
categories: vue
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/baby.png
date: 2023-02-16 18:00:00
---

# new Vue 发生了什么？

合并配置、初始化生命周期、初始化自定义事件、渲染、beforeCreate、初始化 inject、响应式 state、provide、created、mount 挂载。

# 从模板和数据渲染到最终的页面？

new Vue → init → $mount → compile → render → vnode → patch → DOM

# Vue 的异步更新

利用浏览器的异步任务队列实现。

数据更新后，调用 dep.notify()方法，通知 dep 里的所有 watcher 执行 update 方法，wathcer.update 将 watcher 自己放入一个 watcher 队列（全局 queue 数组）。

通过 nextTick 方法将一个刷新 watcher 队列的方法（flushSchedulerQueue 函数）放入全局的 callbacks 数组中。如果浏览器队列里没有 flushCallbacks 的函数，则执行 timeFunc 方法，将 flushCallbacks 加入异步队列

flushCallbacks 执行 callbacks 数组里的所有 flushSchedulerQueue 函数。

flushSchedulerQueue 负责刷新 wathcer 队列，执行每一个 watcher 的 run 方法，进入更新阶段。

全局 queue 数组：在 queueWatcher 时放入所有需要执行的 watcher，在异步后执行 flushSchedulerQueue 时清空；

全局 callbacks 数组：在 nextTick 时放入包装的 flushSchedulerQueue 函数，或者自定义的 nextTick 方法，在 flushCallbacks 时清空；

watcher.id：如果 watcher 已经存在，则跳过，不会重复入队；

flushing：如果没有处于刷新队列状态，watcher 直接入队；如果已经在刷新队列，则将 watcher 放入当前 watcher 的下一个位置；

waiting：判断是否在刷新队列，避免重复执行刷新队列的方法，在 flushSchedulerQueue 时重新置 false；

pending：判断浏览器异步任务中是否有刷新 callbacks 数组的任务，避免重复执行刷新 callbacks 数组的任务，在 flushCallbacks 时重新置 false。

# nextTick 的原理？

将回调函数用 trycatch 包裹放入 callbacks 数组（与刷新 watcher 队列的函数在一个数组里），

执行 timeFunc 方法，在异步队列放入刷新 callbacks 数组的函数。

从而保证【在下次 DOM 更新循环结束之后执行延迟回调，修改数据后立即使用这个方法，可以获取更新后的 DOM】

# 响应式原理？

在初始化 initData 里，为对象设置响应式 observe，**注意这里只是使用 Object.defineProperty 去设置响应式**，在挂载时，访问数据时才会去收集依赖，设置数据时通知 watcher 更新。数组使用更改数组自身的 7 个原型方法去进行拦截的操作。

# 双向绑定原理？

vue 使用 v-model 绑定数据，v-model 是 value 和 input 方法的语法糖，value 发生变化，触发 setter，执行 dep.notify()，通知所有 watcher，watcher 执行 update 回调函数，调用 compiler 编译解析模块，重新更新视图。

# mount 挂载的实现

判断有没有定义 render 方法，没有则会把 el 或 template 字符串转换成 render 方法，通过 compileToFunctions 方法实现，然后调用原型方法上的$mount 方法，执行 mountComponent 方法，在其中实例化渲染 Watcher，调用 updateComponent 方法，此方法中调用 vm.\_render 生成 vnode，最终调用 vm.\_update 更新 DOM。

# vue 的编译过程

将 template 模板转换成 html 字符串，通过循环遍历的方式处理其中的各个标签及属性，解析成 ast 对象，生成 render 函数，执行 render 函数生成 vnode，patch vnode 后 createElement 生成最终的 DOM。

处理 v-属性：遍历字符串时处理，将元素处理为 ast 对象，然后判断里面是否有 v-的属性，然后进一步处理，放入了 directive 属性下，如 v-model 处理为 name 为 model，value 为 value 值；v-for 处理为 for：arr，将结果设置到 el 对象上

- ast 对象：
  ```jsx
  const ast = {
    type: 1,
    tag,
    attrsList: [{ name: attrName, value: attrVal, start, end }],
    attrsMap: { attrName: attrVal, },
    rawAttrsMap: { attrName: attrVal, type: checkbox },
    // v-if
    ifConditions: [{ exp, block }],
    // v-for
    for: iterator,
    alias: 别名,
    // :key
    key: xx,
    // ref
    ref: xx,
    refInFor: boolean,
    // 插槽
    slotTarget: slotName,
    slotTargetDynamic: boolean,
    slotScope: 作用域插槽的表达式,
    scopeSlot: {
      name: {
        slotTarget: slotName,
        slotTargetDynamic: boolean,
        children: {
          parent: container,
          otherProperty,
        }
      },
      slotScope: 作用域插槽的表达式,
    },
    slotName: xx,
    // 动态组件
    component: compName,
    inlineTemplate: boolean,
    // class
    staticClass: className,
    classBinding: xx,
    // style
    staticStyle: xx,
    styleBinding: xx,
    // attr
    hasBindings: boolean,
    nativeEvents: {同 evetns},
  	// @event
    events: {
      name: [{ value, dynamic, start, end, modifiers }]
    },
    props: [{ name, value, dynamic, start, end }],
    dynamicAttrs: [同 attrs],
    attrs: [{ name, value, dynamic, start, end }],
  	// v-model v-自定义
    directives: [{ name, rawName, value, arg, isDynamicArg, modifiers, start, end }],
    // v-pre
    pre: true,
    // v-once
    once: true,
    parent,
    children: [],
    plain: boolean,
  }
  ```

# patch 算法

初始化调用：`this._init(options)` => `vm.$mount(vm.$options.el)` => `mountComponent(this, el, hydrating)` => `new Watcher()` => `watcher.get()` => `updateComponent()` => `vm._update(vm._render(), hydrating)` => `vm.__patch__(vm.$el, vnode, hydrating, false)`

更新时调用：`observe.set()` => `dep.notify()` => `watcher.update()` => `nextTick()` => `watcher.run()` => `watcher.get()` => `updateComponent()` => `vm._update(vm._render(), hydrating)` => `vm.__patch__(prevVnode, vnode)`

# 选项合并策略

选项合并主要合并 mixin、extends 的选项，以子组件的 options 为主。

# keep-alive

是一个抽象组件，他的实现通过自定义 render 函数利用了插槽，在 patch 过程中对于已经缓存的组件不会执行 mounted，但提供了 activated 和 deactivated 钩子函数。

缓存组件放哪里了：挂在 keepalive 组件的 cache 属性上

# Observer

```jsx
/**
 * 观察者类，会被附加到每个被观察的对象上，value.__ob__ = this
 * 而对象的各个属性则会被转换成 getter/setter，并收集依赖和通知更新
 */
export class Observer {
  value: any;
  dep: Dep;
  vmCount: number; // number of vms that have this object as root $data

  constructor(value: any) {
    this.value = value;
    // 实例话一个 dep
    this.dep = new Dep();
    this.vmCount = 0;
    // 在 value 对象上设置 __ob__ 属性
    def(value, '__ob__', this);
    if (Array.isArray(value)) {
      /**
       * value 为数组
       * hasProto = '__proto__' in {}
       * 用于判断对象是否存在 __proto__ 属性，通过 obj.__proto__ 可以访问对象的原型链
       * 但由于 __proto__ 不是标准属性，所以有些浏览器不支持，比如 IE6-10，Opera10.1
       * 为什么要判断，是因为一会儿要通过 __proto__ 操作数据的原型链
       * 覆盖数组默认的七个原型方法，以实现数组响应式
       */
      if (hasProto) {
        // 有 __proto__
        protoAugment(value, arrayMethods);
      } else {
        copyAugment(value, arrayMethods, arrayKeys);
      }
      this.observeArray(value);
    } else {
      // value 为对象，为对象的每个属性（包括嵌套对象）设置响应式
      this.walk(value);
    }
  }

  /**
   * 遍历对象上的每个 key，为每个 key 设置响应式
   * 仅当值为对象时才会走这里
   */
  walk(obj: Object) {
    const keys = Object.keys(obj);
    for (let i = 0; i < keys.length; i++) {
      defineReactive(obj, keys[i]);
    }
  }

  /**
   * 遍历数组，为数组的每一项设置观察，处理数组元素为对象的情况
   */
  observeArray(items: Array<any>) {
    for (let i = 0, l = items.length; i < l; i++) {
      observe(items[i]);
    }
  }
}
```

# Dep

```jsx
import type Watcher from './watcher';
import { remove } from '../util/index';
import config from '../config';

let uid = 0;

/**
 * 一个 dep 对应一个 obj.key
 * 在读取响应式数据时，负责收集依赖，每个 dep（或者说 obj.key）依赖的 watcher 有哪些
 * 在响应式数据更新时，负责通知 dep 中那些 watcher 去执行 update 方法
 */
export default class Dep {
  static target: ?Watcher;
  id: number;
  subs: Array<Watcher>;

  constructor() {
    this.id = uid++;
    this.subs = [];
  }

  // 在 dep 中添加 watcher
  addSub(sub: Watcher) {
    this.subs.push(sub);
  }

  removeSub(sub: Watcher) {
    remove(this.subs, sub);
  }

  // 像 watcher 中添加 dep
  depend() {
    if (Dep.target) {
      Dep.target.addDep(this);
    }
  }

  /**
   * 通知 dep 中的所有 watcher，执行 watcher.update() 方法
   */
  notify() {
    // stabilize the subscriber list first
    const subs = this.subs.slice();
    if (process.env.NODE_ENV !== 'production' && !config.async) {
      // subs aren't sorted in scheduler if not running async
      // we need to sort them now to make sure they fire in correct
      // order
      subs.sort((a, b) => a.id - b.id);
    }
    // 遍历 dep 中存储的 watcher，执行 watcher.update()
    for (let i = 0, l = subs.length; i < l; i++) {
      subs[i].update();
    }
  }
}

/**
 * 当前正在执行的 watcher，同一时间只会有一个 watcher 在执行
 * Dep.target = 当前正在执行的 watcher
 * 通过调用 pushTarget 方法完成赋值，调用 popTarget 方法完成重置（null)
 */
Dep.target = null;
const targetStack = [];

// 在需要进行依赖收集的时候调用，设置 Dep.target = watcher
export function pushTarget(target: ?Watcher) {
  targetStack.push(target);
  Dep.target = target;
}

// 依赖收集结束调用，设置 Dep.target = null
export function popTarget() {
  targetStack.pop();
  Dep.target = targetStack[targetStack.length - 1];
}
```

# Watcher

```jsx
/**
 * 一个组件一个 watcher（渲染 watcher）或者一个表达式一个 watcher（用户watcher）
 * 当数据更新时 watcher 会被触发，访问 this.computedProperty 时也会触发 watcher
 */
export default class Watcher {
  vm: Component;
  expression: string;
  cb: Function;
  id: number;
  deep: boolean;
  user: boolean;
  lazy: boolean;
  sync: boolean;
  dirty: boolean;
  active: boolean;
  deps: Array<Dep>;
  newDeps: Array<Dep>;
  depIds: SimpleSet;
  newDepIds: SimpleSet;
  before: ?Function;
  getter: Function;
  value: any;

  constructor(
    vm: Component,
    expOrFn: string | Function,
    cb: Function,
    options?: ?Object,
    isRenderWatcher?: boolean
  ) {
    this.vm = vm;
    if (isRenderWatcher) {
      vm._watcher = this;
    }
    vm._watchers.push(this);
    // options
    if (options) {
      this.deep = !!options.deep;
      this.user = !!options.user;
      this.lazy = !!options.lazy;
      this.sync = !!options.sync;
      this.before = options.before;
    } else {
      this.deep = this.user = this.lazy = this.sync = false;
    }
    this.cb = cb;
    this.id = ++uid; // uid for batching
    this.active = true;
    this.dirty = this.lazy; // for lazy watchers
    this.deps = [];
    this.newDeps = [];
    this.depIds = new Set();
    this.newDepIds = new Set();
    this.expression =
      process.env.NODE_ENV !== 'production' ? expOrFn.toString() : '';
    // parse expression for getter
    if (typeof expOrFn === 'function') {
      this.getter = expOrFn;
    } else {
      // this.getter = function() { return this.xx }
      // 在 this.get 中执行 this.getter 时会触发依赖收集
      // 待后续 this.xx 更新时就会触发响应式
      this.getter = parsePath(expOrFn);
      if (!this.getter) {
        this.getter = noop;
        process.env.NODE_ENV !== 'production' &&
          warn(
            `Failed watching path: "${expOrFn}" ` +
              'Watcher only accepts simple dot-delimited paths. ' +
              'For full control, use a function instead.',
            vm
          );
      }
    }
    this.value = this.lazy ? undefined : this.get();
  }

  /**
   * 执行 this.getter，并重新收集依赖
   * this.getter 是实例化 watcher 时传递的第二个参数，一个函数或者字符串，比如：updateComponent 或者 parsePath 返回的读取 this.xx 属性值的函数
   * 为什么要重新收集依赖？
   *   因为触发更新说明有响应式数据被更新了，但是被更新的数据虽然已经经过 observe 观察了，但是却没有进行依赖收集，
   *   所以，在更新页面时，会重新执行一次 render 函数，执行期间会触发读取操作，这时候进行依赖收集
   */
  get() {
    // 打开 Dep.target，Dep.target = this
    pushTarget(this);
    // value 为回调函数执行的结果
    let value;
    const vm = this.vm;
    try {
      // 执行回调函数，比如 updateComponent，进入 patch 阶段
      value = this.getter.call(vm, vm);
    } catch (e) {
      if (this.user) {
        handleError(e, vm, `getter for watcher "${this.expression}"`);
      } else {
        throw e;
      }
    } finally {
      // "touch" every property so they are all tracked as
      // dependencies for deep watching
      if (this.deep) {
        traverse(value);
      }
      // 关闭 Dep.target，Dep.target = null
      popTarget();
      this.cleanupDeps();
    }
    return value;
  }

  /**
   * Add a dependency to this directive.
   * 两件事：
   *   1、添加 dep 给自己（watcher）
   *   2、添加自己（watcher）到 dep
   */
  addDep(dep: Dep) {
    // 判重，如果 dep 已经存在则不重复添加
    const id = dep.id;
    if (!this.newDepIds.has(id)) {
      // 缓存 dep.id，用于判重
      this.newDepIds.add(id);
      // 添加 dep
      this.newDeps.push(dep);
      // 避免在 dep 中重复添加 watcher，this.depIds 的设置在 cleanupDeps 方法中
      if (!this.depIds.has(id)) {
        // 添加 watcher 自己到 dep
        dep.addSub(this);
      }
    }
  }

  /**
   * Clean up for dependency collection.
   */
  cleanupDeps() {
    let i = this.deps.length;
    while (i--) {
      const dep = this.deps[i];
      if (!this.newDepIds.has(dep.id)) {
        dep.removeSub(this);
      }
    }
    let tmp = this.depIds;
    this.depIds = this.newDepIds;
    this.newDepIds = tmp;
    this.newDepIds.clear();
    tmp = this.deps;
    this.deps = this.newDeps;
    this.newDeps = tmp;
    this.newDeps.length = 0;
  }

  /**
   * 根据 watcher 配置项，决定接下来怎么走，一般是 queueWatcher
   */
  update() {
    /* istanbul ignore else */
    if (this.lazy) {
      // 懒执行时走这里，比如 computed

      // 将 dirty 置为 true，可以让 computedGetter 执行时重新计算 computed 回调函数的执行结果
      this.dirty = true;
    } else if (this.sync) {
      // 同步执行，在使用 vm.$watch 或者 watch 选项时可以传一个 sync 选项，
      // 当为 true 时在数据更新时该 watcher 就不走异步更新队列，直接执行 this.run
      // 方法进行更新
      // 这个属性在官方文档中没有出现
      this.run();
    } else {
      // 更新时一般都这里，将 watcher 放入 watcher 队列
      queueWatcher(this);
    }
  }

  /**
   * 由 刷新队列函数 flushSchedulerQueue 调用，完成如下几件事：
   *   1、执行实例化 watcher 传递的第二个参数，updateComponent 或者 获取 this.xx 的一个函数(parsePath 返回的函数)
   *   2、更新旧值为新值
   *   3、执行实例化 watcher 时传递的第三个参数，比如用户 watcher 的回调函数
   */
  run() {
    if (this.active) {
      // 调用 this.get 方法
      const value = this.get();
      if (
        value !== this.value ||
        // Deep watchers and watchers on Object/Arrays should fire even
        // when the value is the same, because the value may
        // have mutated.
        isObject(value) ||
        this.deep
      ) {
        // 更新旧值为新值
        const oldValue = this.value;
        this.value = value;

        if (this.user) {
          // 如果是用户 watcher，则执行用户传递的第三个参数 —— 回调函数，参数为 val 和 oldVal
          try {
            this.cb.call(this.vm, value, oldValue);
          } catch (e) {
            handleError(
              e,
              this.vm,
              `callback for watcher "${this.expression}"`
            );
          }
        } else {
          // 渲染 watcher，this.cb = noop，一个空函数
          this.cb.call(this.vm, value, oldValue);
        }
      }
    }
  }

  /**
   * 懒执行的 watcher 会调用该方法
   *   比如：computed，在获取 vm.computedProperty 的值时会调用该方法
   * 然后执行 this.get，即 watcher 的回调函数，得到返回值
   * this.dirty 被置为 false，作用是页面在本次渲染中只会一次 computed.key 的回调函数，
   *   这也是大家常说的 computed 和 methods 区别之一是 computed 有缓存的原理所在
   * 而页面更新后会 this.dirty 会被重新置为 true，这一步是在 this.update 方法中完成的
   */
  evaluate() {
    this.value = this.get();
    this.dirty = false;
  }

  /**
   * Depend on all deps collected by this watcher.
   */
  depend() {
    let i = this.deps.length;
    while (i--) {
      this.deps[i].depend();
    }
  }

  /**
   * Remove self from all dependencies' subscriber list.
   */
  teardown() {
    if (this.active) {
      // remove self from vm's watcher list
      // this is a somewhat expensive operation so we skip it
      // if the vm is being destroyed.
      if (!this.vm._isBeingDestroyed) {
        remove(this.vm._watchers, this);
      }
      let i = this.deps.length;
      while (i--) {
        this.deps[i].removeSub(this);
      }
      this.active = false;
    }
  }
}
```

参考：

[前言 | Vue.js 技术揭秘 (ustbhuangyi.github.io)](https://ustbhuangyi.github.io/vue-analysis/)

[Vue 源码解读（知识点总结） - 掘金 (juejin.cn)](https://juejin.cn/post/6981461361536696351)

[精通 Vue 技术栈的源码原理 - 李永宁的专栏 - 掘金 (juejin.cn)](https://juejin.cn/column/6960553066101735461)

[淼淼真人 的文章 - SegmentFault 思否](https://segmentfault.com/u/zhenren/articles)

[参考](https://www.notion.so/f83bc076792f4806a45ad9e472bb8e0e)
