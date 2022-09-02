<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AmbientLight, AxesHelper, BoxBufferGeometry, BoxGeometry, BufferAttribute, BufferGeometry, Color, CubeTextureLoader, DirectionalLight, DoubleSide, EquirectangularReflectionMapping, LoadingManager, Mesh, MeshBasicMaterial, MeshStandardMaterial, MirroredRepeatWrapping, NearestFilter, PerspectiveCamera, PlaneBufferGeometry, RepeatWrapping, Scene, SphereBufferGeometry, SphereGeometry, TextureLoader, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
import { GUI } from 'dat.gui'
import { gsap } from "gsap";
import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader'

const base = ref()
const gui = new GUI()

// 灯光与阴影
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
    camera.position.set(0, 0, 8)

    scene.add(camera)

    const SphereGeometry = new SphereBufferGeometry(1, 20, 20)
    const material = new MeshStandardMaterial({

    })

    const sphere = new Mesh(SphereGeometry, material)
    sphere.castShadow = true
    scene.add(sphere)


    const planeGeometry = new PlaneBufferGeometry(10, 10)

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
    const directionalLight = new DirectionalLight(0xffffff, .5)
    directionalLight.position.set(5, 5, 5)
    directionalLight.castShadow = true

    // 模糊度
    directionalLight.shadow.radius = 20
    // 阴影贴图分辨率
    directionalLight.shadow.mapSize.set(4096, 4096)

    // 设置平行光投射摄像机可视区域
    directionalLight.shadow.camera.near = .5
    directionalLight.shadow.camera.far = 500
    directionalLight.shadow.camera.top = 5
    directionalLight.shadow.camera.bottom = -5
    directionalLight.shadow.camera.left = -5
    directionalLight.shadow.camera.right = 5

    scene.add(directionalLight)

    gui.add(directionalLight.shadow.camera, "near")
        .min(0)
        .max(10)
        .step(.1)
        .onChange(() => {
            directionalLight.shadow.camera.updateProjectionMatrix()
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