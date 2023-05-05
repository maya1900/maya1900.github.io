---
title: vue3 使用 params 传递数据，接收时 params 里的值为空
tags:
  - vue
categories: vue
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/4acc4f57c9045584767e15a45969ff4b.png
date: 2023-04-24 21:00:00
---

> Discarded invalid param(s) “id“,“name“,“age“when navigating

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/a2335659-a312-4527-a685-ff0cd7979301/Untitled.png)

vue3 使用 params 传递数据，接收时 params 里的值为空。

点开链接后发现了原因，[点击查看更新日志](https://github.com/vuejs/router/blob/main/packages/router/CHANGELOG.md#414-2022-08-22)。

![https://cdn.jsdelivr.net/gh/liaoyio/imgHosting/DjangoS1.png](https://cdn.jsdelivr.net/gh/liaoyio/imgHosting/DjangoS1.png)

![https://cdn.jsdelivr.net/gh/liaoyio/imgHosting/DjangoS2.png](https://cdn.jsdelivr.net/gh/liaoyio/imgHosting/DjangoS2.png)

也就是说，从 Vue Router 的 2022-8-22 这次更新后，我们使用上面的方式在新页面无法获取：

vue 也给我们提出了解决方案：

1. 数据放在 pinia 或者 vux 仓库里；
2. 使用 query 的方式传参；

   ```jsx
   <script setup>
   import { useRouter } from 'vue-router'

   const router = useRouter()
   const query = { id: '1', name: 'ly', phone: 13246566476, age: 23 }
   const toDetail = () => router.push({  path: '/detail', query })

   </script>
   <template>
     <el-button type="danger" @click="toDetail">查看情页</el-button>
   </template>
   ```

3. 动态路由匹配；

   ```jsx
   // params 传递的参数: { id: '1', name: 'ly', phone: 13246566476, age: 23 }

   {
         path: '/detail/:id/:name/:phone/:age',
         name: 'detail',
         component: () => import('@/views/detail/index.vue')
   }
   ```

4. 传递 state，在 history.state 里接收；

   ```jsx
   <script setup>
   import { useRouter } from 'vue-router'

   const router = useRouter()

   const params = { id: '1', name: 'ly', phone: 13246566476, age: 23 }
   const toDetail = () => router.push({ name: 'detail', state: { params } })

   </script>

   <template>
     <el-button type="danger" @click="toDetail">查看情页</el-button>
   </template>

   // 接收方
   <template>
     <div>{{ historyParams }}</div>
   </template>

   <script setup lang="ts">

   const historyParams = history.state.params
   console.log('history.state', history.state)
   </script>
   ```

5. 使用路由 meta 方式传递
