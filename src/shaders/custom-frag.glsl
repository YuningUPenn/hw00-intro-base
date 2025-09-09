#version 300 es
precision highp float;

uniform vec4  u_Color;
uniform float u_Time;

in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec4 fs_Col;
in vec4 fs_WorldPos;

out vec4 out_Col;

float hash(vec3 p) {
    float randot = dot(p, vec3(69.341, 95.316, 73.598));
    randot = sin(randot) * 43758.5453;
    return fract(randot);
}

float Perlin(vec3 x) {
  vec3 whole = floor(x);
  vec3 frac = fract(x);

  vec3 curv = frac * frac * (3.0 - 2.0 * frac);

  float p000 = hash(whole + vec3(0.0, 0.0, 0.0));
  float p100 = hash(whole + vec3(1.0, 0.0, 0.0));
  float p010 = hash(whole + vec3(0.0, 1.0, 0.0));
  float p110 = hash(whole + vec3(1.0, 1.0, 0.0));
  float p001 = hash(whole + vec3(0.0, 0.0, 1.0));
  float p101 = hash(whole + vec3(1.0, 0.0, 1.0));
  float p011 = hash(whole + vec3(0.0, 1.0, 1.0));
  float p111 = hash(whole + vec3(1.0, 1.0, 1.0));

  float px00 = mix(p000, p100, curv.x);
  float px10 = mix(p010, p110, curv.x);
  float px01 = mix(p001, p101, curv.x);
  float px11 = mix(p011, p111, curv.x);

  float pxy0 = mix(px00, px10, curv.y);
  float pxy1 = mix(px01, px11, curv.y);

  float pxyz = mix(pxy0, pxy1, curv.z);

  return mix(pxy0, pxy1, curv.z);
}

void main() {
  float diffuseTerm = max(dot(normalize(fs_Nor.xyz), normalize(fs_LightVec.xyz)), 0.0);
  float ambientTerm = 0.2;
  float lightIntensity = diffuseTerm + ambientTerm;

  vec3 p = fs_WorldPos.xyz + vec3(-0.0305 * u_Time * 0.0966, 0.0931 * u_Time * 0.0475, -0.0891 * u_Time * 0.0393);
  float noise = Perlin(p);
  vec3 outColorRGB = u_Color.rgb * noise * lightIntensity * 2.0;

  out_Col = vec4(outColorRGB, u_Color.a);
}