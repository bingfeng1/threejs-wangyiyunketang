<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { ACESFilmicToneMapping, AxesHelper, BoxGeometry, BufferAttribute, BufferGeometry, CineonToneMapping, Clock, Color, DirectionalLight, DoubleSide, EquirectangularReflectionMapping, LinearToneMapping, Mesh, MeshBasicMaterial, PerspectiveCamera, PlaneBufferGeometry, Points, PointsMaterial, RawShaderMaterial, ReinhardToneMapping, Scene, ShaderMaterial, sRGBEncoding, TextureLoader, Vector2, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';

import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import gsap from 'gsap';
import { GUI } from 'dat.gui';

// 导入water
import { Water } from "three/examples/jsm/objects/Water2"

import vertexShader from "./shader/base/vertex.glsl?raw"
import fragmentShader from "./shader/base/fragment.glsl?raw"

const base = ref()

const gui = new GUI()
onUnmounted(() => {
    gui.destroy()
})

onMounted(() => {
    const { canvas, width, height } = base.value
    // console.log(canvas);
    // 1、创建场景
    const scene = new Scene()

    // 2、创建相机
    const camera = new PerspectiveCamera(75, width / height, .1, 1000)

    // 设置相机位置
    camera.position.set(0, 5, 5)

    scene.add(camera)

    const controls = new OrbitControls(camera, canvas)
    controls.enableDamping = true

    const axesHelper = new AxesHelper(5)
    scene.add(axesHelper)


    const geometry = new BufferGeometry()
    const positions = new Float32Array([0, 0, 0])

    geometry.setAttribute('position', new BufferAttribute(positions, 3))

    // 点材质
    // const material = new PointsMaterial({
    //     color: 0xff0000,
    //     size: 10,
    //     sizeAttenuation: true
    // })

    // 点着色器材质
    const material = new ShaderMaterial(
        {
            vertexShader,
            fragmentShader,
            transparent: true
        }
    )

    // 生成点
    const points = new Points(geometry, material)

    scene.add(points)



    // 初始化渲染器
    const renderer = new WebGLRenderer({
        canvas
    })
    renderer.setSize(width, height)


    renderer.toneMappingExposure = 0.2

    renderer.render(scene, camera)


    const clock = new Clock()

    function render() {
        const elapsedTime = clock.getElapsedTime()

        controls.update()
        renderer.render(scene, camera)
        requestAnimationFrame(render)
    }
    render()

    onUnmounted(() => {
        renderer.dispose()
    })
})
</script>
            
<template>
    <BaseCanvas ref="base"></BaseCanvas>
</template>
            
<style scoped>

</style>