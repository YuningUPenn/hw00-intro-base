#version 300 es
uniform float u_Time;
uniform mat4 u_Model;
uniform mat4 u_ModelInvTr;
uniform mat4 u_ViewProj;
in vec4 vs_Pos;
in vec4 vs_Nor;
in vec4 vs_Col;
out vec4 fs_Nor;
out vec4 fs_LightVec;
out vec4 fs_Col;
out vec4 fs_WorldPos;
const vec4 lightPos = vec4(5, 5, 3, 1);

void main() {
    fs_Col = vs_Col;
    mat3 invTranspose = mat3(u_ModelInvTr);
    

    vec4 modelposition = u_Model * vs_Pos;
    vec3 pos = modelposition.xyz;

    pos.x += 0.03 * sin(u_Time*0.007 - pos.z * 5.0);
    pos.y += 0.07 * cos(u_Time*0.003 + pos.x * 3.0);
    modelposition.xyz = pos;
    fs_WorldPos = modelposition;
    
    fs_LightVec = lightPos - modelposition;
    fs_Nor = vec4(invTranspose * vec3(vs_Nor), 0);
    gl_Position = u_ViewProj * modelposition;   
}