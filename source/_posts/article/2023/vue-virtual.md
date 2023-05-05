---
title: vue3 虚拟列表
tags:
  - vue
categories: vue
cover: https://may-data.oss-cn-hangzhou.aliyuncs.com/myartilepic/281c3ac5c2f9a4e16854b10710a02a7c.png
date: 2023-05-05 21:00:00
---

```jsx
<template>
  <el-dialog v-model="isShow" width="500px" title="关联">
    <div class="container">
      <div class="left">
        <el-scrollbar wrap-class="list-wrapper" @scroll="handleScroll($event)">
          <div class="virtual-list" ref="container" :style="{height: containerHeight}">
            <div :style="{height: totalHeight + 'px', paddingTop: paddingTop + 'px'}" ref="container1">
              <div v-for="(item,index) in data.items" :key="`list-${index}`" class="virtual-list-item" :style="{height: `${itemHeight}px`}">
                <el-radio @change="change" v-model="data.buyIns" :label="item.id">{{item.name}}</el-radio>
              </div>
            </div>
          </div>
        </el-scrollbar>
      </div>
      <div class="right">
        111
      </div>
    </div>
  </el-dialog>
</template>

<script setup lang="jsx">
import {computed, onMounted, reactive, ref, watchEffect} from 'vue'

const props = defineProps({
  items: {
    type: Array,
    default: () => []
  }
})
const data = reactive({
  buyIns: '',
  items: []
})
const emits = defineEmits(['add'])

const container = ref(null)
const paddingTop = ref(0)
const itemHeight = ref(30)
const visibleCount = ref(10)
const scrollTop = ref(0)
watchEffect(() => {
  if (container.value) {
    updateVisibleDate()
  }
})
const totalHeight = computed(() => props.items.length * itemHeight.value)
const containerHeight = computed(() => visibleCount.value * itemHeight.value)
function updateVisibleDate() {
  const start = Math.floor(scrollTop.value / itemHeight.value)
  const end = start + visibleCount.value
  data.items = props.items.slice(start, end)
  paddingTop.value = start * itemHeight.value
}
const handleScroll = (event) => {
  scrollTop.value = event.scrollTop
  // updateVisibleDate()
  if (event.scrollTop + containerHeight.value >= totalHeight.value) {
    emits('add',[{id:100,name:'100'}])
  }
}
const change = (val) => {
  console.log(val)
}

const isShow = ref(false)
const open = () => {
  isShow.value = true
}
defineExpose({
  open
})
</script>
<style lang="scss" scoped>
.container {
  display: flex;
}
.left, .right {
  width: 50%
}
.left {
  border-right: 1px solid #ccc;
}
:deep(.list-wrapper) {
  height: 300px;
  width: 100%;
}
.virtual-list {
  overflow-y: auto;
  &-item {
    height: 30px;
  }
}

</style>
```
