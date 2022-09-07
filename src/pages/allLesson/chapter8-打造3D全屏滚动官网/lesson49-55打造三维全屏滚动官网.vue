<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AdditiveBlending, AmbientLight, AxesHelper, BoxBufferGeometry, BoxGeometry, BufferAttribute, BufferGeometry, Clock, Color, CubeTextureLoader, DirectionalLight, DoubleSide, EquirectangularReflectionMapping, Group, LoadingManager, Mesh, MeshBasicMaterial, MeshStandardMaterial, MirroredRepeatWrapping, NearestFilter, PerspectiveCamera, PlaneBufferGeometry, PointLight, Points, PointsMaterial, Raycaster, RepeatWrapping, Scene, SphereBufferGeometry, SphereGeometry, SpotLight, TextureLoader, Vector2, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
import { GUI } from 'dat.gui'
import { gsap } from "gsap";
import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader'
import { useCanvasEvent } from 'utils/useCanvasEvent'

const base = ref()
const gui = new GUI()

onUnmounted(() => {
    gui.destroy()
})

const main = ref()

onMounted(() => {
    const { canvas, width, height } = base.value
    const { addCanvasEventFn } = useCanvasEvent(base.value.canvas)


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
                    cube.position.set(i * 2 - 4, j * 2 - 4, z * 2 - 4)
                    cubeGroup.add(cube)
                    cubeArr.push(cube)
                }
            }
        }

        scene.add(cubeGroup)


        // 创建投射光线对象
        const raycaster = new Raycaster()

        // 监听鼠标的位置
        addCanvasEventFn('click', 'getRaycaster', (x, y) => {
            const mouse = new Vector2()
            mouse.x = x
            mouse.y = y
            raycaster.setFromCamera(mouse, camera)
            let result = raycaster.intersectObjects(cubeArr)
            if (result) {
                result.forEach((v) => v.object.material = redMaterial)
            }
        })
        addCanvasEventFn('click', 'log', (x, y) => {
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

    let sjxGroup = new Group()
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
                    positionArray[j] = (Math.random() - .5) * 5
                } else {
                    positionArray[j] = (Math.random() - .5) * 5
                }
            }

            let color = new Color(Math.random(), Math.random(), Math.random())
            const material = new MeshBasicMaterial({
                color,
                transparent: true,
                opacity: .5,
                side: DoubleSide
            })
            // 根据几何体和材质创建模型


            geometry.setAttribute("position", new BufferAttribute(positionArray, 3))
            let mesh = new Mesh(geometry, material)

            sjxGroup.add(mesh)
        }
        sjxGroup.position.set(0, -30, 0)

        scene.add(sjxGroup)
    }

    // 弹跳小球
    const sphereGroup = new Group()
    let smallBall
    {

        const sphereGeometry = new SphereBufferGeometry(1, 20, 20)
        const sphereMaterial = new MeshStandardMaterial({

        })

        const sphere = new Mesh(sphereGeometry, sphereMaterial)
        sphere.castShadow = true
        sphereGroup.add(sphere)


        const planeGeometry = new PlaneBufferGeometry(50, 50)

        const plane = new Mesh(planeGeometry, sphereMaterial)
        plane.position.set(0, -1, 0)
        plane.rotation.x = -Math.PI / 2
        plane.receiveShadow = true
        sphereGroup.add(plane)


        // 灯光
        // 环境光
        const light = new AmbientLight(0xffffff, .5)
        sphereGroup.add(light)

        smallBall = new Mesh(
            new SphereBufferGeometry(0.1, 20, 20),
            new MeshBasicMaterial({ color: 0xff0000 })
        )

        smallBall.position.set(2, 2, 2)


        // 直线光
        const pointLight = new PointLight(0xff0000, 2)
        pointLight.castShadow = true


        // 模糊度
        pointLight.shadow.radius = 20
        // 阴影贴图分辨率
        pointLight.shadow.mapSize.set(256, 256)

        pointLight.distance = 0
        pointLight.decay = 0

        // 设置透视相机可视区域

        smallBall.add(pointLight)
        sphereGroup.add(smallBall)

        sphereGroup.position.set(0, -60, 0)
        scene.add(sphereGroup)
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
    gsap.to(cubeGroup.rotation, {
        x: "+=" + Math.PI * 2,
        y: "+=" + Math.PI * 2,
        duration: 5,
        repeat: -1,
        ease: "power2.inOut"
    })

    gsap.to(sjxGroup.rotation, {
        x: "+=" + Math.PI * 2,
        y: "+=" + Math.PI * 2,
        duration: 5,
        repeat: -1,
        ease: "power2.inOut"
    })

    gsap.to(smallBall.position, {
        x: -3,
        z: 2,
        duration: 5,
        repeat: -1,
        ease: "power2.inOut",
        yoyo: true
    })
    gsap.to(smallBall.position, {
        y: 0,
        duration: .5,
        repeat: -1,
        ease: "power2.inOut",
        yoyo: true
    })


    const mouse = new Vector2()
    function animate() {
        let time = clock.getElapsedTime()
        let deltaTime = clock.getDelta()

        // cubeGroup.rotation.x = time * .5
        // cubeGroup.rotation.y = time * .5

        // sjxGroup.rotation.x = time * .4
        // sjxGroup.rotation.z = time * .3

        // smallBall.position.x = Math.sin(time) * 3
        // smallBall.position.z = Math.cos(time) * 3
        // smallBall.position.y = 2 + Math.sin(time)

        camera.position.x += (mouse.x * 5 - camera.position.x)

        // 根据当前滚动的scrolly，去设置相机移动的位置
        camera.position.y = -(mainDom.scrollTop / mainDom.clientHeight) * 30
        // controls.update()
        renderer.render(scene, camera)
        requestAnimationFrame(animate)
    }

    animate()

    {
        let arrGroup = [cubeGroup, sjxGroup, sphereGroup]
        let currentPage = 0

        function handleScroll() {
            const newPage = Math.round(mainDom.scrollTop / mainDom.clientHeight)
            if (newPage != currentPage) {
                currentPage = newPage
                console.log("改变页面，当前是：" + currentPage);

                gsap.to(arrGroup[currentPage].rotation, {
                    z: "+=" + Math.PI * 2,
                    duration: 1,
                })

                // gsap.to(`.page${currentPage + 1} h1`, {
                //     rotate: "+=" + 360,
                //     duration: 2
                // })
                gsap.fromTo(`.page${currentPage + 1} h1`,
                    {
                        x: -300
                    },
                    {
                        x: 0,
                        rotate: "+=" + 360,
                        duration: 2
                    })
            }
        }
        mainDom.addEventListener('scroll', handleScroll)
        onMounted(() => {
            mainDom.removeEventListener('scroll', handleScroll)
        })

    }

    {
        // 鼠标摇晃相机
        addCanvasEventFn("mousemove", 'moveCamera', (x, y) => {
            mouse.x = x
            mouse.y = y
        })
    }

})

</script>
            
<template>

    <section class="main" ref="main">
        <div class="canvas">
            <BaseCanvas style="background-color: transparent;" ref="base">
            </BaseCanvas>
        </div>
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
    overflow-y: auto;

    ::-webkit-scrollbar {
        display: none;
    }

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

    .canvas {
        height: calc(100vh - 40px);
        position: sticky;
        // position: -webkit-sticky;
        top: 0;
        margin-bottom: calc(-80vh - 200px);
    }
}
</style>