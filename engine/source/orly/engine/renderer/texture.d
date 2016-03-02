module orly.engine.renderer.texture;

import orly.engine.backend.ibackend;

class Texture {
 private:

	int id;

 public:

	/**
		Creates a new texture.
	*/
	this() {
		id = Backend.TextureCreate();
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