<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AmbientLight, AxesHelper, BoxBufferGeometry, BoxGeometry, BufferAttribute, BufferGeometry, Clock, Color, CubeTextureLoader, DirectionalLight, DoubleSide, EquirectangularReflectionMapping, LoadingManager, Mesh, MeshBasicMaterial, MeshStandardMaterial, MirroredRepeatWrapping, NearestFilter, PerspectiveCamera, PlaneBufferGeometry, PointLight, RepeatWrapping, Scene, SphereBufferGeometry, SphereGeometry, SpotLight, TextureLoader, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
import { GUI } from 'dat.gui'
import { gsap } from "gsap";
import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader'

const base = ref()
const gui = new GUI()

// 目标：点光源

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

    const SphereGeometry = new SphereBufferGeometry(1, 20, 20)
    const material = new MeshStandardMaterial({

    })

    const sphere = new Mesh(SphereGeometry, material)
    sphere.castShadow = true
    scene.add(sphere)


    const planeGeometry = new PlaneBufferGeometry(50, 50)

    const plane = new Mesh(planeGeometry, material)
    plane.position.set(0, -1, 0)
    plane.rotation.x = -Math.PI / 2
    plane.receiveShadow = true
    scene.add(plane)


    // 灯光
    // 环境光
    const light = new AmbientLight(0xffffff, .5)
    scene.add(light)

    const smallBall = new Mesh(
        new SphereBufferGeometry(0.1, 20, 20),
        new MeshBasicMaterial({ color: 0xff0000 })
    )

    smallBall.position.set(2, 2, 2)


    // 直线光
    const pointLight = new PointLight(0xff0000, 1)
    pointLight.castShadow = true


    // 模糊度
    pointLight.shadow.radius = 20
    // 阴影贴图分辨率
    pointLight.shadow.mapSize.set(256, 256)

    pointLight.distance = 0
    pointLight.decay = 2

    // 设置透视相机可视区域

    smallBall.add(pointLight)
    scene.add(smallBall)

    gui.add(sphere.position, "x")
        .min(-5)
        .max(5)
        .step(.1)

    gui.add(pointLight, 'distance')
        .min(0)
        .max(10)
        .step(.001)
    gui.add(pointLight, 'decay')
        .min(0)
        .max(5)
        .step(.01)


    // 初始化渲染器
    const renderer = new WebGLRenderer({
        canvas
    })

    // 开启渲染阴影映射
    renderer.shadowMap.enabled = true
    renderer.setSize(width, height)
    renderer.render(scene, camera)
    renderer.physicallyCorrectLights = true

    // 创建轨道控制器
    const controls = new OrbitControls(camera, canvas)
    controls.enableDamping = true

    // 添加坐标轴辅助器
    const axesHelper = new AxesHelper(5)
    scene.add(axesHelper)

    const clock = new Clock()

    // controls.update()
    function animate() {
        let time = clock.getElapsedTime()
        smallBall.position.x = Math.sin(time) * 3
        smallBall.position.z = Math.cos(time) * 3
        // smallBall.position.y = 2 + Math.sin(time)

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