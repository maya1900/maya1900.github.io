---
title: dolphinscheduler的状态显示
date: 2021-05-30
tags:
  - dolphinscheduler
categories:
  - 网络
cover: https://z3.ax1x.com/2021/05/30/2VXV6s.jpg
---

```javascript
// dag.vue
// 初始化
      init (args) {
	  // 判断是否存在tasks
        if (this.tasks.length) {
		// 回填数据
          Dag.backfill(args)
          // 判断是实例则显示节点状态
          if (this.type === 'instance') {
            this._getTaskState(false).then(res => {})
            // 轮询状态 90s查询一次
            this.setIntervalP = setInterval(() => {
              this._getTaskState(true).then(res => {})
            }, 90000)
          }
        } else {
		// 没有就创建
          Dag.create()
        }
      },
	  // 得到tasks状态
	  _getTaskState (isReset) {
        return new Promise((resolve, reject) => {
		  // 这里去发送请求
          this.getTaskState(this.urlParam.id).then(res => {
		    // 拿到状态列表
            let data = res.list
			// 拿到状态值
            let state = res.processInstanceState
			// 拿到tasks列表
            let taskList = res.taskList
			// 拿到所有节点id
            let idArr = allNodesId()
			// 写了一个提示文字的方法
            const titleTpl = (item, desc) => {
			  // 取到一条task信息
              let $item = _.filter(taskList, v => v.name === item.name)[0]
			  // 拼了一个html
              return `<div style="text-align: left">${i18n.$t('Name')}：${$item.name}</br>${i18n.$t('State')}：${desc}</br>${i18n.$t('type')}：${$item.taskType}</br>${i18n.$t('host')}：${$item.host || '-'}</br>${i18n.$t('Retry Count')}：${$item.retryTimes}</br>${i18n.$t('Submit Time')}：${formatDate($item.submitTime)}</br>${i18n.$t('Start Time')}：${formatDate($item.startTime)}</br>${i18n.$t('End Time')}：${$item.endTime ? formatDate($item.endTime) : '-'}</br></div>`
            }

            // 移除状态节点的信息
            $('.w').find('.state-p').html('')
            const newTask = []
            data.forEach(v1 => {
              idArr.forEach(v2 => {
                if (v2.name === v1.name) {
				  // 拿到tasks节点的dom
                  let dom = $(`#${v2.id}`)
				  // 拿到状态的dom
                  let state = dom.find('.state-p')
                  let depState = ''
                  taskList.forEach(item => {
				    // 判断tasks列表与状态列表的节点一样
                    if (item.name === v1.name) {
                      depState = item.state
                      const params = item.taskJson ? JSON.parse(item.taskJson).params : ''
                      let localParam = params.localParams || []
                      newTask.push({
                        id: v2.id,
                        localParam
                      })
                    }
                  })
				  // 给tasks节点加入属性
                  dom.attr('data-state-id', v1.stateId)
                  dom.attr('data-dependent-result', v1.dependentResult || '')
                  dom.attr('data-dependent-depState', depState)
				  // 给state的dom加入提示
                  state.append(`<strong class="${v1.icoUnicode} ${v1.isSpin ? 'as as-spin' : ''}" style="color:${v1.color}" data-toggle="tooltip" data-html="true" data-container="body"></strong>`)
                  state.find('strong').attr('title', titleTpl(v2, v1.desc))
                }
              })
            })
            if (state === 'PAUSE' || state === 'STOP' || state === 'FAILURE' || this.state === 'SUCCESS') {
              // 轮询重设状态
              if (isReset) {
			   // 这里会再次获取本条工作流详情，更新工作流运行结果
                findComponentDownward(this.$root, `${this.type}-details`)._reset()
              }
            }
			// 重设本地参数
            if (!isReset) {
              this.resetLocalParam(newTask)
            }
            resolve()
          })
        })
      }
```

```javascript
// dag/action.js
// 请求状态
getTaskState ({ state }, payload) {
    return new Promise((resolve, reject) => {
      io.get(`projects/${state.projectName}/instance/task-list-by-process-id`, {
        processInstanceId: payload
      }, res => {
        const arr = _.map(res.data.taskList, v => {
		  // 为节点加入状态属性
          return _.cloneDeep(_.assign(tasksState[v.state], {
            name: v.name,
            stateId: v.id,
            dependentResult: v.dependentResult
          }))
        })
        resolve({
          list: arr,
          processInstanceState: res.data.processInstanceState,
          taskList: res.data.taskList
        })
      }).catch(e => {
        reject(e)
      })
    })
  }
```
