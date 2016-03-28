module orly.engine.renderer.shader;

import orly.engine.backend.ibackend;
import orly.engine.math.vector2;
import orly.engine.math.vector3;
import orly.engine.math.matrix4x4;
import orly.engine.time;

/** Shader types. */
enum ShaderType { Vertex = 1, Fragment = 2, Geometry = 4 }

class Shader {
private:

	int program;
	bool compiled;

	int[string] uniforms;

	/**
		Registers engine default shader variables.
	*/
	void AddDefaults() { // TODO: Wykonywane manualnie, czy po kompilacji?
		AddUniform("time");
	}

public:

	ShaderType type = cast(ShaderType)0;

	/**
		Creates a new shader. It must be compiled, to use it.
	*/
	this() {
		program = Backend.ProgramCreate();
	}

	~this() {
		Backend.ProgramDestroy(program);
	}

	/**
		Adds a shader of specified type. After adding the sources, the shader must be compiled.
	*/
	void AddShader(ShaderType shaderType, string source) {
		assert(!compiled, "This program is already compiled! Can't add more shaders!");

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
		AddDefaults();
	}

	/**
		Binds the shader, so it will be used in next rendering operations.
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

	/*
		Uniforms
	*/

	/**
		Should be called before any bind call.
		Sets default uniform variables.
	*/
	void Update() {
		SetUniformNoThrow("time", Time.Seconds);
	}

	/**
		Registers an uniform, so it can be set later.
	*/
	void AddUniform(string name) {
		assert(compiled, "This shader must be compiled first!");

		uint addr = Backend.ProgramGetUniformLocation(program, name);

		if(addr != 0xFFFFFFFF)
			uniforms[name] = addr;
	}

	/**
		Sets uniform. Throws an exception, if uniform doesn't exist.
	*/
	void SetUniform(T)(string name, T variable) {
		if(auto ptr = name in uniforms) {
			static if(is(T : int))
				Backend.ProgramSetUniformInt(*ptr, variable);
			else static if(is(T : float))
				Backend.ProgramSetUniformFloat(*ptr, variable);
			else static if(is(T : Vector2))
				Backend.ProgramSetUniformVector2(*ptr, variable);
			else static if(is(T : Vector3))
				Backend.ProgramSetUniformVector3(*ptr, variable);
			else static if(is(T : Matrix4x4))
				Backend.ProgramSetUniformMatrix4x4(*ptr, variable);
		}
		else
			throw new Exception("No such uniform " ~ name ~ " registered.");
	}

	/**
		Sets uniform. If uniform doesn't exist, does nothing.
	*/
	void SetUniformNoThrow(T)(string name, T variable) { // TODO: Moze zamiast osobnej funkcji NoThrow, zrobic template z boolean'em?
		if(auto ptr = name in uniforms) {
			static if(is(T : int))
				Backend.ProgramSetUniformInt(*ptr, variable);
			else static if(is(T : float))
				Backend.ProgramSetUniformFloat(*ptr, variable);
			else static if(is(T : Vector2))
				Backend.ProgramSetUniformVector2(*ptr, variable);
			else static if(is(T : Vector3))
				Backend.ProgramSetUniformVector3(*ptr, variable);
			else static if(is(T : Matrix4x4))
				Backend.ProgramSetUniformMatrix4x4(*ptr, variable);
		}
	}
}