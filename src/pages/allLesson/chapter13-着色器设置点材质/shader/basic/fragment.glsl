precision lowp float;

varying vec2 vUv;
varying float vImgIndex;
varying vec3 vColor;

uniform sampler2D uTexture;
uniform sampler2D uTexture1;
uniform sampler2D uTexture2;

void main() {

    // // 根据纹理设置图案
    // vec4 textureColor = texture2D(uTexture, gl_PointCoord);
    // gl_FragColor = vec4(textureColor.rgb, textureColor.r);
    vec4 textureColor;
    if(vImgIndex == 0.0) {

        textureColor = texture2D(uTexture, gl_PointCoord);
    } else if(vImgIndex == 1.0) {

        textureColor = texture2D(uTexture1, gl_PointCoord);
    } else {

        textureColor = texture2D(uTexture2, gl_PointCoord);
    }
    // gl_FragColor = vec4(gl_PointCoord, 1.0, textureColor.r);
    gl_FragColor = vec4(vColor, textureColor.r);

}