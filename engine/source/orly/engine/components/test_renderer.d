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
						 void main()
						 {
						 gl_FragColor = vec4(0.4,0.4,0.8,0.5);
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