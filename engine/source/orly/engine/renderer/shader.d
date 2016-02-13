module orly.engine.renderer.shader;

import orly.engine.backend.ibackend;

enum ShaderType { Vertex = 1, Fragment = 2, Geometry = 4 }

class Shader {
 private:

	int program;
	bool compiled;

 public:
	
	ShaderType type = cast(ShaderType)0;
	
	/**
		Creates a new shader. It must be compiled, to use it.
	*/
	this() {
		program = Backend.ProgramCreate();
	}

	/**
		Adds a shader of specified type. After adding the sources, the shader must be compiled.
	*/
	void AddShader(ShaderType shaderType, string source) {
		assert(!compiled, "This shader is already compiled! Can't add more shaders!");

		if(type & shaderType)
			throw new Exception("This type of shader is already added!");

		type |= shaderType;

		Backend.ShaderCreate(program, shaderType, source);
	}

	/**
		Compiles the shader. Using it more than once will throw an exception.
	*/
	void Compile() {
		assert(!compiled, "This shader is already compiled!");
		Backend.ProgramCompile(program);
		compiled = true;
	}

	/**
		Binds the shader, so it will be use in next rendering operations.
	*/
	void Bind() {
		assert(compiled, "This shader must be compiled first!");
		Backend.ProgramUse(program);
	}

	/**
		Unbinds the shader.
	*/
	void Unbind() {
		Backend.ProgramUnbind();
	}
}