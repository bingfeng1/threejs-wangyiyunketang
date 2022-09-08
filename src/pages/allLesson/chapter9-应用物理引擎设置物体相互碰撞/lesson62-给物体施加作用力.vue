<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AmbientLight, AxesHelper, BoxBufferGeometry, BoxGeometry, Clock, DirectionalLight, Mesh, MeshBasicMaterial, MeshStandardMaterial, PerspectiveCamera, PlaneBufferGeometry, PlaneGeometry, Scene, SphereGeometry, WebGLRenderer } from 'three'
import * as CANNON from 'cannon-es'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
import { useCanvasEvent } from '../../../utils/useCanvasEvent';

const base = ref()

// 目标：使用cannon

onMounted(() => {
    const { canvas, width, height } = base.value
    const { addCanvasEventFn } = useCanvasEvent(canvas)
    // console.log(canvas);
    // 1、创建场景
    const scene = new Scene()

    // 2、创建相机
    const camera = new PerspectiveCamera(75, width / height, .1, 1000)

    // 设置相机位置
    camera.position.set(0, 0, 20)

    scene.add(camera)

    const cubeArr = []
    const cubeWorldMaterial = new CANNON.Material("cube")
    // 创建立方体和平面
    function createCube() {
        const cubeGeometry = new BoxBufferGeometry(1, 1, 1)
        const cubeMaterial = new MeshStandardMaterial()
        const cube = new Mesh(cubeGeometry, cubeMaterial)
        cube.castShadow = true
        scene.add(cube)

        // 创建物理小球
        const cubeShape = new CANNON.Box(new CANNON.Vec3(0.5, 0.5, 0.5))

        // 设置物体材质


        // 创建物理世界的物体
        const cubeBody = new CANNON.Body({
            shape: cubeShape,
            position: new CANNON.Vec3(0, 0, 0),
            // 小球质量
            mass: 1,
            // 物体材质
            material: cubeWorldMaterial
        })

        // 施加作用力
        cubeBody.applyLocalForce(
            // 添加的力的大小和方向
            new CANNON.Vec3(180, 0, 0),
            // 施加的力所在的位置
            new CANNON.Vec3(0, 0, 0)
        )

        // 将物体添加至物理世界
        world.addBody(cubeBody)

        cubeBody.addEventListener('collide', HitEvent)

        cubeArr.push({
            mesh: cube,
            body: cubeBody
        })
    }


    // 创建击打声音
    const hitSound = new Audio("/metalHit.mp3")

    // 添加监听碰撞事件
    function HitEvent(e) {
        // console.log(e);
        // 获取碰撞的强度
        const impactStrength = e.contact.getImpactVelocityAlongNormal()
        console.log(impactStrength);
        if (impactStrength > 1) {
            hitSound.currentTime = 0
            hitSound.volume = .01 * impactStrength
            hitSound.play()
        }
    }

    addCanvasEventFn("click", "addCube", createCube)

    // 这里可以释放此碰撞事件
    onUnmounted(() => {
        for (let { body } of cubeArr) {
            body.removeEventListener('collide', HitEvent)
        }
    })

    const floor = new Mesh(
        new PlaneBufferGeometry(20, 20),
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


    // 物理世界创建地面
    const floorShape = new CANNON.Plane()
    const floorBody = new CANNON.Body()
    const floorMaterial = new CANNON.Material("floor")
    floorBody.material = floorMaterial
    // 当质量为0的时候，可以使物体保持不动
    floorBody.mass = 0
    floorBody.addShape(floorShape)
    // 地面位置
    floorBody.position.set(0, -5, 0)
    // 旋转地面的位置
    floorBody.quaternion.setFromAxisAngle(new CANNON.Vec3(1, 0, 0), -Math.PI / 2)
    world.addBody(floorBody)


    // 设置两种材质碰撞的参数
    const defaultContactmaterial = new CANNON.ContactMaterial(
        cubeWorldMaterial,
        floorMaterial,
        {
            // 摩擦力
            friction: 0.1,
            // 弹性
            restitution: 0.7
        }
    )

    // 设置世界默认的碰撞材料，如果材料没有设置，都用这个
    world.defaultContactMaterial = defaultContactmaterial

    // 将材料的关联设置添加到物理世界
    world.addContactMaterial(defaultContactmaterial)

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

        // cube.position.copy(cubeBody.position)
        cubeArr.forEach(({ body, mesh }) => {
            mesh.position.copy(body.position)
            // 设置渲染的物体跟随物理的物体旋转
            mesh.quaternion.copy(body.quaternion)
        })

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