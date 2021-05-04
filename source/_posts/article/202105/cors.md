---
title: 跨域问题--cors解决方案
tags:
  - 跨域
  - cors
categories: 浏览器
cover: 'https://z3.ax1x.com/2021/05/04/gnoROJ.png'
keywords:
  - cors
  - 跨域
  - 浏览器
abbrlink: 6a1e86eb
date: 2021-05-03 00:00:00
---

## 一、 跨域

js出于安全方面的考虑，不允许不同域调用其他页面的对象。当协议、域名、端口号任意一个不相同时，就算不同域。
跨域并不是请求发不出去，而是请求能发出去，服务端能收到请求并正常返回结果，只是结果被浏览器拦截了。

## 二、跨域解决

### 1. jsonp
jsonp优点就是可以兼容各种浏览器，而缺点也很明显，只能发送get请求。
jsonp利用了script标签加载机制，它发送的不是ajax请求。

客户端代码：

``` javascript
function getData() {
	const script = document.createElement('script');
	script.type = 'text/javascript';
	script.src = 'http://localhost:3000/jsonpText?callback=getData'
	document.head.appendChild(script)
}
function fun(res) {
	alert(res)
}

document.getElementById('get_data').addEventListener('click', ()=>{
	getData()
})
```
服务端代码：

``` javascript
const express = require('express')
const app = express()

app.get('/jsonpTest', (req,res)=>{
	// 返回的数据
	const data = {
		"name": "xixi",
		"age": "18"
	}
	const callFn = req.query.callback
	// 返回函数触发客户端的回调函数执行
	res.send(`${callFn}(${JSON.stringify(data)})`)
})

app.listen(5000)
```

### 2. cors跨域解决方案

CORS:跨源资源共享，基于http协议，通过允许服务器标示除了它自己以外的其它origin来实现请求。

CORS需要浏览器和服务器同时支持，IE不低于IE10。

#### cors的两种请求

CORS请求分为两类：简单请求和预检请求。

符合下面条件的就是简单请求：

> 请求方式使用下列方法之一：
> GET
> HEAD
> POST
>  
> Content-Type 的值仅限于下列三者之一：
> text/plain
> multipart/form-data
> application/x-www-form-urlencoded

对于简单请求，浏览器直接发出CORS请求。具体来说，就是在头信息之中，增加一个Origin字段。同样，在响应头中，返回服务器设置的相关CORS头部字段，Access-Control-Allow-Origin字段为允许跨域请求的源。

预检请求：

> 使用了下面任一 HTTP 方法：
> PUT
> DELETE
> CONNECT
> OPTIONS
> TRACE
> PATCH
>  
> Content-Type 的值不属于下列之一:
> application/x-www-form-urlencoded
> multipart/form-data
> text/plain

当发生符合非简单请求（预检请求）的条件时，浏览器会自动先发送一个options请求，如果发现服务器支持该请求，则会将真正的请求发送到后端，反之，如果浏览器发现服务端并不支持该请求，则会在控制台抛出错误

如果非简单请求（预检请求）发送成功，则会在头部多返回以下字段：

> Access-Control-Allow-Origin: http://localhost:3001  //该字段表明可供那个源跨域
Access-Control-Allow-Methods: GET, POST, PUT        // 该字段表明服务端支持的请求方法
Access-Control-Allow-Headers: X-Custom-Header       // 实际请求将携带的自定义请求首部字段

### 实例代码：

``` javascript
const express = require('express')
const app = express()

app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin','*');
  res.header('Access-Control-Allow-Credential','true');
  res.header('Access-Control-Allow-Methods','GET,POST,PUT,DELETE,OPTIONS');
  next();
})

app.get('/login', (req,res) => {
  res.send({meg: 'success', code: 200})
})

app.listen(3000)
```

### 注意：
需要携带cookie信息时，需要将Access-Control-Allow-Credentials设置为true,同时axios也需要打开：xhr.withCredentials=true

## 参考：
1. [MDN:CORS](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/CORS)
2. [彻底理解CORS跨域原理](https://www.cnblogs.com/qiujianmei/p/11649905.html)
