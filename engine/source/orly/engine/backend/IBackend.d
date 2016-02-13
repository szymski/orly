module orly.engine.backend.ibackend;

import orly.engine.renderer.mesh;
import orly.engine.renderer.shader;

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

	/** Sets window size */
	void SetWindowSize(int width, int height);

	/** Max frames-per-second */
	@property ref int MaxFPS();

	@property void WindowTitle(string title);
	@property string WindowTitle();

	/*
		Vertex buffers
	*/
	
	/** Creates a vertex buffer from specified mesh and returns its id. */
	int VertexBufferCreate(Mesh mesh);
	/** Destroys a vertex buffer. */
	void VertexBufferDestroy(int id);
	/** Binds vertex buffer. */
	void VertexBufferBind(int id);
	/** Unbinds vertex buffer. */
	void VertexBufferUnbind();
	/** Draws vertex buffer. */
	void VertexBufferDraw(int id, int size);

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
		Projection
	*/

	/** Sets up perspective rendering. */
	void SetupPerspective(float fov, float zNear, float zFar);
}

interface IBackendGraphics {
	
}

IBackend Backend;
IBackendGraphics BackendGraphics;