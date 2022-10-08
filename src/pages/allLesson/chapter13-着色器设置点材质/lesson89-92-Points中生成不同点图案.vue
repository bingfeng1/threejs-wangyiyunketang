<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { ACESFilmicToneMapping, AdditiveBlending, AxesHelper, BoxGeometry, BufferAttribute, BufferGeometry, CineonToneMapping, Clock, Color, DirectionalLight, DoubleSide, EquirectangularReflectionMapping, LinearToneMapping, Mesh, MeshBasicMaterial, PerspectiveCamera, PlaneBufferGeometry, Points, PointsMaterial, RawShaderMaterial, ReinhardToneMapping, Scene, ShaderMaterial, sRGBEncoding, TextureLoader, Vector2, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';

import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import gsap from 'gsap';
import { GUI } from 'dat.gui';

// 导入water
import { Water } from "three/examples/jsm/objects/Water2"

import vertexShader from "./shader/basic/vertex.glsl?raw"
import fragmentShader from "./shader/basic/fragment.glsl?raw"

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
    camera.position.set(0, 0, 10)

    scene.add(camera)

    const textureLoader = new TextureLoader()
    const texture = textureLoader.load("/textures/particles/10.png")
    const texture1 = textureLoader.load("/textures/particles/8.png")
    const texture2 = textureLoader.load("/textures/particles/9.png")


    const params = {
        count: 10000,
        size: 0.1,
        radius: 10,
        branch: 6,
        color: "#ff6030",
        rotateScale: .5,
        outGalaxyColor: '#1b3984'
    }

    let geometry;
    let material;
    let points;

    const galaxyColor = new Color(params.color)
    const outGalaxyColor = new Color(params.outGalaxyColor)
    const generateGalaxy = () => {
        // 如果已经村子这些点，那么先释放内存，再删除顶点数据
        if (points !== null) {
            geometry?.dispose()
            material?.dispose()
            scene.remove(points)
        }

        // 生成顶点
        geometry = new BufferGeometry()
        // 随机生成位置
        const positions = new Float32Array(params.count * 3)
        // 设置顶点颜色
        const colors = new Float32Array(params.count * 3)

        // 大小
        const scales = new Float32Array(params.count)

        // 团的属性
        const imgIndex = new Float32Array(params.count)

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

            // 混合颜色，形成渐变色
            const mixColor = galaxyColor.clone()
            mixColor.lerp(outGalaxyColor, distance / params.radius)

            colors[current] = mixColor.r
            colors[current + 1] = mixColor.g
            colors[current + 2] = mixColor.b

            // 顶点大小
            scales[current] = Math.random()
            // 根据索引设置不同的图案
            imgIndex[current] = i % 3
            // imgIndex[current + 1] = i % 3
            // imgIndex[current + 2] = i % 3
        }

        geometry.setAttribute("position",
            new BufferAttribute(positions, 3)
        )
        geometry.setAttribute("color",
            new BufferAttribute(colors, 3)
        )
        geometry.setAttribute("aScale",
            new BufferAttribute(scales, 1)
        )
        geometry.setAttribute("imgIndex",
            new BufferAttribute(imgIndex, 1)
        )

        // // 设置点材质
        // material = new PointsMaterial({
        //     // color: new Color(params.color),
        //     size: params.size,
        //     sizeAttenuation: true,
        //     depthWrite: false,
        //     blending: AdditiveBlending,
        //     map: particlesTexture,
        //     alphaMap: particlesTexture,
        //     transparent: true,
        //     vertexColors: true

        // })

        // 设置点的着色器材质
        material = new ShaderMaterial({
            vertexShader,
            fragmentShader,
            vertexColors: true,
            transparent: true,
            blending: AdditiveBlending,
            depthWrite: false,
            uniforms: {
                uTime: {
                    value: 0
                },
                uTexture: {
                    value: texture
                },
                uTexture1: {
                    value: texture1
                },
                uTexture2: {
                    value: texture2
                },
                uColor: {
                    value: galaxyColor
                }
            }
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

        material.uniforms.uTime.value = time
        controls.update()
        renderer.render(scene, camera)
        requestAnimationFrame(animate)
    }

    animate()

})

</script>
            
<template>
    <BaseCanvas ref="base"></BaseCanvas>
</template>
            
<style scoped>

</style>