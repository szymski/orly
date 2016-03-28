module orly.engine.renderer.shaders.standardshader;

import orly.engine.renderer.shader;
import std.file;

class StandardShader : Shader {

	this() {
		super();

		AddShader(ShaderType.Vertex, readText("shaders/standard.vert.glsl"));
		AddShader(ShaderType.Fragment, readText("shaders/standard.frag.glsl"));

		Compile();
	}

	
}