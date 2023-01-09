---
title: 算法学习
tags:
  - 算法
categories: js
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/puddlepounce.png
date: 2023-01-09 19:00:00
---

# 算法

## 考察重点

复杂度：时间、空间

思维：贪心、二分、动态规划

常见数据结构

## 例题

### 将一个数组旋转 k 步

### 快速排序

### 判断字符串是否括号匹配

### 反转单向链表

## 复杂度

![https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202212231746617.png](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202212231746617.png)

## 旋转数组

```markdown
定义一个函数，实现数组的旋转。如输入 `[1, 2, 3, 4, 5, 6, 7]` 和 `key = 3`，
输出 `[5, 6, 7, 1, 2, 3, 4]`<br>
考虑时间复杂度和性能
```

思路 1：末尾元素 pop，然后 unshift

思路 2：拆分两个数组，然后拼接

- 代码：

  ```jsx
  export function rotate1(arr: number[], k: number): number[] {
    const length = arr.length;
    if (!k || length === 0) {
      return arr;
    }
    // 可能比length大，或者是负数，取余。
    const step = Math.abs(k % length);
    // O(n^2)
    for (let i = 0; i < step; i++) {
      const pop = arr.pop();
      if (pop != null) {
        // 数组是连续的，unshift需要把所有值后移一位，O(n)
        arr.unshift(pop);
      }
    }
    return arr;
  }
  export function rotate2(arr: number[], k: number): number[] {
    const length = arr.length;
    if (!k || length === 0) {
      return arr;
    }
    // 可能比length大，或者是负数，取余。
    const step = Math.abs(k % length);
    // O(1)
    // O(n)
    const part1 = arr.slice(0, step);
    const part2 = arr.slice(step);
    const part3 = part2.concat(part1);
    return part3;
  }

  // // 功能测试
  // const arr = [1, 2, 3, 4, 5, 6];
  // console.log(rotate1(arr, 3));
  // console.log(rotate2(arr, 3));

  // // 性能测试
  // const arr1 = [];
  // for (let i = 0; i < 10 * 10000; i++) {
  //     arr1.push(i);
  // }
  // console.time("rotate1");
  // rotate1(arr1, 9 * 10000);
  // console.timeEnd("rotate1"); // 968ms

  // const arr2 = [];
  // for (let i = 0; i < 10 * 10000; i++) {
  //     arr2.push(i);
  // }
  // console.time("rotate2");
  // rotate2(arr2, 9 * 10000);
  // console.timeEnd("rotate2"); // 0.9ms
  ```

- 测试：

  ```tsx
  /**
   * @description rotate test
   * @author may
   */

  import { rotate1, rotate2 } from './rotate';

  describe('array rotate', () => {
    it('normal', () => {
      const arr = [1, 2, 3, 4, 5, 6];
      const k = 3;
      const res = rotate1(arr, k);
      expect(res).toEqual([4, 5, 6, 1, 2, 3]);
    });
    it('empty array', () => {
      const res = rotate1([], 3);
      expect(res).toEqual([]);
    });
    it('k is a negative value', () => {
      const arr = [1, 2, 3, 4, 5, 6];
      const k = -3;
      const res = rotate1(arr, k);
      expect(res).toEqual([4, 5, 6, 1, 2, 3]);
    });
    it('k is not number', () => {
      const arr = [1, 2, 3, 4, 5, 6];
      const k = 'abc';
      // @ts-ignore
      const res = rotate2(arr, k);
      expect(res).toEqual([1, 2, 3, 4, 5, 6]);
    });
  });
  ```

- 复杂度分析：
  思路 1：时间 O(n^2)，空间 O(1)
  思路 2：时间 O(1)，空间 O(n)

## 括号匹配

```markdown
一个字符串内部可能包含 `{ }` `( )` `[ ]` 三种括号，判断该字符串是否是括号匹配的。<br>
如 `(a{b}c)` 就是匹配的， `{a(b` 和 `{a(b}c)` 就是不匹配的。
```

- 栈 stack
  考察栈：先进后出，push、pop、length
- 栈和数组
  没有可比性，栈是逻辑结构，一种理论模型，它可以脱离编程语言；数组是一种物理结构，代码的实现，不同的语言，数组语法是不一样的。
  栈可以用数组表达，也可以用链表表达，也可以自定义 `class MyStack {...}` 自己实现…
  在 JS 中，栈一般情况下用数组实现。
- 思路：
  - 遇到左括号 `{ ( [` 则压栈
  - 遇到右括号 `} ) ]` 则判断栈顶，相同的则出栈
  - 最后判断栈 length 是否为 0
- 代码：

  ```jsx
  /**
   * @description matchBracket
   * @author may
   */
  export function matchBracket(str: string): boolean {
    if (!str.length) {
      return true;
    }
    const stack = [];
    const leftSymbols = '{([';
    const rightSymbols = ')}]';
    for (let i = 0; i < str.length; i++) {
      const s = str[i];
      if (leftSymbols.includes(s)) {
        stack.push(s);
      } else if (rightSymbols.includes(s)) {
        const top = stack[stack.length - 1];
        if (isMatch(top, s)) {
          stack.pop();
        } else {
          return false;
        }
      }
    }
    return stack.length === 0;
  }
  function isMatch(left: string, right: string): boolean {
    if (left === '{' && right === '}') return true;
    if (left === '[' && right === ']') return true;
    if (left === '(' && right === ')') return true;
    return false;
  }

  // // 功能测试
  // const str = "{a(b[c]d)e}f";
  // console.log(matchBracket(str));
  ```

- 测试：

  ```tsx
  import { matchBracket } from './match-bracket';

  /**
   * @description matchBracket test
   * @author may
   */
  describe('match bracket', () => {
    it('正常的', () => {
      const str = '{a(b[c]d)e}f';
      const res = matchBracket(str);
      // toEqual 判断对象或数组 toBe 判断值类型
      expect(res).toBe(true);
    });
    it('不匹配的', () => {
      const str = '{ab[c]d)e}f';
      const res = matchBracket(str);
      expect(res).toBe(false);
    });
    it('顺序不一致的', () => {
      const str = '{a[b(c]d)e}f';
      const res = matchBracket(str);
      expect(res).toBe(false);
    });
    it('空数组', () => {
      const str = '';
      const res = matchBracket(str);
      expect(res).toBe(true);
    });
  });
  ```

- 复杂度：
  时间 O(n)，空间 O(n)

## 两个栈实现一个队列

请用两个栈，来实现队列的功能，实现功能 `add` `delete` `length` 。

- 队列：
  先进先出，API：add、delete、length
  队列和栈一样，是一种逻辑结构。它可以用数组、链表等实现
- 思路：
  - add：直接 push 到 stack1
  - delete：分三步
    - 先把 stack1 元素 pop 出来，push 到 stack2
    - 对 stack2 pop
    - 再把 stack2 元素 pop 出来，push 到 stack1
- 代码：

  ```tsx
  /**
   * @description two to one queue
   * @author may
   */

  export class MyQueue {
    private stack1: number[] = [];
    private stack2: number[] = [];

    add(n: number) {
      this.stack1.push(n);
    }
    delete(): number | null {
      let res;
      const stack1 = this.stack1;
      const stack2 = this.stack2;
      while (stack1.length) {
        const n = stack1.pop();
        if (n != null) {
          stack2.push(n);
        }
      }
      res = stack2.pop();
      while (stack2.length) {
        const n = stack2.pop();
        if (n != null) {
          stack1.push(n);
        }
      }
      return res || null;
    }
    get length(): number {
      return this.stack1.length;
    }
  }

  // // 功能测试
  // const q = new MyQueue();
  // q.add(1);
  // q.add(2);
  // q.add(3);
  // console.log(q.length);
  // console.log(q.delete());
  // console.log(q.length);
  ```

- 测试：

  ```tsx
  /**
   * @description two to one queue test
   * @author may
   */

  import { MyQueue } from './twotoonequeue';

  describe('twotoonequeue', () => {
    it('add and length', () => {
      const q = new MyQueue();
      expect(q.length).toBe(0);
      q.add(1);
      q.add(2);
      q.add(3);
      expect(q.length).toBe(3);
    });
    it('delete', () => {
      const q = new MyQueue();
      expect(q.delete()).toBeNull();
      q.add(1);
      q.add(2);
      q.add(3);
      expect(q.delete()).toBe(1);
      expect(q.delete()).toBe(2);
      expect(q.length).toBe(1);
    });
  });
  ```

- 复杂度：
  时间：add：O(1)，delete：O(n)
  空间：整体 O(n)

## 定义一个 js 函数，反转单向链表

定义一个函数，输入一个单向链表的头节点，反转该链表，并输出反转之后的头节点

- 链表：
  是一种物理结构，是数组的补充。
  数组需要连续的内存空间，链表是零散的数据结构。
  链表分为单向链表和双向链表
  - 单向：`value next`
  - 双向：`value prev next`
    链表查询慢，新增和删除快；
    数组查询快，新增和删除慢。
- 链表应用 Fiber：
  ![https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202212241551356.png](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202212241551356.png)
- 分析：
  画图理解，遍历一遍，重新设置 next，nextNode 易丢失，定义三个指针：prevNode、curNode、nextNode
  ![https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202212272036501.png](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202212272036501.png)
- 代码：

  ```tsx
  /**
   * @description reverse link
   * @author may
   */
  export interface ILinkListNode {
    value: number;
    next?: ILinkListNode;
  }

  /**
   * 反转单向链表
   * @param listNode head node
   */
  export function reverseList(listNode: ILinkListNode): ILinkListNode {
    let preNode: ILinkListNode | undefined = undefined;
    let curNode: ILinkListNode | undefined = undefined;
    let nextNode: ILinkListNode | undefined = listNode;
    while (nextNode) {
      // 第一个元素，删掉next
      if (curNode && !preNode) {
        delete curNode.next;
      }
      // 反转指针
      if (curNode && preNode) {
        curNode.next = preNode;
      }
      // 整体向后移动指针
      preNode = curNode;
      curNode = nextNode;
      nextNode = nextNode?.next;
    }
    // 补充最后一步的处理
    curNode!.next = preNode;
    return curNode!;
  }
  /**
   * 根据数组生成单向链表
   * @param arr
   * @returns
   */
  export function createLinkList(arr: number[]): ILinkListNode {
    const length = arr.length;
    if (length === 0) throw new Error('arr is empty');

    let curNode: ILinkListNode = {
      value: arr[length - 1],
    };
    for (let i = length - 2; i >= 0; i--) {
      curNode = {
        value: arr[i],
        next: curNode,
      };
    }
    return curNode;
  }

  // // 功能测试
  // let arr = [1, 2, 3];
  // const res = createLinkList(arr);
  // console.log(res);
  // console.log(reverseList(res));
  ```

- 测试：

  ```tsx
  /**
   * @description reverse list test
   * @author may
   */

  import {
    ILinkListNode,
    reverseList,
    createLinkList,
  } from './reverse-link-list';

  describe('reverse list', () => {
    it('单个元素', () => {
      const node: ILinkListNode = { value: 100 };
      const node1 = reverseList(node);
      expect(node1).toEqual({ value: 100 });
    });
    it('多个元素', () => {
      const node: ILinkListNode = createLinkList([1, 2, 3]);
      const node1 = reverseList(node);
      expect(node1).toEqual({
        value: 3,
        next: { value: 2, next: { value: 1 } },
      });
    });
  });
  ```

- 变式：
  ```tsx
  let prev = null;
  while (head) {
    const next = head.next;
    head.next = prev;
    prev = head;
    head = next;
  }
  ```
- 递归：
  ```tsx
  function reverse(head) {
    if (head == null || head.next == null) return head;
    const last = reverse(head.next);
    head.next.next = head;
    head.next = null;
    return last;
  }
  ```

## 连环问：链表和数组，那个实现队列更快？

链表更快，链表入队和出队直接改变 next 的指向就好了；数组入队时快，push 就好，出队时 shift 操作，比较慢，需要把后面的值都一个个挪上来。

- 链表实现队列：
  - 需要记录 head 和 tail 两个指针
  - 从 tail 入，从 head 出
  - length 单独存储
- 实现：

  ```tsx
  /**
   * @description 链表实现队列
   * @author may
   */

  interface IListNode {
    value: number;
    next: IListNode | null;
  }

  export class MyQueue {
    private head: IListNode | null = null;
    private tail: IListNode | null = null;
    private len = 0;
    add(n: number) {
      const newNode: IListNode = {
        value: n,
        next: null,
      };
      if (this.head == null) {
        this.head = newNode;
      }
      const tailNode = this.tail;
      if (tailNode) {
        tailNode.next = newNode;
      }
      this.tail = newNode;
      this.len++;
    }
    delete(): number | null {
      const headNode = this.head;
      if (headNode == null || this.len <= 0) {
        return null;
      }
      const value = headNode.value;
      this.head = headNode.next;
      this.len--;
      return value;
    }
    get length(): number {
      return this.len;
    }
  }

  // // 功能测试
  // const queue = new MyQueue();
  // queue.add(1);
  // queue.add(2);
  // console.log(queue.length);
  // console.log(queue.delete());
  // console.log(queue.delete());
  // console.log(queue.delete());
  // console.log(queue.length);

  // // 性能测试
  // const q1 = new MyQueue();
  // console.time("queue with list");
  // for (let i = 0; i < 10 * 10000; i++) {
  //     q1.add(i);
  // }
  // for (let i = 0; i < 10 * 10000; i++) {
  //     q1.delete();
  // }
  // console.timeEnd("queue with list"); // 9 ms

  // const q2 = [];
  // console.time("queue with array");
  // for (let i = 0; i < 10 * 10000; i++) {
  //     q2.push(i);
  // }
  // for (let i = 0; i < 10 * 10000; i++) {
  //     q2.shift();
  // }
  // console.timeEnd("queue with array"); // 604 ms
  ```

- 测试：

  ```tsx
  /**
   * @description queue with list test
   * @author may
   */

  import { MyQueue } from './queue-with-list';
  describe('链表实现队列', () => {
    it('add and length', () => {
      const q = new MyQueue();
      expect(q.length).toBe(0);
      q.add(1);
      q.add(2);
      q.add(3);
      expect(q.length).toBe(3);
    });
    it('delete', () => {
      const q = new MyQueue();
      expect(q.delete()).toBeNull();
      q.add(1);
      q.add(2);
      q.add(3);
      expect(q.delete()).toBe(1);
      expect(q.delete()).toBe(2);
      expect(q.delete()).toBe(3);
      expect(q.delete()).toBeNull();
    });
  });
  ```

- 性能：
  - 空间都是 O(n)
  - add：链表 O(1)数组 O(1)
  - delete：链表 O(1)数组 O(n)

## js 实现二分查找

思路：

- 递归 - 逻辑简洁
- 循环 - 性能更好

复杂度：O(logn)

- 代码：

  ```tsx
  /**
   * @description 二分查找
   * @author may
   */

  /**
   * 循环
   */
  export function binarySearch1(arr: number[], target: number): number {
    const len = arr.length;
    if (len === 0) return -1;
    let start = 0;
    let end = len - 1;
    while (start <= end) {
      const mid = Math.floor((start + end) / 2);
      const midValue = arr[mid];
      if (target < midValue) {
        end = mid - 1;
      } else if (target > midValue) {
        start = mid + 1;
      } else {
        return mid;
      }
    }
    return -1;
  }

  /**
   * 递归
   */
  export function binarySearch2(
    arr: number[],
    target: number,
    start?: number,
    end?: number
  ): number {
    const len = arr.length;
    if (len === 0) return -1;
    if (start == null) start = 0;
    if (end == null) end = len - 1;
    if (start > end) return -1;

    const mid = Math.floor((start + end) / 2);
    const midValue = arr[mid];
    if (target < midValue) {
      return binarySearch2(arr, target, start, mid - 1);
    } else if (target > midValue) {
      return binarySearch2(arr, target, mid + 1, end);
    } else {
      return mid;
    }
  }

  // // 功能测试
  // const arr = [1, 2, 3, 4, 5, 6];
  // const target = 30;
  // console.log(binarySearch2(arr, target));
  // // 性能测试
  // console.time("binarySearch1");
  // for (let i = 0; i < 10 * 10000; i++) {
  //     binarySearch1(arr, target);
  // }
  // console.timeEnd("binarySearch1"); // 2ms
  // console.time("binarySearch2");
  // for (let i = 0; i < 10 * 10000; i++) {
  //     binarySearch2(arr, target);
  // }
  // console.timeEnd("binarySearch2"); // 4ms
  ```

- 测试：

  ```tsx
  /**
   * @description 二分 test
   * @author may
   */

  import { binarySearch1, binarySearch2 } from './binary-search';

  describe('二分查找', () => {
    it('正常', () => {
      const arr = [1, 2, 3, 4, 5];
      const target = 4;
      const res1 = binarySearch1(arr, target);
      const res2 = binarySearch2(arr, target);
      expect(res1).toBe(3);
      expect(res2).toBe(3);
    });
    it('空数组', () => {
      const target = 4;
      const res1 = binarySearch1([], target);
      const res2 = binarySearch2([], target);
      expect(res1).toBe(-1);
      expect(res2).toBe(-1);
    });
    it('找不到target', () => {
      const arr = [1, 2, 3, 4, 5];
      const target = 40;
      const res1 = binarySearch1(arr, target);
      const res2 = binarySearch2(arr, target);
      expect(res1).toBe(-1);
      expect(res2).toBe(-1);
    });
  });
  ```

- 性能分析：
  循环稍快，遍历慢一点

划重点：

- 凡有序必二分
- 凡二分，必 O(logn)

## 给一个数组，找出和为 n 的两个元素

```markdown
输入一个递增的数字数组，和一个数字 `n` 。求和等于 `n` 的两个数字。<br>
例如输入 `[1, 2, 4, 7, 11, 15]` 和 `15` ，返回两个数 `[4, 11]`
```

常规思路：

嵌套循环，复杂度 O(n^2)，不可用。

利用数组递增的特性：

数组递增，如果和大于 n，则向前寻找；如果和小于 n，则向后寻找。

复杂度 O(n)

- 代码：

  ```tsx
  /**
   * @description 两数之和
   * @author may
   */

  export function twoNumSum(arr: number[], target: number): number[] {
    const arr1 = arr.sort((a, b) => a - b);
    let i = 0;
    let j = arr1.length - 1;
    while (i <= j) {
      if (arr[i] + arr[j] > target) {
        j--;
      } else if (arr[i] + arr[j] < target) {
        i++;
      } else {
        return [arr[i], arr[j]];
      }
    }
    return [];
  }
  // // 功能测试
  // const arr11 = [1, 2, 4, 7, 15];
  // const target = 15;
  // console.log(twoNumSum(arr11, target));
  ```

- 测试：
  ```tsx
  /**
   * @description two number test
   * @author may
   */
  import { twoNumSum } from './two-number-sum';
  describe('两数之和', () => {
    it('正常', () => {
      const arr = [1, 2, 4, 7, 15];
      const target = 6;
      const res = twoNumSum(arr, target);
      expect(res).toEqual([2, 4]);
    });
    it('空数组', () => {
      const res = twoNumSum([], 5);
      expect(res).toEqual([]);
    });
    it('找不到', () => {
      const arr = [1, 2, 4, 7, 15];
      const target = 15;
      const res = twoNumSum(arr, target);
      expect(res).toEqual([]);
    });
  });
  ```

## 求一个二叉搜索树的第 k 小值

一个二叉搜索树，求其中的第 K 小的节点的值。

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/0dae4a79-50be-430e-be22-deca293c0f13/Untitled.png)

二叉树 BST(Binary Search Tree)：

每个节点最多能有两个子节点。

- left（包括其后代）value ≤ root value
- right（包括其后代）value ≥ root value

遍历：

- 前序遍历：root → left → right
- 中序遍历：left → root → right
- 后序遍历：left → right → root

分析：

根据中序遍历的结果，第 k 个最小值恰好是数组的 arr[k]。

- 代码：

  ```tsx
  /**
   * @description 二叉树
   * @author may
   */

  export interface ITreeNode {
    value: number;
    left: ITreeNode | null;
    right: ITreeNode | null;
  }

  const b: ITreeNode = {
    value: 5,
    left: {
      value: 3,
      left: {
        value: 2,
        left: null,
        right: null,
      },
      right: {
        value: 4,
        left: null,
        right: null,
      },
    },
    right: {
      value: 7,
      left: {
        value: 6,
        left: null,
        right: null,
      },
      right: {
        value: 8,
        left: null,
        right: null,
      },
    },
  };
  const arr: number[] = [];
  /**
   * 前序遍历
   * @param node
   */
  function preOrderTraverse(node: ITreeNode | null) {
    if (node == null) return;
    arr.push(node.value);
    // console.log(node.value);
    preOrderTraverse(node.left);
    preOrderTraverse(node.right);
  }
  // preOrderTraverse(b);
  /**
   * 中序遍历
   * @param node
   */
  function inOrderTraverse(node: ITreeNode | null) {
    if (node == null) return;
    inOrderTraverse(node.left);
    // console.log(node.value);
    arr.push(node.value);
    inOrderTraverse(node.right);
  }
  // inOrderTraverse(b);
  /**
   * 后续遍历
   * @param node
   */
  function postOrderTraverse(node: ITreeNode | null) {
    if (node == null) return;
    postOrderTraverse(node.left);
    postOrderTraverse(node.right);
    // console.log(node.value);
    arr.push(node.value);
  }
  // postOrderTraverse(b);
  /**
   * 寻找bst的第k个最小值
   */
  function getKthValue(node: ITreeNode, k: number): number | null {
    inOrderTraverse(node);
    return arr[k - 1] || null;
  }
  // console.log(getKthValue(b, 3));
  ```

## 为什么二叉树如此重要？

如何让性能整体最优？

将数组和链表有点结合：查找易，增删易 —— 二分算法

平衡二叉搜索树 bbst：要求左右尽量平衡

- 树高度 h 等于 logn
- 查找，增删，时间复杂度等于 O(logn)

红黑树：一种自动平衡的二叉树

- 节点分红黑两种颜色，通过颜色转换来维持树的平衡
- 相比普通，他维持平衡的效率更高

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/100b43a8-bc38-40fa-aff6-4d36a76d3c4d/Untitled.png)

b 树：物理上是多叉树，但逻辑上是二叉树。

用于高效 I/O，如关系型数据库。

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/3a36e7be-ba0b-4832-838a-a888e0040842/Untitled.png)

堆：

- 完全二叉树
- 最大堆：子节点大于等于父节点
- 最小堆：子节点小于等于父节点

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/895de938-5195-4be0-999a-74a79665b18c/Untitled.png)

**堆逻辑结构是一棵二叉树，物理结构是一个数组**

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/e8ef0cea-9cee-4071-ae20-2bb4b07832e8/Untitled.png)

堆 vs bst

- 查询比 bst 慢（规则比 bst 模糊）
- 增删比 bst 块（规则简单）

使用场景：

- 适合堆栈模型
- 堆的数据都是在栈中引用的
- 堆恰巧是数组形式，可用 O(1)找到目标

小结：

- 堆栈模型，堆的场景
- 堆的特点，堆和 bst
- 堆的逻辑结构和物理结构

## 斐波那契数列

用 Javascript 计算第 n 个斐波那契数列的值，注意时间复杂度。

```markdown
斐波那契数列很好理解

- `f(0) = 0`
- `f(1) = 1`
- `f(n) = f(n - 1) + f(n - 2)` 前两个值的和
```

- 递归：
  ```tsx
  function fibonacci1(n: number): number {
    if (n <= 0) return 0;
    if (n === 1) return 1;
    return fibonacci1(n - 1) + fibonacci1(n - 2);
  }
  ```

重复计算,复杂度 O(2^n)，不可取。

- 循环：
  ```tsx
  function fibonacci2(n: number): number {
    if (n <= 0) return 0;
    if (n === 1) return 1;
    let n1 = 1;
    let n2 = 0;
    let res = 0;
    for (let i = 2; i < n; i++) {
      res = n1 + n2;
      n2 = n1;
      n1 = res;
    }
    return res;
  }
  ```

### 动态规划：

- 把一个大问题，拆解成多个小问题，逐级向下拆解；
- 用递归的思路分析问题，再改为循环来实现。
- 算法三大思维：贪心、二分、动态规划

## 连环问：青蛙跳台阶有几种方式

- 青蛙跳一节台阶有一种方式 f(1) = 1
- 青蛙跳两节台阶有两种方式(2) = 2
- 青蛙跳 n 节台阶有 f(n) = f(n-1) + f(n - 2)方式
  - 第一次跳，要么 1 级，要么 2 级，两种
  - 第一次跳 1 级，剩下 f(n - 1)种方式
  - 第一次跳 2 级，剩下 f(n - 2)种方式

## 将数组 0 移动到末尾

```markdown
定义一个函数，将数组种所有的 `0` 都移动到末尾，例如输入 `[1, 0, 3, 0, 11, 0]` 输出 `[1, 3, 11, 0, 0, 0]`。要求：

- 只移动 `0` ，其他数字顺序不变
- 考虑时间复杂度
- 必须在原数组就行操作
```

思路（双指针）：

- i 指向第一个 0(如何判断第一个？), j 指向第一个非 0
- 把 i 和 j 交换
- 指针后移
- 代码：

  ```tsx
  /**
   * @description 移动0到末尾
   * @author may
   */

  export function moveZero(arr: number[]): void {
    if (!arr.length) return;
    // p1 指向0， p2指向非0
    let p1 = -1;
    let p2 = 0;
    while (p2 < arr.length) {
      if (arr[p2] === 0) {
        // 第一个0，如何判断第一个0？p1 = -1
        if (p1 < 0) {
          p1 = p2;
        }
      }
      if (arr[p2] !== 0 && p1 >= 0) {
        const tmp = arr[p2];
        arr[p2] = arr[p1];
        arr[p1] = tmp;
        p1++;
      }
      p2++;
    }
  }
  // // 功能测试
  // const array = [1, 0, 3, 0, 11, 0];
  // moveZero(array);
  // console.log(array);
  ```

- 复杂度
  时间 O(n)，空间 O(1)

## 字符串连续最多的字符次数

```markdown
给一个字符串，找出连续最多的字符，以及次数。<br>
例如字符串 `'aabbcccddeeee11223'` 连续最多的是 `e` ，4 次。
```

思路：双指针法

- 代码：

  ```tsx
  function findContinuousChar1(str: string): IRes {
    const res: IRes = {
      char: '',
      length: 0,
    };
    let temp = 0;

    // O(n)
    for (let i = 0; i < str.length; i++) {
      temp = 0;
      for (let j = i; j < str.length; j++) {
        if (str[i] === str[j]) {
          temp++;
        }
        if (str[i] !== str[j] || j === str.length - 1) {
          if (temp > res.length) {
            res.char = str[i];
            res.length = temp;
          }
          if (i < str.length - 1) {
            i = j - 1; // 跳步
          }
          break;
        }
      }
    }
    return res;
  }
  function findContinuousChar2(str: string): IRes {
    const res: IRes = {
      char: '',
      length: 0,
    };
    let i = 0;
    let j = 0;
    let temp = 0;
    while (i < str.length) {
      if (str[i] === str[j]) {
        temp++;
      }
      if (str[i] !== str[j] || i === str.length - 1) {
        if (temp > res.length) {
          res.char = str[j];
          res.length = temp;
        }
        temp = 0;
        if (i < str.length - 1) {
          j = i;
          i--;
        }
      }
      i++;
    }
    return res;
  }

  // // 功能测试
  // const strr = "aabbcccddeeee11223";
  // console.info(findContinuousChar2(strr));
  ```

- 其他方法：
  - 正则表达式：效率低
  - 使用数组累计各个字符串的长度，增加空间复杂度（看不出算法思维）

## 快速排序

固定算法，固定思路：

- 找到中间位置 midValue
- 遍历数组，小于 midValue 放在 left，否则放在 right
- 继续递归，最后 concat 拼接，返回

如何取出 midValue：使用 slice，推荐，不会修改原数组

- 代码：

  ```tsx
  function quickSort1(arr: number[]): number[] {
    if (arr.length === 0) {
      return arr;
    }
    const midIndex = Math.floor(arr.length / 2);
    const midValue = arr.splice(midIndex, 1)[0];
    const left: number[] = [];
    const right: number[] = [];
    for (let i = 0; i < arr.length; i++) {
      if (arr[i] < midValue) {
        left.push(arr[i]);
      } else {
        right.push(arr[i]);
      }
    }
    return quickSort1(left).concat([midValue], quickSort1(right));
  }

  function quickSort2(arr: number[]): number[] {
    if (arr.length === 0) {
      return arr;
    }
    const midIndex = Math.floor(arr.length / 2);
    const midValue = arr.slice(midIndex, midIndex + 1)[0];
    const left: number[] = [];
    const right: number[] = [];
    for (let i = 0; i < arr.length; i++) {
      if (i !== midIndex) {
        if (arr[i] < midValue) {
          left.push(arr[i]);
        } else {
          right.push(arr[i]);
        }
      }
    }
    return quickSort2(left).concat([midValue], quickSort2(right));
  }

  // // 功能测试
  // const arra = [4, 2, 3, 4, 1, 3, 2, 1, 3];
  // console.info(quickSort2(arra));
  ```

复杂度：O(n\*logn)

性能测试：splice 和 slice 两种方法差不多

为什么 splice 和 slice 没有区分出来

- 算法本身复杂度就高
- splice 是逐步二分之后执行的，二分会快速削减数量级
- 如果单独比较 splice 和 slice，效果会非常明显

## 求 1-10000 之间的所有对称数（回文）

思路 1：使用数组反转、比较

转换为字符串，split 分割数组，反转 reverse，再 join 为字符串，两个字符串比较

思路 2：字符串头尾比较

for 循环套 while 循环

思路 3：生成翻转数

使用%和 Math.floor 生成翻转数。

- 代码：

  ```tsx
  export function findPalindromeNumbers3(max: number): number[] {
    const res: number[] = [];
    if (max <= 0) return res;

    for (let i = 1; i <= max; i++) {
      let n = i;
      let rev = 0; // 存储翻转数

      // 生成翻转数
      while (n > 0) {
        rev = rev * 10 + (n % 10);
        n = Math.floor(n / 10);
      }

      if (i === rev) res.push(i);
    }

    return res;
  }
  ```

性能分析：

数组转换最慢，直接操作数字最快。

## 英文单词前缀匹配

```markdown
请描述算法思路，不要求写出代码。

- 先给一个英文单词库（数组），里面有几十万个英文单词
- 再给一个输入框，输入字母，搜索单词
- 输入英文字母，要实时给出搜索结果，按前缀匹配
```

常规思路：

遍历数组，indexOf 判断前缀，时间复杂度超过了 O(n)

优化数据结构：

将数组分组，把数组变成一个数，然后在字母顺序在树中查找。

## 数字千分位

思路：

- 转换为数组，reverse 拆分，取余。
- 正则 ×
- 字符串分析
- 代码：

  ```tsx
  /**
   * 千分位格式化（使用数组）
   * @param n number
   */
  export function format1(n: number): string {
    n = Math.floor(n); // 只考虑整数

    const s = n.toString();
    const arr = s.split('').reverse();
    return arr.reduce((prev, val, index) => {
      if (index % 3 === 0) {
        if (prev) {
          return val + ',' + prev;
        } else {
          return val;
        }
      } else {
        return val + prev;
      }
    }, '');
  }

  /**
   * 数字千分位格式化（字符串分析）
   * @param n number
   */
  export function format2(n: number): string {
    n = Math.floor(n); // 只考虑整数

    let res = '';
    const s = n.toString();
    const length = s.length;

    for (let i = length - 1; i >= 0; i--) {
      const j = length - i;
      if (j % 3 === 0) {
        if (i === 0) {
          res = s[i] + res;
        } else {
          res = ',' + s[i] + res;
        }
      } else {
        res = s[i] + res;
      }
    }

    return res;
  }
  ```

性能分析：

- 数组转换，影响性能
- 正则，性能较差
- 操作字符串，性能较好

## 切换字母大小写

切换字母大小写，输入 `'aBc'` 输出 `'AbC'`

思路：

- 正则
- ASCII 码计算
