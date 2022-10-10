<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { ACESFilmicToneMapping, AmbientLight, AxesHelper, BoxGeometry, CineonToneMapping, Clock, DoubleSide, EquirectangularReflectionMapping, LinearToneMapping, Mesh, MeshBasicMaterial, PerspectiveCamera, PlaneBufferGeometry, PointLight, RawShaderMaterial, ReinhardToneMapping, Scene, ShaderMaterial, sRGBEncoding, TextureLoader, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';

// 顶点着色器
import vertexShader from './shader/flylight/vertex.glsl?raw'
// 片元着色器
import fragmentShader from './shader/flylight/fragment.glsl?raw'
import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import gsap from 'gsap';
import Firework from './firework';

// 导入water
import { Water } from "three/examples/jsm/objects/Water2"


const base = ref()

onMounted(() => {
    const { canvas, width, height } = base.value
    // console.log(canvas);
    // 1、创建场景
    const scene = new Scene()

    // 2、创建相机
    const camera = new PerspectiveCamera(75, width / height, .1, 1000)

    // 设置相机位置
    camera.position.set(0, 0, 20)

    scene.add(camera)

    const light = new PointLight()
    light.intensity = 2
    light.position.set(0, 0, 100)
    scene.add(light)

    // 加载环境纹理
    const rgbeLoader = new RGBELoader()
    rgbeLoader.loadAsync("/2k.hdr").then((texture) => {
        texture.mapping = EquirectangularReflectionMapping
        scene.background = texture
        scene.environment = texture
    })


    // 创建着色器材质
    const shaderMaterial = new ShaderMaterial({
        vertexShader: vertexShader,
        fragmentShader: fragmentShader,
        // wireframe: true,
        side: DoubleSide,
        uniforms: {

        },
        // transparent: true
    })

    let lightBox;
    const gltfLoader = new GLTFLoader()

    gltfLoader.load("/models/newyears_min.glb", (gltf) => {
        // console.log(gltf);
        scene.add(gltf.scene)

        // 创建水面
        const waterGeometry = new PlaneBufferGeometry(100, 100)
        let water = new Water(waterGeometry, {
            scale: 4,
            textureHeight: 1024,
            textureWidth: 1024,
        })

        water.position.y = 1;
        water.rotation.x = -Math.PI / 2;
        scene.add(water)
    })
    gltfLoader.load('/models/flyLight.glb', (gltf) => {
        // console.log(gltf);
        // scene.add(gltf.scene)
        gltf.scene.children.shift()
        lightBox = gltf.scene.children[0]
        lightBox.material = shaderMaterial


        for (let i = 0; i < 50; i++) {
            let flyLight = gltf.scene.clone(true)
            let x = (Math.random() - 0.5) * 300
            let z = (Math.random() - 0.5) * 300
            let y = Math.random() * 30
            flyLight.position.set(x, y, z);

            gsap.to(flyLight.rotation, {
                y: 2 * Math.PI,
                duration: (Math.random() + 5) * 2,
                repeat: -1
            })

            gsap.to(flyLight.position, {
                x: "+=" + (Math.random() + 1) * 3,
                y: "+=" + Math.random() * 10,
                duration: 5 + Math.random() * 5,
                repeat: -1,
                yoyo: true
            })

            scene.add(flyLight)
        }

    })





    const controls = new OrbitControls(camera, canvas)
    controls.enableDamping = true
    // controls.autoRotate = true
    // controls.autoRotateSpeed = 0.1
    // controls.maxPolarAngle = Math.PI / 4 * 2.5
    // controls.minPolarAngle = Math.PI / 4 * 2.5

    const axesHelper = new AxesHelper(5)
    scene.add(axesHelper)

    // 初始化渲染器
    const renderer = new WebGLRenderer({
        canvas
    })
    renderer.setSize(width, height)
    renderer.outputEncoding = sRGBEncoding
    renderer.toneMapping = ACESFilmicToneMapping
    // renderer.toneMapping = LinearToneMapping
    // renderer.toneMapping = ReinhardToneMapping
    // renderer.toneMapping = CineonToneMapping

    renderer.toneMappingExposure = 0.1

    renderer.render(scene, camera)


    const clock = new Clock()

    // 管理烟花
    let fireworks = []
    function render() {
        const elapsedTime = clock.getElapsedTime()

        fireworks.forEach((firework, i) => {
            const type = firework.update()
            if (type == 'remove') {
                fireworks.splice(i, 1)
            }
        })

        controls.update()
        renderer.render(scene, camera)
        requestAnimationFrame(render)
    }
    render()

    onUnmounted(() => {
        renderer.dispose()
    })


    // 设置烟花函数
    createFireworks = () => {
        let color = `hsl(${Math.floor(Math.random() * 360)},100%,80%)`
        let position = {
            x: (Math.random() - 0.5) * 40,
            z: -(Math.random() - 0.5) * 40,
            y: 7 + Math.random() * 25,

        }

        // 随机生成颜色和烟花放的位置
        let firework = new Firework(color, position)
        firework.addScene(scene, camera)
        fireworks.push(firework)
    }

})

let createFireworks
// 设置烟花创建函数
onMounted(() => {
    window.addEventListener("click", createFireworks)
})

onUnmounted(() => {
    window.removeEventListener("click", createFireworks)
})

</script>
            
<template>
    <BaseCanvas ref="base"></BaseCanvas>
</template>
            
<style scoped>

</style>