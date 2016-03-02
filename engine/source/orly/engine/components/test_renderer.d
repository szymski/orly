module orly.engine.components.test_renderer;

import orly.engine.components.component;
import derelict.opengl3.gl;
import orly.engine.time;
import orly.engine.renderer.mesh;
import orly.engine.renderer.vertex;
import orly.engine.renderer.vertexbuffer;
import orly.engine.renderer.shader;
import orly.engine.assets.models.modelasset;
import orly.engine.components.factory;

class TestRenderer : Component { 

	VertexBuffer vb;
	ModelAsset model;
	Shader shader;

	this() {
		model = new ModelAsset("tris.md2");
		vb = new VertexBuffer(model.Mesh);

		shader = new Shader();
		shader.AddShader(ShaderType.Fragment, r"
						 float checkeredPattern( vec2 p ) {
						 float u = 1.0 - floor( mod( p.x, 2.0 ) );
						 float v = 1.0 - floor( mod( p.y, 2.0 ) );

						 if ( ( u == 1.0 && v < 1.0 ) || ( u < 1.0 && v == 1.0 ) ) {
						 return 0.0;
						 } else {
						 return 1.0;
						 }
		}

						 void main( void ) {
						 vec2 p = ( gl_FragCoord.xy * 2.0 ) / 100.0;
						 float a = 1.0;
						 gl_FragColor = vec4( vec3( checkeredPattern(  vec2( sign(p.x) * pow( p.x, a ) , sign(p.y) * pow( p.y, a)  ) * 5.0 ) ), 1.0 );
						 }
						 ");
		shader.Compile();
	}

	override public void OnRender() {
		glTranslatef(15f, -30f, -15f);
		glRotatef(100, 0, 1, 0);

		glDisable(GL_TEXTURE_2D);

		glColor3f(1f, 0f, 1f);
		shader.Bind();
		vb.Render();
		shader.Unbind();
	}

}

mixin RegisterComponent!TestRenderer;