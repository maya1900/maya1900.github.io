---
title: axios的五种请求方式详解
tags: 
- axios
- 请求
categories: 网络
cover: https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/377d8c3a1e47d5760609873be26e4073.png
date: 2021-05-09 09:33:12
---

## axios的基本介绍
Axios 是一个基于 promise 的 HTTP 库，可以用在浏览器和 node.js 中。
axios支持请求的方式：
- get：获取数据
- post：提交数据（表单提交+文件上传）
- put：更新数据（所有数据推送到后端）
- patch：更新数据（只将更改的数据推送到后端）
- delete：删除数据

## 1. get
### 1.0 前提
在本地请求先解决跨域问题，这里使用cors解决跨域

``` javascript
app.use((req,res,next) => {
    res.header('Access-Control-Allow-Origin','*');
    res.header('Access-Control-Allow-Credential','true');
    res.header('Access-Control-Allow-Methods','GET,POST,PUT,DELETE,PATCH,OPTIONS');
	// 这里处理请求头跨域的问题
    res.header("Access-Control-Allow-Headers", "Origin,X-Requested-With,Content-Type,Accept,Authorization")
    next()
})
```

### 1.1 基本用法

``` javascript
      axios.get('http://localhost:3000/login').then(res => {
        console.log(res.data)  // 这里的data是固定的
      })
```

``` javascript
app.get('/login', (req, res) => {
    res.send({ msg: 'login success', status:200 })
})
```
结果：
![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/20210509105202.png)

### 1.2 字符串传参

``` javascript
      axios.get('http://localhost:3000/login-param?id=123').then(res => {
        console.log(res.data)
      })
```

``` javascript
app.get('/login-param',(req,res) => {
    res.send({msg: 'param is ' + req.query.id, status: 200})
})
```

> <i class="fas fa-feather-alt" style="color: #E91E63"></i> 这里是?id=xxx，所以node使用req.query接收

结果：
![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/20210509110534.png)

### 1.3 使用params方式传参
使用的最多的方式，这里注意get方式的传参前面参数一定是params

``` javascript
      axios.get('http://localhost:3000/login-param', {params:{id:456}}).then(res => {
        console.log(res.data)
      })
```
后端与1.2相同，使用req.query接收值

结果：
![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/20210509110916.png)

### 1.4 使用restful风格传参
即url后面直接拼传入的值，使用不同请求方式来得到不同响应

``` javascript
      axios.get('http://localhost:3000/login-param/' + 789).then(res => {
        console.log(res.data)
      })
```

``` javascript
app.get('/login-param/:id',(req,res) => {
    res.send({msg:'restful param is ' + req.params.id, status: 200})
})
```

> <i class="fas fa-feather-alt" style="color: #E91E63"></i>使用restful传参，后端使用:id来接收值，同时使用req.params来得到参数

结果：
![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/20210509111509.png)

## 2.post
### 2.1 默认post传参

``` javascript
      axios.post('http://localhost:3000/login-post',{name: 'xixi', age: 18}).then(res => {
        console.log(res.data)
      })
```

``` javascript
app.post('/login-post', (req,res) => {
    res.send({msg: 'post name is ' + req.body.name + ';age is ' + req.body.age, status: 200})
})
```

> <i class="fas fa-feather-alt" style="color: #E91E63"></i>使用默认方式json传值时，node现在默认接收不到post参数，需要使用body-parser来进行转码，然后使用req.body来得到参数值

``` javascript
// post请求处理
const bodyParser = require('body-parser')
app.use(bodyParser.urlencoded({extended: false}))
app.use(bodyParser.json())
```
结果：
![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/20210509112537.png)

### 2.2 使用UrlSearchParams传参
前端去处理数据：

``` javascript
      let data = new URLSearchParams()
      data.append('name', 'xixi')
      data.append('age', '18')
      axios.post('http://localhost:3000/login-post', data).then(res => {
        console.log(res.data)
      })
```

后面与2.1相同，使用req,body去接收参数

结果：
![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/20210509112819.png)

### 2.3 使用qsStringify传参
还是前端处理数据：

``` javascript
      let data = {name: 'xixi', age: '18'}
      axios.post('http://localhost:3000/login-post', qs.stringify(data)).then(res => {
        console.log(res.data)
      })
```
后端与2.1相同，结果相同。

> <i class="fas fa-smile" style="color: #E91E63"></i>qs库包含在axios库里的，不用单独去下载依赖包，只需直接引入即可。

## 3. delete
delete一般用法基本与get相同，get的传参方法都适用于delete，但delete也可以使用类似post的传参，参数包含在body请求体中。
### 3.1 data方式传参
``` javascript
      axios.delete('http://localhost:3000/login-data', {data:{id:456}}).then(res => {
        console.log(res.data)
      })
```

``` javascript
app.delete('/login-data', (req, res) => {
    res.send({msg: 'delete data is ' + req.body.id, status: 200})
})
```

结果：
![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/20210509113748.png)

### 3.2 普通字符串传参

``` javascript
      axios.delete('http://localhost:3000/login-param?id=123').then(res => {
        console.log(res.data)
      })
```

``` javascript
app.delete('/login-param',(req,res) => {
    res.send({msg: 'delete param is ' + req.query.id, status: 200})
})
```
结果：
![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/20210509114122.png)
### 3.3 params传参

``` javascript
      axios.delete('http://localhost:3000/login-param', {params:{id:456}}).then(res => {
        console.log(res.data)
      })
```
后端与3.2相同
结果：
![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/20210509114307.png)
### 3.4 restful传参

``` javascript
      axios.delete('http://localhost:3000/login-param/' + 789).then(res => {
        console.log(res.data)
      })
```

``` javascript
app.delete('/login-param/:id',(req,res) => {
    res.send({msg:'delete restful param is ' + req.params.id, status: 200})
})
```
结果：
![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/20210509114513.png)

## 4. put
put传参与post类似，作用是更新后台数据。

``` javascript
      axios.put('http://localhost:3000/login-put/' + 666,{name: 'xixi', age: 18}).then(res => {
        console.log(res.data)
      })
```

``` javascript
app.put('/login-put/:id',(req,res) => {
    res.send({msg:`put id is ${req.params.id};name is ${req.body.name};age is ${req.body.age}`, status: 200})
})
```

> <i class="fas fa-feather-alt" style="color: #E91E63"></i>这里综合使用了get的restful传参与post的默认传参方式

结果：
![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/20210509115111.png)

## 5. patch
patch传参也与post类似，作用是只更新局部数据。

``` javascript
      axios.patch('http://localhost:3000/login-patch', {name: 'haha', age: 20},{params:{id: 888}}).then(res => {
        console.log(res.data)
      })
```

``` javascript
app.patch('/login-patch', (req, res) => {
    res.send({msg:`put id is ${req.query.id};name is ${req.body.name};age is ${req.body.age}`, status: 200})
})
```

> <i class="fas fa-feather-alt" style="color: #E91E63"></i>这里综合使用了get的params传参与post的默认传参方式。

结果：
![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/20210509115639.png)
