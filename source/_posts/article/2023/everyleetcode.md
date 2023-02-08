---
title: 每日一练leetcode
tags:
  - 算法
categories: js
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/lofislime_1x.png
date: 2023-02-06 22:00:00
---

## 02.06

[3. 无重复字符的最长子串 - 力扣（Leetcode）](https://leetcode.cn/problems/longest-substring-without-repeating-characters/)

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

注意：indexOf(searchElement, fromIndex)，第二个参数表示从当前位置开始搜索。

## 02.07

[5. 最长回文子串 - 力扣（Leetcode）](https://leetcode.cn/problems/longest-palindromic-substring/)

思路：回文数。从中间向两边扩散左右数字相同。分奇偶情况，双指针用一个辅助函数来实现。

代码：

```js
var longestPalindrome = function (s) {
  let max = '';
  for (let i = 0; i < s.length; i++) {
    // 分奇偶情况
    helper(i, i);
    helper(i, i + 1);
  }
  function helper(l, r) {
    // 判断回文条件
    while (l >= 0 && r < s.length && s[l] === s[r]) {
      l--;
      r++;
    }
    // while满足条件多执行了一次，因此需要l + 1, r + 1 - 1
    let maxStr = s.slice(l + 1, r + 1 - 1);
    if (maxStr.length > max.length) max = maxStr;
  }
  return max;
};
```

[14. 最长公共前缀 - 力扣（Leetcode）](https://leetcode.cn/problems/longest-common-prefix/)

思路：假设第一个就是公共前缀，循环每个字符串，判断前缀在每个字符串里是否包含，没有就截取掉一个字符继续判断，有就遍历下一个，直到遍历完

代码：

```js
var longestCommonPrefix = function (strs) {
  if (strs == null || strs.length == 0) {
    return '';
  }

  //假设初始最长前缀是第一个字符串
  var results = strs[0];
  for (var i = 0; i < strs.length; i++) {
    while (strs[i].indexOf(results) != 0) {
      results = results.substring(0, results.length - 1);
      if (strs.length == 0) {
        return '';
      }
    }
  }
  return results;
};
```

## 02.08

[76. 最小覆盖子串 - 力扣（Leetcode）](https://leetcode.cn/problems/minimum-window-substring/)

思路：

滑动窗口解题。使用 map 保存 t，右指针在 s 字符串向右移动，包含了 t，窗口就+1，取值和 map 的 value 相等时，计数+1，计数和 map 的 size 相等时获得子串，子串和旧的子串相比小的保存。获得左指针，左指针在 map 里有，再看二者是否相等，相等计数-1，然后窗口-1，左指针+1，再比较计数和 map 的 size，不相等右指针继续向前走。

代码：

```jsx
var minWindow = function (s, t) {
  const need = new Map(),
    window = {};
  for (let c of t) {
    const val = need.has(c) ? need.get(c) + 1 : 1;
    need.set(c, val);
  }
  const needSize = need.size;
  let left = 0,
    right = 0,
    valid = 0,
    res = '';
  while (right < s.length) {
    const c = s[right];
    if (need.has(c)) {
      window[c] ? window[c]++ : (window[c] = 1);
      // 计数等窗口取值和map的value相等时计数
      if (window[c] === need.get(c)) valid++;
    }
    while (valid === needSize) {
      const newRes = s.substring(left, right + 1);
      if (!res || res.length > newRes.length) {
        res = newRes;
      }
      // 移动左指针
      const d = s[left];
      if (need.has(d)) {
        if (window[d] === need.get(d)) valid--;
        window[d]--;
      }
      left++;
    }
    right++;
  }
  return res;
};
```
