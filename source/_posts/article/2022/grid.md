---
title: 探 Grid 布局
date: 2022-05-16
tags:
  - css
  - grid
categories: css
cover: https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/202205161237491.jpg
---

# CSS 网格布局

grid 是唯一的二维布局方式，将网页分为一个个网格，可以任意组合不同的网格，从而实现各种各样的布局

> 二维布局：同时控制行和列进行布局；一维布局：只需按行或列进行布局

# 重要术语

## 网格容器（Grid Container）

应用`display: grid`的元素，是所有网格项的父元素。

## 网格项（Grid Item）

容器的直接子元素。

## 网格线（Grid line）

构成网格元素的分割线

## 网格单元格（Grid Cell）

横纵相邻网格线之间的空间。

## 网格区域（Grid Area）

网格上矩形区域的一个或多个的单元格组合。

## 网格轨道（Grid Track）

相邻网格线之间的空间，行和列的概念。

# Grid 属性

## 容器属性

- display
- grid-template-columns
- grid-template-rows
- grid-template-areas
- grid-template
- column-gap(grid-column-gap)
- row-gap(grid-row-gap)
- gap(grid-gap)
- justify-items
- align-items
- place-items
- justify-content
- align-content
- place-content
- grid-auto-columns
- grid-auto-rows
- grid-auto-flow
- grid

## 网格项属性

- grid-column-start
- grid-column-end
- grid-row-start
- grid-row-end
- grid-column
- grid-row
- grid-area
- justify-self
- align-self
- place-self

# 容器属性详解

## grid-template-columns/grid-template-rows

定义网格线及网格尺寸大小。

属性值：

- 网格宽度：`grid-template-columns: 100px 1fr;`
- 网格线+ 网格宽度：`grid-template-columns: [linename1] 100px [linename2 linename3] auto [linename4] 200px [lastlinename];`(有中括号的)

其他：

- 双命名：给同一条线起两个名字。
- repeat 语法：repeat(多少次，值)，如：`repeat(3, 200px [col-start])`
- fr：fraction 缩写，等分，如：`reppeat(4, 1fr)`
- auto-fill：网格固定，容器不固定，自动填充，如：repeat(`auto-fill`, 100px)
- minmax：长度范围，如：`minmax(100px, 1fr)`
- auto：浏览器自己决定长度。

## grid-template-areas

定义网格区域。

```CSS
.container {
  grid-template-areas:
    "<grid-area-name> | . | none | ..."
    "...";
}
```

grid-area-name：网格名称；

. 表示空的网格

none 没有定义网格区域

使用 grid-area 定义网格名称

步骤：

1. 定义好基本行和列尺寸；
2. 使用 grid-template-areas 定义网格区域位置
3. 使用 grid-area 定义网格名称

## grid-template

是 grid-template-columns、grid-template-rows 和 grid-template-areas 的缩写。

如：`grid-tempalte: 100px 1fr / 50px 1fr;`（中间是个斜杠，空格隔开）

```CSS
.container {
    grid-template: none;
}
.container {
    grid-template: <grid-template-rows> / <grid-template-columns>;
}
```

## column-gap/row-gap

定义网格间隙的尺寸。旧的有前缀`grid-`

```CSS
.container {
  column-gap: <line-size>;
  row-gap: <line-size>;
}
```

## gap

column-gap 和 row-gap 的缩写。旧的有前缀`grid-` flex 布局也可以用`gap`属性。

```CSS
.container {
    grid-gap: <grid-row-gap> <grid-column-gap>;
}
```

## justify-items

网格元素的水平呈现方式。

```CSS
.container {
    justify-items: stretch | start | end | center;
}
```

## align-items

网格元素的垂直呈现方式。

```CSS
.container {
    align-items: stretch | start | end | center;
}
```

## place-items

justify-items 和 align-items 的缩写。

```CSS
.container {
    place-items: <align-items> <justify-items>?;
}
```

## justify-content

整体网格在容器内的水平分布方式。

```JavaScript
justify-content: stretch | start | end | center | space-between | space-around | space-evenly;
```

## align-content

整体网格在容器内的垂直分布方式。

```CSS
align-content: stretch | start | end | center | space-between | space-around | space-evenly;
```

## place-content

justify-conent 和 align-cotent 的缩写。

```CSS
.container {
    place-content: <align-content> <justify-content>?;
}
```

## grid-auto-columns/grid-auto-rows

定义隐式网格轨道的大小。当网格元素位于显式网格之外，将创建隐式网格。

```CSS
.container {
    grid-auto-columns: <track-size> ...;
    grid-auto-rows: <track-size> ...;
}
```

## grid-auto-flow

定义没有明确指定位置的子项元素分布方式。

```CSS
.container {
  grid-auto-flow: row | column | row dense | column dense
}
```

## grid

是定义显式网格和隐式网格尺寸的集合。

```CSS
grid: <grid-template-rows> / [ auto-flow && dense? ] <grid-auto-columns>?
grid: [ auto-flow && dense? ] <grid-auto-rows>? / <grid-template-columns>

```

# 网格属性详解

## grid-column-start, grid-column-end, grid-row-start 和 grid-row-end

表示 grid 子项所占据的区域的起始和终止位置，包括水平方向和垂直方向。

```CSS
.item {
    grid-column-start: <number> | <name> | span <number> | span <name> | auto
    grid-column-end: <number> | <name> | span <number> | span <name> | auto
    grid-row-start: <number> | <name> | span <number> | span <name> | auto
    grid-row-end: <number> | <name> | span <number> | span <name> | auto
}
```

## grid-column 和 grid-row

上面四个的缩写。

## grid-area

`grid-area`其实是`grid-row-start`, `grid-column-start`, `grid-row-end` 以及 `grid-column-end`属性的缩写，以及额外支持`grid-template-areas`设置的网格名称。

```CSS
.item {
    grid-area: <name> | <row-start> / <column-start> / <row-end> / <column-end>;
}
```

## justify-self

`justify-self`表示单个网格元素的水平对齐方式。

```CSS
.item {
    justify-self: stretch | start | end | center;
}
```

## align-self

`align-self`指定了网格元素的垂直呈现方式

```CSS
.container {
    align-self: stretch | start | end | center;
}
```

## place-self

上面两个的缩写。

```CSS
.item {
    place-self: <align-self> <justify-self>?
}
```

# 实践

## 基本布局

![](https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/202205160823732.png)

```HTML
  <body>
    <div class="container">
      <div class="header"></div>
      <div class="side"></div>
      <div class="wrapper"></div>
      <div class="footer"></div>
    </div>
  </body>

```

```CSS
.container {
  display: grid;
  grid-template-columns: 200px 1fr;
  grid-template-rows: 60px 1fr 60px;
  grid-template-areas:
    'header header'
    'side wrapper'
    'side footer';
  height: 100%;
}
.header {
  background-color: green;
  grid-area: header;
}
.side {
  background-color: orange;
  grid-area: side;
}
.wrapper {
  background-color: red;
  grid-area: wrapper;
}
.footer {
  background-color: yellow;
  grid-area: footer;
}
```

# 参考：

[网格布局 - CSS（层叠样式表） | MDN](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Grid_Layout)

[CSS Grid 网格布局教程 - 阮一峰的网络日志 ](https://www.ruanyifeng.com/blog/2019/03/grid-layout-tutorial.html)

[写给自己看的 display: grid 布局教程 « 张鑫旭](https://www.zhangxinxu.com/wordpress/2018/11/display-grid-css-css3/)

[Grid by Example - Usage examples of CSS Grid Layout](https://gridbyexample.com/examples/)
