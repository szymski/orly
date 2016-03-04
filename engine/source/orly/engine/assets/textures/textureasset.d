module orly.engine.assets.textures.textureasset;

public import orly.engine.renderer.texture;
import orly.engine.assets.asset;
import derelict.devil.il;
import std.stdio, std.conv;

alias Texture _Texture;

class TextureAsset : Asset {
 private:

	_Texture texture;

 public:

	this(string filename) {
		int img = ilGenImage();	
		ilBindImage(img);
		ilLoadImage(cast(char*)filename);

		int width = ilGetInteger(IL_IMAGE_WIDTH), height = ilGetInteger(IL_IMAGE_HEIGHT);

		ubyte[] data = new ubyte[width * height * 4];
		ilCopyPixels(0, 0, 0, width, height, 1, IL_RGBA, IL_UNSIGNED_BYTE, data.ptr);

		texture = new _Texture(width, height, data.ptr);

		ilDeleteImage(img);
	}

	@property _Texture Texture() {
		return texture;
	}

	override public bool CanHandle(string filename) {
		return true;
	}

}