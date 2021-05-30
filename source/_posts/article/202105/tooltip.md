---
title: vue-cli3中使用bootstrap
date: 2021-05-30
tags:
  - vue
  - bootstrap
categories: vue
cover: https://z3.ax1x.com/2021/05/30/2VOxOI.jpg
---

## 1. 引入 bootstrap

bootsrap 依赖 jquery，使用 bootsrap 先引入 jquery，（不用引入 popper.js）

```javascript
yarn add bootstrap@3 jquery
```

## 2. 在 main.js 中引入

```javascript
import 'bootstrap';

// 引入bootstrap样式
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.min.js';

// 全局注册 $
Vue.prototype.$ = $;
```

直接在实例中引入（这里只使用 tooltip 提示部分）

```javascript
  methods: {
    initApp () {
      // 避免命名冲突
      const bootstrapTooltip = $.fn.tooltip.noConflict()
      $.fn.tooltip = bootstrapTooltip
      $('body').tooltip({
        selector: '[data-toggle="tooltip"]',
        trigger: 'hover'
      })
    }
  },
  created () {
    this.initApp()
  }
```

## 3. 在根目录下创建 vue.config.js 进行配置：

```javascript
const webpack = require('webpack');
module.exports = {
  // 配置插件参数
  configureWebpack: {
    plugins: [
      // 配置 jQuery 插件的参数
      new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        'window.jQuery': 'jquery',
      }),
    ],
  },
};
```

## 4. 解决 eslint 报错

如果出现 eslint 报错$不存在，则在根目录下的.eslintrc.js 里加入：

```javascript
  env: {
    node: true,
    jquery: true  // ++
  }
```

## 5. 使用

```html
<button
  type="button"
  class="btn btn-primary"
  data-toggle="tooltip"
  data-placement="bottom"
  title="Tooltip on bottom"
>
  Tooltip
</button>
```
