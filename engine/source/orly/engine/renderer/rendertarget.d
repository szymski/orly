module orly.engine.renderer.rendertarget;

import orly.engine.backend.ibackend;
import orly.engine.renderer.texture;

alias Texture _Texture;

/**
	Render to texture object.
*/
class RenderTarget {
 private:

	RT rt;
	_Texture tex;

	int lastId;

 public:

	/**
		Creates a new render target with specified size.
	*/
	this(int width, int height) {
		tex = new _Texture(width, height);
		rt = Backend.RenderTargetCreate(width, height, tex.Id);
	}
	
	~this() {
		//delete tex;
		Backend.RenderTargetDestroy(rt);
	}

	@property ref _Texture Texture() { return tex; }
	
	/**
		Binds the render target for drawing.	
	*/
	void Bind() {
		lastId = Backend.RenderTargetBind(rt);
	}

	/**
		Binds previous render target.
	*/
	void Unbind() {
		Backend.RenderTargetBind(lastId);
	}

	/**
		Binds the texture.
	*/
	void BindTexture() {
		tex.Bind();
	}


}
