<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AxesHelper, BoxGeometry, Clock, DoubleSide, Mesh, MeshBasicMaterial, PerspectiveCamera, PlaneBufferGeometry, RawShaderMaterial, Scene, ShaderMaterial, TextureLoader, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';

// 顶点着色器
import deepVertexShader from './shader/deep73/vertex.glsl?raw'
// 片元着色器
import deepFragmentShader from './shader/deep73/fragment.glsl?raw'
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

    // const material = new MeshBasicMaterial({
    //     color: "#00ff00"
    // })

    const textureLoader = new TextureLoader()
    const texture = textureLoader.load("/texture/ca.jpeg")

    const params = {
        scale: 0.5
    }

    // 创建着色器材质
    const rawShaderMaterial = new RawShaderMaterial({
        vertexShader: deepVertexShader,
        fragmentShader: deepFragmentShader,
        // wireframe: true,
        side: DoubleSide,
        uniforms: {
            uTime: {
                value: 0
            },
            uTexture: {
                value: texture
            },
            uScale: {
                value: params.scale
            }
        },
        transparent: true,
    })

    const floor = new Mesh(
        new PlaneBufferGeometry(1, 1, 64, 64),
        rawShaderMaterial
    )

    scene.add(floor)

    gui.add(params, "scale")
        .min(0)
        .max(1)
        .step(0.01)
        .onChange((value) => {
            rawShaderMaterial.uniforms.uScale.value = value
        })

    const controls = new OrbitControls(camera, canvas)
    controls.enableDamping = true

    const axesHelper = new AxesHelper(5)
    scene.add(axesHelper)

    // 初始化渲染器
    const renderer = new WebGLRenderer({
        canvas
    })
    renderer.setSize(width, height)
    renderer.render(scene, camera)

    const clock = new Clock()

    function render() {
        const elapsedTime = clock.getElapsedTime()

        rawShaderMaterial.uniforms.uTime.value = elapsedTime


        controls.update()
        renderer.render(scene, camera)
        requestAnimationFrame(render)
    }
    render()

})
</script>
        
<template>
    <BaseCanvas ref="base"></BaseCanvas>
</template>
        
<style scoped>

</style>