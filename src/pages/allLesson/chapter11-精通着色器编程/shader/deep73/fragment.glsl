precision lowp float;
varying vec2 vUv;
uniform float uTime;
uniform float uScale;

#define PI 3.14159265359

// 随机函数
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) *
        43758.5453123);
}

// 旋转函数
vec2 rotate(vec2 uv, float rotation, vec2 mid) {
    return vec2(cos(rotation) * (uv.x - mid.x) + sin(rotation) * (uv.y - mid.y) + mid.x, cos(rotation) * (uv.y - mid.y) - sin(rotation) * (uv.x - mid.x) + mid.x);
}

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise(in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f * f * (3.0 - 2.0 * f);
    // u = smoothstep(0.,1.,f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
        (c - a) * u.y * (1.0 - u.x) +
        (d - b) * u.x * u.y;
}

vec4 permute(vec4 x) {
    return mod(((x * 34.0) + 1.0) * x, 289.0);
}

vec2 fade(vec2 t) {
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

float cnoise(vec2 P) {
    vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
    vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
    Pi = mod(Pi, 289.0); // To avoid truncation effects in permutation
    vec4 ix = Pi.xzxz;
    vec4 iy = Pi.yyww;
    vec4 fx = Pf.xzxz;
    vec4 fy = Pf.yyww;
    vec4 i = permute(permute(ix) + iy);
    vec4 gx = 2.0 * fract(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
    vec4 gy = abs(gx) - 0.5;
    vec4 tx = floor(gx + 0.5);
    gx = gx - tx;
    vec2 g00 = vec2(gx.x, gy.x);
    vec2 g10 = vec2(gx.y, gy.y);
    vec2 g01 = vec2(gx.z, gy.z);
    vec2 g11 = vec2(gx.w, gy.w);
    vec4 norm = 1.79284291400159 - 0.85373472095314 * vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
    g00 *= norm.x;
    g01 *= norm.y;
    g10 *= norm.z;
    g11 *= norm.w;
    float n00 = dot(g00, vec2(fx.x, fy.x));
    float n10 = dot(g10, vec2(fx.y, fy.y));
    float n01 = dot(g01, vec2(fx.z, fy.z));
    float n11 = dot(g11, vec2(fx.w, fy.w));
    vec2 fade_xy = fade(Pf.xy);
    vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
    float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
    return 2.3 * n_xy;
}

void main() {
    // 1通过顶点对应的uv，决定每个像素在uv的图像位置，通过这个x,y决定颜色
    // gl_FragColor = vec4(vUv, 0.0, 1.0);

    // 2对第一种变形
    // gl_FragColor = vec4(vUv,1,1);

    // 3利用uv实现渐变效果，从左到右
    // vUv.x
    // float strength = vUv.x;
    // gl_FragColor = vec4(strength, strength, strength, 1.0);

    // 4从下到上
    // float strength = vUv.y;
    // gl_FragColor = vec4(strength, strength, strength, 1.0);

    // 增加变化
    // float strength = vUv.y * 10.0;
    // gl_FragColor = vec4(strength, strength, strength, 1.0);

    // 通过取模，得到反复
    // float strength = mod(vUv.y * 10.0, 1.0);
    // gl_FragColor = vec4(strength, strength, strength, 1.0);

    // step函数，step(edge,x) 如果X< edge ,返回0.0,否则返回1.0
    // float strength = mod(vUv.y * 10.0, 1.0);
    // strength = step(0.8, strength);
    // gl_FragColor = vec4(strength, strength, strength, 1.0);

    // float strength = mod(vUv.x * 10.0, 1.0);
    // strength = step(0.8, strength);
    // gl_FragColor = vec4(strength, strength, strength, 1.0);

    // 两种条纹相加

    // float strength = mod(vUv.x * 10.0, 1.0);
    // strength = step(0.8, strength);

    // float strength_y = mod(vUv.y * 10.0, 1.0);
    // strength += step(0.8, strength_y);
    // gl_FragColor = vec4(strength, strength, strength, 1.0);

    // 条纹相乘
    // float strength = step(0.8, mod(vUv.x * 10.0, 1.0));
    // strength *= step(0.8, mod(vUv.y * 10.0, 1.0));

    // 相减
    // float strength = step(0.8, mod(vUv.x * 10.0, 1.0));
    // strength -= step(0.8, mod(vUv.y * 10.0, 1.0));
    // gl_FragColor = vec4(strength, strength, strength, 1.0);

    // 方块图形
    // float strength = step(0.2, mod(vUv.x * 10.0, 1.0));
    // strength *= step(0.2, mod(vUv.y * 10.0, 1.0));
    // gl_FragColor = vec4(strength, strength, strength, 1.0);

    // float barX = step(0.4, mod(vUv.x * 10.0, 1.0)) * step(0.8, mod(vUv.y * 10.0, 1.0));
    // float barY = step(0.4, mod(vUv.y * 10.0, 1.0)) * step(0.8, mod(vUv.x * 10.0, 1.0));
    // float strength = barX + barY;
    // gl_FragColor = vec4(strength, strength, strength, 1.0);

    // float barX = step(0.4, mod((vUv.x + uTime * 0.1) * 10.0, 1.0)) * step(0.8, mod(vUv.y * 10.0, 1.0));
    // float barY = step(0.4, mod(vUv.y * 10.0, 1.0)) * step(0.8, mod(vUv.x * 10.0, 1.0));
    // float strength = barX + barY;
    // gl_FragColor = vec4(vUv, 1.0, strength);

    // 增加动画
    // float barX = step(0.4, mod((vUv.x + uTime * 0.1) * 10.0, 1.0)) * step(0.8, mod(vUv.y * 10.0, 1.0));
    // float barY = step(0.4, mod(vUv.y * 10.0, 1.0)) * step(0.8, mod(vUv.x * 10.0, 1.0));
    // float strength = barX + barY;
    // gl_FragColor = vec4(strength, strength, strength, 1.0);

    // 利用绝对值
    // float strength = abs(vUv.x - 0.5);
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 取两个值得最小值
    // float strength = min(abs(vUv.x - 0.5), abs(vUv.y - 0.5));
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 取两个值得最小大值
    // float strength = 1.0 - max(abs(vUv.x - 0.5), abs(vUv.y - 0.5));
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // step
    // float strength = step(0.2, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));
    // gl_FragColor = vec4(strength, strength, strength, 1);
    // float strength = 1.0 - step(0.2, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 利用取整，实现条纹渐变
    // float strength = ceil(vUv.y * 10.0) / 10.0;
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 条纹相乘，渐变格子

    // float strength = ceil(vUv.x * 10.0) / 10.0 * ceil(vUv.y * 10.0) / 10.0;
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 随机效果
    // float strength = random(vUv);
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 随机+格子效果
    // float strength = ceil(vUv.x * 10.0) / 10.0 * ceil(vUv.y * 10.0) / 10.0;
    // strength = random(vec2(strength, strength));
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 根据length返回向量长度
    // float strength = length(vUv);
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 根据distance计算两个向量的距离
    // float strength = 1.0 - distance(vUv, vec2(0.5, 0.5));
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 根据相除，实现星星
    // float strength = 0.15 / distance(vUv, vec2(0.5, 0.5)) - 1.0;
    // gl_FragColor = vec4(strength, strength, strength, strength);

    // 设置vUv水平或者垂直变量
    // float strength = 0.15 / distance(vec2(vUv.x, (vUv.y - 0.5) * 5.0), vec2(0.5, 0.5)) - 1.0;
    // gl_FragColor = vec4(strength, strength, strength, strength);

    // 十字交叉的星星
    // float strength = (0.15 / distance(vec2(vUv.x, (vUv.y - 0.5) * 5.0 + 0.5), vec2(0.5, 0.5)) - 1.0) + (0.15 / distance(vec2((vUv.x - 0.5) * 5.0 + 0.5, vUv.y), vec2(0.5, 0.5)) - 1.0);
    // gl_FragColor = vec4(strength, strength, strength, strength);

    // 旋转飞镖，旋转uv
    // vec2 rotateUv = rotate(vUv, 3.14 * 0.25, vec2(0.5, 0.5));
    // vec2 rotateUv = rotate(vUv, -uTime * 5.0, vec2(0.5, 0.5));

    // float strength = (0.15 / distance(vec2(rotateUv.x, (rotateUv.y - 0.5) * 5.0 + 0.5), vec2(0.5, 0.5)) - 1.0) + (0.15 / distance(vec2((rotateUv.x - 0.5) * 5.0 + 0.5, rotateUv.y), vec2(0.5, 0.5)) - 1.0);

    // gl_FragColor = vec4(strength, strength, strength, strength);

    // 画圆
    // float strength = step(0.5, distance(vUv, vec2(0.5)) + 0.25);
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 画圆2
    // float strength = 1.0 - step(0.5, distance(vUv, vec2(0.5)) + 0.25);
    // gl_FragColor = vec4(strength, strength, strength, strength);

    // 圆环
    // float strength = step(0.5, distance(vUv, vec2(0.5)) + 0.35);
    // strength *= (1.0 - step(0.5, distance(vUv, vec2(0.5)) + 0.25));
    // gl_FragColor = vec4(strength, strength, strength, strength);

    // 画环2
    // float strength = step(0.1, abs(distance(vUv, vec2(0.5)) - 0.25));
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 画环3
    // float strength = 1.0 - step(0.1, abs(distance(vUv, vec2(0.5)) - 0.25));
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 波浪环
    // vec2 waveUv = vec2(vUv.x, vUv.y + sin(vUv.x * 30.0) * 0.1);
    // float strength = 1.0 - step(0.01, abs(distance(waveUv, vec2(0.5)) - 0.25));
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 其他
    // vec2 waveUv = vec2(vUv.x + sin(vUv.y * 30.0) * 0.1, vUv.y + sin(vUv.x* 30.0) * 0.1);
    // float strength = 1.0 - step(0.01, abs(distance(waveUv, vec2(0.5)) - 0.25));
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 39其他
    // vec2 waveUv = vec2(vUv.x + sin(vUv.y * 100.0) * 0.1, vUv.y + sin(vUv.x* 100.0) * 0.1);
    // float strength = 1.0 - step(0.01, abs(distance(waveUv, vec2(0.5)) - 0.25));
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 40 根据角度显示试图
    // float angle = atan(vUv.x,vUv.y);
    // float strength = angle;
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 41根据角度实现螺旋渐变
    // float angle = atan(vUv.x - 0.5, vUv.y - 0.5);
    // float strength = (angle + 3.14) / 6.28;
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 实现雷达扫射
    // float alpha = 1.0 - step(0.5, distance(vUv, vec2(0.5)));
    // float angle = atan(vUv.x - 0.5, vUv.y - 0.5);
    // float strength = (angle + 3.14) / 6.28;
    // gl_FragColor = vec4(strength, strength, strength, alpha);

    // 43实现雷达扫射    
    // vec2 rotateUv = rotate(vUv, -uTime * 5.0, vec2(0.5));
    // float alpha = 1.0 - step(0.5, distance(vUv, vec2(0.5)));
    // float angle = atan(rotateUv.x - 0.5, rotateUv.y - 0.5);
    // float strength = (angle + 3.14) / 6.28;
    // gl_FragColor = vec4(strength, strength, strength, alpha);

    // 44万花筒
    // float angle = atan(vUv.x - 0.5, vUv.y - 0.5) / PI;
    // float strength = mod(angle * 10.0, 1.0);
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 45 光芒四射
    // float angle = atan(vUv.x - 0.5, vUv.y - 0.5) / (2.0 * PI);
    // float strength = sin(angle * 100.0);
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 46 使用噪声实现烟雾/波纹效果
    // float strength = noise(vUv);
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // float strength = noise(vUv * 10.0);
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 通过时间控制波形
    // float strength = step(uScale, noise(vUv * 10.0 + uTime));
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // float strength = abs(cnoise(vUv * 10.0));
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 发光路径
    // float strength = 1.0 - abs(cnoise(vUv * 10.0));
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 波纹效果
    // float strength = sin(cnoise(vUv * 10.0) * 5.0 + uTime);
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // float strength = step(0.9,sin(cnoise(vUv * 10.0) * 20.0));
    // gl_FragColor = vec4(strength, strength, strength, 1);

    // 使用混合函数混合颜色
    vec3 blackColor = vec3(0.0, 0.0, 0.0);
    vec3 yellowColor = vec3(1.0, 1.0, 0.0);
    vec3 uvColor = vec3(vUv, 1.0);
    float strength = step(0.9, sin(cnoise(vUv * 10.0) * 20.0));

    vec3 minColor = mix(uvColor, yellowColor, strength);
    gl_FragColor = vec4(minColor, 1);
}