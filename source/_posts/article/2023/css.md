---
title: css基础回顾
tags:
  - css
categories: css
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/5836a17eb9e7f5c4e2974b18f79717c0.png
date: 2023-01-31 15:00:00
---

![](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202302081503292.png)

1. CSS 选择器及其优先级
   内联 1000
   id100
   类、伪类、属性 10
   标签、伪元素 1
2. CSS 中可继承与不可继承属性
   无继承：
   宽高内外边距
   背景、定位
   有继承
   字体、文本
3. 隐藏元素的方法
   display:none
   visibility:hidden
   opacity:0
   绝对定位
   z-index 负值
   transform:scale(0)
4. link 和@import 的区别
   都是引用外部 css
   link 除了加载 css，还可以定义 rss 等，import 只能 css
   link 页面载入时同时加载；import 等网页载入后才加载
   import 低版本浏览器不支持
5. transition 和 animation 的区别
   transtion 是过渡属性，需要一个触发事件
   animation 是动画属性，不需要事件，设定好事件自动执行，使用 keyframe 设置多个关键帧
6. display:none 与 visibility:hidden 的区别
   none 会让元素从渲染树中消失，不占据空间；hidden 不会从 dom 树中消失，占据空间
   none 非继承属性，父节点消失，子节点同时消失；hidden 继承属性，子孙节点可通过 visible 让子孙显示
   none 造成文档重排，hidden 不会
   9.  伪元素和伪类的区别和作用
   伪元素：在内容元素前后插入新的元素或样式，不会在文档中出现，只是外部显示
   伪类：将特殊效果添加到特定选择器上，在已有元素上添加类别，不会产生新的元素
7. 对 requestAnimationframe 的理解
   用于请求动画 api，不需要设定时间间隔
   setTimeout 的缺点：setimeout 是异步任务，需要等前面的任务完成才会执行，而且固定时间不一定与屏幕刷新时间相同，会引起丢帧
   requestAnimationframe 采用系统时间间隔，会把每一帧中的 dom 操作集中起来，在一次重绘回流中完成，而且时间间隔金穗浏览器的刷新频率。
   在隐藏或不可见的元素中，request 不会重绘回流
   在页面未激活状态时，动画也会自动暂停，节省 cpu 开销
8. 对盒模型的理解
   标准盒模型 width 和 height 值包含 content
   IE 盒模型 width 和 height 包含 border、padding、content
9. CSS3 中有哪些新特性
   新增 css 选择器：+ > : ::
   背景、border-radius、box-shadow、
   渐变、旋转、缩放、位移、动画
10. 常见的图片格式
    png、jpg、gif、svg、webp、bmp、avif、apng
11. CSS 预处理器/后处理器是什么
    预处理器：sass 定义变量使用$，less 使用@，sass 在服务端处理，less 使用 js 引擎，需要额外时间。
    后处理器：规范 css，postcss 添加私有前缀
12. 如何判断元素是否到达可视区域
    元素距离文档顶部的距离 < 浏览器可视区的高度 + 滚动条滚动的距离。
13. 两栏布局的实现
    浮动左边 200px，右边 margin-left200px，宽度 auto
    浮动左边 200px，右边 overflow:hidden
    flex 布局
    定位
14. 三栏布局的实现
    定位左右绝对定位，中间设置 margin
    flex 布局
    左右浮动，中间 margin 5.水平垂直居中的实现
    绝对定位 top left 50%，transform translate -50%
    绝对定位四个方向都为 0，margin auto
    绝对定位 top left 50%，margin 负值自身宽高的一半
    flex
15. 对 Flex 布局的理解
    弹性布局。用来为盒状模型提供最大的灵活性。设置后 float 失效，子元素都变成块级元素，默认有两条轴：水平和垂直
16. 对 BFC 的理解，如何创建 BFC
    块级格式化上下文，是一个独立的布局环境，按照一定的规则摆放，不会影响外部的元素。元素布局不受外部影响。
    条件：
    根元素 body
    元素设置浮动
    设置绝对定位
    display 为 inline-block、table-cell、flex
    overflow 为 hidden
    特点：
    垂直方向上，自上而下排列
    相邻元素 margin 重叠
    bfc 不会与浮动容器重叠
    容器内部不会影响外部的元素
    元素左 margin 和容器左 border 接触
    作用：
    解决 margin 重叠
    解决高度塌陷
    创建自适应两栏布局
17. 元素的层叠顺序
    层叠上下文，html 的三维概念，html 元素在 z 轴方向按一定的顺序进行堆叠起来的
    背景和边框
    负的 z-index
    块级盒子
    浮动盒子
    行内盒子
    z-index：0
    正 z-index
18. 实现一个三角形
    宽高设为 0，给边框宽度，一边设置颜色，其他三边颜色设为透明
    ｜
19. 实现一个扇形
    和三角差不多，增加一个圆角即可。
20. 实现一个宽高自适应的正方形
    高度 vw，宽度百分比
    利用元素的 margin、padding 的百分比相对于父元素的 width
    利用伪元素的 margin-top
