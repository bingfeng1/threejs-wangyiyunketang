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
    const camera = new PerspectiveCamera(75, width / height, .1, 1000)

    // 设置相机位置
    camera.position.set(0, 0, 10)

    scene.add(camera)

    const textureLoader = new TextureLoader()
    const particlesTexture = textureLoader.load("/textures/particles/1.png")


    const params = {
        count: 10000,
        size: 0.1,
        radius: 5,
        branch: 6,
        color: "#ffffff",
        rotateScale: 1
    }

    let geometry;
    let material;
    let points;
    const generateGalaxy = () => {
        // 生成顶点
        geometry = new BufferGeometry()
        // 随机生成位置
        const positions = new Float32Array(params.count * 3)
        // 设置顶点颜色
        const colors = new Float32Array(params.count * 3)

        // 循环生成点
        for (let i = 0; i < params.count; i++) {
            // 当前的点应该在哪一条分支的角度上
            const branchAngle = (i % params.branch) * (2 * Math.PI / params.branch)

            // 当前点距离圆心的距离
            const distance = Math.random() * params.radius * Math.random() ** 3

            const current = i * 3

            const randomX = (Math.random() * 2 - 1) ** 3 * (params.radius - distance) / 5
            const randomY = (Math.random() * 2 - 1) ** 3 * (params.radius - distance) / 5
            const randomZ = (Math.random() * 2 - 1) ** 3 * (params.radius - distance) / 5

            positions[current] = Math.cos(branchAngle + distance * params.rotateScale) * distance + randomX
            positions[current + 1] = 0 + randomY
            positions[current + 2] = Math.sin(branchAngle + distance * params.rotateScale) * distance + randomZ

        }

        geometry.setAttribute("position",
            new BufferAttribute(positions, 3)
        )

        // 设置点材质
        material = new PointsMaterial({
            color: new Color(params.color),
            size: params.size,
            sizeAttenuation: true,
            depthWrite: false,
            blending: AdditiveBlending,
            map: particlesTexture,
            alphaMap: particlesTexture,
            transparent: true,
            // vertexColors: true

        })

        points = new Points(geometry, material)
        scene.add(points)
    }

    generateGalaxy()

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