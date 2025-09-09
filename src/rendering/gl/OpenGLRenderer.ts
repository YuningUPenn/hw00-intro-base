import {mat4, vec4} from 'gl-matrix';
import Drawable from './Drawable';
import Camera from '../../Camera';
import {gl} from '../../globals';
import ShaderProgram from './ShaderProgram';

// In this file, `gl` is accessible because it is imported above
class OpenGLRenderer {
  constructor(public canvas: HTMLCanvasElement) {
  }

  setClearColor(r: number, g: number, b: number, a: number) {
    gl.clearColor(r, g, b, a);
  }

  setSize(width: number, height: number) {
    this.canvas.width = width;
    this.canvas.height = height;
  }

  clear() {
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
  }

  render(camera: Camera, prog: ShaderProgram, drawables: Array<Drawable>, hexcolor: string) {
    let model = mat4.create();
    let viewProj = mat4.create();
    //let color = vec4.fromValues(1, 0, 0, 1);
    if (hexcolor.startsWith('#')){
      hexcolor = hexcolor.slice(1);
    }
    const r = parseInt(hexcolor.slice(0, 2), 16) / 255;
    const g = parseInt(hexcolor.slice(2, 4), 16) / 255;
    const b = parseInt(hexcolor.slice(4, 6), 16) / 255;
    const a = hexcolor.length === 8 ? parseInt(hexcolor.slice(6, 8), 16) / 255 : 1.0;
    let color = vec4.fromValues(r,g,b,a);

    mat4.identity(model);
    mat4.multiply(viewProj, camera.projectionMatrix, camera.viewMatrix);
    prog.setModelMatrix(model);
    prog.setViewProjMatrix(viewProj);
    prog.setGeometryColor(color);

    for (let drawable of drawables) {
      prog.draw(drawable);
    }
  }
};

export default OpenGLRenderer;
