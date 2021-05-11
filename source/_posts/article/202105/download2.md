---
title: vue+nodejs的第二种下载方式
tags:
- 下载
- vue
categories: 网络
cover: https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/5836a17eb9e7f5c4e2974b18f79717c0.png
date: 2021-05-11 23:04:34
---

其实这里也没啥，就是使用了表单的下载，哈哈～

## 表单提交法

``` javascript
	import {downloadFile} from "../until/download";
    downloadB () {
      downloadFile('http://localhost:3000/request/download', {name: this.name})
    }
```

``` javascript
// download.js
import $ from 'jquery'
const downloadFile = ($url, $obj) => {
    const param = {
        url: $url,
        obj: $obj
    }

    if (!param.url) {
        return
    }

    const generatorInput = function (obj) {
        let result = ''
        const keyArr = Object.keys(obj)
        keyArr.forEach(function (key) {
            result += "<input type='hidden' name = '" + key + "' value='" + obj[key] + "'>"
        })
        return result
    }
    $(`<form action="${param.url}" method="get">${generatorInput(param.obj)}</form>`).appendTo('body').submit().remove()
}

export { downloadFile }
```

## axios方法

``` javascript
  axios.get("http://localhost:3000/request/download", {
	params: {
	  name: this.name
	},
	responseType: "blob", // 服务器返回的数据类型
  })
	.then((res) => {
	  debugger;
	  const content = res.data; // 使用res.data接收数据
	  const blob = new Blob([content]); //  构造一个blob对象处理数据
	  const fileName = "12.txt"; // 保存的文件名
	  if ("download" in document.createElement("a")) {
		// 兼容浏览器
		const link = document.createElement("a");
		const href = window.URL.createObjectURL(blob);
		link.href = href;
		link.download = fileName;
		document.body.appendChild(link);
		link.click(); // 点击下载
		document.body.removeChild(link); // 移除a标签
		window.URL.revokeObjectURL(href); // 释放url
	  } else {
		navigator.msSaveBlob(blob, fileName);
	  }
	});
```

## node后端

``` javascript
const express = require('express')
const router = express.Router()
const fs = require('fs')

router.get('/download', (req, res) => {
  let name = req.query.name  //获取下载名称
  let path = './upload/' + name // 服务器上的文件路径
  res.set({  // 设置下载请求头
    'Content-Type': 'application/octet-stream',  // 二进制文件
    'Content-Disposition': 'attachment; filename=' + name  // 需要下载
  })
  fs.createReadStream(path).pipe(res)  // 创建文件流管道
})

module.exports = router
```
