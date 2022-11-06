---
title: 关于本地调试不携带cookie
date: 2022-10-02
tags:
  - 浏览器
  - cookie
categories: 浏览器
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/2462401306aa800a3a5910d9c921956a.png
---

最近做公司 vue 老项目，登录成功后又调取其他接口来获取个人信息，发现在线上运行正常，到了本地调试接口报 401，跳转登录页面，登录页面判断已登录又去调个人信息的接口，接口报 401 又跳转登录页面，无限循环下去了…… 通过比较发现，这个获取个人信息的接口在本地调试时没有携带 cookie，而在线上却携带了。

问了其他同事，说换火狐浏览器，还要是低版本的。之前就听说过这样的情况是浏览器机制的问题，谷歌和 edge 不行，只有火狐好使，我在想到底是什么机制 ，没听说过呢？这次遇到，是时候要清楚了。

说要低版本火狐是吧，首先去火狐浏览器官网找，找了一通没找到低版本的下载入口呀，然后百度搜火狐浏览器低版本，找了一通没啥有用的，然后看到一篇[《如何降级火狐浏览器》](https://www.sohu.com/a/500463409_120099901)，有点用但是没给地址呀。然后又搜索 firebox 降级，百度搜索一通没啥有用的，脑子一想谷歌搜索试一下？得，一搜索[第二个就是](https://support.mozilla.org/zh-CN/kb/%E5%AE%89%E8%A3%85%20Firefox%20%E4%BB%A5%E5%89%8D%E7%9A%84%E7%89%88%E6%9C%AC)，我真的是会谢。。搜索还得是 google

![](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202210021350861.png)

然后就开始尝试，安装 80 版本，不行；安装 60 版本，不行；安装 40 版本，网页都打不开了；安装 50 版本，哎呦终于好使了。

然后我就想这是为什么呢？谷歌浏览器不行，为啥？接着又开始百度（为啥老是用百度，不是说 google 好吗？不说说就是中文亲切一点，搜索问题之类的先在百度找，找不到再去 google 找，[stackoverflow](https://stackoverflow.com/) 上一般就会有答案），本地调试不携带 cookie，果然找到了一些答案。

首先映入眼帘的是[解决 vue 项目本地启动时无法携带 cookie](https://blog.csdn.net/weixin_47160442/article/details/113699007)，问题和我很像，我直接就去实验了，

说是在浏览器地址栏访问`chrome://flags`，搜索 samesite，然后 disabled，我一尝试，我的 chrome 怎么没有这个选项呢？我的 chrome 是假的吗？？

![](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202210021351439.png)

不太对，又搜索其他方法。找到一个：[90 版本以上的谷歌浏览器，本地请求不携带 cookie](https://blog.csdn.net/TurtleOrange/article/details/118971762)，说是

`-disable-features=SameSiteByDefaultCookies 直接拷贝到目标输入框后面`

然后我这样做了，打开浏览器发现也没什么效果。。

又搜索了一通，发现这个：[chrome 禁用 samesite 的通用解法 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/397317451)，就说是 94 版本以后的设置参数也不行了，我看了下自己的版本，额默认升级最新版本了。。

看了很多答案都发现说是 chrome samesite 的问题，于是自己总结了一下：

1.  Chrome 51 开始，浏览器的 Cookie 新增加了一个 SameSite 属性，用来防止 CSRF 攻击和用户追踪；
2.  Chrome 80 版本后将 sameSite 默认设置为 Lax，可以通过浏览器配置，或者 nginx 设置 samesite 为 none 解决；
3.  Chrome 91 版本将浏览器配置删除（即 chrome://flags 方法），默认开启 samesite，但还可以通过配置浏览器启动方式解决（即在快捷方式那里添加`-disable-features=SameSiteByDefaultCookies`）；
4.  Chrome 94 版本后浏览器启动参数也不行了（没尝试，反正最新 105 版本不得行）

那么找了一通，最终还是到了浏览器、cookie、samesite 的问题上，虽然最后本地还是用了低版本浏览器解决了开发环境不能访问的问题，但还是想了解一下这个知识点。

首先 http 是无状态的协议，就是说客户端向服务器发送两次请求，服务器无法识别两次请求是同一客户端发送的，为了保存状态，有了 cookie。

cookie 的运行过程：

- 客户端向服务器发送请求，
- 服务器收到请求设置 set-cookie 到浏览器，
- 浏览器保存 cookie，以后每次请求 cookie 都伴随请求来回发送和接收，来判断状态。

浏览器只需要判断请求是来自同站点的，就会携带 cookie。

cookie 的一些属性：

- Name/Value
- Expired
- Max-Age
- Domain：指定 cookie 到达的主机名，没有指定默认是 url 的主机部分
- Path：指定请求到相应资源路径才会发送 cookie
- Secure：标记了 Secure 的 cookie 只能通过 https 发送
- HTTPOnly：cookie 只能通过请求访问，避免 XSS 攻击
- SameSite：设置 SameSite 可以让跨站请求时 cookie 不被发送，防止 CSRF 攻击。

另外，cookie 还有第一方 cookie（first part cookie）和第三方 cookie（third part cookie）的区别：

如果发送请求网址与当前网页的网域一致，我们称带在请求上的 cookie 为第一方 cookie; 如果是网页上一些置放在第三方域底下的资源所发出的请求（ 图片、跟踪代码等等）所附挂的 cookie，则称之为 第三方 cookie。

这样看起来浏览器设置 SameSite 就是为了 CSRF 攻击，那么先了解一下 CSRF 攻击：

> 攻击者诱导用户进入一个第三方网站，然后该网站向被攻击网站发送跨站请求。如果用户在被攻击网站中保存了登录状态，那么攻击者就可以利用这个登录状态，绕过后台的用户验证，冒充用户向服务器执行一些操作

常见的 CSRF 攻击有三种：

- GET 类型的 CSRF 攻击，比如在网站中的一个 img 标签里构建一个请求，当用户打开这个网站的时候就会自动发起提交。
- POST 类型的 CSRF 攻击，比如构建一个表单，然后隐藏它，当用户进入页面时，自动提交这个表单。
- 链接类型的 CSRF 攻击，比如在 a 标签的 href 属性里构建一个请求，然后诱导用户去点击。

CSRF 的本质是**利用浏览器在同站请求中携带 cookie 发送服务器的特点，来实现对用户的冒充。**

> 同源和同站：

> 浏览器的同源策略和 cookie 同站判断是完全不同的。浏览器要求一个请求需要**协议主机名端口号**一致，否则这个请求会被拦截，要清楚的是，请求发送了，服务器响应了，但是无法被浏览器接收。

> cookie 的同站则相对宽松：只要两个 URL 的 eTLD+1 相同即可，不需要考虑协议和端口。其中，eTLD 表示有效顶级域名，注册于 Mozilla 维护的公共后缀列表（Public Suffix List）中，例如，.com、.co.uk、.github.io 等。eTLD+1 则表示，有效顶级域名+二级域名，例如 [taobao.com](http://taobao.com) 等。

> 举几个例子，[www.taobao.com](http://www.taobao.com) 和  [www.baidu.com](http://www.baidu.com/)  是跨站，[www.a.taobao.com](http://www.a.taobao.com) 和  [www.b.taobao.com](http://www.b.taobao.com/)  是同站，[a.github.io](http://a.github.io) 和 [b.github.io](http://b.github.io) 是跨站(注意是跨站)。

那么 SameSite 有一些什么属性呢？

SameSite 可以设置三个值：

- Strict 最为严格，完全禁止第三方 Cookie，只有当前网页的 URL 与请求目标一致，才会带上 Cookie；
- Lax 规则稍稍放宽，大多数情况也是不发送第三方 Cookie
- None 无论是否跨站都会发送 Cookie

![](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202210021432400.png)

从上表可以看到，以前的 post、iframe、ajax 和 image 中的请求以前是发送 cookie 的，浏览器升级了 80 版本后变成不能携带 cookie，导致了我们客户端的 get 请求不能请求成功了。

在 SameSite 影响较多的时候，我们可以将它设为 None，但同时也要注意两个地方：一是需要同时加上 Secure 属性，只有 https 协议下 cookie 才会发送；二是 IOS 12 的 Safari 以及老版本的一些 Chrome 会把 SameSite=none 识别成 SameSite=Strict，所以服务端必须在下发 Set-Cookie 响应头时进行 User-Agent 检测，对这些浏览器不下发 SameSite=none 属性

参考：

1.  [Cookie 的 SameSite 属性](http://www.ruanyifeng.com/blog/2019/09/cookie-samesite.html)
2.  [Chrome 80 后针对第三方 Cookie 的规则调整 （default SameSite=Lax）](https://ianhung0529.medium.com/chrome-80-%E5%BE%8C%E9%87%9D%E5%B0%8D%E7%AC%AC%E4%B8%89%E6%96%B9-cookie-%E7%9A%84%E8%A6%8F%E5%89%87%E8%AA%BF%E6%95%B4-default-samesite-lax-aaba0bc785a3)
3.  [浏览器系列之 Cookie 和 SameSite 属性](https://github.com/mqyqingfeng/Blog/issues/157)
