<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AmbientLight, AxesHelper, BoxBufferGeometry, BoxGeometry, BufferAttribute, BufferGeometry, Color, CubeTextureLoader, DirectionalLight, DoubleSide, EquirectangularReflectionMapping, LoadingManager, Mesh, MeshBasicMaterial, MeshStandardMaterial, MirroredRepeatWrapping, NearestFilter, PerspectiveCamera, PlaneBufferGeometry, RepeatWrapping, Scene, SphereBufferGeometry, SphereGeometry, TextureLoader, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
import { GUI } from 'dat.gui'
import { gsap } from "gsap";
import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader'

const base = ref()
// const gui = new GUI()


onMounted(() => {
    const { canvas, width, height } = base.value

    // 加载hdr环境纹理
    const rgbeLoader = new RGBELoader()
    rgbeLoader.loadAsync("/textures/hdr/002.hdr").then((texture)=>{
        texture.mapping = EquirectangularReflectionMapping
        scene.background = texture
        scene.environment = texture
    })

    // console.log(canvas);
    // 1、创建场景
    const scene = new Scene()

    // 2、创建相机
    const camera = new PerspectiveCamera(75, width / height, .1, 1000)

    // 设置相机位置
    camera.position.set(0, 0, 2)

    scene.add(camera)

    // 设置cube纹理加载器
    const cubeTextureLoader = new CubeTextureLoader()
    const envMapTexture = cubeTextureLoader.load([
        "/textures/environmentMaps/1/px.jpg",
        "/textures/environmentMaps/1/nx.jpg",
        "/textures/environmentMaps/1/py.jpg",
        "/textures/environmentMaps/1/ny.jpg",
        "/textures/environmentMaps/1/pz.jpg",
        "/textures/environmentMaps/1/nz.jpg",
    ])

    const sphereGeometry = new SphereGeometry(1, 20, 20)
    const material = new MeshStandardMaterial({
        // envMap: envMapTexture,
        metalness: .7,
        roughness: .1
    })

    const sphere = new Mesh(sphereGeometry, material)
    scene.add(sphere)

    // 给场景添加背景
    // scene.background = envMapTexture
    // 给场景所有的物体添加默认的环境贴图
    scene.environment = envMapTexture

    // 灯光
    // 环境光
    const light = new AmbientLight(0xffffff, .5)
    scene.add(light)
    // 直线光
    const directionalLight = new DirectionalLight(0xffffff, .5)
    directionalLight.position.set(10, 10, 10)

    scene.add(directionalLight)


    // 初始化渲染器
    const renderer = new WebGLRenderer({
        canvas
    })
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

// onUnmounted(() => {
//     gui.destroy()
// })
</script>
    
    <template>
    <BaseCanvas ref="base"></BaseCanvas>
</template>
    
    <style scoped>
    </style>