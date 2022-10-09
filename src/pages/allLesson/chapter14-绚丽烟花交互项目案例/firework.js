import { AdditiveBlending, BufferAttribute, BufferGeometry, Clock, Color, Points, ShaderMaterial } from "three";
// 顶点着色器
import startPointVertex from './shader/startpoint/vertex.glsl?raw'
// 片元着色器
import startPointFragment from './shader/startpoint/fragment.glsl?raw'
// 顶点着色器
import fireworksVertex from './shader/fireworks/vertex.glsl?raw'
// 片元着色器
import fireworksFragment from './shader/fireworks/fragment.glsl?raw'

export default class Firework {
    constructor(color, to, from = { x: 0, y: 0, z: 0 }) {
        // console.log("创建烟花", color, to);
        this.color = new Color(color)

        // 创建烟花发射的球
        this.startGeometry = new BufferGeometry()
        const startPositionArray = new Float32Array(3)
        startPositionArray[0] = from.x;
        startPositionArray[1] = from.y;
        startPositionArray[2] = from.z;
        this.startGeometry.setAttribute('position', new BufferAttribute(startPositionArray, 3))

        const astepArray = new Float32Array(3);
        astepArray[0] = to.x - from.x;
        astepArray[1] = to.y - from.y;
        astepArray[2] = to.z - from.z;
        this.startGeometry.setAttribute("aStep", new BufferAttribute(astepArray, 3))

        // 设置着色器材质
        this.startMaterial = new ShaderMaterial({
            vertexShader: startPointVertex,
            fragmentShader: startPointFragment,
            transparent: true,
            blending: AdditiveBlending,
            depthWrite: false,
            uniforms: {
                uTime: {
                    value: 0
                },
                uSize: {
                    value: 20
                },
                uColor: {
                    value: this.color
                }
            }
        })

        // 创建烟花球
        this.startPoint = new Points(this.startGeometry, this.startMaterial)

        // 开始计时
        this.clock = new Clock()

        // 创建爆炸烟花
        this.fireworkGeometry = new BufferGeometry();
        this.fireworksCount = 180 + Math.floor(Math.random() * 180);
        const positionFireworksArray = new Float32Array(this.fireworksCount * 3)
        const scaleFireArray = new Float32Array(this.fireworksCount)
        const directionArray = new Float32Array(this.fireworksCount * 3)

        for (let i = 0; i < this.fireworksCount; i++) {
            // 一开始烟花位置
            positionFireworksArray[i * 3 + 0] = to.x;
            positionFireworksArray[i * 3 + 1] = to.y;
            positionFireworksArray[i * 3 + 2] = to.z;
            // 设置烟花所有例子初始化大小
            scaleFireArray[i] = Math.random()
            // 设置四周发射的角度

            let theta = Math.random() * 2 * Math.PI;
            let beta = Math.random() * 2 * Math.PI;
            let r = Math.random();

            directionArray[i * 3 + 0] = r * Math.sin(theta) + r * Math.sin(beta)
            directionArray[i * 3 + 1] = r * Math.cos(theta) + r * Math.cos(beta)
            directionArray[i * 3 + 2] = r * Math.sin(theta) + r * Math.cos(beta)

        }

        this.fireworkGeometry.setAttribute("position", new BufferAttribute(positionFireworksArray, 3))
        this.fireworkGeometry.setAttribute("aScale", new BufferAttribute(scaleFireArray, 1))
        this.fireworkGeometry.setAttribute("aRandom", new BufferAttribute(directionArray, 3))

        this.fireworksMaterial = new ShaderMaterial({
            uniforms: {
                uTime: {
                    value: 0
                },
                uSize: {
                    value: 0
                },
                uColor: {
                    value: this.color
                }
            },
            transparent: true,
            blending: AdditiveBlending,
            depthWrite: false,
            vertexShader: fireworksVertex,
            fragmentShader: fireworksFragment
        })

        this.fireworks = new Points(this.fireworkGeometry, this.fireworksMaterial)
    }

    // 添加到场景
    addScene(scene, camera) {
        scene.add(this.startPoint)
        scene.add(this.fireworks)
        this.scene = scene
    }

    // update变量
    update() {
        const elapsedTime = this.clock.getElapsedTime()

        if (elapsedTime < 1) {
            this.startMaterial.uniforms.uTime.value = elapsedTime
            this.startMaterial.uniforms.uSize.value = 20
        } else {
            const time = elapsedTime - 1;
            this.startMaterial.uniforms.uSize.value = 0
            this.startPoint.clear()
            this.startGeometry.dispose()
            this.startMaterial.dispose()
            // this.clock.stop()

            // 设置烟花显示
            this.fireworksMaterial.uniforms.uSize.value = 20
            this.fireworksMaterial.uniforms.uTime.value = time

            if (time > 5) {
                this.fireworks.clear()
                this.fireworkGeometry.dispose()
                this.fireworksMaterial.dispose()

                this.scene.remove(this.fireworks)
                this.scene.remove(this.startPoint)
            }
        }
    }
}