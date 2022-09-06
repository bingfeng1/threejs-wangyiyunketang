import { ref, onUnmounted } from "vue"

// 封装鼠标事件和方法
class DomEventCollection {
    constructor(canvas) {
        this.canvas = canvas
        this.callback = {}
        this.x = ref(0)
        this.y = ref(0)
    }

    // 设置鼠标位置
    setMouseSite(event) {
        const rect = this.canvas.getBoundingClientRect()
        this.x.value = ((event.clientX - rect.left) / rect.width) * 2 - 1
        this.y.value = -(((event.clientY - rect.top) / rect.height) * 2 - 1)
    }

    // 添加鼠标事件
    addDomEvent(name) {
        let handleEvent = (event) => {
            this.setMouseSite(event)
            // 将当前的鼠标三维坐标传出
            this.callback[name].forEach(fn => fn(this.x.value, this.y.value))
        }
        this.canvas.addEventListener(name, handleEvent)

        onUnmounted(() => {
            this.canvas.removeEventListener(name, handleEvent)
            this.callback[name].clear()
            this.callback[name] = undefined
        })
    }

    // 添加具体事件触发
    addDomEventFn(name, key, fn) {
        if (!this.callback[name]) {
            this.callback[name] = new Map()
            this.addDomEvent(name)
        }
        this.callback[name].set(key, fn)
    }

    // 移除具体事件触发
    removeDomEventFn(name, key) {
        this.callback[name].delete(key)
    }
}

export function useDomEvent(canvas) {
    let domEventCollection = new DomEventCollection(canvas)

    return {
        addDomEventFn: domEventCollection.addDomEventFn.bind(domEventCollection),
        removeDomEventFn: domEventCollection.removeDomEventFn.bind(domEventCollection)
    }
}