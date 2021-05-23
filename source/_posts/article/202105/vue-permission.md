---
title: vue动态路由的前端控制
tags:
  - vue
  - 权限
  - 路由
categories: vue
cover: https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/a30f7a789262dcddce8a5de3a9036309.png
date: 2021-05-23
---

## 前言

动态路由权限控制这块主要是几种，前端控制/后端控制/登录与菜单页分离等。本篇主要是分享下对路由在前端控制，这里使用了[vue-element-admin](https://github1s.com/PanJiaChen/vue-element-admin)的方法

## 使用

- 前端使用 vue+element-ui
- 后端使用 nodejs+koa

## demo 效果

![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/gif-2021-05-23.gif)

## 步骤

- 1. 先定义好常规路由与动态路由列表
- 2. 需要在 vuex 里维护权限，根据不同角色来分配路由
- 3. 在 router.beforeEach 里来动态添加路由表
- 4. 页面通过获得的路由来进行渲染

## 注意

- 1. 退出前需要有重置路由这一操作，否则在用户不刷新的情况下，先登录管理员，再登录普通用户时，普通用户页面也有了管理员权限的页面。
- 2. 在使用 next(...route, replace: true)时会产生一个报错，在 router 的 index.js 里加一段代码就好了（见完整源码）

## 关键源码

```javascript
// src/permission.js
router.beforeEach(async (to, from, next) => {
  if (getToken()) {
    const hasRoles = store.getters.roles && store.getters.roles.length > 0;
    if (hasRoles) {
      next();
    } else {
      try {
        // 获取user信息
        const { roles } = await store.dispatch('user/getInfo');
        // 获取更新后的路由
        const accessedRoutes = await store.dispatch(
          'permission/generateRoutes',
          roles
        );
        // 添加到路由表
        router.addRoutes(accessedRoutes);
        next({ ...to, replace: true });
      } catch (err) {
        // 错误
        await store.dispatch('user/resetToken');
        Message.error(err || 'Has Error');
        next('/login');
      }
    }
  } else {
    // 这里要避免login无限循环！！
    if (to.path === '/login') {
      next();
    } else {
      next('/login');
    }
  }
});
```

```javascript
// store/module/permission.js
import { asyncRoutes, constantRoutes } from '../../router';

// 判断是否有权限，找roles
function hasPermisson(roles, route) {
  if (route.meta && route.meta.roles) {
    return roles.some((role) => route.meta.roles.includes(role));
  } else {
    return true;
  }
}

// 过滤掉没有权限的路由
export function filterAsyncRoutes(routes, roles) {
  const res = [];
  routes.forEach((route) => {
    const tmp = { ...route };
    if (hasPermisson(roles, tmp)) {
      if (tmp.children) {
        tmp.children = filterAsyncRoutes(tmp.children, roles);
      }
      res.push(tmp);
    }
  });
  return res;
}
export default {
  namespaced: true,
  state: {
    routes: [],
    addRoutes: [],
  },
  mutations: {
    SET_ROUTES: (state, routes) => {
      (state.addRoutes = routes),
        (state.routes = constantRoutes.concat(routes));
    },
  },
  actions: {
    // 根据roles更新路由
    generateRoutes({ commit }, roles) {
      return new Promise((resolve) => {
        let accessedRoutes;
        if (roles.includes('ADMIN_USER')) {
          accessedRoutes = asyncRoutes || [];
        } else {
          accessedRoutes = filterAsyncRoutes(asyncRoutes, roles);
        }
        commit('SET_ROUTES', accessedRoutes);
        resolve(accessedRoutes);
      });
    },
  },
};
```

```html
<-- home.vue -->
<el-menu
  default-active="2"
  class="el-menu-vertical-demo"
  background-color="#545c64"
  text-color="#fff"
  active-text-color="#ffd04b"
>
  <sidebarItem
    v-for="route in permission_routes"
    :key="route.path"
    :item="route"
    :base-path="route.path"
  ></sidebarItem>
</el-menu>
```

## 完整源码

[vue-permission-demo](https://github.com/maya1900/vue-permission-demo)

## 参考链接

- [动态路由前端控制还是后端控制？](https://juejin.cn/post/6844904145267195917#heading-13)
- [vue 权限路由实现方式总结](https://juejin.cn/post/6844903648057622536#heading-7)
- [vue-element-admin](https://github1s.com/PanJiaChen/vue-element-admin)
