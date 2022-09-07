<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AmbientLight, AxesHelper, BoxBufferGeometry, BoxGeometry, BufferAttribute, BufferGeometry, Clock, Color, CubeTextureLoader, DirectionalLight, DoubleSide, EquirectangularReflectionMapping, LoadingManager, Mesh, MeshBasicMaterial, MeshStandardMaterial, MirroredRepeatWrapping, NearestFilter, PerspectiveCamera, PlaneBufferGeometry, PointLight, Points, PointsMaterial, RepeatWrapping, Scene, SphereBufferGeometry, SphereGeometry, SpotLight, TextureLoader, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
import { GUI } from 'dat.gui'
import { gsap } from "gsap";
import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader'

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

    // 创建球几何体
    const sphereGeometry = new SphereBufferGeometry(3, 20, 20)
    // const material = new MeshBasicMaterial({
    //     color: 0xff0000,
    //     wireframe: true
    // })
    // const mesh = new Mesh(sphereGeometry, material)
    // scene.add(mesh)

    const pointsMaterial = new PointsMaterial({
        size: 0.1
    })
    const points = new Points(sphereGeometry, pointsMaterial)
    scene.add(points)

    // 初始化渲染器
    const renderer = new WebGLRenderer({
        canvas
    })

    // 开启渲染阴影映射
    renderer.shadowMap.enabled = true
    renderer.setSize(width, height)
    renderer.render(scene, camera)

    // 创建轨道控制器
    const controls = new OrbitControls(camera, canvas)
    controls.enableDamping = true

    // 添加坐标轴辅助器
    const axesHelper = new AxesHelper(5)
    scene.add(axesHelper)

    const clock = new Clock()

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