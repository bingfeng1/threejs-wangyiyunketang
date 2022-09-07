<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AxesHelper, BoxGeometry, BufferAttribute, BufferGeometry, Mesh, MeshBasicMaterial, PerspectiveCamera, Scene, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
import { GUI } from 'dat.gui'
import { gsap } from "gsap";

const base = ref()
const gui = new GUI()

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

    // 创建物体
    // 创建几何体
    const geometry = new BufferGeometry()
    const vertices = new Float32Array([
        -1.0, -1.0, 1.0,
        1.0, -1.0, 1.0,
        1.0, 1.0, 1.0,
        -1.0, -1.0, 1.0,
        1.0, 1.0, 1.0,
        -1.0, 1.0, 1.0
    ])


    const material = new MeshBasicMaterial({ color: 0xffff00 })
    // 根据几何体和材质创建模型


    geometry.setAttribute("position", new BufferAttribute(vertices, 3))
    const mesh = new Mesh(geometry, material)
    scene.add(mesh)

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

    // 双击控制屏幕进入全屏，推出全屏
    // window.addEventListener("dblclick", () => {
    //     const fullScreenElement = document.fullscreenElement
    //     if (!fullScreenElement) {
    //         canvas.requestFullscreen()
    //     } else {
    //         document.exitFullscreen()
    //     }
    // })

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