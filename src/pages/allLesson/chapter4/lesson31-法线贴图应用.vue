<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AmbientLight, AxesHelper, BoxBufferGeometry, BoxGeometry, BufferAttribute, BufferGeometry, Color, DirectionalLight, DoubleSide, Mesh, MeshBasicMaterial, MeshStandardMaterial, MirroredRepeatWrapping, NearestFilter, PerspectiveCamera, PlaneBufferGeometry, RepeatWrapping, Scene, TextureLoader, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
import { GUI } from 'dat.gui'
import { gsap } from "gsap";

const base = ref()
// const gui = new GUI()

// 法线贴图

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

    // 导入纹理
    const textureLoader = new TextureLoader()

    const doorColorTexture = textureLoader.load("/textures/door/color.jpg")
    const doorAlphaTexture = textureLoader.load("/textures/door/alpha.jpg")
    const doorAoTexture = textureLoader.load("/textures/door/ambientOcclusion.jpg")
    // 导入置换贴图
    const doorHeightTexture = textureLoader.load("/textures/door/height.jpg")
    // 导入粗糙度贴图
    const doorRoughnessTexture = textureLoader.load("/textures/door/roughness.jpg")
    // 导入金属贴图
    const doorMetalnessTexture = textureLoader.load("/textures/door/metalness.jpg")
    // 导入法线贴图
    const doorNormalTexture = textureLoader.load("/textures/door/normal.jpg")

    // 创建物体
    const cubeGeometry = new BoxBufferGeometry(1, 1, 1, 200, 200, 200)
    // 材质
    const material = new MeshStandardMaterial({
        // color: "#ffff00",
        map: doorColorTexture,
        transparent: true,
        alphaMap: doorAlphaTexture,
        // opacity: .8,
        // 背面
        side: DoubleSide,
        aoMap: doorAoTexture,
        displacementMap: doorHeightTexture,
        displacementScale: 0.05,
        roughness: 1,
        roughnessMap: doorRoughnessTexture,
        metalness: 1,
        metalnessMap: doorMetalnessTexture,
        normalMap: doorNormalTexture
    })

    const cube = new Mesh(cubeGeometry, material)
    scene.add(cube)

    // 给cube设置第二组UV！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
    cubeGeometry.setAttribute('uv2', new BufferAttribute(cubeGeometry.attributes.uv.array, 2))

    // 添加平面
    const planeGeometry = new PlaneBufferGeometry(1, 1, 200, 200)
    const plane = new Mesh(
        planeGeometry,
        material
    )

    plane.position.set(2, 0, 0)
    scene.add(plane)
    // 设置第二组UV！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
    planeGeometry.setAttribute('uv2', new BufferAttribute(planeGeometry.attributes.uv.array, 2))

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