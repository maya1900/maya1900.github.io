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

## 02.09

[354. 俄罗斯套娃信封问题 - 力扣（Leetcode）](https://leetcode.cn/problems/russian-doll-envelopes/)

思路：

最长递增子数列。先将信封宽度 w 升序排序，如果宽度 w 相同，则高度 h 降序。然后比较 h，循环 len，取出 h，dp 表示最长递增的子序列，和初始 dp 数组最后一个值相比，h 大则直接 push，h 小则二分找出 h 在 dp 里的位置，更新值。最后返回 dp 的长度。

代码：

```jsx
var maxEnvelopes = function (envelopes) {
  const len = envelopes.length;
  if (len <= 1) return len;
  envelopes.sort((a, b) => {
    if (a[0] === b[0]) {
      return b[1] - a[1];
    } else {
      return a[0] - b[0];
    }
  });
  const dp = [envelopes[0][1]];
  for (let i = 0; i < len; i++) {
    const num = envelopes[i][1];
    if (num > dp[dp.length - 1]) {
      dp.push(envelopes[i][1]);
    } else {
      const index = binarySearch(dp, num);
      dp[index] = num;
    }
  }
  return dp.length;
};
const binarySearch = (dp, target) => {
  let left = 0,
    right = dp.length - 1;
  while (left < right) {
    const mid = left + ((right - left) >> 1);
    if (dp[mid] === target) {
      return mid;
    } else if (dp[mid] > target) {
      right = mid;
    } else {
      left = mid + 1;
    }
  }
  return left;
};
let envelopes = [
  [4, 5],
  [4, 6],
  [6, 7],
  [2, 3],
  [1, 1],
];
console.log(maxEnvelopes(envelopes)); // 3
```

## 02.10

[674. 最长连续递增序列 - 力扣（Leetcode）](https://leetcode.cn/problems/longest-continuous-increasing-subsequence/)

思路：滑动窗口。设置左右指针，移动右指针，判断右指针和前一个值的大小，小的话就移动左指针到right位置，记录length长度。

代码：

```jsx
var findLengthOfLCIS = function(nums) {
  if(nums.length < 2) return nums.length;
  // 滑动窗口
  let left = 0, right = 1, len = 1
  while(right < nums.length) {
    if(nums[right] <= nums[right - 1]) {
      left = right
    }
    len = Math.max(len, right - left + 1)
    right++
  }
  return len
}
```

[128. 最长连续序列 - 力扣（Leetcode）](https://leetcode.cn/problems/longest-consecutive-sequence/description/)

思路：Set哈希。使用set去除重复元素；遍历数组，寻找序列起点，当前项-1是否存在于set没有则说明是起点，然后不断在set中查看cur+1是否存在，有则count+1，没有了，就算出了一段连续序列的长度。

代码：

```jsx
var longestConsecutive = (nums) => {
  const set = new Set(nums)
  let max = 0
  for(let i = 0; i < nums.length; i++) {
    if(!set.has(nums[i] - 1)) {
      let cur = nums[i]
      let count = 1
      while(set.has(cur + 1)) {
        cur++
        count++
      }
      max = Math.max(max, count)
    }
  }
  return max
}
```
