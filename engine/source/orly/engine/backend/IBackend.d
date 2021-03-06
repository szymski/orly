module orly.engine.backend.ibackend;

import orly.engine.renderer.mesh;
import orly.engine.renderer.shader;
import orly.engine.math.matrix4x4;
import orly.engine.math.vector2;
import orly.engine.math.vector3;
import orly.engine.renderer.vertexarray;

/**
	Graphics matrix mode enum.
*/
enum MatrixMode {
	ModelView,
	Projection,
	Texture,
	Color
}

/**
	Face culling mode.
*/
enum CullingMode {
	Disabled,
	Front,
	Back,
	FrontAndBack
}

/**
	Texture minifying filter.
*/
enum MinFilter {
	Nearest,
	Linear,
	NearestMipmapNearest,
	LinearMipmapLinear,
	LinearMipmapNearest,
	NearestMipmapLinear
}

/**
	Texture magnification filter.
*/
enum MagFilter {
	Nearest,
	Linear
}

/**
	Texture wrap mode.
*/
enum WrapMode {
	ClampToEdge,
	ClampToBorder,
	MirroredRepeat,
	Repeat,
	MirrorClampToEdge
}

/**
	Render target struct.
*/
struct RT {
	int fboId;
	int rbId;
}

/**
	Graphics backend wrapper.
*/
interface IBackend {

	/*
		General
	*/

	/** Initializes the backend. Called only once, when the engine starts. */
    void Init();
	/** Destroys the backend. Closes the window and rendering context. */
    void Destroy();
	/** Updates the backend. Required for rendering. Must be called from the main loop. */
    void Update();

	/** Sets rendering function. All rendering should be done by this function. */
	void SetRenderFunc(void delegate() func);

	/*
		Window
	*/

	/** Returns the width of the window */
	@property int Width();
	/** Returns the height of the window */
	@property int Height();

	/** Sets window size. */
	void SetWindowSize(int width, int height);

	/** Max frames-per-second. -1 is no limit.*/
	@property ref int MaxFPS();

	@property void WindowTitle(string title);
	@property string WindowTitle();

	@property void LockCursor(bool value);
	@property bool LockCursor();

	/*
		Vertex arrays
	*/
	
	/** Creates a vertex array from specified mesh and returns its id. */
	int VertexArrayCreate(Mesh mesh);
	/** Destroys a vertex array. */
	void VertexArrayDestroy(uint id);
	/** Binds vertex array. */
	void VertexArrayBind(int id);
	/** Unbinds vertex array. */
	void VertexArrayUnbind();
	/** Draws vertex array. */
	void VertexArrayDraw(int id, int size, DrawType drawType);

	/*
		Shaders
	*/

	int ProgramCreate();
	void ProgramDestroy(int id);
	void ProgramUse(int id);
	void ProgramUnbind();
	void ProgramCompile(int id);

	int ShaderCreate(int program, ShaderType type, string source);
	void ShaderDestroy(int id);

	uint ProgramGetUniformLocation(int id, string name);

	void ProgramSetUniformInt(int location, int variable);
	void ProgramSetUniformFloat(int location, float variable);
	void ProgramSetUniformVector2(int location, Vector2 variable);
	void ProgramSetUniformVector3(int location, Vector3 variable);
	void ProgramSetUniformMatrix4x4(int location, Matrix4x4 variable);

	/*
		Textures
	*/

	/** Creates a new texture from RGBA data. Leaves texture binded. */
	int TextureCreate(int width, int height, ubyte* data);
	/** Creates a new, empty texture. Leaves texture binded. */
	int TextureCreate(int width, int height);
	void TextureDestroy(int id);
	void TextureBind(int id);
	void TextureUnbind();
	void TextureGenerateMipmap(MinFilter min, MagFilter mag);
	void TextureWrapMode(WrapMode s, WrapMode t);

	/*
		Render targets
	*/
	
	/** Creates a render target of specified size binded to specified texture. */
	RT RenderTargetCreate(int width, int height, int textureId);
	void RenderTargetDestroy(RT renderTarget);
	/** Binds render target. Returns previous framebuffer id. */
	int RenderTargetBind(RT renderTarget);
	/** Binds render target from framebuffer id. */
	void RenderTargetBind(int id);

	/*
		Projection
	*/

	/** Sets the viewport. */
	void SetViewport(int x, int y, int width, int heigh);

	/** Loads the matrix. */
	void SetMatrix(Matrix4x4 matrix);

	/** Sets current matrix mode. */
	void SetMatrixMode(MatrixMode mode);

	/*
		Face culling
	*/

	void EnableFaceCulling();
	void DisableFaceCulling();

	/** Sets face culling mode. */
	void SetFaceCullingMode(CullingMode mode);

	/*
		Enables / disables
	*/

	void EnableDepth();
	void DisableDepth();

	void EnableTexture2D();
	void DisableTexture2D();
}

/** Instance of the backend. Created in engine.d. */
IBackend Backend;