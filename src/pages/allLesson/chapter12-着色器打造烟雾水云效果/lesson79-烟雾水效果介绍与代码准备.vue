<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { ACESFilmicToneMapping, AxesHelper, BoxGeometry, CineonToneMapping, Clock, Color, DoubleSide, EquirectangularReflectionMapping, LinearToneMapping, Mesh, MeshBasicMaterial, PerspectiveCamera, PlaneBufferGeometry, RawShaderMaterial, ReinhardToneMapping, Scene, ShaderMaterial, sRGBEncoding, TextureLoader, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';

// 顶点着色器
import vertexShader from './shader/water/vertex.glsl?raw'
// 片元着色器
import fragmentShader from './shader/water/fragment.glsl?raw'
import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import gsap from 'gsap';
import { GUI } from 'dat.gui';

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

    const params = {
        uWaresFrequency: 14,
        uScale: 0.03,
        uxzScale: 1.5,
        // 噪声频率
        uNoiseFrequency: 10,
        uNoiseScale: 1.5,
        uTime: 0,
        uLowColor: '#ff0000',
        uHighColor: '#ffff00',
        uXspeed: 1,
        uZspeed: 1,
        uNoiseSpeed: 1,
        uOpacity: 1
    }

    const shaderMaterial = new ShaderMaterial({
        vertexShader: vertexShader,
        fragmentShader: fragmentShader,
        side: DoubleSide,
        uniforms: {
            uWaresFrequency: {
                value: params.uWaresFrequency
            },
            uScale: {
                value: params.uScale
            },
            uxzScale: {
                value: params.uxzScale
            },
            uNoiseFrequency: {
                value: params.uNoiseFrequency
            },
            uNoiseScale: {
                value: params.uNoiseScale
            },
            uTime: {
                value: params.uTime
            },
            uLowColor: {
                value: new Color(params.uLowColor)
            },
            uHighColor: {
                value: new Color(params.uHighColor)
            },
            uXspeed: {
                value: params.uXspeed
            },
            uZspeed: {
                value: params.uZspeed
            },
            uNoiseSpeed: {
                value: params.uNoiseSpeed
            },
            uOpacity: {
                value: params.uOpacity
            },
        },
        transparent: true
    })

    // for (let [key, value] of Object.entries(params)) {
    //     shaderMaterial.uniforms[key] = {
    //         value
    //     }
    // }

    gui.add(params, "uWaresFrequency")
        .min(1)
        .max(100)
        .step(0.1)
        .onChange((value) => {
            shaderMaterial.uniforms.uWaresFrequency.value = value
        })

    gui.add(params, "uScale")
        .min(0)
        .max(0.2)
        .step(0.001)
        .onChange((value) => {
            shaderMaterial.uniforms.uScale.value = value
        })


    gui.add(params, "uNoiseFrequency")
        .min(1)
        .max(100)
        .step(0.1)
        .onChange((value) => {
            shaderMaterial.uniforms.uNoiseFrequency.value = value
        })

    gui.add(params, "uNoiseScale")
        .min(0)
        .max(5)
        .step(0.001)
        .onChange((value) => {
            shaderMaterial.uniforms.uNoiseScale.value = value
        })


    gui.add(params, "uxzScale")
        .min(1)
        .max(5)
        .step(0.1)
        .onChange((value) => {
            shaderMaterial.uniforms.uxzScale.value = value
        })
    gui.addColor(params, "uLowColor")
        .onFinishChange((value) => {
            shaderMaterial.uniforms.uLowColor.value = new Color(value)
        })

    gui.addColor(params, "uHighColor")
        .onFinishChange((value) => {
            shaderMaterial.uniforms.uHighColor.value = new Color(value)
        })

    gui.add(params, "uXspeed")
        .min(0)
        .max(5)
        .step(0.01)
        .onChange((value) => {
            shaderMaterial.uniforms.uXspeed.value = value
        })
    gui.add(params, "uZspeed")
        .min(0)
        .max(5)
        .step(0.01)
        .onChange((value) => {
            shaderMaterial.uniforms.uZspeed.value = value
        })
    gui.add(params, "uNoiseSpeed")
        .min(0)
        .max(5)
        .step(0.1)
        .onChange((value) => {
            shaderMaterial.uniforms.uNoiseSpeed.value = value
        })
    gui.add(params, "uOpacity")
        .min(0)
        .max(1)
        .step(0.001)
        .onChange((value) => {
            shaderMaterial.uniforms.uOpacity.value = value
        })

    const plane = new Mesh(
        new PlaneBufferGeometry(1, 1, 1024, 1024),
        // new MeshBasicMaterial({
        //     color: 0xff0000
        // })
        shaderMaterial
    )

    plane.rotation.x = -Math.PI / 2


    scene.add(plane)

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

        shaderMaterial.uniforms.uTime.value = elapsedTime

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