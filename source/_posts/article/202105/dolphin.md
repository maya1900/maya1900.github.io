---
title: dolphinscheduler的请求
date: 2021-05-04
tags: 
- axios
- 请求
categories: 网络
cover: https://z3.ax1x.com/2021/05/04/gnhcbq.png
keywords: 
- axios
- 请求
---

## axios文件夹
### querystring.js

``` javascript
/* 
功能是构造参数
*/
let param = function (a) {
  let s = []
  // 正则，[]
  let rbracket = /\[\]$/
  // 对象是否是数组
  let isArray = function (obj) {
    return Object.prototype.toString.call(obj) === '[object Array]'
  }
  // 给地址添加一个参数和值
  let add = function (k, v) {
    v = typeof v === 'function' ? v() : v === null ? '' : v === undefined ? '' : v
    // encodeURIComponent，把字符串按URI组件编码
    s[s.length] = encodeURIComponent(k) + '=' + encodeURIComponent(v)
  }
  // 构造参数
  let buildParams = function (prefix, obj) {
    let i, len, key
    if (prefix) {
      if (isArray(obj)) {
        for (i = 0, len = obj.length; i < len; i++) {
          if (rbracket.test(prefix)) {
            add(prefix, obj[i])
          } else {
            buildParams(prefix + '[' + (typeof obj[i] === 'object' ? i : '') + ']', obj[i])
          }
        }
      } else if (obj && String(obj) === '[object Object]') {
        for (key in obj) {
          buildParams(prefix + '[' + key + ']', obj[key])
        }
      } else {
        add(prefix, obj)
      }
    } else if (isArray(obj)) {
      for (i = 0, len = obj.length; i < len; i++) {
        add(obj[i].name, obj[i].value)
      }
    } else {
      for (key in obj) {
        buildParams(key, obj[key])
      }
    }
    return s
  }
  return buildParams('', a).join('&').replace(/%20/g, '+')
}

module.exports = param

```

### jsonp.js

``` javascript

// 没太懂，再研究
function jsonp (url, opts, fn) {
  if (typeof opts === 'function') {
    fn = opts
    opts = {}
  }
  if (!opts) opts = {}

  let prefix = opts.prefix || '__jp'

  // 使用回调函数的名称，或者计数器
  let id = opts.name || (prefix + (count++))

  let param = opts.param || 'callback'
  let timeout = opts.timeout !== null ? opts.timeout : 60000
  let enc = encodeURIComponent
  /* istanbul ignore next */
  let target = document.getElementsByTagName('script')[0] || document.head
  let script
  let timer
 // 超时报错
  if (timeout) {
    timer = setTimeout(
      /* istanbul ignore next */
      function () {
        cleanup()
        if (fn) fn(new Error('Timeout'))
      }, timeout)
  }

  // 清除计时器
  function cleanup () {
    script.onerror = null
    script.onload = null
    /* istanbul ignore else */
    if (script.parentNode) script.parentNode.removeChild(script)
    window[id] = noop
    /* istanbul ignore else */
    if (timer) clearTimeout(timer)
  }

  function cancel () {
    /* istanbul ignore else */
    if (window[id]) {
      cleanup()
    }
  }

  window[id] = function (data) {
    // debug('jsonp got', data);
    cleanup()
    if (fn) fn(null, data)
  }

  // add qs component
  url += (~url.indexOf('?') ? '&' : '?') + param + '=' + enc(id)
  url = url.replace('?&', '?')

  // debug('jsonp req "%s"', url);
  let handler = ({ type }) => {
    /* istanbul ignore else */
    if (type === 'error') {
      cleanup()
      fn(new Error('http error'))
    }
  }
  // create script
  script = document.createElement('script')
  script.src = url
  script.onload = handler
  script.onerror = handler
  target.parentNode.insertBefore(script, target)

  return cancel
}
```

### index.js

``` javascript
/*
功能是对axios的进一步封装
*/
const _ = require('lodash')
const axios = require('axios')
const combineURLs = require('axios/lib/helpers/combineURLs')
const buildURL = require('axios/lib/helpers/buildURL')

const qs = require('./querystring')
const jsonp = require('./jsonp')

const preflightDataMethods = ['post', 'put', 'patch']
const API_ASSERT_OK = 0

// 定义属性
const def = (o, p, v, desc) =>
  Object.defineProperty(o, p,
    // 合并desc属性
    Object.assign({ writable: false, enumerable: false, configurable: false }, desc, { value: v }))

  // 归一化参数
const normalizeArgs = (method, url, data, success, fail, config) => {
  // 判断是否函数
  if (_.isFunction(data)) {
    config = fail
    fail = success
    success = data
  }
  // 判断是否普通对象
  if (_.isPlainObject(data)) {
    //判断请求方法是否是post,put,patch，是就直接加进配置，不是需要加params
    if (!_.includes(preflightDataMethods, method)) {
      config = _.merge({}, config, { params: data })
    } else {
      config = _.merge({}, config, { data })
    }
  } else {
    config = config || {}
  }
  config.method = method
  config.url = url
  return {
    success, fail, config
  }
}

// 返回成功或失败的数据
const generalHandle = (data, res, resolve, reject, success, fail) => {
  // 如果没有data,或者 data.code或0的结果不等于API_ASSERT_OK ，就执行失败；否则成功
  // 加号表示隐式转换为数字类型
  if (!data || +(data.code || 0) !== API_ASSERT_OK) {
    fail && fail(data)
    reject(data)
  } else {
    success && success(data)
    resolve(data)
  }
}

// 正则 测试url是否有https:// /i不区分大小写
const isAbsUrl = (url) => {
  return /^(https?:)?\/\//i.test(url)
}

// 连接url 即https://xxx  /xxx 连接起来
const resolveURL = (base, path) => {
  if (!base || (path && isAbsUrl(path))) {
    return path
  }
  return combineURLs(base, path)
}

const create = (cfg) => new InnerCtor(cfg)

class InnerCtor {
  constructor (defaults) {
    const inter = axios.create(defaults)

    // { baseURL, timeout, ... }
    this.config = Object.assign(
      {
        baseURL: '',
        timeout: 0,
        resolveURL: u => u
      },
      defaults
    )

    // 定义类的属性inter和interceptors与axios实例关联
    this.inter = inter
    this.interceptors = inter.interceptors

    this.jsonp = this.jsonp.bind(this)

    // Exporse the internal json api
    this.jsonp.inter = jsonp

    // 更新http请求的方法.把axios的request全部换成this.request
    ;['get', 'delete', 'head', 'options', 'post', 'put', 'patch'].forEach((method) => {
      this[method] = function (url, data, success, fail, config) {
        return this.request({ url, method, data, success, fail, config })
      }.bind(this)
    })
  }

  request ({ url, method, data, success, fail, config }) {
    const configs = normalizeArgs(method, this.config.resolveURL(url), data, success, fail, config)
    configs.config = _.merge({}, this.config, configs.config)

    // 构造参数 将json转为x-www-form-urlencoded,数据格式由json转为对象
    if (configs.config.emulateJSON !== false) {
      configs.config.data = qs(configs.config.data)
    }

    return new Promise((resolve, reject) => {
      // 发送请求 axios.request
      this.inter.request(configs.config)
        .then((res) => {
          // 预检请求
          if (method === 'head' || method === 'options') {
            res.data = res.headers
          }
          generalHandle(res.data, res, resolve, reject, configs.success, configs.fail)
        })
        .catch(err => {
          let ret, code
          /* istanbul ignore else */
          if (err.response && err.response.status) {
            code = err.response.status
          } else {
            code = 500
          }
          if (err.response && (method === 'head' || method === 'options')) {
            err.response.data = err.response.headers
          }
          /* istanbul ignore else */
          if (err.response && err.response.data) {
            if (_.isString(err.response.data)) {
              ret = {
                message: err.message,
                code,
                data: err.response.data
              }
            } else {
              ret = err.response.data
            }
          } else {
            ret = {
              code,
              message: err.message,
              data: null
            }
          }
          def(ret, '$error', err)
          reject(ret)
        })
    })
  }

  jsonp (url, data, success, fail, config) {
    const configs = normalizeArgs('jsonp', this.config.resolveURL(url), data, success, fail, config)

    configs.config = _.merge({}, this.config, configs.config)
    configs.url = buildURL(resolveURL(configs.config.baseURL, configs.config.url), configs.config.params)

    return new Promise((resolve, reject) => {
      jsonp(configs.url, configs.config, (err, data) => {
        if (err) {
          const ret = {
            code: 500,
            message: err.message,
            data: null
          }
          def(ret, '$error', err)
          reject(ret)
        } else {
          generalHandle(data, data, resolve, reject, configs.success, configs.fail)
        }
      })
    })
  }
}

// 暴露合并create ,create为空的实例
module.exports = Object.assign(create({}), { create, axios })
```

## io 文件夹
### index.js
``` javascript
/* 
功能是io的请求拦截部分
*/
import io from '@/module/axios/index'
import cookies from 'js-cookie'

const apiPrefix = '/dolphinscheduler'
// 正则，表示 /+ /出现一次或多次
const reSlashPrefix = /^\/+/

// 返回后端url
const resolveURL = (url) => {
  // 如果url地址没有http，直接返回url
  if (url.indexOf('http') === 0) {
    return url
  }
  // 如果url第一个字符不是/, 返回/dolphinscheduler/xxx
  if (url.charAt(0) !== '/') {
    return `${apiPrefix}/${url.replace(reSlashPrefix, '')}`
  }

  return url
}
export { resolveURL }

// 默认io配置
io.config.resolveURL = resolveURL
io.config.timeout = 0
io.config.maxContentLength = 200000
// 验证状态
io.config.validateStatus = function (status) {
  // 如果未登录或者请求超时跳转到登录页面
  if (status === 401 || status === 504) {
    window.location.href = `${PUBLIC_PATH}/view/login/index.html`
    return
  }
  return status
}

// 添加本地请求拦截，不能mock数据
const _propRequest = io.request
io.request = (spec) => {
  return _propRequest.call(io, spec)
}

// 全局响应拦截器
io.interceptors.response.use(
  response => {
    return response
  }, error => {
    return Promise.reject(error)
  }
)

// 全局请求拦截器
io.interceptors.request.use(
  config => {
    // 拿到cookie里存的sessionId 和sessionStorage里存的sessionId
    const sIdCookie = cookies.get('sessionId')
    const sessionId = sessionStorage.getItem('sessionId')
    // 请求地址，截取最后的部分
    const requstUrl = config.url.substring(config.url.lastIndexOf('/') + 1)
    // 如果cooide里没有sessionId，或者 sessionStorage有id 且 它不等于cookie里的id ，并且请求地址不是login，那么跳转到登录页
    if ((!sIdCookie || (sessionId && sessionId !== sIdCookie)) && requstUrl !== 'login') {
      window.location.href = `${PUBLIC_PATH}/view/login/index.html`
    } else {
      // 否则如果此次请求是get方法，就在请求参数后面追加一个_t参数，值是随机数
      const { method } = config
      if (method === 'get') {
        config.params = Object.assign({}, config.params, {
          _t: Math.random()
        })
      }
      // 设置请求头和语言
      config.headers = config.headers || {}
      const language = cookies.get('language')
      if (language) config.headers.language = language
      if (sIdCookie) config.headers.sessionId = sIdCookie
      return config
    }
  }, error => {
    // Do something with request error
    return Promise.reject(error)
  }
)

export default io
```
