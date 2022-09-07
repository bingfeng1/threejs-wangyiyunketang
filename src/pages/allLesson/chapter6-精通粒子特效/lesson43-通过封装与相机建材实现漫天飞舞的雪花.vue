<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AdditiveBlending, AmbientLight, AxesHelper, BoxBufferGeometry, BoxGeometry, BufferAttribute, BufferGeometry, Clock, Color, CubeTextureLoader, DirectionalLight, DoubleSide, EquirectangularReflectionMapping, LoadingManager, Mesh, MeshBasicMaterial, MeshStandardMaterial, MirroredRepeatWrapping, NearestFilter, PerspectiveCamera, PlaneBufferGeometry, PointLight, Points, PointsMaterial, RepeatWrapping, Scene, SphereBufferGeometry, SphereGeometry, SpotLight, TextureLoader, WebGLRenderer } from 'three'
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
    const camera = new PerspectiveCamera(75, width / height, .1, 30)

    // 设置相机位置
    camera.position.set(0, 0, 40)

    scene.add(camera)


    let points1 = createPoints("/textures/particles/9.png")
    let points2 = createPoints("/textures/particles/10.png")

    function createPoints(url, size = 20) {

        const particlesGeometry = new BufferGeometry()
        const count = 5000
        // 设置缓冲区数组
        const positions = new Float32Array(count * 3)
        // 设置粒子顶点颜色
        const colors = new Float32Array(count * 3)
        // 设置顶点
        for (let i = 0; i < count * 3; i++) {
            positions[i] = (Math.random() - 0.5) * 100
            colors[i] = Math.random()
        }

        particlesGeometry.setAttribute(
            'position',
            new BufferAttribute(positions, 3)
        )

        particlesGeometry.setAttribute(
            'color',
            new BufferAttribute(colors, 3)
        )


        // 载入纹理
        const textureLoader = new TextureLoader()
        const texture = textureLoader.load(url)


        const pointsMaterial = new PointsMaterial({
            size,
            color: 0xffff00,
            // 相机深度是否衰减
            sizeAttenuation: false,
            map: texture,
            // 透明贴图
            alphaMap: texture,
            transparent: true,
            // 深度检测
            depthWrite: false,
            // 叠加算法
            blending: AdditiveBlending,
            // 启动顶点颜色
            vertexColors: true,
        })



        const points = new Points(particlesGeometry, pointsMaterial)
        scene.add(points)

        return points
    }



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
        let time = clock.getElapsedTime()
        points1.rotation.x = time * .3
        points2.rotation.x = time * .5
        points2.rotation.y = time * .6


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