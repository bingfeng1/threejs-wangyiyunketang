<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { ACESFilmicToneMapping, AxesHelper, BoxGeometry, CineonToneMapping, Clock, Color, DoubleSide, EquirectangularReflectionMapping, LinearToneMapping, Mesh, MeshBasicMaterial, PerspectiveCamera, PlaneBufferGeometry, RawShaderMaterial, ReinhardToneMapping, Scene, ShaderMaterial, sRGBEncoding, TextureLoader, Vector2, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';

import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import gsap from 'gsap';
import { GUI } from 'dat.gui';

// 导入water
import { Water } from "three/examples/jsm/objects/Water2"

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
    camera.position.set(0, 0, 2)

    scene.add(camera)

    const controls = new OrbitControls(camera, canvas)
    controls.enableDamping = true

    const axesHelper = new AxesHelper(5)
    scene.add(axesHelper)


    // 水的材质
    const water = new Water(
        new PlaneBufferGeometry(1, 1, 1024, 1024),
        {
            color: "#ffffff",
            scale: 1,
            flowDirection: new Vector2(1, 1),
            textureHeight: 1024,
            textureWidth: 1024
        }
    )


    water.rotation.x = -Math.PI / 2


    scene.add(water)

    // 加载场景背景
    const rgbeLoader = new RGBELoader()
    rgbeLoader.loadAsync("/050.hdr").then((texture)=>{
        texture.mapping = EquirectangularReflectionMapping
        scene.background = texture
        scene.environment = texture
    })

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