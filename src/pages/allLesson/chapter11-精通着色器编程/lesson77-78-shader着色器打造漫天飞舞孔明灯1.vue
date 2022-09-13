<script setup>
import { onMounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { ACESFilmicToneMapping, AxesHelper, BoxGeometry, CineonToneMapping, Clock, DoubleSide, EquirectangularReflectionMapping, LinearToneMapping, Mesh, MeshBasicMaterial, PerspectiveCamera, PlaneBufferGeometry, RawShaderMaterial, ReinhardToneMapping, Scene, ShaderMaterial, sRGBEncoding, TextureLoader, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';

// 顶点着色器
import vertexShader from './shader/flylight/vertex.glsl?raw'
// 片元着色器
import fragmentShader from './shader/flylight/fragment.glsl?raw'
import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import gsap from 'gsap';

const base = ref()

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
    gltfLoader.load('/models/flyLight.glb', (gltf) => {
        console.log(gltf);
        // scene.add(gltf.scene)
        lightBox = gltf.scene.children[1]
        lightBox.material = shaderMaterial


        for (let i = 0; i < 150; i++) {
            let flyLight = gltf.scene.clone(true)
            let x = (Math.random() - 0.5) * 300
            let z = (Math.random() - 0.5) * 300
            let y = Math.random() * 60
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
                yoyo:true
            })

            scene.add(flyLight)
        }

    })





    const controls = new OrbitControls(camera, canvas)
    controls.enableDamping = true
    controls.autoRotate = true
    controls.autoRotateSpeed = 0.1
    controls.maxPolarAngle = Math.PI / 4 * 3
    controls.minPolarAngle = Math.PI / 4 * 3

    // const axesHelper = new AxesHelper(5)
    // scene.add(axesHelper)

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

})
</script>
            
<template>
    <BaseCanvas ref="base"></BaseCanvas>
</template>
            
<style scoped>

</style>