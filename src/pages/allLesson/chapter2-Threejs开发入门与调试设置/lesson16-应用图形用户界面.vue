<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AxesHelper, BoxGeometry, Mesh, MeshBasicMaterial, PerspectiveCamera, Scene, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
import { GUI } from 'dat.gui'
import { gsap } from "gsap";

const base = ref()
const gui = new GUI()

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

    gui.add(cube.position, "x")
        .min(0)
        .max(5)
        .step(.01)
        .name("移动X轴")
        .onChange((v) => console.log("值被修改了：", v))
        .onFinishChange((v) => console.log("完全停下来：", v))

    // 修改物体颜色
    const params = {
        color: '#ffff00',
        fn: () => {
            // 让立方体运动起来
            gsap.to(cube.position, { x: 5, duration: 2, yoyo: true, repeat: -1 })
        }
    }
    gui.addColor(params, "color").onChange(v => {
        console.log(v)
        cube.material.color.set(v)
    })

    // 设置选项框
    gui.add(cube, "visible").name("是否显示")


    const folder = gui.addFolder("设置立方体")
    folder.add(cube.material,"wireframe")
    // 设置按钮点击触发某个事件
    folder.add(params, "fn").name("立方体运动")

    // 初始化渲染器
    const renderer = new WebGLRenderer({
        canvas
    })
    renderer.setSize(width, height)
    renderer.render(scene, camera)

    // 创建轨道控制器
    const controls = new OrbitControls(camera, canvas)
    controls.enableDamping = true

    // 添加坐标轴辅助器
    const axesHelper = new AxesHelper(5)
    scene.add(axesHelper)

    // 双击控制屏幕进入全屏，推出全屏
    // window.addEventListener("dblclick", () => {
    //     const fullScreenElement = document.fullscreenElement
    //     if (!fullScreenElement) {
    //         canvas.requestFullscreen()
    //     } else {
    //         document.exitFullscreen()
    //     }
    // })

    // controls.update()
    function animate() {
        controls.update()
        renderer.render(scene, camera)
        requestAnimationFrame(animate)
    }

    animate()

})

onUnmounted(() => {
    gui.destroy()
})
</script>

<template>
    <BaseCanvas ref="base"></BaseCanvas>
</template>

<style scoped>
</style>