<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AdditiveBlending, AmbientLight, AxesHelper, BoxBufferGeometry, BoxGeometry, BufferAttribute, BufferGeometry, Clock, Color, CubeTextureLoader, DirectionalLight, DoubleSide, EquirectangularReflectionMapping, Group, LoadingManager, Mesh, MeshBasicMaterial, MeshStandardMaterial, MirroredRepeatWrapping, NearestFilter, PerspectiveCamera, PlaneBufferGeometry, PointLight, Points, PointsMaterial, Raycaster, RepeatWrapping, Scene, SphereBufferGeometry, SphereGeometry, SpotLight, TextureLoader, Vector2, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
import { GUI } from 'dat.gui'
import { gsap } from "gsap";
import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader'
import { useDomEvent } from 'utils/useDomEvent'

const base = ref()
const gui = new GUI()

const main = ref()

onMounted(() => {
    const { canvas, width, height } = base.value
    const { addDomEventFn } = useDomEvent(base.value.canvas)


    // console.log(canvas);
    // 1、创建场景
    const scene = new Scene()

    // 2、创建相机
    const camera = new PerspectiveCamera(75, width / height, .1, 1000)

    // 设置相机位置
    camera.position.set(0, 0, 20)

    scene.add(camera)

    // 三维交互
    let cubeGroup = new Group()
    {
        const textureLoader = new TextureLoader()
        const particlesTexture = textureLoader.load("/textures/particles/1.png")

        const cubeGeometry = new BoxBufferGeometry(2, 2, 2)
        const material = new MeshBasicMaterial({
            wireframe: true
        })
        const redMaterial = new MeshBasicMaterial({
            color: "#ff0000"
        })

        let cubeArr = []
        // 1000个立方体
        for (let i = 0; i < 5; i++) {
            for (let j = 0; j < 5; j++) {
                for (let z = 0; z < 5; z++) {
                    const cube = new Mesh(cubeGeometry, material)
                    cube.position.set(i * 2 - 5, j * 2 - 5, z * 2 - 5)
                    cubeGroup.add(cube)
                    cubeArr.push(cube)
                }
            }
        }

        scene.add(cubeGroup)


        // 创建投射光线对象
        const raycaster = new Raycaster()

        // 监听鼠标的位置
        // addMouseMoveFn('mousemove', 'getRaycaster', (x, y) => {
        //     const mouse = new Vector2()
        //     mouse.x = x
        //     mouse.y = y
        //     raycaster.setFromCamera(mouse, camera)
        //     let result = raycaster.intersectObjects(cubeArr)
        //     if (result) {
        //         result.forEach((v) => v.object.material = redMaterial)
        //     }
        // })
        addDomEventFn('click', 'getRaycaster', (x, y) => {
            const mouse = new Vector2()
            mouse.x = x
            mouse.y = y
            raycaster.setFromCamera(mouse, camera)
            let result = raycaster.intersectObjects(cubeArr)
            if (result) {
                result.forEach((v) => v.object.material = redMaterial)
            }
        })
        addDomEventFn('click', 'log', (x, y) => {
            const mouse = new Vector2()
            mouse.x = x
            mouse.y = y
            raycaster.setFromCamera(mouse, camera)
            let result = raycaster.intersectObjects(cubeArr)
            if (result) {
                console.log(result);
            }
        })
    }

    let sjxMesh
    // 三角形
    {
        // 创建物体
        // 创建几何体
        for (let i = 0; i < 50; i++) {
            // 每个三角形，需要三个顶点，每个顶点需要三个值
            const geometry = new BufferGeometry()
            const positionArray = new Float32Array(9)
            for (let j = 0; j < 9; j++) {
                if (j % 3 === 1) {
                    positionArray[j] = (Math.random() - 7) * 5
                } else {
                    positionArray[j] = (Math.random() - .5) * 5
                }
            }

            let color = new Color(Math.random(), Math.random(), Math.random())
            const material = new MeshBasicMaterial({ color, transparent: true, opacity: .8 })
            // 根据几何体和材质创建模型


            geometry.setAttribute("position", new BufferAttribute(positionArray, 3))
            sjxMesh = new Mesh(geometry, material)
            scene.add(sjxMesh)
        }

    }

    // 初始化渲染器
    const renderer = new WebGLRenderer({
        canvas,
        alpha: true
    })

    // 开启渲染阴影映射
    renderer.shadowMap.enabled = true
    renderer.physicallyCorrectLights = true
    renderer.setSize(width, height)
    renderer.render(scene, camera)



    // 创建轨道控制器
    // const controls = new OrbitControls(camera, canvas)
    // controls.enableDamping = true

    // 添加坐标轴辅助器
    const axesHelper = new AxesHelper(5)
    scene.add(axesHelper)

    const clock = new Clock()

    const mainDom = main.value
    // controls.update()
    function animate() {
        let time = clock.getElapsedTime()

        cubeGroup.rotation.x = time * .5
        cubeGroup.rotation.y = time * .5

        // 根据当前滚动的scrolly，去设置相机移动的位置
        camera.position.y = -(mainDom.scrollTop / mainDom.clientHeight) * 30
        // controls.update()
        renderer.render(scene, camera)
        requestAnimationFrame(animate)
    }

    animate()

    let currentPage = 0
    let scrollYLength = 0
    // mainDom.addEventListener('mousewheel', (event) => {
    //     scrollYLength += event.deltaY
    //     mainDom.scrollTo({
    //         top:scrollYLength,
    //         behavior:'smooth'
    //     })
    //     const newPage = Math.round(mainDom.scrollTop / mainDom.clientHeight)
    //     if (newPage != currentPage) {
    //         currentPage = newPage
    //         console.log("改变页面，当前是：" + currentPage);
    //     }
    // })
})

onUnmounted(() => {
    gui.destroy()
})
</script>
            
<template>

    <section class="main" ref="main">
        <BaseCanvas style="background-color: transparent;height:calc(100vh - 40px);position: sticky;top: 20px;bottom:20px;"
            ref="base">
        </BaseCanvas>
        <div class="page page1">
            <h1>投射光线</h1>
            <h3>实现3D交互</h3>
        </div>
        <div class="page page2">
            <h1>BufferGeometry</h1>
            <h3>打造酷炫三角形</h3>
        </div>
        <div class="page page3">
            <h1>SpotLight</h1>
            <h3>目标：点光源</h3>
        </div>

    </section>
</template>
            
<style lang="scss" scoped>
section.main {
    background-color: rgb(11, 28, 66);
    color: white;
    position: relative;
    height: calc(100vh - 40px);
    overflow-y: visible;

    .page {
        height: 100vh;
        display: flex;
        align-items: center;
        flex-direction: column;

        h1 {
            margin: 30px;
            font-size: 40px;
        }

        h3 {
            font-size: 30px;
        }
    }
}
</style>