---
title: React-hook练手小项目--待办事件
date: 2021-12-28
tags:
  - 项目 
categories: 项目
cover: https://s4.ax1x.com/2021/12/29/TgxOSK.jpg
---

## React-hook练手小项目--待办事件

### 一、学到了什么？

1. 写代码前的规划
2. useState()/useRef()/useCallback()/useEffect()的使用
3. 父子组件传值
4. 自定义组件双标签的写法
5. 使用useEffect()的先后顺序
6. 条件渲染

### 二、具体写法

1. 写代码前考虑可以分为几个模块，分个组件，组件之间的关系，如何排版

2. useState

   ```js
   // 定义变量，改变变量的方法，初始值
   const [todoList, setTodoList] = useState([])
   ```

   useRef

   ```jsx
   // 定义
   const inputRef = useRef();
   <input ref={inputRef} type="text"></input>
   // 获取值
   inputRef.current.value
   ```

   useEffect

   ```js
   // 在页面加载完成的时候以及数据更新的时候,触发执行
   // 第二个参数，当依赖变化的时候执行
   useEffect(() => {
       sessionStorage.setItem('todoData', JSON.stringify(todoList))
   }, [todoList])
   ```

   useCallback

   ```js
   // useCallback缓存todoList，只有todlList发生变化再次渲染，减少不必要的渲染问题
   const openCheckModal = useCallback(id => {
       setCurrentData(() => todoList.filter(item => item.id === id)[0])
       setShowCheckModal(true)
   }, [todoList])
   ```

3. 父子通讯

   ```jsx
   // 父：
   // isInputShow属性传给子组件
   <AddInput 
       isInputShow={ isInputShow }
       addItem={addItem}
       />
   // 定义方法
   const addItem = () => {}
   // 子：
   // 子组件使用了addItem方法并传递给父组件
   const { isInputShow, addItem } = props,
   ```

4. 双标签的写法

   ```jsx
   // 双标签封装通过this.props.children来获取标签内的元素，主要目的就是能嵌套标签
   // Modal 基础组件
   function Modal (props) {
     const { isShowModal, modalTitle, children } = props
     return (
       <>
         {
           isShowModal
           ?
             (
               <div className="modal">
                 <div className="inner">
                   <div className="m-header">{modalTitle}</div>
                   <div className="content-wrapper">
                     {children}
                   </div>
                 </div>
               </div>
             )
           :
           ""
         }
       </>
     )
   }
   // CheckModal包装组件
   function CheckModal (props) {
     const { isShowCheckModal, data, closeModal } = props
     return (
       <Modal
         isShowModal={isShowCheckModal}
         modalTitle="查看事件"
       >
         <p className="topic">时间：{formatDateTime(data.id)}</p>
         <p className="topic">内容：{data.content}</p>
         <p className="topic">时间：{data.completed ? '已完成' : '未完成'}</p>
         <button className='btn btn-primary confirm-btn' onClick={closeModal}>确定</button>
       </Modal>
     )
   }
   ```

5. 使用useEffect()的先后顺序

   初始化执行useEffect依次执行，需要考虑不同顺序下的不同结果

6. 条件渲染

   上面例子。