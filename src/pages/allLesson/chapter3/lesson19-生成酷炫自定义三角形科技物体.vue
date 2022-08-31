<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AxesHelper, BoxGeometry, BufferAttribute, BufferGeometry, Color, Mesh, MeshBasicMaterial, PerspectiveCamera, Scene, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
import { GUI } from 'dat.gui'
import { gsap } from "gsap";

// 打造酷炫三角形

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
    for (let i = 0; i < 50; i++) {
        // 每个三角形，需要三个顶点，每个顶点需要三个值
        const geometry = new BufferGeometry()
        const positionArray = new Float32Array(9)
        for (let j = 0; j < 9; j++) {
            positionArray[j] = (Math.random() - .5) * 5
        }

        let color = new Color(Math.random(), Math.random(), Math.random())
        const material = new MeshBasicMaterial({ color, transparent: true, opacity: .8 })
        // 根据几何体和材质创建模型


        geometry.setAttribute("position", new BufferAttribute(positionArray, 3))
        const mesh = new Mesh(geometry, material)
        scene.add(mesh)
    }


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