---
title: react知识学习
tags:
  - react
categories: react
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/team-lily-bug.png
date: 2023-02-13 16:00:00
---

![](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202302131650496.png)

一、组件基础
    1. React 事件机制
        <div onClick={this.handleClick.bind(this)}>点我</div>
        React并不是将click事件绑定到了div的真实DOM上，而是在document处监听了所有的事件，当事件发生并且冒泡到document处的时候，React将事件内容封装并交由真正的处理函数运行。这样的方式不仅仅减少了内存的消耗，还能在组件挂载销毁时统一订阅和移除事件。
        冒泡到document上的事件也不是原生的浏览器事件，而是由react自己实现的合成事件（SyntheticEvent）。因此如果不想要是事件冒泡的话应该调用event.preventDefault()方法，而不是调用event.stopPropgation()方法。
        事件的执行顺序为原生事件先执行，合成事件后执行。如果原生事件阻止冒泡，可能会导致合成事件不执行，因为需要冒泡到document 上合成事件才会执行。
    2. React的事件和普通的HTML事件有什么不同？
        react命名事件小驼峰
        事件处理react是函数
        react阻止事件必须调用preventDefault()
    3. React 组件中怎么做事件代理？它的原理是什么？
        React基于Virtual DOM实现了一个SyntheticEvent层（合成事件层），定义的事件处理器会接收到一个合成事件对象的实例，它符合W3C标准，且与原生的浏览器事件拥有同样的接口，支持冒泡机制，所有的事件都自动绑定在最外层上。
        React会把所有的事件绑定到结构的最外层，使用统一的事件监听器，这个事件监听器上维持了一个映射来保存所有组件内部事件监听和处理函数。
        React组件中，每个方法的上下文都会指向该组件的实例，即自动绑定this为当前组件。
    4. React 高阶组件、Render props、hooks 有什么区别，为什么要不断迭代
        这三者是目前react解决代码复用的主要方式
        高阶组件（HOC）是 React 中用于复用组件逻辑的一种高级技巧。缺点∶ hoc传递给被包裹组件的props容易和被包裹后的组件重名，进而被覆盖
        "render prop"是指一种在 React 组件之间使用一个值为函数的 prop 共享代码的简单技术。缺点：无法在 return 语句外访问数据、嵌套写法不够优雅
        Hook让你在不编写 class 的情况下使用 state 以及其他的 React 特性。解决了hoc的prop覆盖的问题，同时使用的方式解决了render props的嵌套地狱的问题。缺点：hook只能在组件顶层使用，不可在分支语句中使用。
        Hoc、render props和hook都是为了解决代码复用的问题，但是hoc和render props都有特定的使用场景和明显的缺点。
    5. 对React-Fiber的理解，它解决了什么问题？
        React V15 在渲染时，会递归比对 VirtualDOM 树，找出需要变动的节点，然后同步更新它们， 一气呵成。这个过程期间， React 会占据浏览器资源，这会导致用户触发的事件得不到响应，并且会导致掉帧，导致用户感觉到卡顿。
        Fiber 也称协程或者纤程。它和线程并不一样，协程本身是没有并发或者并行能力的（需要配合线程），它只是一种控制流程的让出机制。让出 CPU 的执行权，让 CPU 能在这段时间执行其他的操作。渲染的过程可以被中断，可以将控制权交回浏览器，让位给高优先级的任务，浏览器空闲后再恢复渲染。
    6. React.Component 和 React.PureComponent 的区别
        PureComponent表示一个纯组件，可以用来优化React程序，减少render函数执行的次数，从而提高组件的性能。
        在React中，当prop或者state发生变化时，可以通过在shouldComponentUpdate生命周期函数中执行return false来阻止页面的更新，从而减少不必要的render执行。React.PureComponent会自动执行 shouldComponentUpdate。
        使用pureComponent的好处：当组件更新时，如果组件的props或者state都没有改变，render函数就不会触发。省去虚拟DOM的生成和对比过程，达到提升性能的目的。这是因为react自动做了一层浅比较。
    10. 对componentWillReceiveProps 的理解
        该方法当props发生变化时执行，初始化render时不执行，在这个回调函数里面，你可以根据属性的变化，通过调用this.setState()来更新你的组件状态，旧的属性还是可以通过this.props来获取,这里调用更新状态是安全的，并不会触发额外的render调用。
    11. 哪些方法会触发 React 重新渲染？重新渲染 render 会做些什么？
        setState（）方法被调用
        父组件重新渲染
        重新渲染 render 会做些什么？Diff算法
    17. React中可以在render访问refs吗？为什么？
        不可以，render 阶段 DOM 还没有生成，无法获取 DOM。DOM 的获取需要在 pre-commit 阶段和 commit 阶段
    19. 在React中如何避免不必要的render？
        shouldComponentUpdate 和 PureComponent
        利用高阶组件
        使用 React.memo
二、数据管理
    12. React中怎么检验props？验证props的目的是什么？
        React为我们提供了PropTypes以供验证使用。当我们向Props传入的数据无效（向Props传入的数据类型和验证的数据类型不符）就会在控制台发出警告信息。它可以避免随着应用越来越复杂从而出现的问题。
三、生命周期
    1. React的生命周期有哪些？
        组件挂载阶段
            constructor
            getDerivedStateFromProps
            render
            componentDidMount
        组件更新阶段
            getDerivedStateFromProps
            shouldComponentUpdate
            render
            getSnapshotBeforeUpdate
            componentDidUpdate
        组件卸载阶段
            componentDidMount
        错误处理阶段
            componentDidCatch
    6. React中发起网络请求应该在哪个生命周期中进行？为什么？
        对于异步请求，最好放在componentDidMount中去操作，对于同步的状态改变，可以放在componentWillMount中，一般用的比较少。
        componentDidMount方法中的代码，是在组件已经完全挂载到网页上才会调用被执行，所以可以保证数据的加载。
四、组件通信
    1. 父子组件的通信方式？
        父到子props
        子到父props+回调
    2. 跨级组件的通信方式？
        props层层传递
        context
    3. 非嵌套关系组件的通信方式？
        自定义事件
        redux
        兄弟间找父节点，结合父子间通信
五、路由
六、Redux
    1. 对 Redux 的理解，主要解决什么问题
        Redux 提供了一个叫 store 的统一仓储库，组件通过 dispatch 将 state 直接传入store，不用通过其他的组件。并且组件通过 subscribe 从 store获取到 state 的改变。使用了 Redux，所有的组件都可以从 store 中获取到所需的 state，他们也能从store 获取到 state 的改变。
        单纯的Redux只是一个状态机，是没有UI呈现的，react- redux作用是将Redux的状态机和React的UI呈现绑定在一起，当你dispatch action改变state的时候，会自动更新页面。
    2. Redux 原理及工作流程
        工作流程：
            const store= createStore（fn）生成数据;
            action: {type: Symble('action01), payload:'payload' }定义行为;
            dispatch发起action：store.dispatch(doSomething('action001'));
            reducer：处理action，返回新的state;
    3. Redux 中异步的请求怎么处理
        使用react-thunk中间件
        使用redux-saga中间件
    4. Redux 怎么实现属性传递，介绍下原理
        react-redux 数据传输∶ view-->action-->reducer-->store-->view。看下点击事件的数据是如何通过redux传到view上：
            view 上的AddClick 事件通过mapDispatchToProps 把数据传到action ---> click:()=>dispatch(ADD)
            action 的ADD 传到reducer上
            reducer传到store上 const store = createStore(reducer);
            store再通过 mapStateToProps 映射穿到view上text:State.text
    9. Redux 和 Vuex 有什么区别
        Vuex改进了Redux中的Action和Reducer函数，以mutations变化函数取代Reducer，无需switch，只需在对应的mutation函数里改变state值即可
        Vuex由于Vue自动重新渲染的特性，无需订阅重新渲染函数，只要生成新的State即可
        Vuex数据流的顺序是∶View调用store.commit提交对应的请求到Store中对应的mutation函数->store改变（vue检测到数据变化自动渲染）
七、Hooks
    1. 对 React Hook 的理解，它的实现原理是什么
        为了能让开发者更好的的去编写函数式组件
    2. 为什么 useState 要使用数组而不是对象
        useState 返回的是 array 而不是 object 的原因就是为了降低使用的复杂度
    3. React Hooks 解决了哪些问题
        在组件之间复用状态逻辑很难
        复杂组件变得难以理解
        难以理解的 class
    4. React Hook 的使用限制有哪些
        不要在循环、条件或嵌套函数中调用 Hook；
        在 React 的函数组件中调用 Hook。
    6. React Hooks在平时开发中需要注意的问题和原因
        不要在循环，条件或嵌套函数中调用Hook，必须始终在 React函数的顶层使用Hook
        使用push直接更改数组无法获取到新值，应该采用解构方式
        useState设置状态的时候，只有第一次生效，后期需要更新状态，必须通过useEffect
        善用useCallback
        不要滥用useContext
    7. React Hooks 和生命周期的关系？
        Hooks 组件（使用了Hooks的函数组件）有生命周期，而函数组件（未使用Hooks的函数组件）是没有生命周期的。
        constructor -> useState
        getDerivedStateFromProps -> useState update
        shouldComponentUpdate -> useMemo
        render -> render
        componentDidMount -> useEffect
        componentDidUpdate -> useEffect
        componentWillUnmount -> useEffect返回的函数
八、虚拟DOM
    React 与 Vue 的 diff 算法有何不同？
        vue对比节点，如果节点元素类型相同，但是className不同，认为是不同类型的元素，会进行删除重建，但是react则会认为是同类型的节点，只会修改节点属性。
        vue的列表比对采用的是首尾指针法，而react采用的是从左到右依次比对的方式
九、其他
    5. 对 React 和 Vue 的理解，它们的异同
        相同之处：
            都将注意力集中保持在核心库，而将其他功能如路由和全局状态管理交给相关的库
            都有自己的构建工具
            都使用了虚拟dom提升性能
            都有props
            都有组件化应用
        不同之处：
            Vue默认支持数据双向绑定，而React一直提倡单向数据流
            虚拟domvue可以更快的计算vdom差异，不必重新渲染整个树，react每当应用的状态被改变时，全部子组件都会重新渲染。
            vue使用模版，react使用jsx
            vue使用数据劫持，react使用比较引用
            react扩展使用高阶组件，vue通过mixins
