module orly.engine.backend.ibackend;

import orly.engine.renderer.mesh;
import orly.engine.renderer.shader;
import orly.engine.math.matrix4x4;

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
	void VertexArrayDraw(int id, int size);

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

	/*
		Textures
	*/

	int TextureCreate(int width, int height, ubyte* data);
	void TextureDestroy(int id);
	void TextureBind(int id);
	void TextureUnbind();

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

interface IBackendGraphics {
	
}

IBackend Backend;
IBackendGraphics BackendGraphics;