---
title: 每日一练leetcode
tags:
  - 算法
categories: js
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/lofislime_1x.png
date: 2023-02-06 22:00:00
sticky: 1
---

## 04.01

[剑指 Offer 55 - I. 二叉树的深度 - 力扣（Leetcode）](https://leetcode.cn/problems/er-cha-shu-de-shen-du-lcof/description/)

思路：

1. 回溯。遍历二叉树，前序遍历depth加1，遍历过程记录最大深度，后续遍历depth减1
2. 动态规划。输入一个节点，返回该节点的最大深度，根据左右子树最大深度推断原二叉树最大深度。

代码：

```jsx
var maxDepth = function (root) {
  if (root == null) {
    return 0
  }
  let left = maxDepth(root.left)
  let right = maxDepth(root.right)
  return 1 + Math.max(left, right)
}

var maxDepth = function (root) {
  let depth = 0
  let res = 0
  traverse(root)
  return res

  function traverse(root) {
    if (root == null) {
      return
    }
    depth++
    res = Math.max(res, depth)
    traverse(root.left)
    traverse(root.right)
    depth--
  }
}
```

## 03.31

[234. 回文链表 - 力扣（Leetcode）](https://leetcode.cn/problems/palindrome-linked-list/)

思路：递归

代码：

```jsx
var isPalindrome = function(head) {
    let left = head
    function traverse(right) {
        if (right == null) return true
        let res = traverse(right.next)
        res = res && (right.val === left.val)
        left = left.next
        return res
    }
    return traverse(head)
};
```

## 03.30

[206. 反转链表 - 力扣（Leetcode）](https://leetcode.cn/problems/reverse-linked-list/)

代码：

```jsx
var reverseList = function(head) {
  let pre = null;
  let cur = head;
  while (cur != null) {
    // [cur.next, pre, cur] = [pre, cur, cur.next];
    const next = cur.next;
    cur.next = pre;
    pre = cur;
    cur = next;
  }
  return pre;
};
var reverseList = function(head) {
    if (head == null || head.next == null) return head;
    const last = reverseList(head.next)
    head.next.next = head
    head.next = null
    return last
};
```

## 03.29

[148. 排序链表 - 力扣（Leetcode）](https://leetcode.cn/problems/sort-list/)

思路：

自顶向下的归并。先归并再排序。

代码：

```jsx
var sortList = function(head) {
  return toSortList(head, null)
}
function toSortList(head, tail) {
  if(head == null) {
    return head
  }
  if(head.next == tail){
    head.next = null
    return head
  }
  let slow = head, fast = head
  while(fast != tail) {
    slow = slow.next
    fast = fast.next
    if(fast != tail) {
      fast = fast.next
    }
  }
  const mid = slow
  return merge(toSortList(head, mid), toSortList(mid, tail))
}
function merge(h1, h2) {
  const dummy = new ListNode()
  let head = dummy
  while(h1 != null & h2 != null) {
    if(h1.val <= h2.val) {
      head.next = h1
      h1 = h1.next
    } else {
      head.next = h2
      h2 = h2.next
    }
    head = head.next
  }
  if(h1 != null) {
    head.next = h1
  }
  if(h2 != null) {
    head.next = h2
  }
  return dummy.next
}
```

## 03.28

[143. 重排链表 - 力扣（Leetcode）](https://leetcode.cn/problems/reorder-list/description/)

思路：

使用数组先存储节点，然后在进行排列。

代码：

```jsx
var reorderList = function (head) {
  if (head == null) return head;
  let queue = [];
  let p = head;
  while (p) {
    queue.push(p);
    p = p.next;
  }
  while (queue.length > 2) {
    let h = queue.shift();
    let t = queue.pop();
    t.next = h.next;
    h.next = t;
  }
  queue[queue.length - 1].next = null;
  return head;
};
```

## 03.27

[142. 环形链表 II - 力扣（Leetcode）](https://leetcode.cn/problems/linked-list-cycle-ii/)

思路：

快慢指针相遇后，将慢指针重新指向头节点走到相交点就是环起点。

代码：

```jsx
var detectCycle = function (head) {
  let fast = head,
    slow = head;
  while (fast != null && fast.next != null) {
    fast = fast.next.next;
    slow = slow.next;
    if (fast == slow) {
      break;
    }
  }
  if (fast == null || fast.next == null) {
    return null;
  }
  slow = head;
  while (slow != fast) {
    fast = fast.next;
    slow = slow.next;
  }
  return slow;
};
```

## 03.26

[141. 环形链表 - 力扣（Leetcode）](https://leetcode.cn/problems/linked-list-cycle/)

思路：判断环形，快指针走两步，慢指针走一步，然后判断有么有相遇。

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

## 03.25

[86. 分隔链表 - 力扣（Leetcode）](https://leetcode.cn/problems/partition-list/description/)

代码：

```jsx
var partition = function (head, x) {
  let dummy1 = new ListNode();
  let dummy2 = new ListNode();
  let p1 = dummy1,
    p2 = dummy2;
  p = head;
  while (p != null) {
    if (p.val >= x) {
      p2.next = p;
      p2 = p2.next;
    } else {
      p1.next = p;
      p1 = p1.next;
    }
    let tmp = p.next;
    p.next = null;
    p = tmp;
  }
  p1.next = dummy2.next;
  return dummy1.next;
};
```

## 03.24

[92. 反转链表 II - 力扣（Leetcode）](https://leetcode.cn/problems/reverse-linked-list-ii/)

代码：

```jsx
var reverseBetween = function (head, left, right) {
  // 因为头节点有可能发生变化，使用虚拟头节点可以避免复杂的分类讨论
  const dummyNode = new ListNode(-1);
  dummyNode.next = head;

  let pre = dummyNode;
  // 第 1 步：从虚拟头节点走 left - 1 步，来到 left 节点的前一个节点
  // 建议写在 for 循环里，语义清晰
  for (let i = 0; i < left - 1; i++) {
    pre = pre.next;
  }

  // 第 2 步：从 pre 再走 right - left + 1 步，来到 right 节点
  let rightNode = pre;
  for (let i = 0; i < right - left + 1; i++) {
    rightNode = rightNode.next;
  }

  // 第 3 步：切断出一个子链表（截取链表）
  let leftNode = pre.next;
  let curr = rightNode.next;

  // 注意：切断链接
  pre.next = null;
  rightNode.next = null;

  // 第 4 步：同第 206 题，反转链表的子区间
  reverseLinkedList(leftNode);

  // 第 5 步：接回到原来的链表中
  pre.next = rightNode;
  leftNode.next = curr;
  return dummyNode.next;
};

const reverseLinkedList = (head) => {
  let pre = null;
  let cur = head;

  while (cur) {
    const next = cur.next;
    cur.next = pre;
    pre = cur;
    cur = next;
  }
};
```

## 03.23

[138. 复制带随机指针的链表 - 力扣（Leetcode）](https://leetcode.cn/problems/copy-list-with-random-pointer/description/)

代码：

```jsx
var copyRandomList = function (head) {
  const originToClone = new Map();

  // 第一次遍历，先把所有节点克隆出来
  for (let p = head; p !== null; p = p.next) {
    if (!originToClone.has(p)) {
      originToClone.set(p, new Node(p.val));
    }
  }

  // 第二次遍历，把克隆节点的结构连接好
  for (let p = head; p !== null; p = p.next) {
    if (p.next !== null) {
      originToClone.get(p).next = originToClone.get(p.next);
    }
    if (p.random !== null) {
      originToClone.get(p).random = originToClone.get(p.random);
    }
  }

  // 返回克隆之后的头结点
  return originToClone.get(head);
};
```

## 03.22

复习：[21. 合并两个有序链表 - 力扣（Leetcode）](https://leetcode.cn/problems/merge-two-sorted-lists/description/)

思路：

双指针+虚拟头节点。

代码：

```jsx
var mergeTwoLists = function (list1, list2) {
  const dummy = new ListNode();
  let p = dummy;
  while (list1 != null && list2 != null) {
    if (list1.val > list2.val) {
      p.next = list2;
      list2 = list2.next;
    } else {
      p.next = list1;
      list1 = list1.next;
    }
    p = p.next;
  }
  if (list1 != null) {
    p.next = list1;
  }
  if (list2 != null) {
    p.next = list2;
  }
  return dummy.next;
};
```

## 03.21

[82. 删除排序链表中的重复元素 II - 力扣（Leetcode）](https://leetcode.cn/problems/remove-duplicates-from-sorted-list-ii/)

思路：需要删掉重复元素，则要判断 next 和 next.next 是否相等，将所有相同的 next.next 删除，cur 就可以指向 next。

代码：

```jsx
var deleteDuplicates = function (head) {
  if (!head) {
    return head;
  }
  const dummy = new ListNode(0, head);
  let cur = dummy;
  while (cur.next && cur.next.next) {
    if (cur.next.val === cur.next.next.val) {
      const x = cur.next.val;
      while (cur.next && cur.next.val == x) {
        cur.next = cur.next.next;
      }
    } else {
      cur = cur.next;
    }
  }
  return dummy.next;
};
```

## 03.20

[83. 删除排序链表中的重复元素 - 力扣（Leetcode）](https://leetcode.cn/problems/remove-duplicates-from-sorted-list/)

思路：和上道题相似，只是不需要做 next.next 的处理

代码：

```jsx
var deleteDuplicates = function (head) {
  if (!head) {
    return head;
  }
  let cur = head;
  while (cur.next) {
    if (cur.val == cur.next.val) {
      cur.next = cur.next.next;
    } else {
      cur = cur.next;
    }
  }
  return head;
};
```

## 03.19

复习：[1143. 最长公共子序列 - 力扣（Leetcode）](https://leetcode.cn/problems/longest-common-subsequence/)

思路：动态规划。

代码：

```jsx
var longestCommonSubsequence = function (text1, text2) {
  const m = text1.length,
    n = text2.length;
  const dp = new Array(m + 1).fill(0).map(() => new Array(n + 1).fill(0));
  for (let i = 1; i <= m; i++) {
    const c1 = text1[i - 1];
    for (let j = 1; j <= n; j++) {
      const c2 = text2[j - 1];
      if (c1 === c2) {
        dp[i][j] = dp[i - 1][j - 1] + 1;
      } else {
        dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
      }
    }
  }
  return dp[m][n];
};
```

## 03.18

[17. 电话号码的字母组合 - 力扣（Leetcode）](https://leetcode.cn/problems/letter-combinations-of-a-phone-number/description/)

思路：

回溯。

代码：

```jsx
var letterCombinations = function (digits) {
  const res = [];
  const keys = [
    '',
    '',
    'abc',
    'def',
    'ghi',
    'jkl',
    'mno',
    'pqrs',
    'tuv',
    'wxyz',
  ];
  if (digits.length) {
    backtrack(0, []);
  }
  return res;

  function backtrack(start, track) {
    if (track.length === digits.length) {
      res.push(track.join(''));
      return;
    }
    for (let i = start; i < digits.length; i++) {
      const digit = digits.charAt(i) - '0';
      for (const c of keys[digit]) {
        track.push(c);
        backtrack(i + 1, track);
        track.pop();
      }
    }
  }
};
```

## 03.17

复习：[11. 盛最多水的容器 - 力扣（Leetcode）](https://leetcode.cn/problems/container-with-most-water/description/)

思路：贪心

代码：

```jsx
var maxArea = function (height) {
  let max = 0;
  let left = 0,
    right = height.length - 1;
  while (left < right) {
    max = Math.max(max, (right - left) * Math.min(height[right], height[left]));
    if (height[right] < height[left]) {
      right--;
    } else {
      left++;
    }
  }
  return max;
};
```

## 03.16

[93. 复原 IP 地址 - 力扣（Leetcode）](https://leetcode.cn/problems/restore-ip-addresses/)

思路：

代码：

```jsx
var restoreIpAddresses = function (s) {
  const res = [];
  const track = [];

  function backtrack(s, start) {
    if (start === s.length && track.length === 4) {
      res.push(track.join('.'));
    }
    for (let i = start; i < s.length; i++) {
      if (!isValid(s, start, i)) {
        continue;
      }
      if (track.length >= 4) {
        break;
      }
      track.push(s.substring(start, i + 1));
      backtrack(s, i + 1);
      track.pop();
    }
  }
  function isValid(s, start, end) {
    const length = end - start + 1;
    if (length === 0 || length > 3) {
      return false;
    }
    // 只有一位，合法
    if (length === 1) {
      return true;
    }
    // 多于1位，但开头是0，不合法
    if (s.charAt(start) === '0') {
      return false;
    }
    // 开头不是0,1-2是合法的
    if (length <= 2) {
      return true;
    }
    // 三位数不可能大于255
    if (parseInt(s.substring(start, start + length)) > 255) {
      return false;
    } else {
      return true;
    }
  }

  backtrack(s, 0);
  return res;
};

console.log(restoreIpAddresses('25525511135'));
```

## 03.15

[78. 子集 - 力扣（Leetcode）](https://leetcode.cn/problems/subsets/description/)

思路：

递归函数参数：start

递归终止条件：start 大于数组长度

单层搜索逻辑：遍历整个树

代码：

```jsx
var subsets = function (nums) {
  const res = [];
  const track = [];
  backtrack(nums, 0, track);
  return res;
  function backtrack(nums, start, track) {
    res.push([...track]);
    for (let i = start; i < nums.length; i++) {
      track.push(nums[i]);
      backtrack(nums, i + 1, track);
      track.pop();
    }
  }
};
```

## 03.14

[22. 括号生成 - 力扣（Leetcode）](https://leetcode.cn/problems/generate-parentheses/)

思路：

回溯算法。左括号数量一定等于右括号数量。回溯算法的核心在于选择，递归，撤销选择。

代码：

```jsx
var generateParenthesis = function (n) {
  if (n === 0) return [];
  // 记录所有组合
  const res = [];
  // 过程中的路径
  let track = '';
  // 可用的左括号和右括号数量初始化为n
  backtrack(n, n, track, res);
  return res;
};
function backtrack(left, right, track, res) {
  // 左右不相等或者小于0，说明不合法
  if (right < left) return;
  if (left < 0 || right < 0) return;
  // 左右刚好用完得到一个合法的括号组合
  if (left == 0 && right == 0) {
    res.push(track);
    return;
  }
  // 尝试放一个左括号
  track += '('; // 选择
  backtrack(left - 1, right, track, res);
  track = track.slice(0, -1); // 撤销选择

  track += ')';
  backtrack(left, right - 1, track, res);
  track = track.slice(0, -1);
}
```

[51. N 皇后 - 力扣（Leetcode）](https://leetcode.cn/problems/n-queens/)

思路：

回溯。

框架：

```jsx
result = []
def backtrack(路径，选择列表):
    if 满足结束条件:
        result.add(路径)
        return

    for 选择 in 选择列表:
        做选择
        backtrack(路径，选择列表)
        撤销选择
# 详细解析参见：
# https://labuladong.github.io/article/?qno=
```

代码：

```jsx
var solveNQueens = function (n) {
  var res = [];
  var board = new Array(n);
  for (var i = 0; i < n; i++) {
    board[i] = new Array(n).fill('.');
  }
  backtrack(board, 0);
  return res;

  function backtrack(board, row) {
    // 结束条件: 行等于board的长度
    if (row == board.length) {
      res.push(Array.from(board, (row) => row.join('')));
      return;
    }

    var n = board.length;
    for (var col = 0; col < n; col++) {
      if (!isValid(board, row, col)) {
        continue;
      }
      board[row][col] = 'Q';
      backtrack(board, row + 1);
      board[row][col] = '.';
    }
  }

  function isValid(board, row, col) {
    var n = board.length;
    // 检查列是否有冲突
    for (var i = 0; i <= row; i++) {
      if (board[i][col] === 'Q') {
        return false;
      }
    }
    // 检查右上方是否有冲突
    for (var i = row - 1, j = col + 1; i >= 0 && j < n; i--, j++) {
      if (board[i][j] === 'Q') {
        return false;
      }
    }
    // 检查左上方是否有冲突
    for (var i = row - 1, j = col - 1; (i >= 0) & (j >= 0); i--, j--) {
      if (board[i][j] === 'Q') {
        return false;
      }
    }
    return true;
  }
};
```

## 03.13

[46. 全排列 - 力扣（Leetcode）](https://leetcode.cn/problems/permutations/)

思路：

回溯算法。1 递归函数参数，2 递归终止条件，3 单层搜索逻辑

代码：

```jsx
var permute = function (nums) {
  const res = [],
    path = [];
  backtracking(nums, nums.length, []);
  return res;
  function backtracking(n, k, used) {
    if (path.length === k) {
      res.push(Array.from(path));
      return;
    }
    for (let i = 0; i < k; i++) {
      if (used[i]) continue;
      path.push(n[i]);
      used[i] = true;
      backtracking(n, k, used);
      path.pop();
      used[i] = false;
    }
  }
};
console.log(permute([1, 2, 3]));
```

## 03.12

[100. 相同的树 - 力扣（Leetcode）](https://leetcode.cn/problems/same-tree/description/)

思路：

深度遍历。

代码：

```jsx
var isSameTree = function (p, q) {
  if (p == null && q == null) return true;
  if (p == null || q == null) return false;
  if (p.val != q.val) return false;
  return isSameTree(p.left, q.left) && isSameTree(p.right, q.right);
};
```

## 03.11

[695. 岛屿的最大面积 - 力扣（Leetcode）](https://leetcode.cn/problems/max-area-of-island/description/)

思路：

递归。找到面积是 1 的，将小岛沉没，变为 0，初始化计数为 1，向上下左右递归寻找小岛，返回面积。

代码：

```jsx
var maxAreaOfIsland = function (grid) {
  let result = 0;
  for (let i = 0; i < grid.length; i++) {
    for (let j = 0; j < grid[0].length; j++) {
      if (grid[i][j] === 1) {
        const count = dfs(i, j);
        result = Math.max(count, result);
      }
    }
  }
  function dfs(i, j) {
    if (
      i < 0 ||
      i >= grid.length ||
      j < 0 ||
      j >= grid[0].length ||
      grid[i][j] === 0
    )
      return 0;
    grid[i][j] = 0;
    let count = 1;
    count += dfs(i + 1, j);
    count += dfs(i - 1, j);
    count += dfs(i, j + 1);
    count += dfs(i, j - 1);
    return count;
  }
  return result;
};
```

## 03.10

[71. 简化路径 - 力扣（Leetcode）](https://leetcode.cn/problems/simplify-path/description/)

思路：

按"/"将输入切分，遇到空字符、'.'跳过，遇到'..'将上一次加入的路径名弹出，其他加入路径名，最后用"/"连接。

代码：

```jsx
var simplifyPath = function (path) {
  const res = [];
  for (const s of path.split('/')) {
    if (s != '' && s != '.' && s != '..') {
      res.push(s);
    } else if (s == '..' && res.length > 0) {
      res.pop();
    }
  }
  return '/' + res.join('/');
};
```

## 03.09

[20. 有效的括号 - 力扣（Leetcode）](https://leetcode.cn/problems/valid-parentheses/description/)

思路：

map 匹配。

代码：

```jsx
var isValid = function (s) {
  const map = new Map();
  map.set('(', ')');
  map.set('{', '}');
  map.set('[', ']');
  const stack = [];
  for (let i = 0; i < s.length; i++) {
    if (['(', '{', '['].includes(s[i])) {
      stack.push(s[i]);
    } else if (s[i] === map.get(stack[stack.length - 1])) {
      stack.pop();
    } else {
      return false;
    }
  }
  return stack.length ? false : true;
};
```

## 03.08

[496. 下一个更大元素 I - 力扣（Leetcode）](https://leetcode.cn/problems/next-greater-element-i/description/)

思路：

单调栈+哈希表

代码：

```jsx
var nextGreaterElement = function (nums1, nums2) {
  const map = new Map();
  const stack = [];
  for (let i = nums2.length - 1; i >= 0; i--) {
    const num = nums2[i];
    while (stack.length && num >= stack[stack.length - 1]) {
      stack.pop();
    }
    map.set(num, stack.length ? stack[stack.length - 1] : -1);
    stack.push(num);
  }
  return new Array(nums1.length).fill(0).map((_, i) => map.get(nums1[i]));
};
```

## 03.07

[111. 二叉树的最小深度 - 力扣（Leetcode）](https://leetcode.cn/problems/minimum-depth-of-binary-tree/description/)

思路：

深度搜索与广度搜索。

深度在于递归，广度在于循环。

代码：

```jsx
var minDepth = function (root) {
  // if (root == null) return 0
  // if (root.left == null) {
  //   return minDepth(root.right) + 1
  // } else if (root.right == null) {
  //   return minDepth(root.left) + 1
  // } else {
  //   return Math.min(minDepth(root.left), minDepth(root.right)) + 1
  // }
  const pre = [];
  if (root == null) return 0;
  pre.push(root);
  let depth = 0;
  while (pre.length != 0) {
    depth++;
    for (let i = 0; i < pre.length; i++) {
      const cur = pre.shift();
      if (cur.left) pre.push(cur.elft);
      if (cur.right) pre.push(cur.right);
      if (cur.left == null && cur.right == null) return depth;
    }
  }
  return depth;
};
```

## 03.06

[122. 买卖股票的最佳时机 II - 力扣（Leetcode）](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock-ii/)

思路：

只需要计算出当前项减去前一项是否为正数，累加即可。计算的过程并不是交易的过程。

代码：

```jsx
var maxProfit = function (prices) {
  let res = 0;
  for (let i = 1; i < prices.length; i++) {
    res += Math.max(0, prices[i] - prices[i - 1]);
  }
  return res;
};
```

## 03.05

[121. 买卖股票的最佳时机 - 力扣（Leetcode）](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock/description/)

思路：

一次遍历，前一个比后一个大则从最小开始；前一个减去最小的大于最大利润，则赋值给最大利润。

代码：

```jsx
var maxProfit = function (prices) {
  let res = 0,
    min = prices[0];
  for (let i = 1; i < prices.length; i++) {
    if (prices[i] < min) {
      min = prices[i];
    } else if (prices[i] - min > res) {
      res = prices[i] - min;
    }
  }
  return res;
};
```

## 03.04

[53. 最大子数组和 - 力扣（Leetcode）](https://leetcode.cn/problems/maximum-subarray/)

思路：

dp[i]：包括下标 i 之前的最大连续子序列和为 dp[i]

dp[i - 1] + nums[i]，nums[i]加入当前连续子序列和，

nums[i]，从头开始计算当前连续子序列和

dp[i] = max(dp[i - 1] + nums[i], nums[i])

代码：

```jsx
const maxSubArray = function (nums) {
  const len = nums.length,
    dp = [nums[0]];
  let max = dp[0];
  for (let i = 1; i < len; i++) {
    dp[i] = Math.max(dp[i - 1] + nums[i], nums[i]);
    max = Math.max(max, dp[i]);
  }
  return max;
};
```

## 03.03

[516. 最长回文子序列 - 力扣（Leetcode）](https://leetcode.cn/problems/longest-palindromic-subsequence/)

思路：

动态规划。

dp[i][j]：字符串 s 在[i, j]范围内最长的回文子序列的长度为 dp[i][j]

如果 s[i]与 s[j]相同，那么 dp[i][j] = dp[i + 1][j - 1] + 2

如果 s[i]与 s[j]不相同，

加入 s[j]的回文子序列长度为 dp[i + 1][j]。

加入 s[i]的回文子序列长度为 dp[i][j - 1]。

那么 dp[i][j]一定是取最大的，即：dp[i][j] = max(dp[i + 1][j], dp[i][j - 1]);

递推公式是计算不到 i 和 j 相同时候的情况，当 i 与 j 相同，那么 dp[i][j]一定是等于 1，其他情况 dp[i][j]初始为 0 就行。

dp[i][j]是依赖于 dp[i + 1][j - 1] 和 dp[i + 1][j]，遍历 i 的时候一定要从下到上遍历，这样才能保证，下一行的数据是经过计算的

代码：

```jsx
var longestPalindromeSubseq = function (s) {
  const len = s.length;
  const dp = new Array(len).fill(0).map(() => new Array(len).fill(0));
  for (let i = len - 1; i >= 0; i--) {
    dp[i][i] = 1;
    for (let j = i + 1; j < len; j++) {
      if (s[i] === s[j]) {
        dp[i][j] = dp[i + 1][j - 1] + 2;
      } else {
        dp[i][j] = Math.max(dp[i + 1][j], dp[i][j - 1]);
      }
    }
  }
  return dp[0][len - 1];
};
```

## 03.02

[72. 编辑距离 - 力扣（Leetcode）](https://leetcode.cn/problems/edit-distance/description/)

思路：

动态规划。

dp[i][j] 表示以下标 i-1 为结尾的字符串 word1，和以下标 j-1 为结尾的字符串 word2，最近编辑距离为 dp[i][j]。

if (word1[i - 1] == word2[j - 1])不操作
if (word1[i - 1] != word2[j - 1])增删换

dp[i][0]对 word1 里的元素全部做删除操作，即：dp[i][0] = i;同理 dp[0][j] = j;

dp[i][j]是依赖左方，上方和左上方元素的，矩阵中一定是从左到右从上到下去遍历

代码：

```jsx
const minDistance = (word1, word2) => {
  let dp = Array.from(new Array(word1.length + 1), () =>
    new Array(word2.length + 1).fill(0)
  );
  for (let i = 1; i <= word1.length; i++) {
    dp[i][0] = i;
  }
  for (let j = 1; j <= word2.length; j++) {
    dp[0][j] = j;
  }
  for (let i = 1; i <= word1.length; i++) {
    for (let j = 1; j <= word2.length; j++) {
      if (word1[i - 1] === word2[j - 1]) {
        dp[i][j] = dp[i - 1][j - 1];
      } else {
        dp[i][j] = Math.min(
          dp[i - 1][j] + 1,
          dp[i][j - 1] + 1,
          dp[i - 1][j - 1] + 1
        );
      }
    }
  }
  return dp[word1.length][word2.length];
};
```

## 03.01

[1143. 最长公共子序列 - 力扣（Leetcode）](https://leetcode.cn/problems/longest-common-subsequence/)

思路：

动态规划。

dp[i][j]：长度为[0, i - 1]的字符串 text1 与长度为[0, j - 1]的字符串 text2 的最长公共子序列为 dp[i][j]。

如果 text1[i - 1] 与 text2[j - 1]相同，那么找到了一个公共元素，所以 dp[i][j] = dp[i - 1][j - 1] + 1;

如果 text1[i - 1] 与 text2[j - 1]不相同，那就看看 text1[0, i - 2]与 text2[0, j - 1]的最长公共子序列 和 text1[0, i - 1]与 text2[0, j - 2]的最长公共子序列，取最大的。

代码：

```jsx
var longestCommonSubsequence = function (text1, text2) {
  const m = text1.length,
    n = text2.length;
  const dp = new Array(m + 1).fill(0).map(() => new Array(n + 1).fill(0));
  for (let i = 1; i <= m; i++) {
    const c1 = text1[i - 1];
    for (let j = 1; j <= n; j++) {
      const c2 = text2[j - 1];
      if (c1 === c2) {
        dp[i][j] = dp[i - 1][j - 1] + 1;
      } else {
        dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
      }
    }
  }
  return dp[m][n];
};
```

## 02.28

[322. 零钱兑换 - 力扣（Leetcode）](https://leetcode.cn/problems/coin-change/)

给你一个整数数组  `coins`，表示不同面额的硬币；以及一个整数  `amount`，表示总金额。

思路：

动态规划。

dp[j]：凑足总额为 j 所需铅笔的最少个数是 dp[j]

凑足总额为 j - coins[i]的最少个数为 dp[j - coins[i]]，那么只需要加上一个钱币 coins[i]即 dp[j - coins[i]] + 1 就是 dp[j]（最少个数就加 1）

dp 初始化个数一定是 0

遍历顺序：外层 for 循环遍历物品，内层 for 遍历背包或者外层 for 遍历背包，内层 for 循环遍历物品都是可以的

举例推导数组。

代码：

```jsx
var coinChange = (coins, amount) => {
  if (!amount) {
    return 0;
  }
  const dp = new Array(amount + 1).fill(Infinity);
  dp[0] = 0;
  for (let i = 0; i < coins.length; i++) {
    for (let j = coins[i]; j <= amount; j++) {
      dp[j] = Math.min(dp[j - coins[i]] + 1, dp[j]);
    }
  }
  return dp[amount] === Infinity ? -1 : dp[amount];
};
```

## 02.27

[300. 最长递增子序列 - 力扣（Leetcode）](https://leetcode.cn/problems/longest-increasing-subsequence/description/)

思路：

动态规划 5 步法。

1 dp[i]的定义：dp[i]表示 i 之前最长上升子序列的长度

2 状态转移方程：位置 i 的最长升序子序列等于 j 从 0 到 i-1 各个位置的最长升序子序列 + 1 的最大值`if (nums[i] > nums[j]) dp[i] = max(dp[i], dp[j] + 1)`

3 dp[i]的初始化：每一个 i，对应的 dp[i]（即最长上升子序列）起始大小至少都是是 1

4 确定遍历顺序：遍历 i 一定是从前向后遍历。j 其实就是 0 到 i-1，遍历 i 的循环里外层，遍历 j 则在内层

5 举例推导 dp 数组

代码：

```jsx
var lengthOfLIS = (nums) => {
  let dp = Array(nums.length).fill(1);
  let res = 1;
  for (let i = 1; i < nums.length; i++) {
    for (let j = 0; j < i; j++) {
      if (nums[i] > nums[j]) {
        dp[i] = Math.max(dp[i], dp[j] + 1);
      }
    }
    res = Math.max(res, dp[i]);
  }
  return res;
};
```

## 02.26

[34. 在排序数组中查找元素的第一个和最后一个位置 - 力扣（Leetcode）](https://leetcode.cn/problems/find-first-and-last-position-of-element-in-sorted-array/description/)

给你一个按照非递减顺序排列的整数数组  `nums`，和一个目标值  `target`。请你找出给定目标值在数组中的开始位置和结束位置。

思路：

二分查找。左下标寻找第一个大于等于 target 的下标，右下标寻找第一个大于 target 的下标，然后下标减一。

代码：

```jsx
const binarySearch = (nums, target, lower) => {
  let left = 0,
    right = nums.length - 1,
    ans = nums.length;
  while (left <= right) {
    const mid = Math.floor((left + right) / 2);
    if (nums[mid] > target || (lower && nums[mid] >= target)) {
      right = mid - 1;
      ans = mid;
    } else {
      left = mid + 1;
    }
  }
  return ans;
};

var searchRange = function (nums, target) {
  let ans = [-1, -1];
  const leftIdx = binarySearch(nums, target, true);
  const rightIdx = binarySearch(nums, target, false) - 1;
  if (
    leftIdx <= rightIdx &&
    rightIdx < nums.length &&
    nums[leftIdx] === target &&
    nums[rightIdx] === target
  ) {
    ans = [leftIdx, rightIdx];
  }
  return ans;
};
```

## 02.25

[392. 判断子序列 - 力扣（Leetcode）](https://leetcode.cn/problems/is-subsequence/)

给定字符串  **s**和  **t**，判断  **s**是否为  **t**的子序列。

思路一：

双指针。while 循环，s[i]和 t[j]相等就都向前走，不相等只走右指针，最后看做指针是否和 s 长度相等即可。

思路二：

动态规划。

代码：

```jsx
const isSubsequence = (s, t) => {
  // const [m, n] = [s.length, t.length]
  // const dp = new Array(m + 1).fill(0).map(x => new Array(n + 1).fill(0))
  // for (let i = 1; i <= m; i++) {
  //   for (let j = 1; j <= n; j++) {
  //     if (s[i - 1] == t[j - 1]) {
  //       dp[i][j] = dp[i - 1][j - 1] + 1
  //     } else {
  //       dp[i][j] = dp[i][j - 1]
  //     }
  //   }
  // }
  // return dp[m][n] === m ? true : false
  let i = 0,
    j = 0;
  while (i < s.length && j < t.length) {
    if (s[i] == t[j]) {
      i++;
      j++;
    }
    if (s[i] != t[j]) {
      j++;
    }
  }
  return i == s.length;
};
```

## 02.24

[4. 寻找两个正序数组的中位数 - 力扣（Leetcode）](https://leetcode.cn/problems/median-of-two-sorted-arrays/description/)

给定两个大小分别为  `m`和  `n`的正序（从小到大）数组  `nums1`和  `nums2`。请你找出并返回这两个正序数组的  **中位数**。

思路：

直接连接两个数组不符合题目要求。使用二分查找方法。找到两个数组二分的位置，比较这两个位置的四个数是否满足交叉小于等于 L1<=R2 && L2 <=R1，满足则找到题解，不满足继续二分。

代码：

```jsx
var findMedianSortedArrays = (nums1, nums2) => {
  const len1 = nums1.length,
    len2 = nums2.length;
  if (len1 > len2) return findMedianSortedArrays(nums2, nums1); // 对长度较小的二分
  const len = len1 + len2;
  let start = 0,
    end = len1; //二分的开始和结束位置
  let partLen1, partLen2;
  while (start <= end) {
    partLen1 = (start + end) >> 1; //  nums1的二分位置
    partLen2 = ((len + 1) >> 1) - partLen1; // nums2的二分位置
    // L1和R1代表nums1二分后左右两边的位置
    // L2和R2代表nums2二分后左右两边的位置
    let L1 = partLen1 === 0 ? -Infinity : nums1[partLen1 - 1];
    let L2 = partLen2 === 0 ? -Infinity : nums2[partLen2 - 1];
    let R1 = partLen1 === len1 ? Infinity : nums1[partLen1];
    let R2 = partLen2 === len2 ? Infinity : nums2[partLen2];

    if (L1 > R2) {
      end = partLen1 - 1;
    } else if (L2 > R1) {
      start = partLen1 + 1;
    } else {
      // L1<=R2 && L2 <=R1符合交叉小于等于
      return len % 2 === 0
        ? (Math.max(L1, L2) + Math.min(R1, R2)) / 2
        : Math.max(L1, L2);
    }
  }
};
```

## 02.23

[56. 合并区间 - 力扣（Leetcode）](https://leetcode.cn/problems/merge-intervals/description/)

以数组  `intervals`表示若干个区间的集合，其中单个区间为  `intervals[i] = [starti, endi]`。请你合并所有重叠的区间，并返回  *一个不重叠的区间数组，该数组需恰好覆盖输入中的所有区间*。

思路：

先向左端排序，判断当前区间左端小于等于上一个区间右端，是则说明区间相交，更新上个区间的右端，不是则 push 新区间，更新暂存的上个区间。

代码：

```jsx
var merge = function (intervals) {
  const res = [];
  intervals.sort((a, b) => a[0] - b[0]);
  let prev = intervals[0];
  for (let i = 1; i < intervals.length; i++) {
    const cur = intervals[i];
    if (prev[1] >= cur[0]) {
      prev[1] = Math.max(cur[1], prev[1]);
    } else {
      res.push(prev);
      prev = cur;
    }
  }
  res.push(prev);
  return res;
};
```

## 02.22

[452. 用最少数量的箭引爆气球 - 力扣（Leetcode）](https://leetcode.cn/problems/minimum-number-of-arrows-to-burst-balloons/)

题目意思：

最少的数字和集合中的所有数组相交。

思路：

将集合按右端升序排序，遍历数组，判断下一个区间左端是否小于等于第一个的右端，是说明相交，遇到不相交则 count 加 1，最后返回 count。

代码：

```jsx
var findMinArrowShots = function (points) {
  points.sort((a, b) => a[1] - b[1]);
  let count = 0;
  let pos = points[0][1];
  for (let i = 0; i < points.length; i++) {
    if (pos < points[i][0]) {
      pos = points[i][1];
      count++;
    }
  }
  return count;
};
```

## 02.21

[103. 二叉树的锯齿形层序遍历 - 力扣（Leetcode）](https://leetcode.cn/problems/binary-tree-zigzag-level-order-traversal/)

给你二叉树的根节点  `root`，返回其节点值的  **锯齿形层序遍历**。（即先从左往右，再从右往左进行下一层遍历，以此类推，层与层之间交替进行）。

思路：

深度遍历。往数组里添加值，奇数层向前添加，偶数层向后添加，判断数组首位是不是空来看是否是下一层。

代码：

```jsx
var zigzagLevelOrder = function (root) {
  const res = [];
  const dfs = (i, root) => {
    if (!root) return null;
    if (!Array.isArray(res[i])) res[i] = [];
    // 按位与运算，i&1为1说明是奇数；i&1为0是偶数
    if (i & 1) {
      res[i].unshift(root.val);
    } else {
      res[i].push(root.val);
    }
    dfs(i + 1, root.left);
    dfs(i + 1, root.right);
  };
  dfs(0, root);
  return res;
};
```

## 02.20

[222. 完全二叉树的节点个数 - 力扣（Leetcode）](https://leetcode.cn/problems/count-complete-tree-nodes/description/)

给你一棵  **完全二叉树**的根节点  `root`，求出该树的节点个数。

思路：

深度遍历。把遍历到的左右子节点数量加起来

代码：

```jsx
var countNodes = function (root) {
  let sum = 0;
  const dfs = function (node) {
    let num = 0;
    if (node == null) return num;
    const left = dfs(node.left);
    const right = dfs(node.right);
    num = left + right + 1;
    return num;
  };
  sum = dfs(root);
  return sum;
};
```

## 02.19

[450. 删除二叉搜索树中的节点 - 力扣（Leetcode）](https://leetcode.cn/problems/delete-node-in-a-bst/)

给定一个二叉搜索树的根节点  **root**  和一个值  **key**，删除二叉搜索树中的  **key**  对应的节点，并保证二叉搜索树的性质不变。返回二叉搜索树（有可能被更新）的根节点的引用。

思路：

递归。左子树所有节点小于根元素；右子树所有节点大于根元素，使用比 root 大的最小节点来代替它，然后删除这个节点，分多种情况讨论。最后一种情况：root 有左右子树，比 root 大的最小节点是 root 的右子树的最小节点，因此找到再删除；递归删除这个节点时，因为他没有左子节点了，因此只会调用一次。

代码：

```jsx
var deleteNode = function (root, key) {
  // root空，返回空
  if (!root) return null;
  // root值大于key，说明key的节点在左子树中
  if (root.val > key) {
    root.left = deleteNode(root.left, key);
    return root;
  }
  // root值小于key，说明key的节点在右子树中
  if (root.val < key) {
    root.right = deleteNode(root.right, key);
    return root;
  }
  // root值等于key，root是要删除的节点
  if (root.val === key) {
    // root左右都没有子节点，直接删除
    if (!root.left && !root.right) return null;
    // root只有左节点，返回左节点
    if (!root.right) return root.left;
    // root只有右节点，返回右节点
    if (!root.left) return root.right;
    // 左右都有子树，得到右子树，不断遍历右子树的左子节点，找到最小一个，返回
    let successor = root.right;
    while (successor.left) successor = successor.left;
    root.right = deleteNode(root.right, successor.val);
    successor.right = root.right;
    successor.left = root.left;
    return successor;
  }
  return root;
};
```

## 02.18

[236. 二叉树的最近公共祖先 - 力扣（Leetcode）](https://leetcode.cn/problems/lowest-common-ancestor-of-a-binary-tree/description/)

给定一个二叉树, 找到该树中两个指定节点的最近公共祖先。

思路：

深度遍历。找到最低层，如果空或者 root 是 p 或 q，返回 root；如果 left 和 right 都不为空，则说明 root 是最近公共节点；如果 left 空 right 不为空，则返回 right，反之一样；如果 left 和 right 都是空，返回任一即可。

代码：

```jsx
var lowestCommonAncestor = function (root, p, q) {
  const traverse = (root, p, q) => {
    // 如果空或者root等于p或q，说明找到，返回root
    if (!root || root == p || root == q) return root;
    let left = traverse(root.left, p, q);
    let right = traverse(root.right, p, q);
    // 如果left和right都不为空，则说明root是最近公共节点
    if (left != null && right != null) {
      return root;
    }
    // 如果left空right不为空，则返回right，反之一样
    //  如果left和right都是空，返回任一即可
    if (left == null) return right;
    return left;
  };
  return traverse(root, p, q);
};
```

[700. 二叉搜索树中的搜索 - 力扣（Leetcode）](https://leetcode.cn/problems/search-in-a-binary-search-tree/)

给定二叉搜索树（BST）的根节点  `root`和一个整数值  `val`。你需要在 BST 中找到节点值等于  `val`的节点。 返回以该节点为根的子树。 如果节点不存在，则返回  `null`。

思路：

二叉搜索树满足：左子树所有节点小于根元素；右子树所有节点大于根元素，递归或者迭代找出值即可。

代码：

```jsx
var searchBST = function (root, val) {
  // if (!root) return null;
  // if (val === root.val) return root;
  // return searchBST(val < root.val ? root.left : root.right, val);
  while (root) {
    if (val === root.val) return root;
    root = val < root.val ? root.left : root.right;
  }
  return null;
};
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

## 02.07

[5. 最长回文子串 - 力扣（Leetcode）](https://leetcode.cn/problems/longest-palindromic-substring/)

思路：回文数。从中间向两边扩散左右数字相同。分奇偶情况，双指针用一个辅助函数来实现。

代码：

```jsx
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

```jsx
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

## 02.06

[3. 无重复字符的最长子串 - 力扣（Leetcode）](https://leetcode.cn/problems/longest-substring-without-repeating-characters/)

思路：双指针法。右指针不断向前走，寻找右指针的字符在左右指针间出现的位置，一致则说明不存在重复；不一致则移动左指针，位置是寻找到的位置+1，最后返回最大值。

代码：

```jsx
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
