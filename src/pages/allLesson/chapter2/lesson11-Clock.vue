<script setup>
import { onMounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AxesHelper, BoxGeometry, Clock, Mesh, MeshBasicMaterial, PerspectiveCamera, Scene, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'


const base = ref()

onMounted(() => {
    const { canvas, width, height } = base.value
    // console.log(canvas);
    // 1、创建场景
    const scene = new Scene()

    // 2、创建相机
    const camera = new PerspectiveCamera(75, width / height, .1, 1000)

    // 设置相机位置
    camera.position.set(0, 0, 10)

    scene.add(camera)

    // 创建物体
    // 创建几何体
    const cubeGeometry = new BoxGeometry(1, 1, 1)
    const cubeMaterial = new MeshBasicMaterial({ color: 0xffff00 })
    // 根据几何体和材质创建模型
    const cube = new Mesh(cubeGeometry, cubeMaterial)

    // 将几何体添加到场景中
    scene.add(cube)

    // 初始化渲染器
    const renderer = new WebGLRenderer({
        canvas
    })
    renderer.setSize(width, height)
    renderer.render(scene, camera)

    // 创建轨道控制器
    const controls = new OrbitControls(camera, canvas)

    // 添加坐标轴辅助器
    const axesHelper = new AxesHelper(5)
    scene.add(axesHelper)

    // 设置时钟
    const clock = new Clock()

    // controls.update()
    function animate() {
        // 获取时钟运行的总时长
        let time = clock.getElapsedTime()
        // console.log("时钟运行总时长：",time);
        // let deltaTime = clock.getDelta()
        // console.log("两次获取时间的时间间隔",deltaTime);
        let t = time
        cube.position.x = t % 5

        if (cube.position.x > 5) {
            cube.position.x = 0
        }

        renderer.render(scene, camera)
        requestAnimationFrame(animate)
    }

    animate()

})
</script>

<template>
    <BaseCanvas ref="base"></BaseCanvas>
</template>

<style scoped>
</style>