module orly.engine.renderer.texture;

import orly.engine.backend.ibackend;

class Texture {
 private:

	int id;
	int width, height;

 public:

	/**
		Creates a new texture from specified RGBA data.
	*/
	this(int width, int height, ubyte* data) {
		id = Backend.TextureCreate(width, height, data);
		Backend.TextureGenerateMipmap(MinFilter.LinearMipmapLinear, MagFilter.Linear); // TODO: Mipmapy wybierane gdzie indziej
		Backend.TextureWrapMode(WrapMode.Repeat, WrapMode.Repeat);
	}

	/**
		Creates a new, empty texture.
	*/
	this(int width, int height, MinFilter minFilter = MinFilter.LinearMipmapLinear, MagFilter magFilter = MagFilter.Linear) {
		id = Backend.TextureCreate(width, height);
		Backend.TextureGenerateMipmap(minFilter, magFilter); // TODO: Mipmapy wybierane gdzie indziej
		Backend.TextureWrapMode(WrapMode.Repeat, WrapMode.Repeat);
	}

	~this() {
		Backend.TextureDestroy(id);
	}

	// TODO: Texture parameters

	@property int Id() { return id; }
	@property int Width() { return width; }
	@property int Height() { return height; }

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