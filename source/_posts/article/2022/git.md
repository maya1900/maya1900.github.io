---
title: 再次深入git
date: 2022-01-24
tags:
  - git
categories: 前端
cover: https://s4.ax1x.com/2022/01/24/7IBwcD.jpg
---

## git commit

git branch 创建分支

git checkout 切换分支

git checkout -b 创建并切换到分支

git merge 合并分支：产生一个新提交

在master下合并bugFix, 使用git merge bugFix，此时master向上指向了两条提交记录，在使用git merge bugFix，此时bugFix和master处在了同一位置。

git rebase 合并分支：取出所有提交记录，在另外一个地方放下去

在bugFix分支，git rebase master，然后更新，切回master，git rebase bugFix，master和bugFix就处在了同一位置。



## 分离HEAD

HEAD：当前记录检出的符号引用

直接使用git checkout (提交记录的哈希)，可以分离HEAD

git checkout HEAD^ 向上移动1个提交记录

git checkoutHEAD~3 向上移动3个提交记录

## 撤销变更

git reset 使用git reset HEAD~1，回退到上个提交（修改的内容加入了暂存区）

git revert 使用git revert HEAD，追加了一个新提交，更改就是撤销上个提交，此时新提交和上上个提交相同

 

## 自由移动提交

git cherry-pick (提交记录哈希，可多个)，可以将任意提交记录添加到本分支

配合git reflog可以恢复已经reset的提交。

git rebase -i HEAD~4 交互式移动。



## git打标签

为commit做一个永久标记：

git tag [tagName] [commit] 为某个记录打标签，不写commit为当前commit

git push origin [tagName]  标签推送远程

git show [tagName] 查看某个标签 

git tag -l 查看所有标签

git tag -d [tagName] 删除标签

git describe 描述某个记录的标签



## 多分支rebase

git rebase [branch1] [branch2] 把branch1合并到branch2上来

git checkout master^ 回到master上一条记录

git checkout master^2 回到master另外上一条(如果有)

支持链式操作：

git checkout HEAD~;git checkout HEAD^2;git checkout HEAD~2

=== git checkout HEAD~^2~2

git brance [branch] [commit] 在commit位置新建分支

git branch -f [commit1] [commit2] 移动commit1到commit2



## 远程相关

### git clone 

在本地创建一个远程的拷贝

git fetch 从远程获取数据，不会改变本地的状态，不会更新master分支，也不会修改磁盘上的文件。

git pull == git fetch + git merge

git pull --rebase == git fetch + git rebase

### 任意分支跟踪origin/master

git checkout -b [branch] origin/master

git branch -u origin/master [branch]

### git push参数

git push origin master

获取提交推送到远程master

git push origin master:[branch] 

推送本地分支branch到远程master

### git fetch参数

git fetch origin foo

获取远程foo分支，并下载

git fetch orgin source:descprtion

下载远程source分支到本地descrption，与pugh相反

### 不指定source

git push orgin :side：push空source删除远程side分支

git fetch origin :bugFix：fetch空source会在本地创建一个新分支

### git pull

git pull origin master:foo == git fetch origin master:foo + git merge foo

学习自：

[Learn Git Branching](https://learngitbranching.js.org/?locale=zh_CN)
