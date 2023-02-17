---
title: 每日一练leetcode
tags:
  - 算法
categories: js
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/lofislime_1x.png
date: 2023-02-06 22:00:00
sticky: 2
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

思路：滑动窗口。设置左右指针，移动右指针，判断右指针和前一个值的大小，小的话就移动左指针到 right 位置，记录 length 长度。

代码：

```jsx
var findLengthOfLCIS = function (nums) {
  if (nums.length < 2) return nums.length;
  // 滑动窗口
  let left = 0,
    right = 1,
    len = 1;
  while (right < nums.length) {
    if (nums[right] <= nums[right - 1]) {
      left = right;
    }
    len = Math.max(len, right - left + 1);
    right++;
  }
  return len;
};
```

[128. 最长连续序列 - 力扣（Leetcode）](https://leetcode.cn/problems/longest-consecutive-sequence/description/)

思路：Set 哈希。使用 set 去除重复元素；遍历数组，寻找序列起点，当前项-1 是否存在于 set 没有则说明是起点，然后不断在 set 中查看 cur+1 是否存在，有则 count+1，没有了，就算出了一段连续序列的长度。

代码：

```jsx
var longestConsecutive = (nums) => {
  const set = new Set(nums);
  let max = 0;
  for (let i = 0; i < nums.length; i++) {
    if (!set.has(nums[i] - 1)) {
      let cur = nums[i];
      let count = 1;
      while (set.has(cur + 1)) {
        cur++;
        count++;
      }
      max = Math.max(max, count);
    }
  }
  return max;
};
```

## 02.11

[11. 盛最多水的容器 - 力扣（Leetcode）](https://leetcode.cn/problems/container-with-most-water/description/)

思路：

双指针。左右分别在数组两端，不断逼近中间，计算面积，比前一次大的更新面积值，最后返回。

代码：

```jsx
var maxArea = function (height) {
  let left = 0,
    right = height.length - 1,
    res = 0;
  while (left < right) {
    const curArea = (right - left) * Math.min(height[left], height[right]);
    res = Math.max(res, curArea);
    if (height[left] < height[right]) {
      left++;
    } else {
      right--;
    }
  }
  return res;
};
```

[26. 删除有序数组中的重复项 - 力扣（Leetcode）](https://leetcode.cn/problems/remove-duplicates-from-sorted-array/description/)

思路：

快慢指针。移动右指针，左指针和右指针比较，相等继续移动右指针，不相等，右指针的值赋值给左指针的下一位，返回左指针+1 的长度。

代码：

```jsx
var removeDuplicates = function (nums) {
  let left = (right = 0);
  while (++right < nums.length) {
    if (nums[left] !== nums[right]) {
      nums[++left] = nums[right];
    }
  }
  return left + 1;
};
```

## 02.12

[560. 和为 K 的子数组 - 力扣（Leetcode）](https://leetcode.cn/problems/subarray-sum-equals-k/description/)

思路：

前缀和。理解 nums[0]+…+nums[i] = preSum[i],nums[0]+…+nums[j] = preSum[j],nums[i]+…nums[j] = preSum[j] - preSum[i]，preSum[i] = preSum[j] - k， map 保存累加值，判断之前是否保存过 pre - k，有就计数+1，没有保存 map，最后返回 count。

代码：

```jsx
var subarraySum = function (nums, k) {
  const map = new Map();
  map.set(0, 1);
  let count = 0,
    pre = 0;
  for (const x of nums) {
    pre += x;
    if (map.has(pre - k)) {
      count += map.get(pre - k);
    }
    if (map.has(pre)) {
      map.set(pre, map.get(pre) + 1);
    } else {
      map.set(pre, 1);
    }
  }
  return count;
};
```

## 02.13

[15. 三数之和 - 力扣（Leetcode）15. 三数之和 - 力扣（Leetcode）](https://leetcode.cn/problems/3sum/description/)

思路：

排序+双指针。对数组排序后，遍历数组，如 nums[i] > 0，则后面三数相加不可能等于 0，直接返回结果；重复元素跳过；左指针 i+1,右指针 len-1，左小于右时循环：左指针+右指针+当前数，和大于 0，右指针左移，和小于 0，左指针右移，相等保存解，同时判断左右边界是否和下一位重复，去除重复。

代码：

```jsx
var threeSum = function (nums) {
  let res = [];
  nums.sort((a, b) => a - b);
  for (let i = 0; i < nums.length; i++) {
    let left = i + 1,
      right = nums.length - 1;
    if (nums[i] > 0) {
      return res;
    }
    if (i > 0 && nums[i - 1] === nums[i]) {
      continue;
    }
    while (left < right) {
      const sum = nums[i] + nums[left] + nums[right];
      if (sum < 0) {
        left++;
      } else if (sum > 0) {
        right--;
      } else {
        res.push([nums[i], nums[left], nums[right]]);
        while (left < right && nums[left] == nums[left + 1]) {
          left++;
        }
        while (left < right && nums[right - 1] == nums[right]) {
          right--;
        }
        left++;
        right--;
      }
    }
  }
  return res;
};
```

## 02.14

[55. 跳跃游戏 - 力扣（Leetcode）](https://leetcode.cn/problems/jump-game/description/)

思路：

贪心。遍历所有位置，更新能走到的最远位置，如果最后一个位置超过或者刚好到达最后一个下标，返回 true，否则 false。

代码：

```jsx
var canJump = function (nums) {
  const len = nums.length - 1;
  let step = 0;
  for (let i = 0; i <= len; i++) {
    if (i <= step) {
      step = Math.max(step, i + nums[i]);
      if (step >= len) {
        return true;
      }
    }
  }
  return false;
};
```

[45. 跳跃游戏 II - 力扣（Leetcode）](https://leetcode.cn/problems/jump-game-ii/description/)

思路：

还是贪心，max 表示能跳的最远距离，end 表示能跳的最远位置，steps 表示步数，遍历如果 i 等于 end，那么更新 end，steps+1，最后返回 steps，最后一个下标不走，所以不遍历最后一个下标。

代码：

```jsx
var jump = function (nums) {
  let max = 0,
    end = 0,
    steps = 0;
  for (let i = 0; i < nums.length - 1; i++) {
    max = Math.max(nums[i] + i, max);
    if (i === end) {
      end = max;
      steps++;
    }
  }
  return steps;
};
```

## 02.15

[234. 回文链表 - 力扣（Leetcode）](https://leetcode.cn/problems/palindrome-linked-list/description/)

思路一：

链表后续遍历，函数调用作为后续遍历来判断是否回文。

`res = (res && (right.val === left.val))`注意

代码：

```jsx
var isPalindrome = function (head) {
  let left = head;
  function traverse(right) {
    if (right == null) return true;
    let res = traverse(right.next);
    res = res && right.val === left.val;
    left = left.next;
    return res;
  }
  return traverse(head);
};
```

思路二：

快慢指针找中间点，然后反转链表比较两个链表是否相等来判断。

代码：

```jsx
var isPalindrome = function (head) {
  let right = reverse(findCenter(head));
  let left = head;
  while (right != null) {
    if (left.val !== right.val) {
      return false;
    }
    left = left.next;
    right = right.next;
  }
  return true;
};
function findCenter(head) {
  let slow = head,
    fast = head;
  while (fast && fast.next != null) {
    slow = slow.next;
    fast = fast.next.next;
  }
  // 如果fast不等于null，说明是奇数
  if (fast != null) {
    slow = slow.next;
  }
  return slow;
}
function reverse(head) {
  let prev = null,
    cur = head,
    next = head;
  while (cur != null) {
    next = cur.next;
    cur.next = prev;
    prev = cur;
    cur = next;
  }
  return prev;
}
```

[206. 反转链表 - 力扣（Leetcode）](https://leetcode.cn/problems/reverse-linked-list/)

思路：

除了利用前面的遍历，也可以利用下面的递归

代码：

```jsx
var reverseList = function (head) {
  if (head == null || head.next == null) return head;
  const last = reverseList(head.next);
  head.next.next = head;
  head.next = null;
  return last;
};
```

[141. 环形链表 - 力扣（Leetcode）](https://leetcode.cn/problems/linked-list-cycle/)

思路：

快慢指针。当快指针和慢指针相等时，说明有环形链表。

代码：

```jsx
var hasCycle = function (head) {
  let slow = head,
    fast = head;
  while (fast != null && fast.next != null) {
    slow = slow.next;
    fast = fast.next.next;
    if (slow == fast) {
      return true;
    }
  }
  return false;
};
```

## 02.16

[23. 合并 K 个升序链表 - 力扣（Leetcode）](https://leetcode.cn/problems/merge-k-sorted-lists/description/)

思路：

分治。自低而上归并，第一次合并 2 个链表，第二次归并 4 个链表，不断合并直到合并完所有分治的链表。

代码：

```jsx
var mergeKLists = function (lists) {
  if (lists.length == 0) return null;
  return mergeArr(lists);
};
function mergeArr(lists) {
  if (lists.length <= 1) return lists[0];
  let index = Math.floor(lists.length / 2);
  const left = mergeArr(lists.slice(0, index));
  const right = mergeArr(lists.slice(index));
  return mergeArr(left, right);
}
function merge(l, r) {
  if (l == null && r == null) return null;
  if (l == null && r != null) return r;
  if (l != null && r == null) return l;
  let newHead = null,
    head = null;
  while (l != null && r != null) {
    if (l.val < r.val) {
      if (!head) {
        newHead = l;
        head = l;
      } else {
        newHead.next = l;
        newHead = newHead.next;
      }
      l = l.next;
    } else {
      if (!head) {
        newHead = r;
        head = r;
      } else {
        newHead.next = r;
        newHead = newHead.next;
      }
      r = r.next;
    }
  }
  newHead.next = l ? l : r;
  return head;
}
```

[25. K 个一组翻转链表 - 力扣（Leetcode）](https://leetcode.cn/problems/reverse-nodes-in-k-group/)

给你链表的头节点  `head`，每  `k` \*\*个节点一组进行翻转，请你返回修改后的链表。

思路：

递归。每两组反转一次链表，直到最后完成。

代码：

```jsx
var reverseKGroup = function (head, k) {
  let a = (b = head);
  for (let i = 0; i < k; i++) {
    if (b == null) return head;
    b = b.next;
  }
  const newHead = reverse(a, b);
  a.next = reverseKGroup(b, k);
  return newHead;
};
function reverse(a, b) {
  let prev = null,
    cur = (next = a);
  while (cur != b) {
    next = cur.next;
    cur.next = prev;
    prev = cur;
    cur = next;
  }
  return prev;
}
```

## 02.17

[148. 排序链表 - 力扣（Leetcode）](https://leetcode.cn/problems/sort-list/description/)

给你链表的头结点  `head`，请将其按  **升序**排列并返回  **排序后的链表**。

思路：

自顶而下，归并。不断分割到每个区间只有一个节点位置，然后开始合并。

代码：

```jsx
var sortList = function (head) {
  return toSortList(head, null);
};
function toSortList(head, tail) {
  if (head == null) {
    return head;
  }
  if (head.next == tail) {
    head.next = null;
    return head;
  }
  let slow = head,
    fast = head;
  while (fast != tail) {
    slow = slow.next;
    fast = fast.next;
    if (fast != tail) {
      fast = fast.next;
    }
  }
  const mid = slow;
  return merge(toSortList(head, mid), toSortList(mid, tail));
}
function merge(h1, h2) {
  const dummy = new ListNode();
  let head = dummy;
  while ((h1 != null) & (h2 != null)) {
    if (h1.val <= h2.val) {
      head.next = h1;
      h1 = h1.next;
    } else {
      head.next = h2;
      h2 = h2.next;
    }
    head = head.next;
  }
  if (h1 != null) {
    head.next = h1;
  }
  if (h2 != null) {
    head.next = h2;
  }
  return dummy.next;
}
```

[160. 相交链表 - 力扣（Leetcode）](https://leetcode.cn/problems/intersection-of-two-linked-lists/description/)

给你两个单链表的头节点  `headA`和  `headB`，请你找出并返回两个单链表相交的起始节点。如果两个链表不存在相交节点，返回  `null`。

思路：

判断是否相交，不相交一直后移。

代码：

```jsx
var getIntersectionNode = function (headA, headB) {
  if (!headA || !headB) return null;
  let p1 = headA,
    p2 = headB;
  while (p1 != p2) {
    p1 = p1 == null ? headB : p1.next;
    p2 = p2 == null ? headA : p2.next;
  }
  return p1;
};
```
