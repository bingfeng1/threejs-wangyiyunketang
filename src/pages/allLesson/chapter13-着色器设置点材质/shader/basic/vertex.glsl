precision lowp float;

varying vec2 vUv;
varying float vImgIndex;

attribute float imgIndex;

void main() {
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);
    gl_Position = projectionMatrix * viewMatrix * modelPosition;

    vUv = uv;
    vImgIndex = imgIndex;
    // 设置点的大小
    gl_PointSize = 80.0;
}