---
title: vue-element-admin里面的知识点
date: 2021-08-08
tags:
- vue
- element
categories: vue
cover: https://z3.ax1x.com/2021/08/08/fQhR9e.jpg
---

记录一些值得学习的知识点

## 一、scss部分

scss里的函数使用：

```scss
/*src\styles\btn.scss*/
@import './variables.scss';

@mixin colorBtn($color) {
  background: $color;
}

.blue-btn {
  @include colorBtn($blue)
}  

```
```scss
/*src\styles\variables.scss*/
$blue:#324157;
```
## 二、TagsView部分

- router-link使用tag属性来控制被浏览器渲染成何种元素；
- 自定义的右击事件@contextmenu.prevent.native；
- slot的使用
- element里的隐藏组件el-scrollbar滚动条

```html
<-- src\layout\components\TagsView\index.vue -->
    <scroll-pane ref="scrollPane" class="tags-view-wrapper" @scroll="handleScroll">
      <router-link
        v-for="tag in visitedViews"
        ref="tag"
        :key="tag.path"
        :class="isActive(tag)?'active':''"
        :to="{ path: tag.path, query: tag.query, fullPath: tag.fullPath }"
        tag="span"
        class="tags-view-item"
        @click.middle.native="!isAffix(tag)?closeSelectedTag(tag):''"
        @contextmenu.prevent.native="openMenu(tag,$event)"
      >
        {{ tag.title }}
        <span v-if="!isAffix(tag)" class="el-icon-close" @click.prevent.stop="closeSelectedTag(tag)" />
      </router-link>
    </scroll-pane>
```

```html
  <el-scrollbar ref="scrollContainer" :vertical="false" class="scroll-container" @wheel.native.prevent="handleScroll">
    <slot />
  </el-scrollbar>
```

## 三、批量导入store里的模块文件

使用这个方法可以一次性导入所有模块文件，以后再增加也无需再导入。

``` javascript
const modulesFiles = require.context('./modules', true, /\.js$/)

const modules = modulesFiles.keys().reduce((modules, modulePath) => {

  const moduleName = modulePath.replace(/^\.\/(.*)\.\w+$/, '$1')
  const value = modulesFiles(modulePath)
  modules[moduleName] = value.default
  return modules
}, {})

const store = new Vuex.Store({
  modules,
})
```

## 四、sideBar部分

- 非常规引入，而是根据配置的路由来动态引入
- 为组件命名来实现组件自身调用（自己调用自己）
- 使用了函数式组件来实现最小块部分

``` html
<!-- src\layout\components\Sidebar\index.vue -->
<el-scrollbar wrap-class="scrollbar-wrapper">
  <el-menu
	:default-active="activeMenu"
	:collapse="isCollapse"
	:background-color="variables.menuBg"
	:text-color="variables.menuText"
	:unique-opened="false"
	:active-text-color="variables.menuActiveText"
	:collapse-transition="false"
	mode="vertical"
  >
	<sidebar-item v-for="route in permission_routes" :key="route.path" :item="route" :base-path="route.path" />
  </el-menu>
</el-scrollbar>
```

``` html
<!-- src\layout\components\Sidebar\SidebarItem.vue -->
<template>
  <div v-if="!item.hidden">
    <template v-if="hasOneShowingChild(item.children,item) && (!onlyOneChild.children||onlyOneChild.noShowingChildren)&&!item.alwaysShow">
      <app-link v-if="onlyOneChild.meta" :to="resolvePath(onlyOneChild.path)">
        <el-menu-item :index="resolvePath(onlyOneChild.path)" :class="{'submenu-title-noDropdown':!isNest}">
          <item :icon="onlyOneChild.meta.icon||(item.meta&&item.meta.icon)" :title="onlyOneChild.meta.title" />
        </el-menu-item>
      </app-link>
    </template>

    <el-submenu v-else ref="subMenu" :index="resolvePath(item.path)" popper-append-to-body>
      <template slot="title">
        <item v-if="item.meta" :icon="item.meta && item.meta.icon" :title="item.meta.title" />
      </template>
      <sidebar-item
        v-for="child in item.children"
        :key="child.path"
        :is-nest="true"
        :item="child"
        :base-path="resolvePath(child.path)"
        class="nest-menu"
      />
    </el-submenu>
  </div>
</template>
<script>
	export default {
		name: 'SidebarItem',
		// ......
	}
</script>
```

``` html
<script>
// src\layout\components\Sidebar\Item.vue
export default {
  name: 'MenuItem',
  functional: true,
  props: {
    icon: {
      type: String,
      default: ''
    },
    title: {
      type: String,
      default: ''
    }
  },
  render(h, context) {
    const { icon, title } = context.props
    const vnodes = []

    if (icon) {
      if (icon.includes('el-icon')) {
        vnodes.push(<i class={[icon, 'sub-el-icon']} />)
      } else {
        vnodes.push(<svg-icon icon-class={icon}/>)
      }
    }

    if (title) {
      vnodes.push(<span slot='title'>{(title)}</span>)
    }
    return vnodes
  }
}
</script>

<style scoped>
.sub-el-icon {
  color: currentColor;
  width: 1em;
  height: 1em;
}
</style>
```

## 五、permission部分

- 用户登录，发起login请求，在store里保存token;
- 在src/permission.js里全局路由守卫拦截，获取token，判断有无token，有token但不是在登录页，再判断有无roles，没有发起请求获取roles，等待返回后再发起请求根据roles来获取到路由，使用addRoutes方法添加异步路由，然后跳转页面
- 用户退出，删除token,roles重置token，重置router（非常重要的一步）

``` javascript
// src\permission.js
router.beforeEach(async(to, from, next) => {
  NProgress.start()

  document.title = getPageTitle(to.meta.title)
  
  const hasToken = getToken()

  if (hasToken) {
    if (to.path === '/login') {
      
      next({ path: '/' })
      NProgress.done() 
    } else {
      const hasRoles = store.getters.roles && store.getters.roles.length > 0
      if (hasRoles) {
        next()
      } else {
        try {
          const { roles } = await store.dispatch('user/getInfo')

          const accessRoutes = await store.dispatch('permission/generateRoutes', roles)

          router.addRoutes(accessRoutes)
          next({ ...to, replace: true })
        } catch (error) {
         
          await store.dispatch('user/resetToken')
          Message.error(error || 'Has Error')
          next(`/login?redirect=${to.path}`)
          NProgress.done()
        }
      }
    }
  } else {

    if (whiteList.indexOf(to.path) !== -1) {
  
      next()
    } else {
      next(`/login?redirect=${to.path}`)
      NProgress.done()
    }
  }
})
```

``` javascript
// src\store\modules\permission.js
function hasPermission(roles, route) {
  if (route.meta && route.meta.roles) {
    return roles.some(role => route.meta.roles.includes(role))
  } else {
    return true
  }
}

export function filterAsyncRoutes(routes, roles) {
  const res = []

  routes.forEach(route => {
    const tmp = { ...route }
    if (hasPermission(roles, tmp)) {
      if (tmp.children) {
        tmp.children = filterAsyncRoutes(tmp.children, roles)
      }
      res.push(tmp)
    }
  })

  return res
}

const actions = {
  generateRoutes({ commit }, roles) {
    return new Promise(resolve => {
      let accessedRoutes
      if (roles.includes('admin')) {
        accessedRoutes = asyncRoutes || []
      } else {
        accessedRoutes = filterAsyncRoutes(asyncRoutes, roles)
      }
      commit('SET_ROUTES', accessedRoutes)
      resolve(accessedRoutes)
    })
  }
}
```

``` javascript
// src\router\index.js
export const constantRoutes = []
export const asyncRoutes = []

const createRouter = () => new Router({
  // mode: 'history', // require service support
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes
})

const router = createRouter()

export function resetRouter() {
  const newRouter = createRouter()
  router.matcher = newRouter.matcher // reset router
}

export default router
```
