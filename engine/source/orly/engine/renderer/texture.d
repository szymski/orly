module orly.engine.renderer.texture;

import orly.engine.backend.ibackend;

class Texture {
 private:

	int id;
	int width, height;

 public:

	/**
		Creates a new texture.
	*/
	this(int width, int height, ubyte* data) {
		id = Backend.TextureCreate(width, height, data);
	}

	/**
		Binds the texture.
	*/
	void Bind() {
		Backend.TextureBind(id);
	}

	/**
		Unbinds the texture.
	*/
	void Unbind() {
		Backend.TextureUnbind();
	}
}