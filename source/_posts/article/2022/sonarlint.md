---
title: 安装sonarlint
date: 2022-05-10
tags:
  - 前端
  - 静态检查
categories: 前端
cover: https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/202205102157218.gif
---

sonarQube -- sonarlint 平台代码检测

## 1.安装 jdk

下载地址：[https://www.oracle.com/java/technologies/downloads/#jdk17-windows](https://www.oracle.com/java/technologies/downloads/#jdk17-windows)

配置 java 好环境

## 2.安装 sonarlint

### 1.vscode/wecode 安装方法

#### 1. 下载地址：

[https://marketplace.visualstudio.com/\_apis/public/gallery/publishers/SonarSource/vsextensions/sonarlint-vscode/3.1.0/vspackage](https://marketplace.visualstudio.com/_apis/public/gallery/publishers/SonarSource/vsextensions/sonarlint-vscode/3.1.0/vspackage)

#### 2.wecode 扩展安装-- 右上角三个点-- 选择从 vsix 安装

安装好后，进入 wecode 设置里添加一条：

`"sonarlint.ls.javaHome": "C:\\Program Files\\Java\\jdk-17.0.1" // jdk路径，对应安装路径`

### 2.idea/webstorm 安装

很多教程，自行搜索

## 3.连接 sonarqube

### 1.在 sonarqube 里创建新项目，设置身份令牌 token，项目唯一标识 projectKey

### 2.安装 sonar-scanner

下载地址：[https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-windows.zip](https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-windows.zip)

解压，在我的电脑里配置环境变量%PATH%，路径为 sonar-scanner 的 bin 目录

`D:\tool\sonar-scanner-4.6.2.2472-windows\bin`

#### 3.扫描

`sonar-scanner.bat -Dsonar.projectKey=projectKey -Dsonar.sources=. -Dsonar.host.url=url -Dsonar.login=token`

替换里面的 projectKey/url/token 为自己的，在项目根目录下 cmd 运行，即可成功上传至 sonarqube.

完成。
