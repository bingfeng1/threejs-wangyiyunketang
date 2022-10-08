precision lowp float;

varying vec2 vUv;
varying float vImgIndex;
varying vec3 vColor;
attribute float aScale;
attribute float imgIndex;
uniform float uTime;


void main() {
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);

    vUv = uv;
    vImgIndex = imgIndex;

    // 获取顶点角度
    float angle = atan(modelPosition.x, modelPosition.z);
    // 获取顶点到中心的距离
    float distanceToCenter = length(modelPosition.xz);
    // 根据顶点到中心的距离，设置旋转偏移的度数
    float angleOffset = 1.0 / distanceToCenter * uTime;
    // 目前旋转度数
    angle += angleOffset;

    modelPosition.x = cos(angle) * distanceToCenter;
    modelPosition.z = sin(angle) * distanceToCenter;

    vec4 viewPosition = viewMatrix * modelPosition;
    gl_Position = projectionMatrix * viewPosition;

    // 设置点的大小
    // gl_PointSize = 80.0;
    // 根据viewPosition的z坐标决定是否远离摄像机
    gl_PointSize = 100.0 / -viewPosition.z * aScale;

    vColor = color;
}