---
title: sass的使用
date: 2022-06-08
tags:
  - css
  - sass
categories: css
cover: https://gitlab.com/maya1900/pic/raw/main/img/8_8_7_0_202206080807679.jpg
---

# 安装

1. [安装 Ruby](http://rubyinstaller.org/downloads)；`ruby -v`检查
2. 安装 sass：`gem install sass` `gem install compass` ；`sass -v`检查

# sass 与 less 的区别

1. sass 基于 ruby，less 基于 js；
2. sass 变量定义使用$，less 变量定义使用@；
3. sass 有输出设置；
4. sass 支持条件语句。

# 功能扩展

## 支持嵌套

## 父选择器&

```Sass (Sass)
a {
  text-decoration: none;
  &:hover {
    text-decoration: underline;
  }
}
```

## 占位符选择器%foo

# SassScript

## 变量声明$

```Sass (Sass)
$color: #f00;
#main {
  color: $color;
}
```

变量支持块级作用域，在嵌套规则内定义的变量只能在嵌套层使用。添加!global 变为全局变量。

```Sass (Sass)
#main {
  $width: 30px !global;
  width: $width;
}
.sidebar {
  width: $width;
}
```

## 数据类型

SassScript 支持 6 种数据类型：

- 数字：1,2,10px
- 字符串：有引号的和无引号的，“foo”, bar
- 颜色：blue, #FFF,rgba(0,0,0,.5)
- 布尔型：true,false
- 空值：null
- 数组：空格或逗号分割，10px 20px, Arial, sans-serif

# 运算

运算的重点在于单位之间的转换。

## 加减法

- 绝对单位：px,pt,pc,in,mm,cm...都能运算；
- 相对单位：ex,em,rem...相对于字体的都不能运算；

都有单位以第一个为主进行转换，一般只写一个单位

```Sass (Sass)
$width: 100px + 100em; // Line 1: Incompatible units: 'em' and 'px'.
$height: 100px - 50pt; // 都有单位以第一个为主进行转换
.header {
  width: $width;
  height: $height;
}

```

## 乘法

乘法只能为一个值加单位，否则报错

```Sass (Sass)
$width: 100px * 2pt;
$height: 100px * 2;
.header {
  width: $width; // Line 3: 200px*px isn't a valid CSS value.
  height: $height;
}
```

## 除法

`/`在 css 中起分隔符的作用，在三种情况下`/`被视为运算符号：

- 如果值或值得一部分是变量或函数的返回值
- 值被圆括号包裹
- 值是算术表达式的一部分

```Sass (Sass)
p {
  font: 10px/8px; // 原样输出
  $width: 100px;
  width: $width / 2; // 使用了变量，是除法
  height:(500px/2); // 使用了圆括号，是除法
  line-height: round(1.5) / 2; // 使用了函数，是除法
  margin-right: 4px + 8px/2px; // 使用了加法，是除法
}
// 转换为：
p {
  font: 10px/8px;
  width: 50px;
  height: 250px;
  line-height: 1;
  margin-right: 8px; }

```

## 插值语句#{}

#{}可以在选择器或属性名上使用变量：

```JavaScript
$name: foo;
$attr: border;
p.#{$name} {
  #{$attr}-color: blue;
}
// 转换为：
p.foo {
  border-color: blue; }

```

## 变量定义!default

类似默认值，属性值未被定义时使用默认值，定义了就使用当前值。

# @-rules 与指令

## @import

sass 使用@import 导入 sass 文件，导入的文件将编译到同一个 css 文件。如：`@import "foo.scss"`

但如果有以下情况的则被编译为普通 css 语句：

- 文件扩展名是".css"
- 文件名以“http://”开头
- 文件名是 url()
- @import 包含媒体查询

## @media

sass 的媒体查询允许在 css 规则中嵌套。

```Sass (Sass)
.header {
  width: 100px;
  @media screen and (orientation: landscape) {
    width: 50px;
  }
}
// 转换为：
.header {
  width: 100px; }
  @media screen and (orientation: landscape) {
    .header {
      width: 50px; } }

```

## @extend

继承一个选择器的所有样式。

```Sass (Sass)
.error {
  border: 1px #f00;
  background-color: #fdd;
}
.seriousError {
  @extend .error;
  border-width: 3px;
}
```

# 控制指令

## @if

```Sass (Sass)
$width: 50px !default;
.header {
  $width: 100%;
  @if $width == 100% {
    height: 100px;
  } @else {
    height: 50px;
  }
}
// 转换为：
.header {
  height: 100px; }

```

## @for

有两种格式：

- `@for $var <start> through <end>` through 包含 end
- `@for $var <start> to <end>` to 不包含 end

```Sass (Sass)
$icon-list: down, up, file, hot;
@for $c from 1 through length($icon-list){
  .icon-#{nth($icon-list,$c)}{
      background-position: 0 -30px * $c;
  }
}
// 转换为：
.icon-down {
  background-position: 0 -30px;
}
.icon-up {
  background-position: 0 -60px;
}
.icon-file {
  background-position: 0 -90px;
}
.icon-hot {
  background-position: 0 -120px;
}

```

## @each

格式：`$var in <list>`

```Sass (Sass)
@each $animal in puma, sea-slug, egret, salamander {
  .#{$animal}-icon {
    background-image: url('/images/#{$animal}.png');
  }
}
// 转换为：
.puma-icon {
  background-image: url('/images/puma.png'); }
.sea-slug-icon {
  background-image: url('/images/sea-slug.png'); }
.egret-icon {
  background-image: url('/images/egret.png'); }
.salamander-icon {
  background-image: url('/images/salamander.png'); }

```

# 混合指令

## 定义混合指令@mixin

用法：在 `@mixin` 后添加名称与样式。

```Sass (Sass)
@mixin large-text {
  font: {
    family: Arial;
    size: 20px;
    weight: bold;
  }
  color: #ff0000;
}
```

## 引用混合指令@include

用法：`@include` 指令引用混合样式，格式是在其后添加混合名称，以及需要的参数

```Sass (Sass)
.page-title {
  @include large-text;
  padding: 4px;
  margin-top: 10px;
}
// 转换为：
.page-title {
  font-family: Arial;
  font-size: 20px;
  font-weight: bold;
  color: #ff0000;
  padding: 4px;
  margin-top: 10px; }

```

**为便于书写，\*\***`@mixin`\***\* 可以用 \*\***`=`\***\* 表示，而 \*\***`@include`\***\* 可以用 \*\***`+`\***\* 表示**。

# 函数指令

@function：与 js 函数写法相同。

```Sass (Sass)
$grid-width: 40px;
$gutter-width: 10px;

@function grid-width($n) {
  @return $n * $grid-width + ($n - 1) * $gutter-width;
}

#sidebar { width: grid-width(5); }
// 转换为：
#sidebar {
  width: 240px; }

```

# 输出格式

sass 支持四种输出格式：嵌套式、展开式、紧缩式和压缩式。

可通过`—style options`设定，node-sass 或 webpack 在配置里设置 outputStyle。

## :nested

默认样式（嵌套），能够清晰反映 CSS 与 HTML 的结构关系。

```Sass (Sass)
#main {
  color: #fff;
  background-color: #000; }
  #main p {
    width: 10em; }
```

## :expanded

展开样式。和手写的样式相同。

```Sass (Sass)
#main {
  color: #fff;
  background-color: #000;
}
#main p {
  width: 10em;
}
```

## :compact

紧凑样式。每条 css 规则只占一行。

```Sass (Sass)
#main { color: #fff; background-color: #000; }
#main p { width: 10em; }
```

## :compressed

压缩样式。删除所有无意义的空白、注释等，把文件体积压缩最小。

```Sass (Sass)
#main{color:#fff;background-color:#000}#main p{width:10em}
```

# 参考

[Sass 基础教程 Sass 快速入门 Sass 中文手册 | Sass 中文网](https://www.sass.hk/guide/)

[Sass 教程 Sass 中文文档 | Sass 中文网](https://www.sass.hk/docs/)

[CSS 外挂：Sass 之运算（加、减、乘、除） - SegmentFault 思否](https://segmentfault.com/a/1190000004698546)

[Sass 输出格式 - 我爱学习网 (5axxw.com)](https://www.5axxw.com/wiki/content/easggt)
