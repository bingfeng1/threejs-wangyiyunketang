<script setup>
import { onMounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AxesHelper, BoxGeometry, Clock, Mesh, MeshBasicMaterial, PerspectiveCamera, Scene, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
import { gsap } from "gsap";


const base = ref()

// 掌握gsap动画设置
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

    // 设置动画
    const animate1 = gsap.to(cube.position, {
        x: 5,
        duration: 5,
        // 设置重复的次数，无限次循环-1
        repeat: 2,
        // 往返效果
        yoyo: true,
        ease: "power1.inOut",
        // 延迟
        delay: 2,
        onComplete: () => {
            console.log("动画完成");
        },
        onStart: () => {
            console.log("动画开始");
        }
    })
    gsap.to(cube.rotation, {
        x: 2 * Math.PI,
        duration: 5,
    })

    // 暂停/恢复
    window.addEventListener("dblclick", () => {
        if (animate1.isActive()) {
            animate1.pause()
        }else{
            animate1.resume()
        }
    })

    function animate() {


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