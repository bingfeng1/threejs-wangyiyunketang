precision lowp float;

varying vec2 vUv;
uniform sampler2D uTexture;

void main() {

    // // 根据纹理设置图案
    // vec4 textureColor = texture2D(uTexture, gl_PointCoord);
    // gl_FragColor = vec4(textureColor.rgb, textureColor.r);

    vec4 textureColor = texture2D(uTexture, gl_PointCoord);
    gl_FragColor = vec4(gl_PointCoord, 1.0, textureColor.r);

}