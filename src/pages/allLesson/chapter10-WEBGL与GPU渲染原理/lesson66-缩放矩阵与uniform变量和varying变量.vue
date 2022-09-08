<script setup>
import { onMounted, ref } from 'vue';
import BaseCanvas from '../../../components/BaseCanvas.vue';
import { AxesHelper, BoxGeometry, Mesh, MeshBasicMaterial, PerspectiveCamera, PlaneBufferGeometry, Scene, ShaderMaterial, WebGLRenderer } from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
const base = ref()

onMounted(() => {
    const { canvas, width, height } = base.value
    // console.log(canvas);
    // 1、创建场景
    const scene = new Scene()

    // 2、创建相机
    const camera = new PerspectiveCamera(75, width / height, .1, 1000)

    // 设置相机位置
    camera.position.set(0, 0, 5)

    scene.add(camera)

    // const material = new MeshBasicMaterial({
    //     color: "#00ff00"
    // })

    // 创建着色器材质
    const shaderMaterial = new ShaderMaterial({
        vertexShader: `
            void main(){
                gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(position, 1);
            }
        `,
        fragmentShader: `
            void main(){
                gl_FragColor = vec4(1.0 , 1.0 , 0.0 , 1.0);
            }
        `
    })

    const floor = new Mesh(
        new PlaneBufferGeometry(1, 1, 64, 64),
        shaderMaterial
    )

    scene.add(floor)


    const controls = new OrbitControls(camera, canvas)
    controls.enableDamping = true

    const axesHelper = new AxesHelper(5)
    scene.add(axesHelper)

    // 初始化渲染器
    const renderer = new WebGLRenderer({
        canvas
    })
    renderer.setSize(width, height)
    renderer.render(scene, camera)

    function render() {

        controls.update()
        renderer.render(scene, camera)
        requestAnimationFrame(render)
    }
    render()

})
</script>
    
<template>
    <BaseCanvas ref="base"></BaseCanvas>
</template>
    
<style scoped>

</style>