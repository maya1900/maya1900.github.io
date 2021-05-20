---
title: 实现codemirror的自定义提示的功能
tags:
  - codemirror
  - vue
categories: vue
cover: https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/17617eb644fd4869c7d7070f6b0e8127.png
date: 2021-05-19
---

## 效果图

![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/GIF-2021-5-19-23-31-35.gif)

## 前言

原本是使用 codemirror 的方法来实现，结果在得到行内容的时候问题不能第一次得到括号/花括号这样的符号，需要打两遍，而且实际项目中还需要做遍历操作，需要的参数过多。
于是使用了 vue-codemirror，基于它封装的 vue 插件，而且功能使用上也比较方便，遂使用。

## 代码

```javascript
<template>
  <div class="main">
    <codemirror
      ref="cm"
      v-model="code"
      :options="cmOptions"
      @input="inputChange"
    ></codemirror>
  </div>
</template>

<script>
import { codemirror } from "vue-codemirror";
import "codemirror/theme/idea.css";
import "codemirror/mode/shell/shell";
// 代码提示功能 具体语言可以从 codemirror/addon/hint/ 下引入多个
import "codemirror/addon/hint/show-hint.css";
import "codemirror/addon/hint/show-hint";
// 高亮行功能
import "codemirror/addon/selection/active-line";
import "codemirror/addon/selection/selection-pointer";
// 全屏功能 由于项目复杂，自带的全屏功能一般不好使
import "codemirror/addon/display/fullscreen.css";
import "codemirror/addon/display/fullscreen";
export default {
  components: {
    codemirror,
  },
  data() {
    return {
      code: "",
      cmOptions: {
        mode: "shell",
        theme: "idea",
        line: true,
        lineNumbers: true,
        lineWrapping: true,
        // 高亮行功能
        styleActiveLine: true,
        hintOptions: {
          completeSingle: false,
          hint: this.handleShowHint,
        },
      },
    };
  },
  methods: {
    inputChange() {
      // this.$nextTick(() => {
      //   console.log('code:' + this.code)
      //   console.log('content:' + content)
      // })
    },
    handleShowHint() {
      const hintList = [
        {
          name: "xiaohong",
          value: "xiaohong"
        },
        {
          name: "xiaozhang",
          value: [
            {
              name: "xiaoli",
            },
            {
              name: "xiaosun",
            },
          ],
        },
      ];
      const cmInstance = this.$refs.cm.codemirror;
      console.log(cmInstance, 54);
      // 得到光标
      let cursor = cmInstance.getCursor();
      // 得到行内容
      let cursorLine = cmInstance.getLine(cursor.line);
      // 得到光标位置
      let end = cursor.ch;
      let start = end;
      const Two = `${cursorLine.charAt(start - 2)}${cursorLine.charAt(start - 1)}`;
      const One = `${cursorLine.charAt(start - 1)}`;
      let list = [];
      if (Two === "${") {
        hintList.forEach(e => {
          list.push(e.name)
        })
      } else if (One === ".") {
        let lastIndex = cursorLine.lastIndexOf('${', start)
        let key = cursorLine.substring(lastIndex + 2, start - 1)
        list = []
        hintList.forEach((e) => {
          if (e.name === key && lastIndex !== -1 && Object.prototype.toString.call(e.value) === '[object Array]') {
            e.value.forEach(el => {
              list.push(el.name)
            })
          }
        })
      }
      // 得到光标标识
      let token = cmInstance.getTokenAt(cursor);
      // console.log(cmInstance, cursor, cursorLine, end, token);
      return {
        list: list,
        from: { ch: end, line: cursor.line },
        to: { ch: token.end, line: cursor.line },
      };
    },
  },
  mounted() {
    // 代码提示功能 当用户有输入时，显示提示信息
    this.$refs.cm.codemirror.on("inputRead", (cm) => {
      cm.showHint();
    });
  },
};
</script>

<style>
.main {
  width: 500px;
  height: 300px;
  border: 1px solid;
}
</style>
```

## 更新 2.0

今天把做好的给 pm 看，pm 又说需要实现提示完后自动加上后面的花括号，额...还好不是一个难的需求，想到还有一种提示方式，于是又进行了改装，实现了功能。

## 效果图

[![gTRKjf.gif](https://z3.ax1x.com/2021/05/20/gTRKjf.gif)](https://imgtu.com/i/gTRKjf)

## 修改代码

把赋值的 list 都修改为对象的形式，然后添加一个 hintRender 的方法。

```javascript
// ...
list.push({
  text: e.name + '}',
  displayText: e.name,
  render: this.hintRender,
});
// ...
```

```javascript
  hintRender (element, self, data) {
    let div = document.createElement("div")
    div.setAttribute("class", 'autocomplete-div')

    let divText = document.createElement("div")
    divText.setAttribute("class", 'autocomplete-name')
    divText.innerText = data.displayText

    div.appendChild(divText)
    element.appendChild(div)
  }
```

好，结束。

## 参考

- [codemirror 入门教程](https://blog.gavinzh.com/2020/12/13/codemirror-getting-started/)
- [codemirror 的自定义提示](https://blog.csdn.net/smk108/article/details/87637299)
