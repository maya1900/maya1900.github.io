---
title: 重学React
date: 2021-12-31
tags:
  - react
categories: react
cover: https://s4.ax1x.com/2021/12/31/T4tw1e.jpg
---

# 重学React

## 基础部分

```html
  <script type="text/babel">
    // 1. 创建虚拟dom
    const VDOM = <h1>Hello</h1>
    // 2. 渲染
    ReactDOM.render(VDOM, document.getElementById('test'))
  </script>
```

### jsx基础语法

1. 定义虚拟dom不能使用”“

2. 标签中混入js表达式使用{}

3. 样式类名使用className

4. 内联样式使用双大括号包裹

   > js表达式与js语句：
   >
   > 表达式返回一个值，如a a+b fun() arr.map() function fun(){};
   >
   > 语句是js代码，不会返回值，如if(){} while(){} for(){} switch(){}

```js
    const VDOM = (
      <h1 id={myid.toUpperCase()}>
        <span className="aa" style={{color:'#000'}}>标题</span>
      </h1>
    )
```

### 组件

> 组件名称必须以大写字母开头

#### 函数式组件

```js
  <script type="text/babel">
    // 1. 创建函数
    function Welcome(props) {
      return <h1>hello, {props.name}!</h1>
    }
    // 2. 渲染
    ReactDOM.render(<Welcome name="aa"/>, document.getElementById('test'))
  </script>
```

#### Class组件

```js
class Welcome extends React.Component {
    render() {
        return <div>Welcome,{this.props.name}</div>;
    }
}
```

### 组件三大属性

#### state

```js
  <script type="text/babel">
    class Con extends React.Component {
      constructor(props) {
        super(props);
        this.state = {isHot: true}
        this.dem1 = this.dem.bind(this)
      }
      dem() {
        const isHot = this.state.isHot
        this.setState({isHot:!isHot})
      }
      render() {
        return <h1 onClick={this.dem1}>天气{this.state.isHot ? '火热' : '凉爽'}</h1>;
      }
    }
    ReactDOM.render(<Con/>, document.getElementById('test'))
  </script>
```

注意：

1. 构造函数需要传递一个props参数
2. 关注this，所有方法都是严格模式，直接调用this就为undefined
3. 改变state需要用setState，修改state部分属性是合并不是覆盖
4. this.setState()，接收两种参数：
    1. setState(stateChange, [callback]) // callback可选回调，在render后调用
    2. setState(updater, [callback]) // updater为返回state对象的函数，可以接收state和props参数

**React控制之外的事件调用setState是同步更新，如原生事件setTimeout/setInterval；大部分开发用到的React封装的事件，如onChange/onClick，setState是异步处理的**

**同步更新一个setState调用一次render，异步更新多个setState统一调用一次render**

```js
  <script type="text/babel">
    class Con extends React.Component {
      // state直接赋值
      state = {isHost: true};
      // 使用箭头函数
      dem = () => {
        const isHot = this.state.isHot
        this.setState({isHot:!isHot})
      }
      render() {
        return <h1 onClick={this.dem}>天气{this.state.isHot ? '火热' : '凉爽'}</h1>;
      }
    }
    ReactDOM.render(<Con/>, document.getElementById('test'))
  </script>
```

调用方法传递参数，有两种方法：

```html
<button onClick={(e) => this.deleteRow(id, e)}>Delete Row</button>
<button onClick={this.deleteRow.bind(this, id)}>Delete Row</button>
```

#### props

props主要用来传递数据

基本使用：

```js
  <script type="text/babel">
    class Con extends React.Component {
      render() {
        return (
          <ul>
            <li>{this.props.name}</li>
            <li>{this.props.age}</li>
          </ul>
        )
      }
    }
    ReactDOM.render(<Con name="tom" age="20" />, document.getElementById('test'))
  </script>
```

对象使用：

```js
  <script type="text/babel">
    class Con extends React.Component {
      render() {
        return (
          <ul>
            <li>{this.props.name}</li>
            <li>{this.props.age}</li>
          </ul>
        )
      }
    }
    let p = {name: 'jerry', age: 18}
    // 使用展开运算符
    ReactDOM.render(<Con {...p}/>, document.getElementById('test'))
  </script>
```

props限制：

```js
    class Con extends React.Component {
      render() {
        return (
          <ul>
            <li>{this.props.name}</li>
            <li>{this.props.age}</li>
          </ul>
        )
      }
      // 对属性进行限制
      static propTypes = {
        name: PropTypes.string.isRequired,
        age: PropTypes.number,
        fun: PropTypes.func
      }
      // 默认值
      static defaultProps = {
        sex: 'male'
      }
    }
```

函数式组件的使用：

```js
// 作为参数传递：
function Person(props){
    return (
        <ul>
        <li>{props.name}</li>
        <li>{props.age}</li>
        <li>{props.sex}</li>
        </ul>
    )
}
```

#### refs

1. 字符串形式

   ```js
   <input type="text" ref="input" onBlur={() => this.inputBlur()}/>
   inputBlur() {
       console.log(this.refs.input.value);
   }
   ```

2. 回调形式

   在ref属性中添加一个回调，将dom作为参数传递，c是该input标签，把元素赋值实例对象一个属性

   ```js
   <input type="text" ref={c => this.input = c} onBlur={() => this.inputBlur()}/>
   inputBlur() {
       console.log(this.input.value);
   }
   ```

3. api形式

   ```js
         MyRef = React.createRef()
         render() {
           return (
             <input type="text" ref={this.MyRef} onBlur={() => this.inputBlur()}/>
           )
         }
         inputBlur() {
           console.log(this.MyRef.current.value);
         }
   ```

**尽可能使用操作元素事件替代，少用ref**

### react事件

react事件通过onXXX属性指定属性处理函数，通过事件委托方式处理，事件中返回函数，通过event.target得到发生事件的dom元素对象

### 受控与非受控组件

受控组件state是"唯一数据源"；

非受控组件数据不会更新state，数据用作展示，输入数据现用现取

### 高阶函数

1. 函数的参数是函数
2. 函数的返回值是一个函数

### 函数的柯里化

通过函数调用继续返回函数的形式，实现多次接收参数最后统一处理的函数编码形式

### 生命周期

#### 旧

1. 初始化阶段，由ReactDom.render()触发

   i. constructor()

   ii. componentWillMount()

   iii. render()

   iv. componentDidMount()

2. 更新阶段，由this.setState()触发

   i. shouldComponentUpdate()  // 返回true/false判断是否更新

   ii. componentWillUpdate()

   iii. render()

   (iv. componentWillReceiveProps) // 父组件更新，子组件先执行(第一次传递数据不执行)

   iv. componentDidUpdate()

3. 卸载组件，由ReactDOM.unmountComponentAtNode()触发

   i. componentWillUnmount()

#### 新

抛弃componentWillMount/componentWillReceiveProps/componentWillUpdate

1. 初始化阶段，由ReactDOM.render()触发

   i. constructor()

   ii. getDerivedStateFromProps  // 必须static 传参(props,state)，返回Null或state对象

   iii. render()

   iv. componentDidMount()

2. 更新阶段，由this.setState()或父组件重新render触发

   i. getDerivedStateFromProps

   ii. shouldComponentUpdate()

   iii. render()

   iv. getSnapshotBeforeUpdate // 传参(prevProps, prevState) ，任何返回值传给v阶段

   v. componentDidUpdate()  // 传参(prevProps, prevState, snapshot)

3. 卸载组件， 由ReactDOM.unmountComponentAtNode()触发

   i. componentWillUnmount()

### react 跨域

- 方法一

  在package.json中配置：```"proxy": "http://localhost:5000"```

- 方法二

  ```json
  "proxy": {
      "/api": {
          "target": "http://localhost:8000",
          "changeOrigin": true
      },
      "/app": {
          "target": "http://localhost:8001",
          "changeOrigin": true
      }
  }
  ```

- 方法三

  创建src/setupProxy.js

  ```js
  const proxy = require('http-proxy-middleware')
  module.exports = function(app) {
      app.use(
      	proxy('/api',{
              target: 'http://localhost:3000',
              changeOrigin: true,
              pathRewrite: {
                  '^/api': ''
              }
          })
      )
  }
  ```

## 路由

### 基本使用：

```html
<Link to="/hello">Hello</Link>
v5:
<Switch>
    <Route path="/hello" component={Hello} />
    <Route path="/about" component={About} />
</Switch>
v6:
<Routes>
    <Route path="/hello" element={<Hello/>} />
    <Route path="/about" element={<About/>} />
</Routes>
App外包裹：
<BrowserRouter>
    <App />
</BrowserRouter>
```

### 路由组件与一般组件：

1. 写法不一样：
2. 存放位置不一样：一般组件components，路由组件pages
3. 路由组件接收到固定三个属性history,location,match

### NavLink封装：

```html
 // 通过{...对象}的形式解析对象，相当于将对象中的属性全部展开
 //<NavLink  to = {this.props.to} children = {this.props.children}/>
<NavLink className="list-group-item" {...this.props}/>
使用：
{/*将NavLink进行封装，成为MyNavLink,通过props进行传参数，标签体内容props是特殊的一个属性，叫做children */}
<MyNavLink to = "/about" >About</MyNavLink>
```

### 嵌套路由：

```html
v6:
父：
<Route path="/about/*" element={<About/>} />
子：
<NavLink to="message">message</NavLink>
<Route path="message" element={<Message/>}/>
页面：http://localhost:3000/about/message
v5:
父：
<Route path="/about" element={About} />
子：
let {path, url} = useRouteMatch()
<NavLink to={`${url}/message`}>message</NavLink>
<Route path={`${path}/message`} component={<Message/>}/>
```

其他参考：[react-router v6迁移指南]([(19条消息) React-Router v6 新特性解读及迁移指南_前端劝退师-CSDN博客_react router v6](https://blog.csdn.net/weixin_40906515/article/details/104957712))

### 向路由组件传递参数

+ params

    1. 路由链接：```<Link to='/demo/test/tom/18'}>详情</Link>```
    2. 注册路由：```<Route path="/demo/test/:name/:age" component={Test}/>```
    3. 接收参数：this.props.match.params

  ```html
  	-------------------------------发送参数:父组件----------------------------------------------
    <div>
         {/* 向路由组件传递params参数 */}
         <Link to={`/home/message/detail/${msgObj.id}/${msgObj.title}`}>{msgObj.title}</Link>
         <hr />
         {/* 声明接收params参数 */}
         <Route path="/home/message/detail/:id/:title" component={Detail} />
    </div>
    --------------------------------接受参数:子组件-----------------------------------------------------------
      const {id,title} = this.props.match.params
  ```

+ search

    1. 路由链接：```<Link to='/demo/test?name=tom&age=18'}>详情</Link>```
    2. 注册路由(无需声明)：```<Route path="/demo/test" component={Test}/>```
    3. 接收参数：this.props.location.search

  ```html
  	-------------------------------发送参数:父组件----------------------------------------------
    <div>
        	{/* 向路由组件传递search参数 */}
    	<Link to={`/home/message/detail/?id=${msgObj.id}&title=${msgObj.title}`}>{msgObj.title}</Link>
         <hr />
       	{/* search参数无需声明接收，正常注册路由即可 */}
    	<Route path="/home/message/detail" component={Detail}/>
    </div>
    --------------------------------接受参数:子组件-----------------------------------------------------------
    import qs from 'querystring'
    // 接收search参数
    const {search} = this.props.location
    const {id,title} = qs.parse(search.slice(1))
  ```

+ state

    1. 路由链接：```<Link to={{pathname:'/demo/test',state:{name:'tom',age:18}}}>详情</Link>```
    2. 注册路由(无需声明)：```<Route path="/demo/test" component={Test}/>```
    3. 接收参数：this.props.location.state
        - 使用`BrowserRouter`刷新才可以`保留住参数`,使用`HashRouter`刷新后state将会没有`history`来保存参数

  ```html
  	-------------------------------发送参数:父组件----------------------------------------------
    <div>
        	{/* 向路由组件传递state参数 */}
    	<Link to={{pathname:'/home/message/detail',state:{id:msgObj.id,title:msgObj.title}}}>{msgObj.title}</Link>
  
         <hr />
       	{/* state参数无需声明接收，正常注册路由即可 */}
    	<Route path="/home/message/detail" component={Detail}/>
    </div>
    --------------------------------接受参数:子组件-----------------------------------------------------------
      // 接收state参数,后面添加`||{}`是防止使用`HashRouter`后state为undefined时报错
    const {id,title} = this.props.location.state || {}
  ```

### 编程式路由导航

v5借助this.props.history对象的api对路由跳转进行操作

1. this.props.history.push()
2. this.props.history.replace()
3. this.props.history.goBack()
4. this.props.history.goForward()
5. this.props.history.go()

```jsx
 pushShow = (id, title) => {
   //push跳转+携带params参数
   this.props.history.push(`/home/message/detail/${id}/${title}`)

   //push跳转+携带search参数
   this.props.history.push(`/home/message/detail?id=${id}&title=${title}`)

   //push跳转+携带state参数
   this.props.history.push(`/home/message/detail`, { id, title })

 }
<button onClick={() => this.pushShow(msgObj.id, msgObj.title)}>push查看</button>
{/* 声明接收params参数 */}
{/* <Route path="/home/message/detail/:id/:title" component={Detail}/> */}

{/* search参数无需声明接收，正常注册路由即可 */}
{/* <Route path="/home/message/detail" component={Detail}/> */}

{/* state参数无需声明接收，正常注册路由即可 */}
<Route path="/home/message/detail" component={Detail} />
```

v6使用useNavigate进行编程式导航

### withRouter

withRouter可以让一般组件须具备路由组件的属性`export default withRouter(Header)`

## redux

中文文档：[Redux中文文档](https://www.redux.org.cn/)

### redux是什么

1. redux是一个专门用于做`状态管理的JS库`(不是react插件库)。
2. 它可以用在react, angular, vue等项目中, 但基本与react配合使用。
3. 作用: 集中式管理react应用中多个组件`共享`的状态。

[![TJfZRK.png](https://s4.ax1x.com/2021/12/24/TJfZRK.png)](https://imgtu.com/i/TJfZRK)

### redux三个概念

#### action

动作的对象。

type: 标识属性，唯一，值为字符串

data: 数据属性，值任意

例子：`{ type: 'ADD_STUDENT',data:{name: 'tom',age:18} }`

#### reducer

1. 用于初始化状态、加工状态。

2. 加工时根据旧的state和action,产生新的state的纯函数

3. redux的reducer函数必须是一个纯函数

   > 纯函数：相同输入必定得到同样输出。
   >
   > 1. 不得改写参数数据
   > 2. 不会产生任何副作用，如网络请求、输入输出设备
   > 3. 不能调用Date.now()或Math.random()等不纯的方法

#### store

1. 将state、action、reducer联系在一起的对象

2. 如何获得？

   ```js
   import { createStore } from 'redux'
   import reducer from './reducers'
   const store = createStore(reducer)
   ```

3. 对象的功能？

    * getState()：得到state
    * dispatch(action)：分发action，触发reducer调用，产生新的state
    * subscribe(listencer)：注册监听，产生新的state时，自动调用

### redux的核心api

* createstate()与applyMiddleware()

createstore()：创建包含指定reducer的store对象

applyMiddleware()：应用基于redux的中间件

```js
import { createStore, applyMiddleware } from 'redux'
export default createStore(reducer, composeWithDevTools(applyMiddleware(thunk)))
```

* store对象

redux最核心的管理对象。

维护state,reducer

```jsx
// ---------------------------store.js---------------------------------
/**
* 该文件撰文用于暴露一个store对象,整个应用只有一个store对象
*/
//引入createStore,专门用于创建redux中最为核心的store对象
import {createStore,applyMiddleware} from 'redux'
//引入汇总后的reducer
import reducer from './reducers'
//引入redux-thunk，用于支持异步action
import thunk from 'redux-thunk'
//引入redux-devtools-extension
import {composeWithDevTools} from 'redux-devtools-extension'
//暴露store
export default createStore(reducer,composeWithDevTools(applyMiddleware(thunk)))
// ----------------------------index.js 引入store对象--------------------------------
import React from 'react'
import ReactDOM from "react-dom"
import App from './App'
import store from './redux/store'
import {Provider} from 'react-redux'

ReactDOM.render(
  /* 此处需要用Provider包裹App，目的是让App所有的后代容器组件都能接收到store */
  <Provider store={store}>
  	<App/>
  </Provider>,
  document.getElementById('root')
)
```

* combinReducers()

作用：合并多个reducer函数

```js
// ------------------ redux/reducers/index.js ------------------------------------
/**
 * 该文件用于汇总所有的reducer为一个总的reducer
 */
//引入combineReducers，用于汇总多个reducer
import {combineReducers} from 'redux'
//引入为Count组件服务的reducer
import count from './count'
import persons from './person'

//汇总所有的reducer变为一个总的reducer
export default combineReducers({
  count,persons
})
```

### redux异步编程

使用异步中间件：

下载依赖npm i redux-thunk

### react-redux

[![TdRunK.png](https://s4.ax1x.com/2021/12/26/TdRunK.png)](https://imgtu.com/i/TdRunK)

react插件库，用来简化react应用中使用redux

react-redux将组件分成两大类：ui组件与容器组件

* ui组件
    * 只负责ui呈现，不带有任何业务逻辑
    * 通过props接收数据
    * 不使用任何redux的api
    * 一般保存在components文件夹下，也可以直接在容器组件中直接加工成容器组件
* 容器组件
    * 负责管理数据和业务逻辑
    * 使用redux的api
    * 一般保存在containers文件夹下

相关api

* provider

  作用：记所有组件都可以得到state数据

  ```js
  import React from 'react'
  import ReactDOM from "react-dom"
  import App from './App'
  import store from './redux/store'
  import {Provider} from 'react-redux'
  
  ReactDOM.render(
    /* 此处需要用Provider包裹App，目的是让App所有的后代容器组件都能接收到store */
    <Provider store={store}>
    	<App/>
    </Provider>,
    document.getElementById('root')
  )
  ```

* connect()()

  作用：用于包装ui组件生成容器组件

  connect(mapStateToProps,mapDispatchToprops)(ui组件)

  注意：

    * 默认传入state与dispatch
    * 省略dispatch直接传入action，自动调用dispatch

  **mapStateToProps**

  将外部数据state对象转换为ui组件的标签属性，返回一个对象

  返回对象的key就是传递给ui组件的props的key，value就作为传递ui组件props的value

  用于传递状态

  ```js
  function mapStateToProps(state) {
      return { count: state }
  }
  ```

  **mapDispatchToProps**

  将分发的action的函数转换为ui组件的标签属性，返回一个对象

  用于传递操作状态的方法

  ```js
  function mapDispatchToProps(dispatch) {
      return {
           jia:number => dispatch(createIncrementAction(number)),
    		jian:number => dispatch(createDecrementAction(number)),
    		jiaAsync:(number,time) => dispatch(createIncrementAsyncAction(number,time)),
      }
  }
  export default connect(mapStateToProps,mapDispatchToProps)(CountUI)
  // ------- 简化代码 -----
  export default connect(
  	state => ({ count: state.count, personCount: state.person.length }),
      { increment, decrement, incrementAsync }
  )(Count)
  ```

### 求和案例

#### redux mini版

1. 去除自身状态

2. src下建立：

   -redux

   -store.js

   -count_reducer.js

3. store.js

   ```js
   import { createStore } from 'redux'
   import countReducer from './count_reducer'
   
   export default createStore(countReducer)
   ```

4. count_reducer.js

   ```js
   const initState = 0
   export default function countReducer(preState=initState, action) {
     const { type, data } = action;
     switch (type) {
       case 'increment':
         return preState + data
       case 'decrement':
         return preState - data
       default:
         return preState
     }
   }
   ```

5. count/index.jsx

   ```jsx
   import store from '../../redux/store'  
   increment = () => {
       const { value } = this.selectNumber
       store.dispatch({ type: 'increment', data: value*1})
     }
     incrementIfOdd = () => {
       const { value } = this.selectNumber;
       const count = store.getState();
       if (count % 2 !== 0) {
         store.dispatch({ type: 'increment', data: value * 1 });
       }
     }
     <h1>当前求和为： {store.getState()}</h1>
   ```

6. index.js

   ```js
   import store from './redux/store'
   
   ReactDOM.render(<App />, document.getElementById('root'))
   
   // 监听
   store.subscribe(() => {
     ReactDOM.render(<App />, document.getElementById('root'))
   })
   ```

#### redux 完整版

新增文件：

1. count_action.js

   ```js
   import { INCREMENT, DECREMENT } from './constant'
   export const createIncrementAction = data => ({ type: INCREMENT, data })
   export const createDecrementAction = data => ({ type: DECREMENT, data })
   ```

2. constant.js

   ```js
   export const INCREMENT = 'increment'
   export const DECREMENT = 'decrement'
   ```

#### redux 异步action

延迟动作不想给组件自身，交给action管理

action返回一般对象为同步action,返回函数是异步action

使用redux-thunk,配置在store中

1. 修改count_action.js

   ```js
   // 异步action指action值为函数,异步action中一般会传入同步action,参数值为dispatch, 不是必须用的，在action中写异步时用，在组件中写异步方法不用
   export const createIncrementAsyncAction = (data, time) => {
     return (dispatch) => {
       setTimeout(() => {
         dispatch(createIncrementAction(data))
       }, time);
     }
   }
   ```

2. 修改store.js

   ```js
   import { createStore, applyMiddleware } from 'redux'
   import countReducer from './count_reducer'
   import thunk from 'redux-thunk'
   
   export default createStore(countReducer, applyMiddleware(thunk))
   ```

3. 修改count/index.jsx

   ```jsx
     incrementAsync = () => {
       const { value } = this.selectNumber;
       store.dispatch(createIncrementAsyncAction(value * 1, 500));
     }
   ```

#### react-redux基础版

1. ui组件内不能使用任何redux的api，只负责页面呈现
2. 容器组件：只负责和redux通信，将结果交给ui组件
3. 创建容器组件：react-redux的connect()(ui)方法
4. 容器组件中store是靠props传进去的

App.jsx

```jsx
// 导入容器组件
import Count from './containers/Count'
export default class App extends Component {
  render() {
    return (
      <div>
        <Count store={store}/>
      </div>
    )
  }
}
```

添加容器组件containers/Count/index.js

```jsx
import CountUI from '../../components/Count'
import { connect } from 'react-redux'
import { createIncrementAction,createDecrementAction, createIncrementAsyncAction } from '../../redux/count_action'
function mapStateToProps(state) {
  return { count: state };
}
function mapDispatchToProps(dispatch) {
  return {
    increment: (value) => dispatch(createIncrementAction(value)),
    decrement: (value) => dispatch(createDecrementAction(value)),
    incrementAsync: (value, time) => dispatch(createIncrementAsyncAction(value,time)),
  };
}
export default connect(mapStateToProps, mapDispatchToProps)(CountUI)
```

修改ui组件components/Count/index.js

```jsx
  increment = () => {
    const { value } = this.selectNumber
    this.props.increment(value*1)
  }
  decrement = () => {
    const { value } = this.selectNumber;
    this.props.decrement(value * 1);
  }
  incrementIfOdd = () => {
    const { value } = this.selectNumber;
    if (this.props.count % 2 !== 0) {
      this.props.increment(value*1)
    }
  }
  incrementAsync = () => {
    const { value } = this.selectNumber;
    this.props.incrementAsync(value*1,500);
  }
  <h1>当前求和为： {this.props.count}</h1>
```

#### react-redux优化

优化点：

- 容器组件和ui组件合并为一个文件
- 无需自己给容器组件传递store，给`<App/>`包裹一个`<Provider store={store}>`即可
- 使用react-redux后不用自己监听redux中状态的改变
- mapDispatchToProps可以简单的写成一个对象
- 一个组件使用redux经过哪几步？
    - 定义好ui组件
    - 引入connect生成一个容器组件并暴露
    - 在ui组件中通过this.props.xxx读取和操作状态

container/Count/index.js

```jsx
export default connect(
  (state) => ({ count: state }),
  // mapDispatchToProps一般写法
  // (dispatch) => ({
  //   increment: (value) => dispatch(createIncrementAction(value)),
  //   decrement: (value) => dispatch(createDecrementAction(value)),
  //   incrementAsync: (value, time) =>
  //     dispatch(createIncrementAsyncAction(value, time)),
  // })
  // mapDispatchToProps简写，写成对象，传入action自动调用dispatch
  {
    increment: createIncrementAction,
    decrement: createDecrementAction,
    incrementAsync: createIncrementAsyncAction
  }
)(CountUI);
```

src/index.js

使用react-redux无需再去监听redux状态改变

提供Provider给所有需要store的组件传入store

```js
import { Provider } from 'react-redux'

ReactDOM.render(
  <Provider store={store}>
    <App />
  </Provider>, 
  document.getElementById('root')
)

// 监听redux中状态的改变
// store.subscribe(() => {
//   ReactDOM.render(<App />, document.getElementById('root'))
// })
```

#### react-redux数据共享版

- 定义Person组件，与Count组件通过redux共享数据
- 为Person组件编写reducer,action，配置constant常量
- 使用combineReducer进行reducer合并
- 交给store的是总reducer，取出状态时取到位

containers/Person/index.js

```jsx
import React, { Component } from 'react';
import {nanoid} from 'nanoid';
import { connect } from 'react-redux'
import { createAddPersonAction } from '../../redux/actions/person'

class Person extends Component {
  addPerson = () => {
    const name = this.nameNode.value
    const age = this.ageNode.value
    const personobj = {id:nanoid(),name,age}
    this.props.addPerson(personobj)
  }
  render() {
    const personArr = this.props.person
    return (
      <div>
        <h2>我是person组件</h2>
        <h4>Count组件里的求和为：{this.props.count}</h4>
        <input ref={c => this.nameNode = c}type="text" />
        <input ref={c => this.ageNode = c}type="text" />
        <button onClick={this.addPerson}>增加</button>
        <ul>
          {
            personArr.map((person) => {
              return <li key={person.id}>{person.name}--{person.age}</li>
            })
          }
        </ul>
      </div>
    );
  }
}

export default connect(
  // 可以拿到Count组件里的值
  state => ({person: state.person,count:state.count}),
  { addPerson: createAddPersonAction }
)(Person)
```

actions/person.js

```js
import { ADD_PERSON } from '../constant'

export const createAddPersonAction = personObj => ({
  type: ADD_PERSON, data: personObj
})
```

reducer/person.js

```js
import { ADD_PERSON } from "../constant";

const initState = [{name: 'tom',age: 18, id: '001'}]
export default function personReducer(preState=initState, action) {
  const { type, data } = action
  switch (type) {
    case ADD_PERSON:
      return [data, ...preState]
    default:
      return preState
  }
}
```

redux/store.js

```js
import { createStore, applyMiddleware, combineReducers } from 'redux'
import countReducer from './reducers/count'
import personReducer from './reducers/person'
import thunk from 'redux-thunk'

// 合并后是一个对象，取用时使用state.xxx
const allReducers = combineReducers({
  count: countReducer,
  person: personReducer
})

export default createStore(allReducers, applyMiddleware(thunk))
```

#### redact-redux开发者工具

redux/store.js

```js
import { composeWithDevTools } from 'redux-devtools-extension'
export default createStore(allReducers, composeWithDevTools(applyMiddleware(thunk))
```

## 打包

`npm run build`打包项目

全局安装`npm i serve`，serve 项目目录测试运行。

或者搭建后台环境执行。

例nodejs环境：

```js
const express = require('express')
const proxy = require('http-proxy-middleware')

/*const options = {
    target: "http://localhost:8080",
    changeOrigin:true,
}

const apiProxy = proxy(options)*/

const app = express()

app.use(express.static(__dirname))
//app.use('/', apiProxy)
app.listen(3000)
```

## react 拓展

#### setState的2种写法

- setState(stateChange, [callback])

  stateChange是一个对象，callback是render后的回调

- setState(updater, [callback])

  updater是一个函数，接收state和props两个参数，返回对象

#### lazyLoad

路由组件lazyLoad

```jsx
import React, { Component,lazy,Suspense} from 'react'
// import Home from './Home'
const Home = lazy(()=> import('./Home') )
```

#### Hooks

* useState()

  ```
  State Hook让函数组件也可以有state状态, 并进行状态数据的读写操作
  语法: const [xxx, setXxx] = React.useState(initValue) 
  useState()说明:
      参数: 第一次初始化指定的值在内部作缓存
      返回值: 包含2个元素的数组, 第1个为内部当前状态值, 第2个为更新状态值的函数
  setXxx()2种写法:
      setXxx(newValue): 参数为非函数值, 直接指定新的状态值, 内部用其覆盖原来的状态值
      setXxx(value => newValue): 参数为函数, 接收原本的状态值, 返回新的状态值, 内部用其覆盖原来的状态值
  ```

* useEffect

  ```
  Effect Hook 可以让你在函数组件中执行副作用操作(用于模拟类组件中的生命周期钩子)
  React中的副作用操作:发ajax请求数据获取、设置订阅 / 启动定时器、手动更改真实DOM
  语法：
  userEffect(() => {
  	// 执行副操作
  	return () => { // 写了这里在组件卸载前执行
  	}
  },[statevalue]) // statevalue值变化引起执行，为空只初始化执行
  可以把 useEffect Hook 看做如下三个函数的组合：componentDidMount()、componentDidUpdate()、componentWillUnmount()
  ```

* useRef

  ```
  Ref Hook可以在函数组件中存储/查找组件内的标签或任意其它数据
  语法: const refContainer = useRef()
  作用:保存标签对象,功能与React.createRef()一样
  ```

#### Fragment

```
<Fragment><Fragment>
<></>
```

#### Context

> 一种组件间通信方式, 常用于【父组件】与【后代组件】间通信

```js
// 父组件
const XxxContext = React.createContext()  
<xxxContext.Provider value={数据}>
		子组件
</xxxContext.Provider>
// 后代组件
//第一种方式:仅适用于类组件 
static contextType = xxxContext  // 声明接收context
this.context // 读取context中的value数据
//第二种方式: 函数组件与类组件都可以
<xxxContext.Consumer>
    {
        value => ( // value就是context中的value数据
        要显示的内容
        )
    }
</xxxContext.Consumer>
```

#### 组件优化

* 重写shouldComponentUpdate()方法
* 使用PureComponent

#### render props

向组件内部动态传入带内容的结构(标签)

* 使用children props: 通过组件标签体传入结构

  ```
  <A>
    <B>xxxx</B>
  </A>
  {this.props.children}
  问题: 如果B组件需要A组件内的数据, ==> 做不到 
  ```

* render props

  ```
  <A render={(data) => <C data={data}></C>}></A>
  A组件: {this.props.render(内部state数据)}
  C组件: 读取A组件传入的数据显示 {this.props.data} 
  ```

#### 错误边界

用来捕获后代组件错误，渲染出备用页面

只能捕获后代组件生命周期产生的错误，不能捕获自己组件产生的错误

```js
// 生命周期函数，一旦后台组件报错，就会触发
static getDerivedStateFromError(error) {
    console.log(error);
    // 在render之前触发
    // 返回新的state
    return {
        hasError: true,
    };
}

componentDidCatch(error, info) {
    // 统计页面的错误。发送请求发送到后台去
    console.log(error, info);
}
```

