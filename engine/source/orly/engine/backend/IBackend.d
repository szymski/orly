module orly.engine.backend.ibackend;

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
	
	/** Creates a vertex buffer and returns its id */
	int VertexBufferCreate();
	/** Destroys a vertex buffer */
	void VertexBufferDestroy(int id);
	/** Binds vertex buffer */
	void VertexBufferBind(int id);
	/** Unbinds vertex buffer */
	void VertexBufferUnbind();

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