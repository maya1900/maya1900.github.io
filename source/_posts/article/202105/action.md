---
title: vue action的两个问题
tags:
  - 异步
  - action
categories: vue
cover: https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/281c3ac5c2f9a4e16854b10710a02a7c.png
date: 2021-05-06 23:10:34
---

## dispatch().then 相关

遇到这样一个问题，使用 dispatch 传值，then 里面使用 emit 传给父组件事件传不过去？action 里也使用的 promise，而另外一个组件使用同样的写法却能传过去...

```javascript
methods: {
  getData () {
    this.$store.dispatch('actionA', params).then(res => {
      this.$emit('onUpdate')
      console.log(res)
    })
  }
}
```

```javascript
actionA ({state}, payload) {
  return new Promise((resolve,reject) => {
    // 请求的
    axios.get('xxx').then(res => {
      resolve(res)
    }).catch(err => {
      reject(err)
    })
  })
}
```

对比了很久也没个所以然，再查找了多种资料把请求写成 async 的方式竟然解决了！

```javascript
methods: {
  async getData () {
    await this.$store.dispatch('actionA', params)
    this.$emit('onUpdate')
  }
}
```

## action 的解构

见过的代码多了，常常看到这样的：

```javascript
actionA ({commit}, payload) {
  // 一些代码
}
```

```javascript
actionB ({state}, payload) {
  // 一些代码
}
```

最开始学的不是这样吗？

```javascript
actionC (context, payload) {
  // 一些代码
  context.commit('xxx')
}
```

其实打印出 context 可以看出来，context 也是一个对象，因此可以使用解构出里面的值：
![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/20201116103749422.png)

这样是不是就容易理解了上面解构的写法。

## 参考

- [Action](https://vuex.vuejs.org/zh/guide/actions.html)
- [Vuex 之理解 Actions](https://segmentfault.com/a/1190000009132572)
