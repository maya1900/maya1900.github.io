---
title: 每日一练leetcode
tags:
  - 算法
categories: js
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/lofislime_1x.png
date: 2023-02-06 22:00:00
---

## 02.06

3. 无重复字符的最长子串

思路：双指针法。右指针不断向前走，寻找右指针的字符在左右指针间出现的位置，一致则说明不存在重复；不一致则移动左指针，位置是寻找到的位置+1，最后返回最大值。

代码：

```js
var lengthOfLongestSubstring = function (s) {
  let l = (r = max = 0);
  while (r < s.length) {
    let index = s.indexOf(s[r], l);
    if (r === index) {
      r++;
      max = Math.max(r - l, max);
    } else {
      l = index + 1;
    }
  }
  return max;
};
```
