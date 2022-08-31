<script setup>
import { onMounted, ref } from 'vue';

const canvas = ref()
const width = ref(0)
const height = ref(0)



onMounted(() => {

    let _canvas = canvas.value;
    let parent = _canvas.parentElement
    width.value = parent.clientWidth 
    height.value = parent.clientHeight - 4 
    _canvas.width = width.value
    _canvas.height = height.value
})


// 导出canvas
defineExpose({
    canvas,
    width,
    height
})

</script>

<template>
    <canvas ref="canvas" v-bind="$attrs"></canvas>
    <slot></slot>
</template>

<style scoped>
canvas {
    background: rgb(221, 221, 221);
    width: 100%;
    height: 100%;
}
</style>
