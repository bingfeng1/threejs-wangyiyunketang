<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AxesHelper, BoxBufferGeometry, BoxGeometry, BufferAttribute, BufferGeometry, Color, DoubleSide, Mesh, MeshBasicMaterial, MirroredRepeatWrapping, NearestFilter, PerspectiveCamera, PlaneBufferGeometry, RepeatWrapping, Scene, TextureLoader, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
import { GUI } from 'dat.gui'
import { gsap } from "gsap";

const base = ref()
// const gui = new GUI()

// 透明纹理

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

    // 创建物体
    const cubeGeometry = new BoxBufferGeometry(1, 1, 1)
    // 材质
    const basicMaterial = new MeshBasicMaterial({
        // color: "#ffff00",
        map: doorColorTexture,
        transparent: true,
        alphaMap: doorAlphaTexture,
        opacity: .8,
        // 背面
        side: DoubleSide,
    })

    const cube = new Mesh(cubeGeometry, basicMaterial)
    scene.add(cube)

    // 添加平面
    const plane = new Mesh(
        new PlaneBufferGeometry(1, 1),
        basicMaterial
    )

    plane.position.set(3, 0, 0)
    scene.add(plane)

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