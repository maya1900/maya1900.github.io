---
title: 写一个自己的cli前后端脚手架
date: 2022-04-30
tags:
  - 前端
  - cli
categories: 前端
cover: https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/202204301825386.jpg
---

# 功能：

1. 一键快速搭建前后端项目，mock 请求，简单 demo 开发；
2. 前端模板：vue+vue-router+vuex+sass+axios 封装+本地跨域配置+别名+快速添加 componenent/views/store 页面+get/post 请求演示
3. 后端模板：nodejs+koa+koa-router+cors 配置+mock 数据+get/post 请求演示

# 使用：

1. 创建项目：sk create 你的项目名称
2. 创建普通组件：sk addcpn 组件名
3. 创建路由组件：sk addpage 组件名
4. 创建 vuex 子模块：sk addstore 模块名

![](https://secure2.wostatic.cn/static/cDdh4BLke2T6RrefD9TxTU/image.png)

# 效果：

![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/202204301605870.png)

![](https://secure2.wostatic.cn/static/UUa3eSggvcUYPpsRYmwss/GIF 2022-4-30 16-04-02.gif)

# 技术点：

## 一、创建项目

初始化一个项目，`npm init -y`

入口文件首行添加指令：`#!/usr/bin/env node`

`package.json`添加命令：

```JavaScript
  "bin": {
    "sk": "index.js"
  },
```

执行`npm link`将脚本文件映射全局，再执行 sk 就可以运行 index.js 了

## 二、工作流程

1. commander 解析命令行参数
2. inquirer 命令行交互
3. 创建工程化项目模板
4. dowload-git-repo 下载项目模板
5. ora/chalk 美化输出
6. 创建组件/路由/vuex 模板
7. 修改项目名称
8. npm install 下载依赖
9. npm start 运行项目
10. npm 发布

## 三、commander 解析命令行参数

```JavaScript
const program = require("commander")
// 显示版本号
program.version(require('./package.json').version)
// 解析终端指令
program.parse(process.argv)

```

创建命令：

```JavaScript
  program
    .command('create <projectName>')
    .description('create a project template')
    .option("-T, --template [template]", "输入模板名字")
    .action(async function (projectName, options) {}
```

## 四、inquirer 命令行交互

设置类型：

```JavaScript
const choicesMap = [
  {
    name: "sk-vue-template",
    value: "sk-vue-template"
  }, {
    name: "sk-mock-server",
    value: "sk-mock-server"
  }
]
```

选择类型：

```JavaScript
const inquirer = require("inquirer.js")

async function chooseTemplate() {
  const promptList = [
    {
      type: 'list',
      name: 'template',
      message: 'please select a template',
      choices: choicesMap
    }
  ];

  const { template } = await inquirer.prompt(promptList[0])
  return template
}
```

## 五、创建工程化项目模板

新建一个 vue 模板或者 node 模板，并上传 git

### 动态导入路由：

```JavaScript
const files = require.context('./modules', false, /\.js$/);
const routes = files.keys().map(key => {
  const page = require('./modules' + key.replace('.', ''));
  return page.default;
})
const router = new VueRouter({
  routes
})

```

### 动态导入 vuex：

```JavaScript
const modules = {}
const files = require.context('./', true, /index\.js$/);
files.keys().filter(key => {
  if (key === './index.js') return false;
  return true
}).map(key => {
  // 获取名字
  const modulePath = key.replace('./modules/', '');
  const moduleName = modulePath.replace('/index.js', '');
  const module = require(`${key}`);

  modules[`${moduleName}`] = module.default;
})

export default new Vuex.Store({
  modules
})
```

## 六、dowload-git-repo 下载项目模板

配置模板：

```JavaScript
const templateMap = new Map();

templateMap.set('sk-vue-template', "https://github.com:maya1900/sk-vue-temp#master")
templateMap.set('sk-mock-server', "https://github.com:maya1900/sk-mock-server#master")

module.exports = templateMap
```

下载模板：

```JavaScript
downloadRepo(repoConfig.get(template), projectName, { clone: true }, async error => {
  if (error) {
  } else {
  }
}
```

## 七、ora/chalk 美化输出

### ora 增加 loading 效果

```JavaScript
const spinner = ora({
    text: 'template downloading...',
    color: "yellow"
  });
  spinner.start();
  spinner.succeed(`download succeed: ${projectName}`)
  spinner.fail('download failed')
```

### chalk 美化输出语句

```JavaScript
chalk.red('error')
chalk.green('info')
chalk.rgb(69, 39, 160)('message')
```

## 八、创建组件/路由/vuex 模板

### 创建命令

```JavaScript
  program
    .command('addcpn <name>')
    .description('add a vue component, e.p sk addcpn Nav [-d dest]')
    .action(name => addComponent(name, program.dest || `src/components`))

  program
    .command('addpage <name>')
    .description('add  a vue page, e.p. sk addpage Home [-d dest]')
    .action(name => {
      addPage(name, program.dest || `src/views/${name.toLowerCase()}`)
    })

  program
    .command('addstore <name>')
    .description('add a vue store, e.p. sk addstore Hot [-d dest]')
    .action(name => addStore(name, program.dest || `src/store/modules/${name.toLowerCase()}`))
```

### 编写模板文件

### 编译 ejs，写入文件

```JavaScript
const ejsCompile = (tempaltePath, data = {}, options = {}) => {
  return new Promise((resolve, reject) => {
    ejs.renderFile(tempaltePath, {data}, options, (err, result) => {
      if (err) {
        reject(err);
        return
      }
      resolve(result);
    })
  })
}

const writeFile = (path, content) => {
  if (fs.existsSync(path)) {
    log.error("the file already exists")
    return
  }
  return fs.promises.writeFile(path, content)
}
```

## 九、修改项目名称

把下载的模板名称变成我们的项目名称：

```JavaScript
async function modify (projectName) {
  return new Promise((resolve, reject) => {
    const parentPath = process.cwd()
    const projectPath = path.join(parentPath, projectName)
    const file = path.join(projectPath, 'package.json')
    fs.readFile(file, 'utf8', (err, data) => {
      if (err) {
        reject()
      } else {
        const res = JSON.parse(data)
        const oldName = res.name
        res.name = projectName
        fs.writeFile(file, JSON.stringify(res, null, 2), 'utf-8', err => {
          if (err) {
            reject()
          }
          resolve()
        })
      }
    })
  })
}
```

## 十、npm install 下载依赖

## 十一、npm start 运行项目

使用：

```JavaScript
const { spawn } = require('child_process')

const spawnCommand = (...args) => {
  return new Promise((resolve, reject) => {
    const childProcess = spawn(...args)
    childProcess.stdout.pipe(process.stdout)
    childProcess.stderr.pipe(process.stderr)
    childProcess.on('close', () => {
      resolve()
    })
  })
}
module.exports = {
  spawn: spawnCommand
}
```

调用：

```JavaScript
const terminal = require('../utils/terminal')
terminal.spawn(npm, ['install'], {
  cwd: `./${projectName}`
})
log.bgRgb('Successfully installed, please wait for the server to start...')
terminal.spawn(npm, ['start'], {
  cwd: `./${projectName}`
})
```

> `npm start`自行在`package.json`里配置。

## 十二、npm 发布

先在[https://www.npmjs.com](https://www.npmjs.com/)注册账号；

命令行输入：`npm login`,登录成功后`npm publish`即可。

> 发布前补充好 package.json 信息

这样完成就能在 npmjs 官网里找到自己的 npm 包了，也可以`npm install`下载，🎆🎆🎆

![](https://secure2.wostatic.cn/static/wg8ii9ZwswNLtC8QrJVdvi/image.png)

# 遇到的问题

### npm link 报错

先`npm unlink`解绑后再`npm link`。

### 如何进行脚手架项目的调试

`npm link`建立软连接后就可以在任何地方使用 bin 里的命令了。

### 'git clone' failed with status 128

一是存在同名文件夹；二是 repository 地址没写对

一种是`github:owner/name#branch`，如：`'https://mygitlab.com:flippidippi/download-git-repo-fixture#my-branch'`；

一种是`direct:url`，如：`'direct:https://gitlab.com/flippidippi/download-git-repo-fixture.git'`

### Can we please add commonjs to "exports" in 'package.json'?sometimes" ES Module not supported"

ora 与 chalk 最新版本使用了 ES module。

一种是降版本`"ora": "^5.0.0"`，`"chalk": "^4.1.0"`

另一种在 cjs 里写 ES module 的写法：`const { default: spinner } = await import("ora");`

# 项目地址：

[maya1900/sixknow-cli: 一个简单的前后端脚手架 (github.com)](https://github.com/maya1900/sixknow-cli)

# 参考：

1. codewhy 老师的课
2. [【有手就行】轻松打造属于自己的 Vue 工程化脚手架工具](https://juejin.cn/post/6867331101552181262)
