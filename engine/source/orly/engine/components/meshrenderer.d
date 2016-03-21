module orly.engine.components.meshrenderer;

import orly.engine.components.component;
import orly.engine.time;
import orly.engine.renderer.mesh;
import orly.engine.renderer.vertex;
import orly.engine.renderer.vertexarray;
import orly.engine.renderer.shader;
import orly.engine.assets.models.modelasset;
import orly.engine.components.factory;
import orly.engine.components.camera;
import orly.engine.assets.textures.textureasset;
import orly.engine.backend.ibackend;

alias Texture _Texture;
alias Shader _Shader;
alias VertexArray _VertexArray;
alias Mesh _Mesh;

mixin RegisterComponents;

class MeshRenderer : Component { 

 private:

	_Texture texture;
	_VertexArray va;
	_Shader shader;

 public:

	// TODO: VertexArray caching

	@property ref _Texture Texture() { return texture; }
	@property ref _Shader Shader() { return shader; }
	@property ref _VertexArray VertexArray() { return va; };

	@property void Mesh(_Mesh mesh) {
		va = new _VertexArray(mesh, DrawType.Triangles);
	};

	override public void OnRender() {
		if(!va || !texture) // Don't do anything, when vertex array or texture is null
			return;

		Backend.SetMatrix(Camera.main.GetViewMatrix() * GameObject.Transform.GetMatrix()); // Set view matrix

		Backend.EnableTexture2D();

		if(shader) {
			shader.Bind();
			shader.Update();
		}

		texture.Bind();
		va.Render();

		if(shader)
			shader.Unbind();
	}

}