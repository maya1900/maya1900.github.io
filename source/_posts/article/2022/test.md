---
title: 前端测试
date: 2022-06-27
tags:
  - jest
  - 测试
categories: 测试
cover: https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/202205050819751.gif
---

# 自动化测试

让软件测试代替人工测试，提高代码质量。

## 好处：

- 快速定位 bug
- 有测试的代码，质量比较高
- 提高代码可维护性

什么样的代码需要测试？开发类库、组件库、框架等。

# 分类

- 黑盒测试(功能测试)、白盒测试(代码的具体逻辑)
- 单元测试(以最小的单元实现测试，如方法、组件、模块等)、集成测试(组合在一起进行测试)
- TDD(测试驱动开发，先写测试再写逻辑)、BDD(行为驱动开发，根据用户行为进行测试)

# 常见的测试框架

- Karma 把测试跑在真正的浏览器上，可以测试 UI 组件
- mocha 提供了一个测试环境，断言库 chai，sinon 模拟一些假的方法
- jest 基于 jsdom，用 js 对象模拟浏览器环境，缺点不能测试样式，0 配置

# 第一个测试用例

```JavaScript
// ./src/1.parser.js
const parser = (str) =>{
    const obj = {};
    str.replace(/([^&=]+)=([^&=]+)/g,function () {
        obj[arguments[1]] = arguments[2]
    })
    return obj;
}
const stringify = (obj) =>{
    const arr = [];
    for(let key in obj){
        arr.push(`${key}=${obj[key]}`);
    }
    return arr.join('&')
}
// export 导出的是接口 供别人使用的接口  要通过解构的方式去获取
// export default 导出具体的值
export {
    parser,
    stringify
}
```

```JavaScript
// ./1.parser.test.js

// 测试文件默认一般以.test.js 结尾 .spec.js 结尾
import {
    parser,
    stringify
} from './src/1.parser'
// describe  套件  =》 it 一堆用例
// 默认jest只支持 node语法 babel  babel-jest

describe('测试parser', () => {
    it('测试parser是否能正常解析', () => {
        expect(parser('a=1&b=2&c=3')).toEqual({
            a: "1",
            b: "2",
            c: "3"
        })
    })
})

describe('测试stringify', () => {
    it('测试stringify是否能正常解析', () => {
        expect(stringify({a:1,b:2})).toEqual("a=1&b=2")
    })
})

```

1. 安装 jest，`npm i -D jest`
2. 安装 babel， `npm i -D @babel/presets-env`，配置文件.babelrc

```JavaScript
{
    "presets": [
        ["@babel/preset-env",{
            "targets":{"node":"current"}
        }]
    ]
}
```

# 常用匹配器

```JavaScript
it('测试相等情况  （全等） （长得一样） 是不是真的 是不是假的',()=>{
    expect(1+1).toBe(2); // ===
    expect({name:'zf'}).toEqual({name:'zf'}); // 比较长得是否一致 toEqual
    expect(true).toBeTruthy();
    expect(false).toBeFalsy();
})

it('测试不相等 （大于 小于 大于等于 小于等于）',()=>{
    expect(1+1).not.toBe(3);
    expect(1+1).toBeLessThan(3);
    expect(1+1).toBeGreaterThanOrEqual(0);
})

it.only('是否包含 是否匹配',()=>{ // it.only只测试当前文件的这个用例
    expect('hello').toContain('o');
    expect('hello').toMatch(/hello/)
})
```

```JavaScript
// npx jest --watchAll
// › Press f to run only failed tests.
//  › Press o to only run tests related to changed files. 如果你有git 每次提交后
//  › Press p to filter by a filename regex pattern.
//  › Press t to filter by a test name regex pattern.
//  › Press q to quit watch mode.
//  › Press Enter to trigger a test run.
```

# jsdom 操作

```JavaScript
// ./src/2.dom.js
const addNode = (node,parent)=>{
    parent.appendChild(node)
}

const removeNode = (node) =>{
    node.parentNode.remove(node);
}

export {
    addNode,
    removeNode
}
```

```JavaScript
// ./2.dom.test.js
import {addNode,removeNode} from './src/2.dom';

it('测试能否正常添加节点',()=>{
    // jsdom 假的dom
    document.body.innerHTML = '<div id="wrapper"></div>';
    let button = document.createElement('button');
    let wrapper = document.querySelector('#wrapper');
    addNode(button,wrapper);
     wrapper = document.querySelector('#wrapper');
    let btn =wrapper.querySelector('button');
    expect(btn).not.toBeNull()
});

// 不停的去测试对应的逻辑，单元测试就是测试某个方法是否能达到我的预期效果

it('测试是否能够正常删除',()=>{
    document.body.innerHTML = '<div id="wrapper"><button id="button"></button></div>';
    let btn = document.querySelector('#button');
    expect(btn).not.toBeNull()
    removeNode(btn);
    btn = document.querySelector('#button');
    expect(btn).toBeNull()
})

```

# 异步测试

默认不等待异步后再测试。

1. 使用 done
2. 使用 jest.useFakeTimers()替换掉定时器

```JavaScript
// ./src/3.async.js
const getDataByCallback = (cb) => {
    setTimeout(() => {
        cb({
            name: 'jw'
        })
    }, 1000);
}

const getDataByPromise = () => {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve({
                name: 'jw'
            })
        }, 1000);
    })
}

export {
    getDataByCallback,
    getDataByPromise
}

```

```JavaScript
// ./3.async.test.js

// --watchAll = 监控全部 w
// --watch = o 只监控变化的文件
import {
    getDataByCallback,
    getDataByPromise
} from './src/3.async'
// 1.异步的回调方式可以传入done 函数 什么时候完成什么时候调用
it('测试回调函数 获取数据', (done) => {
    //jest.useFakeTimers(); // 使用假的定时器
    getDataByCallback((data) => {
        expect(data).toEqual({
            name: 'jw'
        });
        done()
    })
    // jest.runAllTimers(); // 运行所有的定时器
    // jest.runOnlyPendingTimers(); // 只运行当前等待队列的一个
    // jest.advanceTimersByTime(10000)
})
// 如果是promise done 、 async+await
it('测试promise获取数据', async () => {
    let data = await getDataByPromise()
    expect(data).toEqual({
        name: 'jw'
    });
});

```

# mock 函数

```JavaScript
// ./src/4.fn.js

export const map = (arr,fn) =>{
    for(let i = 0 ; i< arr.length;i++){
        fn(arr[i],i);
    }
}
```

```JavaScript
// ./4.fn.js

import {map} from './src/4.fn';
it('测试map方法',()=>{
    // jest.fn 模拟一个方法，让用户调用，用户调用这个函数的所有信息 都会被记录到 当前的mock属性上
    let fn = jest.fn(); // 模拟函数 可以记录被执行的过程
    map([1,2,3],fn);
    // expect(fn.mock.calls.length).toBe(3);
    expect(fn.mock.calls[0][0]).toBe(1)
    expect(fn.mock.calls[0][1]).toBe(0)

    expect(fn).toHaveBeenCalled();
    expect(fn).toHaveBeenCalledTimes(3);
})

```

# 覆盖率

生成 jest 配置文件，`npx jest —init`

执行时`npm run jest —converage`

# mock 接口

1. 在文件的当前目录建立名为**mocks**的文件夹，在里面新建同名文件，编写返回方法，适用于整个文件是都是接口的情况，如有真实方法，可用 jest.requireActual 做替换；
2. 只 mock 某个方法，mock 掉某个包

```JavaScript
// ./src/6.ajax.js
import axios from 'axios';

export const fetchData = ()=>{
    return axios.get('/user'); // 获取用户数据  // ['张三','李四]
}

export const sum = (a,b)=>{
    return a+b
}
```

```JavaScript
// ./6.ajax.test.js

// jest.mock('./src/6.ajax'); // 替换整个文件

import {fetchData,sum} from './src/6.ajax';
// let {sum} = jest.requireActual('./src/6.ajax')


it('测试能否正常获取用户数据',async ()=>{
    let r = await fetchData();

    expect(r).toEqual(['张三','李四'])
})

it('测试求和函数', ()=>{
    expect(sum(1,1)).toBe(2)
})

```

```JavaScript
// ./src/__mocks__/6.ajax.js
export const fetchData = () => {
    return new Promise((resolve,reject)=>resolve(['张三','李四']))
};

```

```JavaScript
// ./src/__mocks__/ajax.js
export default {
    get(url) {
        if (url == '/user') {
            return new Promise((resolve) => resolve(['张三', '李四']))
        }
    }
}

```
