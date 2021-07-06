---
title: websocket的简单实现
date: 2021-07-06
tags:
- websocket
- 网络
categories: 网络
cover:
---

客户端：
```js
<script>
  new Vue({
    el: '#app',
    data: {
      value: 'haha'
    },
    methods: {
      init() {
        if(window.WebSocket){
          var ws = new WebSocket('ws://localhost:4444');

          ws.onopen = function(e){
            console.log("连接服务器成功");
            // 向服务器发送消息
            ws.send("what`s your name?");
          }
          ws.onclose = function(e){
            console.log("服务器关闭");
          }
          ws.onerror = function(){
            console.log("连接出错");
          }
          // 接收服务器的消息
          ws.onmessage = function(e){
            let message = "message:"+e.data+"";
            console.log(message);
          }
        }
      }
    },
    mounted () {
      this.init()
    }
  })
</script>
```
服务端：
```js
const express = require('express')
const app = express()
app.use(express.static(__dirname))
app.listen(3000)
const WebSocket = require('ws')
const WebSocketServer = WebSocket.Server;

// 创建 websocket 服务器 监听在 3000 端口
const wss = new WebSocketServer({port: 4444})

// 服务器被客户端连接
wss.on('connection', (ws) => {
  // 通过 ws 对象，就可以获取到客户端发送过来的信息和主动推送信息给客户端
  var i=0
  var int = setInterval(function f() {
    ws.send(i++) // 每隔 1 秒给连接方报一次数
  }, 1000)
})

```
