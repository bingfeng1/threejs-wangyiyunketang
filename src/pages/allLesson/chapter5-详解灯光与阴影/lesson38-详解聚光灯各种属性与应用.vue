<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AmbientLight, AxesHelper, BoxBufferGeometry, BoxGeometry, BufferAttribute, BufferGeometry, Color, CubeTextureLoader, DirectionalLight, DoubleSide, EquirectangularReflectionMapping, LoadingManager, Mesh, MeshBasicMaterial, MeshStandardMaterial, MirroredRepeatWrapping, NearestFilter, PerspectiveCamera, PlaneBufferGeometry, RepeatWrapping, Scene, SphereBufferGeometry, SphereGeometry, SpotLight, TextureLoader, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
import { GUI } from 'dat.gui'
import { gsap } from "gsap";
import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader'

const base = ref()
const gui = new GUI()

// 目标：聚光灯
// 1、材质要满足足够的对光照反应
// 2、设置渲染器开始阴影的计算：renderer.shadowMap.enabled = true;
// 3、设置关照投射阴影directionalLight.castShadow = true
// 4、设置物体投射阴影sphere.castShadow = true
// 5、设置物体接受阴影plane.receiveShadow = true

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

    const SphereGeometry = new SphereBufferGeometry(1, 20, 20)
    const material = new MeshStandardMaterial({

    })

    const sphere = new Mesh(SphereGeometry, material)
    sphere.castShadow = true
    scene.add(sphere)


    const planeGeometry = new PlaneBufferGeometry(50, 50)

    const plane = new Mesh(planeGeometry, material)
    plane.position.set(0, -1, 0)
    plane.rotation.x = -Math.PI / 2
    plane.receiveShadow = true
    scene.add(plane)


    // 灯光
    // 环境光
    const light = new AmbientLight(0xffffff, .5)
    scene.add(light)
    // 直线光
    const spotLight = new SpotLight(0xffffff, .5)
    spotLight.position.set(5, 5, 5)
    spotLight.castShadow = true
    spotLight.intensity = 2

    // 模糊度
    spotLight.shadow.radius = 20
    // 阴影贴图分辨率
    spotLight.shadow.mapSize.set(512, 512)

    spotLight.target = sphere
    // 聚光灯角度
    spotLight.angle = Math.PI / 6
    spotLight.distance = 0
    spotLight.penumbra = 0
    spotLight.decay = 2

    // 设置透视相机可视区域

    scene.add(spotLight)

    gui.add(sphere.position, "x")
        .min(-5)
        .max(5)
        .step(.1)

    gui.add(spotLight, 'angle').min(0).max(Math.PI / 2).step(.01)

    gui.add(spotLight, 'distance')
        .min(0)
        .max(10)
        .step(.1)
    gui.add(spotLight, 'penumbra')
        .min(0)
        .max(1)
        .step(.01)
    gui.add(spotLight, 'decay')
        .min(0)
        .max(5)
        .step(.01)


    // 初始化渲染器
    const renderer = new WebGLRenderer({
        canvas
    })

    // 开启渲染阴影映射
    renderer.shadowMap.enabled = true
    renderer.setSize(width, height)
    renderer.render(scene, camera)
    renderer.physicallyCorrectLights = true

    // 创建轨道控制器
    const controls = new OrbitControls(camera, canvas)
    controls.enableDamping = true

    // 添加坐标轴辅助器
    const axesHelper = new AxesHelper(5)
    scene.add(axesHelper)

    // controls.update()
    function animate() {
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