---
title: axios的基础封装
date: 2021-05-03
tags: axios 请求
categories: 网络
keywords: axios 请求
---

## service.js

``` javascript
import axios from 'axios'

// 创建axios实例
const service = axios.create(null)
service.defaults.timeout = 50000
// 设置form头属性
service.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded;charset=UTF-8'

// 切换环境
if (process.env.NODE_ENV === 'development') {
  service.defaults.baseURL = '/api'
} else if (process.env.NODE_ENV === 'production') {
  service.defaults.baseURL = '/'
}

service.interceptors.request.use(config => {
  // 统一请求头处理
  // const token = 'token'
  // token && (config.headers.Authorization = token)
  return config
}, error => {
  return Promise.reject(error)
})

service.interceptors.response.use(response => {
  if (response.status === 200) {
    return Promise.resolve(response.data)
  } else {
    return Promise.reject(response)
  }
}, error => {
  if (error.response && error.response.status) {
    switch (error.response.status) {
        // 401： 未登录
      case 401:
        console.log("跳转登录")
        break;
        // 403： token过期
      case 403:
        console.log("token过期，跳转登录")
        // 清除token
        break;
      case 404:
        console.log("请求资源不存在")
        break;
      default:
        console.log("其他错误")
    }
    return Promise.reject(error.response)
  } else {
    return Promise.reject(error.message)
  }
})

export default service
```

## request.js

``` javascript
import service from './service'
// 随axios引入的，无需自行引入 
import qs from 'qs'

export function GET_DATA (url, params) {
  return new Promise((resolve, reject) => {
    service.get(url,{
      params
    }).then(res => {
      resolve(res.data)
    }).catch(err => {
      reject(err.data)
    })
  })
}
// axios post数据时使用qs.stringify(data) 或者new URLSearchParams()来添加数据
export function POST_DATA (url, data) {
  return new Promise((resolve, reject) => {
    service.post(url, qs.stringify(data)).then(res => {
      resolve(res.data)
    }).catch(err => {
      reject(err.data)
    })
  })
}
```

## 在nodejs处理

``` javascript
const express = require('express')
const app = express()
const bodyParser = require('body-parser')

// 跨域的处理
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin','*');
  res.header('Access-Control-Allow-Credential','true');
  res.header('Access-Control-Allow-Methods','GET,POST,PUT,DELETE,OPTIONS');
  next();
})

// 使用post请求时需要转换请求体
app.use(bodyParser.urlencoded({extended:false}))


// get使用req.query.xxx接收
app.get('/login', (req,res) => {
  res.send({msg: 'success', code: 200, data:{name:req.query.name}})
})

// post使用req.body.xxx接收
app.post('/login', (req,res) => {
  res.send({msg: 'success', code: 200, data:{pwd:req.body.pwd}})
})

app.listen(3000, () => {
  console.log("server start")
})
```
