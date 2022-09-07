<script setup>
import { onMounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AmbientLight, AxesHelper, BoxGeometry, Clock, DirectionalLight, Mesh, MeshBasicMaterial, MeshStandardMaterial, PerspectiveCamera, PlaneGeometry, Scene, SphereGeometry, WebGLRenderer } from 'three'
import * as CANNON from 'cannon-es'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';

const base = ref()

// 目标：使用cannon

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

    // 创建球和平面
    const sphereGeometry = new SphereGeometry(1, 20, 20)
    const sphereMaterial = new MeshStandardMaterial()
    const sphere = new Mesh(sphereGeometry, sphereMaterial)
    sphere.castShadow = true
    scene.add(sphere)

    const floor = new Mesh(
        new PlaneGeometry(20, 20),
        new MeshStandardMaterial()
    )
    floor.position.set(0, -5, 0)
    floor.rotation.x = -Math.PI / 2
    floor.receiveShadow = true
    scene.add(floor)

    // 创建物理世界
    // const world = new CANNON.World({
    //     gravity: new CANNON.Vec3(0, -9.8, 0)
    // })

    const world = new CANNON.World()
    world.gravity.set(0, -9.8, 0)
    // 创建物理小球
    const sphereShape = new CANNON.Sphere(1)

    // 设置物体材质
    const sphereWorldMaterial = new CANNON.Material({
        restitution: 100
    })

    // 创建物理世界的物体
    const sphereBody = new CANNON.Body({
        shape: sphereShape,
        position: new CANNON.Vec3(0, 0, 0),
        // 小球质量
        mass: 1,
        // 物体材质
        material: sphereWorldMaterial
    })

    // 将物体添加至物理世界
    world.addBody(sphereBody)

    // 创建击打声音
    const hitSound = new Audio("/metalHit.mp3")

    // 添加监听碰撞事件
    function HitEvent(e) {
        // console.log(e);
        // 获取碰撞的强度
        const impactStrength = e.contact.getImpactVelocityAlongNormal()
        console.log(impactStrength);
        if (impactStrength > 5) {
            hitSound.play()
        }
    }
    sphereBody.addEventListener('collide', HitEvent)

    // 物理世界创建地面
    const floorShape = new CANNON.Plane()
    const floorBody = new CANNON.Body()
    // 当质量为0的时候，可以使物体保持不动
    floorBody.mass = 0
    floorBody.addShape(floorShape)
    // 地面位置
    floorBody.position.set(0, -5, 0)
    // 旋转地面的位置
    floorBody.quaternion.setFromAxisAngle(new CANNON.Vec3(1, 0, 0), -Math.PI / 2)
    world.addBody(floorBody)


    // 灯光
    const light = new AmbientLight(
        0xffffff,
        .5
    )
    scene.add(light)

    const dirLight = new DirectionalLight(0xffffff, .5)
    dirLight.castShadow = true
    scene.add(dirLight)

    const controls = new OrbitControls(camera, canvas)
    controls.enableDamping = true

    const axesHelper = new AxesHelper(5)
    scene.add(axesHelper)

    // 初始化渲染器
    const renderer = new WebGLRenderer({
        canvas
    })
    renderer.setSize(width, height)
    renderer.shadowMap.enabled = true

    // 设置时钟
    const clock = new Clock()

    function render() {
        let deltaTime = clock.getDelta()
        // 更新物理引擎里世界的物体
        world.step(1 / 120, deltaTime)

        sphere.position.copy(sphereBody.position)

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