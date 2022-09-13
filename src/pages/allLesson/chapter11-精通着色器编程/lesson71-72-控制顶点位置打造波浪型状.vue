<script setup>
import { onMounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AxesHelper, BoxGeometry, Clock, DoubleSide, Mesh, MeshBasicMaterial, PerspectiveCamera, PlaneBufferGeometry, RawShaderMaterial, Scene, ShaderMaterial, TextureLoader, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';

// 顶点着色器
import basicVertexShader from './shader/raw71/vertex.glsl?raw'
// 片元着色器
import basicFragmentShader from './shader/raw71/fragment.glsl?raw'

const base = ref()

onMounted(() => {
    const { canvas, width, height } = base.value
    // console.log(canvas);
    // 1、创建场景
    const scene = new Scene()

    // 2、创建相机
    const camera = new PerspectiveCamera(75, width / height, .1, 1000)

    // 设置相机位置
    camera.position.set(0, 0, 5)

    scene.add(camera)

    // const material = new MeshBasicMaterial({
    //     color: "#00ff00"
    // })

    const textureLoader = new TextureLoader()
    const texture = textureLoader.load("/texture/ca.jpeg")


    // 创建着色器材质
    const rawShaderMaterial = new RawShaderMaterial({
        vertexShader: basicVertexShader,
        fragmentShader: basicFragmentShader,
        // wireframe: true,
        side: DoubleSide,
        uniforms: {
            uTime: {
                value: 0
            },
            uTexture: {
                value: texture
            }
        }
    })

    const floor = new Mesh(
        new PlaneBufferGeometry(1, 1, 64, 64),
        rawShaderMaterial
    )

    scene.add(floor)


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