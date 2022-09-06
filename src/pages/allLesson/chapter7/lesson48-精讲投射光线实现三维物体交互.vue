<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AdditiveBlending, AmbientLight, AxesHelper, BoxBufferGeometry, BoxGeometry, BufferAttribute, BufferGeometry, Clock, Color, CubeTextureLoader, DirectionalLight, DoubleSide, EquirectangularReflectionMapping, LoadingManager, Mesh, MeshBasicMaterial, MeshStandardMaterial, MirroredRepeatWrapping, NearestFilter, PerspectiveCamera, PlaneBufferGeometry, PointLight, Points, PointsMaterial, Raycaster, RepeatWrapping, Scene, SphereBufferGeometry, SphereGeometry, SpotLight, TextureLoader, Vector2, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
import { GUI } from 'dat.gui'
import { gsap } from "gsap";
import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader'

import { useDomEvent } from 'utils/useDomEvent'

const base = ref()
const gui = new GUI()

onMounted(() => {
    const { canvas, width, height } = base.value
    const { addDomEventFn } = useDomEvent(base.value.canvas)


    // console.log(canvas);
    // 1、创建场景
    const scene = new Scene()

    // 2、创建相机
    const camera = new PerspectiveCamera(75, width / height, .1, 1000)

    // 设置相机位置
    camera.position.set(0, 0, 10)

    scene.add(camera)

    const textureLoader = new TextureLoader()
    const particlesTexture = textureLoader.load("/textures/particles/1.png")

    const cubeGeometry = new BoxBufferGeometry(1, 1, 1)
    const material = new MeshBasicMaterial({
        wireframe: true
    })
    const redMaterial = new MeshBasicMaterial({
        color: "#ff0000"
    })

    let cubeArr = []
    // 1000个立方体
    for (let i = -5; i < 5; i++) {
        for (let j = -5; j < 5; j++) {
            for (let z = -5; z < 5; z++) {
                const cube = new Mesh(cubeGeometry, material)
                cube.position.set(i, j, z)
                scene.add(cube)
                cubeArr.push(cube)
            }
        }
    }


    // 创建投射光线对象
    const raycaster = new Raycaster()

    // 监听鼠标的位置
    // addDomEventFn('mousemove', 'getRaycaster', (x, y) => {
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


        controls.update()
        renderer.render(scene, camera)
        requestAnimationFrame(animate)
    }

    animate()

})

onUnmounted(() => {
    gui.destroy()
})
</script>
            
    <template>
    <BaseCanvas ref="base"></BaseCanvas>
</template>
            
    <style scoped>
    </style>