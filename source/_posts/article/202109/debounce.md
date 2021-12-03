---
title: 跟着讶佬深入js--防抖
date: 2021-09-16
tags:
- js
- 原型
categories: js
cover: https://z3.ax1x.com/2021/09/19/48dptg.jpg
---

## 防抖

在不断触发情况下，一段时间后才执行

防抖、this、event对象（参数）、是否立即执行、有返回值（在immediate中执行）、可取消

``` javascript
function debounce(func, wait) {
  var timeout;
  return function() {
    clearTimeout(timeout);
    timeout = setTimeout(func, wait);
  }
}
```

``` javascript
function debounce(func, wait) {
  var timeout;
  return function() {
    var context = this;
    clearTimeout(timeout);
    timeout = setTimeout(function() {
      func.apply(context);
    }, wait);
  }
}
```

``` javascript
function debounce(func, wait) {
  var timeout;
  return function() {
    var context = this;
    var args = arguments;
    clearTimeout(timeout);
    timeout = setTimeout(function() {
      func.apply(context, args);
    }, wait);
  }
}
```

``` javascript
function debounce(func, wait, immediate) {
  var timeout;
  return function() {
    var context = this;
    var args = arguments;
    if (timeout) {
      clearTimeout(timeout);
    }
    if (immediate) {
      var callNow = !timeout;
      timeout = setTimeout(() => {
        timeout = null
      }, wait);
      if (callNow) {
        func.apply(context, args);
      }
    } else {
      timeout = setTimeout(() => {
        func.apply(context, args);
      }, wait)
    }
  }
}
```

``` javascript
function debounce(func, wait, immediate) {
  var timeout, result;
  var debounced = function () {
    var context = this;
    var args = arguments;
    if (timeout) {
      clearTimeout(timeout);
    }
    if (immediate) {
      var callNow = !timeout;
      timeout = setTimeout(function() {
        timeout = null
      }, wait);
      if (callNow) {
        result = func.apply(context, args)
      }
    } else {
      timeout = setTimeout(function() {
        func.apply(context, args);
      }, wait)
    }
    return result;
  }
  debounced.cancel = function () {
    clearTimeout(timeout);
    timeout = null;
  }
  return debounced;
}
```
