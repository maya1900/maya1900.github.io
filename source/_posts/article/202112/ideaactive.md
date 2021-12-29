---
title: idea2021.3激活教程
date: 2021-12-25
tags:
  - idea
categories: 其他 
cover: https://s4.ax1x.com/2021/12/29/TgxpGV.jpg
---

## idea2021.3激活教程

无需激活码，激活至5000年！！

插件地址：

> 链接：https://pan.baidu.com/s/1c-BaKu6W-cFxv_2rtMet8g
> 提取码：3xc7

### 简单：

1. 登录Jetbrains账号，点击试用
2. 设置-- 编辑自定义VM选项
3. 完成！

### 详细：

1. 登录Jetbrains账号，点击试用

2. 设置-- 编辑自定义VM选项(Edit Custom VM Options...)

   ```java
   -javaagent:D:\\Program Files\\JetBrains\\IntelliJ IDEA 2021.3\\ja-netfilter\\ja-netfilter.jar
   ```

3. 编写janf_config.txt,放在ja-netfilter的同级目录

   ```java
   [DNS]
   EQUAL,jetbrains.com
   
   [URL]
   PREFIX,https://account.jetbrains.com/lservice/rpc/validateKey.action
   
   [MyMap]
   EQUAL,licenseeName->zhile
   EQUAL,gracePeriodDays->30
   EQUAL,paidUpTo->5000-12-31
   ```

4. 添加mymap-v1.0.1.jar

5. 完成