---
title: js的深度遍历与广度遍历
date: 2022-05-29
tags:
  - 算法
  - js
categories: 算法
cover: https://gitlab.com/maya1900/pic/raw/main/img/29_20_37_14_202205292037603.jpg
---

## 基本概念

### 深度优先遍历

Depth First Search，从第一个指定的顶点开始向下寻找元素，直到全部路径都访问，原路回退再继续下一条路径。

深度遍历实现非递归时使用队列。

![](https://gitlab.com/maya1900/pic/-/raw/main/img/29_17_33_12_202205291733441.png)

### 广度优先遍历

Breadth First Search，从第一个顶点开始遍历，先访问相邻所有的元素，完毕后再接着访问下一层相邻的元素，一层一层的访问下去。

广度遍历实现时非递归使用栈的形式。

![](https://gitlab.com/maya1900/pic/-/raw/main/img/29_17_37_22_202205291737041.png)

## 深度遍历

遍历如下 dom 节点。

```HTML
<div id="root">
    <ul>
      <li>
        <a href="">
          <img src="" alt="">
        </a>
      </li>
      <li>
        <span></span>
      </li>
      <li></li>
    </ul>
    <p></p>
    <button></button>
  </div>
```

如图：

![](https://gitlab.com/maya1900/pic/-/raw/main/img/29_18_14_33_202205291814410.png)

递归：

```JavaScript
    function depthFirstSearch(node, nodes = []) {
      if (node) {
        nodes.push(node);
        let children = node.children;
        for (let i = 0; i < children.length; i++) {
          deepFirstSearch(children[i], nodes)
        }
      }
      return nodes;
    }
```

非递归：

```JavaScript
    function deepFirstSearch(node) {
      let nodes = [];
      if (node) {
        let stack = []
        stack.push(node)
        while (stack.length) {
          let item = stack.pop() // 每次选最后一个元素弹出
          nodes.push(item)
          let children = item.children
          for (let i = children.length - 1; i >= 0; i--) {  // 倒序循环，把前面的元素push到后面
            stack.push(children[i])
          }
        }
      }
      return nodes
    }
```

结果：

![](https://gitlab.com/maya1900/pic/-/raw/main/img/29_17_55_55_202205291755292.png)

### leetcode104：二叉树最大深度

[104. 二叉树的最大深度 - 力扣（LeetCode）](https://leetcode.cn/problems/maximum-depth-of-binary-tree/)

- 实现

```JavaScript
var maxDepth = function(root) {
    if (root) {
        const l = maxDepth(root.left)
        const r = maxDepth(root.right)
        return Math.max(l, r) + 1
    } else {
        return 0
    }
};
```

## 广度遍历

依旧遍历如上 dom 节点。

如图：

![](https://gitlab.com/maya1900/pic/-/raw/main/img/29_18_17_48_202205291817717.png)

递归：

```JavaScript
   function breadthFirstSearch(node, nodes = []) {
      if (node) {
        nodes.push(node)
        breadthFirstSearch(node.nextElementSibling, nodes)
        breadthFirstSearch(node.firstElementChild, nodes)
      }
      return nodes
    }
```

非递归：

```JavaScript
    function breadthFirstSearch(node) {
      let nodes = []
      if (node) {
        let queue = []
        queue.unshift(node)
        while (queue.length) {
          let item = queue.shift() // 取第一个元素
          nodes.push(item)
          let children = item.children
          for (let i = 0; i < children.length; i++) {
            queue.push(children[i])
          }
        }
      }
      return nodes
    }
```

结果：

![](https://gitlab.com/maya1900/pic/-/raw/main/img/29_17_54_29_202205291754056.png)

### leetcode102：二叉树的层序遍历

[102. 二叉树的层序遍历 - 力扣（LeetCode）](https://leetcode.cn/problems/binary-tree-level-order-traversal/)

- 实现

```JavaScript
var levelOrder = function(root) {
    const queue = []
    const res = []
    if (root == null) return res
    queue.unshift(root)
    while(queue.length) {
        res.push([])
        for (let i = 0, len = queue.length; i < len; i++) {
            const top = queue.shift()
            res[res.length - 1].push(top.val)
            if (top.left) {
                queue.push(top.left)
            }
            if (top.right) {
                queue.push(top.right)
            }
        }
    }
    return res
};
```

## 总结：

可以看出深度遍历与广度遍历的非递归时的实现差别在于取元素的时候，广度遍历从头开始取元素（shift 方法），而把它的子节点全部 push 到后面，每次循环开始去取的是兄弟节点，保证在循环时可以按层进行遍历；

深度遍历则是从尾开始取元素（pop 方法），倒序循环把子节点放入栈中，那么意味着每次循环开始都会先取子节点，从而形成了一条路走到底，深层遍历的情况。

## 参考：

[JS 算法之深度优先遍历(DFS)和广度优先遍历(BFS)](https://segmentfault.com/a/1190000018706578###)

[写给前端开发的广度优先搜索](https://juejin.cn/post/7060964412105949221)
