---
title: vue+axios+nodejs实现简单上传下载
tags:
- vue
- axios
- nodejs
- 上传
- 下载
categories: 网络
cover: https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/5836a17eb9e7f5c4e2974b18f79717c0.png
date: 2021-05-09 23:55:44
---

## 上传

``` html
    <div class="upload">
      <input type="file" name="file" @change="change" />
      <button @click="upload">上传</button>
    </div>
```

``` javascript
    upload() {
      let formData = new FormData();
      formData.append("file", this.file);
      axios
        .post("http://localhost:3000/request/profile", formData)
        .then((res) => {
          console.log(res.data);
        });
    },
    change(e) {
      let file = e.target.files[0]; // 得到文件
      console.log(file);
      this.file = file;
    }
```

``` javascript
const express = require('express')
const router = express.Router()
const multer = require('multer')

// 创建一个上传文件夹
const uploadFolder = './upload/'
const fs = require('fs')
function createUploadFolder(folder) {
  try {
    fs.accessSync(folder)
  } catch (e) {
    fs.mkdirSync(folder)
  }
}
createUploadFolder(uploadFolder)

// 配置存储属性
let storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, uploadFolder)   // 保存的文件路径
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname)  // 保存的文件名称，这里我使用原名称，一般需要修改
  }
})
let upload = multer({storage})
router.post('/profile',upload.single('file'),(req, res) => {
  res.send({msg: 'upload success'})
})

module.exports = router
```

结果就可以看到服务器上upload文件夹下生成上传的文件

## 下载

``` javascript
    download() {
      axios
        .post(
          "http://localhost:3000/request/download",
          {
            name: this.name,
          },
          {
            responseType: "blob", // 服务器返回的数据类型
          }
        )
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
    }
```

``` javascript
const express = require('express')
const router = express.Router()
const fs = require('fs')

router.post('/download', (req, res) => {
  let name = req.body.name  //获取下载名称
  let path = './upload/' + name // 服务器上的文件路径
  res.set({  // 设置下载请求头
    'Content-Type': 'application/octet-stream',  // 二进制文件
    'Content-Disposition': 'attachment; filename=' + name  // 需要下载
  })
  fs.createReadStream(path).pipe(res)  // 创建文件流管道
})
```

结果点击下载弹出保存位置，然后可以进行保存。

参考：

- [multer文档](https://github.com/khez/multer)
