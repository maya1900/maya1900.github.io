---
title: vue3里的工具函数
date: 2021-08-29
tags:
  - vue
  - vue3
categories: vue
cover: https://z3.ax1x.com/2021/08/29/hGX38I.jpg
---

ts 转 js,学习。

```js
const EMPTY_OBJ = (process.env.NODE_ENV !== 'production')
    ? Object.freeze({})
    : {};

// Object.freeze 冻结对象的最外层无法修改
const EMPTY_OBJ_1 = Object.freeze({});
EMPTY_OBJ_1.name = 'sun';
console.log(EMPTY_OBJ_1.name); // undefined

const EMPTY_OBJ_2 = Object.freeze({ props: { mp: 'hello'}});
EMPTY_OBJ_2.props.name = 'sun';
EMPTY_OBJ_2.props2 = 'props2';
console.log(EMPTY_OBJ_2.props.name); // sun
console.log(EMPTY_OBJ_2.props2); // undefined
console.log(EMPTY_OBJ_2); // { props: { mp: 'hello', name: 'sun' } }

console.log('--------------------')

const EMPTY_ARR = (process.env.NODE_ENV !== 'production')
    ? Object.freeze([]) : [];

// EMPTY_ARR.push(1); // 报错
EMPTY_ARR.length = 3;
console.log(EMPTY_ARR.length) // 0

console.log('--------------------')

NOOP 空函数
使用场景： 1.方便判断 2.方便压缩
const NOOP = () => { }

const instance = {
  render: NOOP
}

const dev = true;
if (dev) {
  instance.render = function () {
    console.log('render');
  }
}

if (instance.render === NOOP) {
  console.log('i')
}

console.log('--------------------')

// NO 永远返回false

const NO = () => false

console.log('--------------------')

// isOn 判断字符串以on开头，并且on后首字母大写
const onRE = /^on[^a-z]/;
const isOn = key => onRE.test(key);

console.log(isOn('onChange')); // true
console.log(isOn('onchange')); // false

console.log('--------------------')

const isModelListener = key => key.startsWith('onUpdate')

isModelListener('onUpdate:change')

console.log('--------------------')

// extend 合并
const extend = Object.assign;

const data = { name: 'sun' };
const data2 = extend(data, { age: 18, name: 'moon' });
console.log(data); // { name: 'moon', age: 18 }
console.log(data2); // { name: 'moon', age: 18 }

console.log('--------------------')

 // remove 移除数组的一项
const remove = (arr, el) => {
  const i = arr.indexOf(el);
  if (i > -1) {
    arr.splice(i, 1);
  }
}

const arr = [1,2,3];
remove(arr, 3);
console.log(arr) // [1,2]

console.log('--------------------')

hasOwn 是不是自己本身的属性
const hasOwnProperty = Object.prototype.hasOwnProperty;
const hasOwn = (val, key) => hasOwnProperty.call(val, key);

let a = hasOwn({ __proto__: { a: 1 }}, 'a');
let b = hasOwn({ a: undefined }, 'a');

console.log(a, b); // false true

console.log('--------------------')
const toTypeString = val => Object.prototype.toString.call(val)
// isArray 判断是否数组
const isArray = Array.isArray
// isMap 判断是否是Map对象
const isMap = val => toTypeString(val) === '[object Map]'

const map = new Map();
const o = { p: 'Hello World' }
map.set(o, 'content');
map.get(o);
console.log(isMap(map)) // true

// isSet 判断是否Set对象
const isSet = val => toTypeString(val) === '[object Set]'

// isDate 判断是不是date对象
 const isDate = val => val instanceof Date;
 console.log(isDate(new Date()), 121) // true
 console.log(isDate({ __proto__: new Date() })) // true 不准确

 // isFunction 判断是不是函数
const isFunction = val => typeof val === 'function';
// isString 判断 是不是字符串
const isString = val => typeof val === 'string';
// isSymbol 判断是不是Symbol
const isSymbol = val => typeof val === 'symbol';
// isObject 判断 是不是对象
// 判断不为null的原因是typeof null 其实是object
const isObject = val => val!== null && typeof val === 'object'

// isPromise 判断是不是promise
const isPromise = val => {
  return isObject(val) && isFunction(val.then) && isFunction(val.catch);
}
const p1 = new Promise((resolve, reject) =>{
  resolve('sun');
});
console.log(isPromise(p1), 141) // true

// objectToString 对象转字符串
const objectToString = Object.prototype.toString;

// toRawType 对象转字符串 截取后几位
const toRawType = val => {
  return Object.prototype.toString.call(val).slice(8, -1);
}
console.log(toRawType(''), 150) // 'String

// isPlainOject 判断是不是纯粹的对象
const isPlainObject = val => {
  return toTypeString(val) === '[object Object]'
}

// isIntegerKey 判断是不是数字型的字符串key型
const isIntegerKey = key => isString(key) &&
    key !== 'NaN' &&
    key[0] !== '-' &&
    '' + parseInt(key, 10) === key;

console.log(isIntegerKey('a'), 163); // false
console.log(isIntegerKey('1'), 164); // true
'abc'.charAt(0) // a
// charAt 与数组形式不同的是，取不到值会返回‘’，而数组形式取清台值会返回undefined

// makeMap && isReservedProp
function makeMap(str, expectsLowerCase) {
  const map = Object.create(null);
  const list = str.split(',');
  for (let i = 0; i < list.length; i++) {
    map[list[i]] = true;
  }
  return expectsLowerCase ? val => !!map[val.toLowerCase()] : val => !!map[val];
}
const isReservedProp = makeMap(',key,ref,' +
    'onVnodeBeforeMount,onVnodeMounted,' +
    'onVnodeBeforeUpdate,onVnodeUpdated,' +
    'onVnodeBeforeUnmount,onVnodeUnmounted');

console.log(isReservedProp('key'), 182)

//cacheStringFunction 缓存
const cacheStringFunction = fn => {
  const cache = Object.create(null);
  return (str => {
    const hit = cache[str];
    return hit || (cache[str] = fn(str))
  })
}

// hasChanged 判断是不是有变化
const hasChanged = (val,oldVal) => val !== oldVal && (val === val || oldVal === oldVal)

// invokeArrayFns 执行数组里的函数
const invokeArrayFns = (fns, arg) => {
  for (let i = 0; i < fns.length; i++) {
    fns[i](arg);
  }
};

const arr = [
  function(val) {
    console.log(val + ' is me');
  },
  function (val) {
    console.log("I'm " + val)
  }
]
invokeArrayFns(arr, 'sun')

// def 定义对象属性
 const def = (obj, key, value) => {
   Object.defineProperty(obj, key, {
     configurable: true,
     enumerable: false,
     value
   });
 };

 // value --- 属性返回值
 // writable --- 属性是否可写
 // enumerable --- 属性是否枚举
 // configurable --- 属性可否删除
 // set() --- 更新调用函数
 // get() --- 获取调用函数

// 数据描述符（enumerable,configurable,value,writable） 与
// 存取描述符(enumerable,configurable,set(),get()) 是互斥关系

// 转数字
const toNumber = val => {
  const n = parseFloat(val);
  return isNaN(n) ? val : n;
}
console.log(toNumber('111'), 237) // 111
console.log(toNumber('a111'), 238) // a111

// 全局对象getGlobalThis
let_globalThis;
const getGlobalThis = () => {
  return (_globalThis ||
    (_globalThis =
      typeof globalThis !== 'undefined'
          ? globalThis
          : typeof self !== 'undefined'
              ? self
              : typeof window !== 'undefined'
                  ? window
                  : typeof global !== 'undefined'
                      ? global
                      : {}));
};

// 有globalThis用它
// 有self用它，web worker没有window对象，可用self访问全局对象
// 有window用window
// 有global用它，node环境下使用global
// 都没有返回空对象，可能在小程序环境下

```
