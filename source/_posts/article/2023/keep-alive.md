---
title: keep-alive理解
tags:
  - js
categories: js
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/377d8c3a1e47d5760609873be26e4073.png
date: 2023-04-17 21:00:00
---

## 组件实现

keep-alive 是 vue 的内置组件，用于缓存组件状态，定义在  `src/core/components/keep-alive.js`
  中：

```jsx
export default {
  name: 'keep-alive',
  abstract: true,

  props: {
    include: patternTypes,
    exclude: patternTypes,
    max: [String, Number],
  },

  created() {
    this.cache = Object.create(null);
    this.keys = [];
  },

  destroyed() {
    for (const key in this.cache) {
      pruneCacheEntry(this.cache, key, this.keys);
    }
  },

  mounted() {
    this.$watch('include', (val) => {
      pruneCache(this, (name) => matches(val, name));
    });
    this.$watch('exclude', (val) => {
      pruneCache(this, (name) => !matches(val, name));
    });
  },

  render() {
    const slot = this.$slots.default;
    const vnode: VNode = getFirstComponentChild(slot);
    const componentOptions: ?VNodeComponentOptions =
      vnode && vnode.componentOptions;
    if (componentOptions) {
      const name: ?string = getComponentName(componentOptions);
      const { include, exclude } = this;
      if (
        (include && (!name || !matches(include, name))) ||
        (exclude && name && matches(exclude, name))
      ) {
        return vnode;
      }

      const { cache, keys } = this;
      const key: ?string =
        vnode.key == null
          ? componentOptions.Ctor.cid +
            (componentOptions.tag ? `::${componentOptions.tag}` : '')
          : vnode.key;
      if (cache[key]) {
        vnode.componentInstance = cache[key].componentInstance;
        remove(keys, key);
        keys.push(key);
      } else {
        cache[key] = vnode;
        keys.push(key);
        if (this.max && keys.length > parseInt(this.max)) {
          pruneCacheEntry(cache, keys[0], keys, this._vnode);
        }
      }

      vnode.data.keepAlive = true;
    }
    return vnode || (slot && slot[0]);
  },
};
```

keep-alive 组件是一个对象，它有一个属性  `abstract`为 true，是一个抽象组件，它在组件实例建立父子关系的时候会被忽略，发生在  `initLifecycle`的过程中：

```jsx
// locate first non-abstract parent
let parent = options.parent;
if (parent && !options.abstract) {
  while (parent.$options.abstract && parent.$parent) {
    parent = parent.$parent;
  }
  parent.$children.push(vm);
}
vm.$parent = parent;
```

`<keep-alive>`在  `created`钩子里定义了  `this.cache`  和  `this.keys`，本质上它就是去缓存已经创建过的  `vnode`。

keep-alive 直接实现了 render 函数，首先获取第一个子元素的  `vnode`：

```jsx
const slot = this.$slots.default;
const vnode: VNode = getFirstComponentChild(slot);
```

由于我们也是在  `<keep-alive>`  标签内部写 DOM，所以可以先获取到它的默认插槽，然后再获取到它的第一个子节点。`<keep-alive>`  只处理第一个子元素，所以一般和它搭配使用的有  `component`  动态组件或者是  `router-view`。

然后又判断了当前组件的名称和  `include`、`exclude`的关系。

`matches`  的逻辑很简单，就是做匹配，分别处理了数组、字符串、正则表达式的情况，也就是说我们平时传的  `include`和  `exclude`可以是这三种类型的任意一种。并且我们的组件名如果满足了配置  `include`且不匹配或者是配置了  `exclude`  且匹配，那么就直接返回这个组件的  `vnode`，否则的话走下一步缓存。

如果命中缓存，则直接从缓存中拿  `vnode`的组件实例，并且重新调整了 key 的顺序放在了最后个；否则把  `vnode`设置进缓存，最后还有一个逻辑，如果配置了  `max`并且缓存的长度超过了  `this.max`
，还要从缓存中删除第一个。

最后设置  `vnode.data.keepAlive = true`

## 组件渲染

### 首次渲染

Vue 的渲染最后都会到  `patch`过程，而组件的  `patch`过程会执行  `createComponent`方法，它的定义在  `src/core/vdom/patch.js`  中：

```jsx
function createComponent(vnode, insertedVnodeQueue, parentElm, refElm) {
  let i = vnode.data;
  if (isDef(i)) {
    const isReactivated = isDef(vnode.componentInstance) && i.keepAlive;
    if (isDef((i = i.hook)) && isDef((i = i.init))) {
      i(vnode, false /* hydrating */);
    }
    if (isDef(vnode.componentInstance)) {
      initComponent(vnode, insertedVnodeQueue);
      insert(parentElm, vnode.elm, refElm);
      if (isTrue(isReactivated)) {
        reactivateComponent(vnode, insertedVnodeQueue, parentElm, refElm);
      }
      return true;
    }
  }
}
```

`createComponent`定义了  `isReactivated`  的变量，它是根据  `vnode.componentInstance`以及  `vnode.data.keepAlive`的判断，第一次渲染的时候，`vnode.componentInstance`为  `undefined`，`vnode.data.keepAlive`为 true，因为它的父组件  `<keep-alive>`的  `render`函数会先执行，那么该  `vnode`缓存到内存中，并且设置  `vnode.data.keepAlive`为 true，因此  `isReactivated`为  `false`
，那么走正常的  `init`的钩子函数执行组件的  `mount`。当  `vnode`  已经执行完  `patch`后，执行  `initComponent`函数

这里会有  `vnode.elm`  缓存了  `vnode`创建生成的 DOM 节点。所以对于首次渲染而言，除在  `<keep-alive>`中建立缓存，和普通组件渲染没什么区别。

### 缓存渲染

`patchVnode`在做各种 diff 之前，会先执行  `prepatch`的钩子函数，`prepatch`核心逻辑就是执行  `updateChildComponent`方法，它的定义在  `src/core/instance/lifecycle.js`中：

```jsx
export function updateChildComponent(
  vm: Component,
  propsData: ?Object,
  listeners: ?Object,
  parentVnode: MountedComponentVNode,
  renderChildren: ?Array<VNode>
) {
  const hasChildren = !!(
    renderChildren ||
    vm.$options._renderChildren ||
    parentVnode.data.scopedSlots ||
    vm.$scopedSlots !== emptyObject
  );

  // ...
  if (hasChildren) {
    vm.$slots = resolveSlots(renderChildren, parentVnode.context);
    vm.$forceUpdate();
  }
}
```

`updateChildComponent`方法主要是去更新组件实例的一些属性，这里我们重点关注一下  `slot`部分，由于  `<keep-alive>`  组件本质上支持了  `slot`，所以它执行  `prepatch`  的时候，需要对自己的  `children`，也就是这些  `slots`做重新解析，并触发  `<keep-alive>`  组件实例  `$forceUpdate`逻辑，也就是重新执行  `<keep-alive>`  的  `render`方法，这个时候如果它包裹的第一个组件  `vnode`  命中缓存，则直接返回缓存中的  `vnode.componentInstance`，在我们的例子中就是缓存的  `A`组件，接着又会执行  `patch`  过程，再次执行到  `createComponent`方法，我们再回顾一下：

```jsx
function createComponent(vnode, insertedVnodeQueue, parentElm, refElm) {
  let i = vnode.data;
  if (isDef(i)) {
    const isReactivated = isDef(vnode.componentInstance) && i.keepAlive;
    if (isDef((i = i.hook)) && isDef((i = i.init))) {
      i(vnode, false /* hydrating */);
    }
    if (isDef(vnode.componentInstance)) {
      initComponent(vnode, insertedVnodeQueue);
      insert(parentElm, vnode.elm, refElm);
      if (isTrue(isReactivated)) {
        reactivateComponent(vnode, insertedVnodeQueue, parentElm, refElm);
      }
      return true;
    }
  }
}
```

这个时候  `isReactivated`为 true，并且在执行  `init`钩子函数的时候不会再执行组件的  `mount`过程了，相关逻辑在  `src/core/vdom/create-component.js`中

```jsx
const componentVNodeHooks = {
  init(vnode: VNodeWithData, hydrating: boolean): ?boolean {
    if (
      vnode.componentInstance &&
      !vnode.componentInstance._isDestroyed &&
      vnode.data.keepAlive
    ) {
      // kept-alive components, treat as a patch
      const mountedNode: any = vnode; // work around flow
      componentVNodeHooks.prepatch(mountedNode, mountedNode);
    } else {
      const child = (vnode.componentInstance = createComponentInstanceForVnode(
        vnode,
        activeInstance
      ));
      child.$mount(hydrating ? vnode.elm : undefined, hydrating);
    }
  },
  // ...
};
```

这也就是被  `<keep-alive>`  包裹的组件在有缓存的时候就不会在执行组件的  `created`、`mounted`等钩子函数的原因了。回到  `createComponent`方法，在  `isReactivated`为 true 的情况下会执行  `reactivateComponent`方法：

```jsx
function reactivateComponent(vnode, insertedVnodeQueue, parentElm, refElm) {
  let i;
  let innerNode = vnode;
  while (innerNode.componentInstance) {
    innerNode = innerNode.componentInstance._vnode;
    if (isDef((i = innerNode.data)) && isDef((i = i.transition))) {
      for (i = 0; i < cbs.activate.length; ++i) {
        cbs.activate[i](emptyNode, innerNode);
      }
      insertedVnodeQueue.push(innerNode);
      break;
    }
  }
  insert(parentElm, vnode.elm, refElm);
}
```

最后通过执行  `insert(parentElm, vnode.elm, refElm)`就把缓存的 DOM 对象直接插入到目标元素中，这样就完成了在数据更新的情况下的渲染过程。

## 生命周期

在渲染的最后一步，会执行  `invokeInsertHook(vnode, insertedVnodeQueue, isInitialPatch)`
  函数执行  `vnode`  的  `insert`钩子函数，它的定义在  `src/core/vdom/create-component.js`
  中。

```jsx
const componentVNodeHooks = {
  insert(vnode: MountedComponentVNode) {
    const { context, componentInstance } = vnode;
    if (!componentInstance._isMounted) {
      componentInstance._isMounted = true;
      callHook(componentInstance, 'mounted');
    }
    if (vnode.data.keepAlive) {
      if (context._isMounted) {
        // vue-router#1212
        // During updates, a kept-alive component's child components may
        // change, so directly walking the tree here may call activated hooks
        // on incorrect children. Instead we push them into a queue which will
        // be processed after the whole patch process ended.
        queueActivatedComponent(componentInstance);
      } else {
        activateChildComponent(componentInstance, true /* direct */);
      }
    }
  },
  // ...
};
```

这里判断如果是被  `<keep-alive>`  包裹的组件已经  `mounted`，那么则执行  `queueActivatedComponent(componentInstance)` ，否则执行  `activateChildComponent(componentInstance, true)`。我们先分析非  `mounted`  的情况，`activateChildComponent`  的定义在  `src/core/instance/lifecycle.js`  中：

```jsx
export function activateChildComponent(vm: Component, direct?: boolean) {
  if (direct) {
    vm._directInactive = false;
    if (isInInactiveTree(vm)) {
      return;
    }
  } else if (vm._directInactive) {
    return;
  }
  if (vm._inactive || vm._inactive === null) {
    vm._inactive = false;
    for (let i = 0; i < vm.$children.length; i++) {
      activateChildComponent(vm.$children[i]);
    }
    callHook(vm, 'activated');
  }
}
```

可以看到这里就是执行组件的  `acitvated`  钩子函数，并且递归去执行它的所有子组件的  `activated`  钩子函数。

那么再看  `queueActivatedComponent`  的逻辑，它定义在  `src/core/observer/scheduler.js`  中：

```jsx
export function queueActivatedComponent(vm: Component) {
  vm._inactive = false;
  activatedChildren.push(vm);
}
```

这个逻辑很简单，把当前  `vm`  实例添加到  `activatedChildren`  数组中，等所有的渲染完毕，在  `nextTick`后会执行  `flushSchedulerQueue`，这个时候就会执行：

```jsx
function flushSchedulerQueue() {
  // ...
  const activatedQueue = activatedChildren.slice();
  callActivatedHooks(activatedQueue);
  // ...
}

function callActivatedHooks(queue) {
  for (let i = 0; i < queue.length; i++) {
    queue[i]._inactive = true;
    activateChildComponent(queue[i], true);
  }
}
```

也就是遍历所有的  `activatedChildren`，执行  `activateChildComponent`  方法，通过队列调的方式就是把整个  `activated`  时机延后了。

有  `activated`  钩子函数，也就有对应的  `deactivated`  钩子函数，它是发生在  `vnode`  的  `destory`  钩子函数，定义在  `src/core/vdom/create-component.js`  中：

```jsx
const componentVNodeHooks = {
  destroy(vnode: MountedComponentVNode) {
    const { componentInstance } = vnode;
    if (!componentInstance._isDestroyed) {
      if (!vnode.data.keepAlive) {
        componentInstance.$destroy();
      } else {
        deactivateChildComponent(componentInstance, true /* direct */);
      }
    }
  },
};
```

对于  `<keep-alive>`  包裹的组件而言，它会执行  `deactivateChildComponent(componentInstance, true)`  方法，定义在  `src/core/instance/lifecycle.js`  中：

```jsx
const componentVNodeHooks = {
  destroy(vnode: MountedComponentVNode) {
    const { componentInstance } = vnode;
    if (!componentInstance._isDestroyed) {
      if (!vnode.data.keepAlive) {
        componentInstance.$destroy();
      } else {
        deactivateChildComponent(componentInstance, true /* direct */);
      }
    }
  },
};
```

和  `activateChildComponent`  方法类似，就是执行组件的  `deacitvated`  钩子函数，并且递归去执行它的所有子组件的  `deactivated`  钩子函数。

## **总结**

那么至此，`<keep-alive>`  的实现原理就介绍完了，通过分析我们知道了  `<keep-alive>`  组件是一个抽象组件，它的实现通过自定义  `render`  函数并且利用了插槽，并且知道了  `<keep-alive>`  缓存  `vnode`，了解组件包裹的子元素——也就是插槽是如何做更新的。且在  `patch`  过程中对于已缓存的组件不会执行  `mounted`，所以不会有一般的组件的生命周期函数但是又提供了  `activated`  和  `deactivated`  钩子函数。另外我们还知道了  `<keep-alive>`  的  `props`  除了  `include`  和  `exclude`  还有文档中没有提到的  `max`，它能控制我们缓存的个数。
