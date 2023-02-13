---
title: typescript类型体操
date: 2022-09-12
tags:
  - ts
  - typescript
  - 类型体操
categories: ts
cover: https://cdn.jsdelivr.net/gh/maya1900/pic@master/img/202205050819751.gif
---

https://splendid-attraction-545.notion.site/ts-6e501c4a33b0402e8b910f856c394e3f

# why

TypeScript 给 JavaScript 增加了一套类型系统，但并没有改变 JS 的语法，只是做了扩展，是 JavaScript 的超集。

这套类型系统支持泛型，也就是类型参数，有了一些灵活性。而且又进一步支持了对类型参数的各种处理，也就是类型编程，灵活性进一步增强。

**对传入的类型参数（泛型）做各种逻辑运算，产生新的类型，这就是类型编程。**

现在 TS 的类型系统是图灵完备的，JS 可以写的逻辑，用 TS 类型都可以写。

但是很多类型编程的逻辑写起来比较复杂，因此被戏称为类型体操。

一段代码

![https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202210112300363.png](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202210112300363.png)

# 类型运算

### 条件：`extends ?:`

### 推导：`infer`

### 联合：`|`

### 交叉：`&`

### 映射类型

# 套路：模式匹配做提取

**Typescript 类型的模式匹配是通过 extends 对类型参数做匹配，结果保存到通过 infer 声明的局部类型变量里，如果匹配就能从该局部变量里拿到提取出的类型。**

```tsx
type GetValueType<P> = P extends Promise<infer Value> ? Value : never;

type p = Promise<'tom'>

type GetValueRes = GetValueType<p>// type GetValueRes = "tom"

```

## 数组类型

```tsx
type GetFirst<Arr extends unknown[]> = Arr extends [infer First, ...unknown[]] ? First : never;

type arr = [1,2,3]

type GetFirstRes = GetFirst<arr> // type GetFirstRes = 1

type GetRest<Arr extends unknown[]> = Arr extends [] ? [] : Arr extends [unknown, ...infer Rest] ? Rest : never;

type GetRestRes = GetRest<arr> // type GetRestRes = [2, 3]

```

## 字符串类型

```tsx
type RelplaceStr<Str extends string, From extends string, To extends string> = Str extends `${infer Prefix}${From}${infer Suffix}` ? `${Prefix}${To}${Suffix}` : Str

type ReplaceRes = RelplaceStr<'he is a ? boy', '?', 'good'> // ype ReplaceRes = "he is a good boy"

```

```tsx
type TrimStrRight<Str extends string> = Str extends `${infer Rest}${' ' | '\\n' | '\\t' }` ? TrimStrRight<Rest> : Str;

type TrimStrLeft<Str extends string> = Str extends `${' ' | '\\n' | '\\t' }${infer Rest}` ? TrimStrLeft<Rest> : Str;

type TrimStr<Str extends string> = TrimStrRight<TrimStrLeft<Str>>

type TrimRes = TrimStr<' tom '> // ype TrimRes = "tom"

```

## 函数

```tsx
type GetParameters<Func extends Function> = Func extends (...args: infer Args) => unknown ? Args : never

type ParamRes = GetParameters<(name: string, age: number) => string> // type ParamRes = [name: string, age: number]

```

## 构造器

```tsx
interface Person {
	name: string;
}

interface PersonConstructor {
	new(name: string): Person;
}

type GetInstanceType<ConstructorType extends new (...args: any) => any> = ConstructorType extends new (...args: any) => infer InstanceType ? InstanceType : any;

type GetInstanceTypeRes = GetInstanceType<PersonConstructor> // type GetInstanceTypeRes = Person

```

## 索引类型

```tsx
type GetRefProps<Props> = 'ref' extends keyof Props ? Props extends { ref?: infer Value | undefined} ? Value : never : never

type GetRefPropsRes = GetRefProps<{ ref?: 1, name: 'tom' }> // type GetRefPropsRes = 1

```

# 套路：重新构造做变换

**TypeScript 的 type、infer、类型参数声明的变量都不能修改，想对类型做各种变换产生新的类型就需要重新构造。**

```tsx
type Zip2<One extends unknown[], Other extends unknown[]> = One extends [
  infer OneFirst,
  ...infer OneRest
]
  ? Other extends [infer OtherFirst, ...infer OtherRest]
    ? [[OneFirst, OtherFirst], ...Zip2<OneRest, OtherRest>]
    : []
  : [];
type Zip2Res = Zip2<[1, 2, 3, 4], ['a', 'b', 'c', 'd']>; // type Zip2Res = [[1, "a"], [2, "b"], [3, "c"], [4, "d"]]
```

```tsx
type FilterByValueType<Obj extends Record<string, any>, ValueType> = {
  [Key in keyof Obj as Obj[Key] extends ValueType ? Key : never]: Obj[Key];
};
interface Person {
  name: string;
  age: number;
  hobby: string[];
}
type FilterRes = FilterByValueType<Person, string | number>; // type FilterRes = {name: string;age: number;}
```

# 套路：递归复用做循环

**递归是把问题分解为一系列相似的小问题，通过函数不断调用自身来解决这一个个小问题，直到满足结束条件，就完成了问题的求解。**

## Promise 的递归复用

```tsx
type DeepPromiseValueType<P extends Promise<unknown>> = P extends Promise<
  infer ValueType
>
  ? ValueType extends Promise<unknown>
    ? DeepPromiseValueType<ValueType>
    : ValueType
  : never;
type ttt = Promise<Promise<Promise<Record<string, any>>>>
type DeepPromiseRes = DeepPromiseValueType<ttt> // type DeepPromiseRes = {[x: string]: any;}
```

## 数组类型的递归

### ReverseArr

```tsx
type ReverseArr<Arr extends unknown[]> = Arr extends [
  infer First,
  ...infer Rest
]
  ? [...ReverseArr<Rest>, First]
  : Arr;
type ReverseArrRes = ReverseArr<[1, 2, 3]>; // type ReverseArrRes = [3, 2, 1]
```

### Includes

```tsx
type IsEqual<A, B> = (A extends B ? true : false) &
  (B extends A ? true : false);
type Includes<Arr extends unknown[], FindItem> = Arr extends [
  infer First,
  ...infer Rest
]
  ? IsEqual<First, FindItem> extends true
    ? true
    : Includes<Rest, FindItem>
  : false;
type IncludesRes = Includes<[1, 2, 3], 2>; // type IncludesRes = true
```

### BuildArray

```tsx
type BuildArray<
  Length extends number,
  Ele = unknown,
  Arr extends unknown[] = []
> = Arr['length'] extends Length ? Arr : BuildArray<Length, Ele, [...Arr, Ele]>;
type BuildArrRes = BuildArray<3, number>; // type BuildArrRes = [number, number, number]
```

**在类型体操里，遇到数量不确定的问题，就要条件反射的想到递归。**

## 对象类型的递归

### DeepReadonly

```tsx
type DeepReadonly<Obj extends Record<string, any>> = Obj extends any
  ? {
      readonly [Key in keyof Obj]: Obj[Key] extends object
        ? Obj[Key] extends Function
          ? Obj[Key]
          : DeepReadonly<Obj[Key]>
        : Obj[Key];
    }
  : never;
type obj = {
  a: {
    b: {
      c: 'c';
      d: () => 'd';
    };
  };
};
type DeepReadonlyRes = DeepReadonly<obj>;
// type DeepReadonlyRes = {
//   readonly a: {
//       readonly b: {
//           readonly c: 'c';
//           readonly d: () => 'd';
//       };
//   };
// }
```

# 套路：数组长度做计数

**TypeScript 类型系统中没有加减乘除运算符，但是可以通过构造不同的数组然后取 length 的方式来完成数值计算，把数值的加减乘除转化为对数组的提取和构造。**

## 数组长度做计数

数组类型取 length 就是数值: `type num1 = [unknown]['length'] // type num1 = 1`

### Add

构造数组：[BuildArray](https://www.notion.so/ts-6e501c4a33b0402e8b910f856c394e3f)

构造两个数组，然后合并成一个，取 length。

```tsx
type Add<Num1 extends number, Num2 extends number> = [
  ...BuildArray<Num1>,
  ...BuildArray<Num2>
]['length'];
type AddRes = Add<12, 13>; // type AddRes = 25
```

### Subtract

减法是从数值中去掉一部分，可以通过数组类型的提取来做。

```tsx
type Subtract<
  Num1 extends number,
  Num2 extends number
> = BuildArray<Num1> extends [...arr1: BuildArray<Num2>, ...arr2: infer Rest]
  ? Rest['length']
  : never;
type SubRes = Subtract<13, 6> // type SubRes = 7
```

### Multiply

1 乘以 5 就相当于 1 + 1 + 1 + 1 + 1，也就是说乘法就是多个加法结果的累加。

那么我们在加法的基础上，多加一个参数来传递中间结果的数组，算完之后再取一次 length 就能实现乘法：

```tsx
type Multiply<
  Num1 extends number,
  Num2 extends number,
  ResultArr extends unknown[] = []
> = Num2 extends 0
  ? ResultArr['length']
  : Multiply<Num1, Subtract<Num2, 1>, [...BuildArray<Num1>, ...ResultArr]>;
type MulRes = Multiply<1, 1> // type MulRes = 1
```

解析：

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/65fa43d2-177b-4e92-b1b3-78b38d366d58/Untitled.png)

![https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202210140043404.png](https://may-data.oss-cn-hangzhou.aliyuncs.com/image/202210140043404.png)

### Divide

除法的实现就是被减数不断减去减数，直到减为 0，记录减了几次就是结果。

```tsx
type Divide<
  Num1 extends number,
  Num2 extends number,
  CountArr extends unknown[] = []
> = Num1 extends 0
  ? CountArr['length']
  : Divide<Subtract<Num1, Num2>, Num2, [unknown, ...CountArr]>;
type DivideRes = Divide<12, 6>; // type DivideRes = 2
```

## 数组长度实现计数

### StrLen

```tsx
type StrLen<
  Str extends string,
  CountArr extends unknown[] = []
> = Str extends `${string}${infer Rest}`
  ? StrLen<Rest, [...CountArr, unknown]>
  : CountArr['length'];
type StrLenRes = StrLen<'I am a boy'>; // type StrLenRes = 10
```

### GreaterThan

```tsx
type GreaterThan<
  Num1 extends number,
  Num2 extends number,
  CountArr extends unknown[] = []
> = Num1 extends Num2
  ? false
  : CountArr['length'] extends Num2
  ? true
  : CountArr['length'] extends Num1
  ? false
  : GreaterThan<Num1, Num2, [...CountArr, unknown]>;
type GreaterThanRes = GreaterThan<2, 3>; // type GreaterThanRes = false
```

# 套路：联合分散可简化

**当类型参数为联合类型，并且在条件类型左边直接引用该类型参数的时候，TypeScript 会把每一个元素单独传入来做类型运算，最后再合并成联合类型，这种语法叫做分布式条件类型。**

### IsUnion

```tsx
type IsUnion<A, B = A> = A extends A ? ([B] extends [A] ? false : true) : never;
```

**当 A 是联合类型时：**

- **A extends A 这种写法是为了触发分布式条件类型，让每个类型单独传入处理的，没别的意义。**
- **A extends A 和 [A] extends [A] 是不同的处理，前者是单个类型和整个类型做判断，后者两边都是整个联合类型，因为只有 extends 左边直接是类型参数才会触发分布式条件类型。**

```tsx
type union = ['aa', 'bb'][number] // type union = "aa" | "bb"
// 数组类型取出所有的数字索引对应的值，然后组成联合类型
```

### AllCombinations

```tsx
type Combination<A extends string, B extends string> =
  | A
  | B
  | `${A}${B}`
  | `${B}${A}`;
type CombinationRes = Combination<'a', 'b'>;
type AllCombinations<A extends string, B extends string = A> = A extends A
  ? Combination<A, AllCombinations<Exclude<B, A>>>
  : never;
type AllCombinationsRes = AllCombinations<'a' | 'b' | 'c'>; // type AllCombinationsRes = "a" | "b" | "c" | "bc" | "cb" | "ab" | "ac" | "abc" | "acb" | "ba" | "ca" | "bca" | "cba" | "bac" | "cab"
```

# 套路：特殊特性要记清

### IsAny

**any 类型与任何类型的交叉都是 any，也就是 1 & any 结果是 any。**

```tsx
type IsAny<T> = string extends (number & T) ? true : false
```

### IsEqual

```tsx
type IsEqual2<A, B> = (<T>() => T extends A ? 1 : 2) extends (<T>() => T extends B ? 1 : 2)
    ? true : false;
```

### IsNever

```tsx
type IsNever<T> = [T] extends [never] ? true : false
```

### IsTuple

```tsx
type IsTuple<T> = T extends readonly [...params: infer Eles]
  ? NotEqual<Eles['length'], number>
  : false;
type NotEqual<A, B> = (<T>() => T extends A ? 1 : 2) extends <
  T
>() => T extends B ? 1 : 2
  ? false
  : true;
```

### UnionToIntersection

如果允许父类型赋值给子类型，就叫做**逆变**。

如果允许子类型赋值给父类型，就叫做**协变**。

在 TypeScript 中有函数参数是有逆变的性质的，也就是如果参数可能是多个类型，参数类型会变成它们的交叉类型。

```tsx
type UnionToIntersection<U> = (
  U extends U ? (x: U) => unknown : never
) extends (x: infer R) => unknown
  ? R
  : never;
type UnionToInterRes = UnionToIntersection<{ a: 1 } | { b: 2 }>; // type UnionToInterRes = {a: 1;} & { b: 2;}
```

### GetOptional

```tsx
type GetOptional<Obj extends Record<string, any>> = {
  [Key in keyof Obj as {} extends Pick<Obj, Key> ? Key : never]: Obj[Key];
};
```

# 类型体操顺口溜

**模式匹配做提取，重新构造做变换。**

**递归复用做循环，数组长度做计数。**

**联合分散可简化，特殊特性要记清。**

**基础扎实套路熟，类型体操可通关。**

### ParseQueryString

```tsx
type ParseQueryString<Str extends string> =
  Str extends `${infer Param}&${infer Rest}`
    ? MergeParams<ParseParam<Param>, ParseQueryString<Rest>>
    : ParseParam<Str>;
type ParseParam<Param extends string> =
  Param extends `${infer Key}=${infer Value}` ? { [K in Key]: Value } : {};
type MergeParams<
  One extends Record<string, any>,
  Other extends Record<string, any>
> = {
  [Key in keyof One | keyof Other]: Key extends keyof One
    ? Key extends keyof Other
      ? MergeValues<One[Key], Other[Key]>
      : One[Key]
    : Key extends keyof Other
    ? Other[Key]
    : never;
};
type MergeValues<One, Other> = One extends Other
  ? One
  : Other extends unknown[]
  ? [One, ...Other]
  : [One, Other];
type ParseQueryStringRes = ParseQueryString<'a=1&b=2&c=3'> // type ParseQueryStringRes = {a: "1";b: "2";c: "3";}
```

# TypeScript 内置

用模式匹配可以实现：Parameters、ReturnType、ConstructorParameters、InstanceType、ThisParameterType。

用模式匹配 + 重新构造可以实现：OmitThisParameter

用重新构造可以实现：Partial、Required、Readonly、Pick、Record

用模式匹配 + 递归可以实现： Awaited

用联合类型在分布式条件类型的特性可以实现： Exclude

此外还有 NonNullable 和四个编译器内部实现的类型：Uppercase、Lowercase、Capitalize、Uncapitalize。

```tsx
type Parameters<T extends (...args: any) => any> = T extends (
  ...args: infer P
) => any
  ? P
  : never;
type ParamsRes = Parameters<(name: string, age: number) => void>; // type ParamsRes = [name: string, age: number]
```

```tsx
type ReturnType<T extends (...args: any) => any> = T extends (
  ...args: any
) => infer R
  ? R
  : any;
type ReturnRes = ReturnType<() => number>; // type ReturnRes = number
```

```tsx
type ConstructorParameters<T extends abstract new (...args: any) => any> =
  T extends abstract new (...args: infer P) => any ? P : never;
interface PersonConstructor {
  new (name: string): Person;
}
type ConstructorParametersRes = ConstructorParameters<PersonConstructor>; // type ConstructorParametersRes = [name: string]
```

```tsx
type InstanceType<T extends abstract new (...args: any) => any> =
  T extends abstract new (...args: any) => infer R ? R : any;
type InstanceTypeRes = InstanceType<PersonConstructor>; // type InstanceTypeRes = Person
```
