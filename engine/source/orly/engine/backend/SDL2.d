module orly.engine.backend.sdl2;

import orly.engine.engine;
import orly.engine.backend.ibackend;
import orly.engine.renderer.mesh;
import orly.engine.math.matrix4x4;
import derelict.opengl3.gl;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import std.conv;
import std.datetime;
import std.math;
import orly.engine.renderer.shader;
import std.string;

/**
	SDL 2.0 Backend
*/
class SDL2 : IBackend {
 private:
    SDL_Window* window;
	SDL_Renderer* renderer;
	int maxFPS = -1;

	void delegate() renderFunc;

	void InitSDL() {
		Log.Print("Initializing SDL");

        if(!SDL_Init(SDL_INIT_VIDEO) < 0)
            throw new Exception("SDL could not be initialized! Error: " ~ to!string(SDL_GetError()));

		SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 8);
		SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 8);
		SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 8);
		SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 8);
		SDL_GL_SetAttribute(SDL_GL_BUFFER_SIZE, 32);
		SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
    }

	void OpenWindow() {
		Log.Print("Creating SDL window");

        SDL_CreateWindowAndRenderer(800, 600, SDL_WINDOW_OPENGL, &window, &renderer);

		if(SDL_GL_CreateContext(window) == null)
			throw new Exception("SDL OpenGL context could not be created! Error: " ~ to!string(SDL_GetError()));

        if(window == null)
            throw new Exception("SDL window could not be created! Error: " ~ to!string(SDL_GetError()));
    }

	const int[] SDLMouseButtonToEngine = [
		1: 0,
		3: 1,
		2: 2,
	];

	void UpdateEvents() {
        SDL_Event event;

        while(SDL_PollEvent(&event)) {
            switch(event.type) {

				case SDL_QUIT:
					Engine.Close();
					break;

				case SDL_KEYDOWN:
					if(event.key.repeat) break;
					Keyboard.SetKey(cast(KeyboardKey)event.key.keysym.sym, true);
					break;

				case SDL_KEYUP:
					Keyboard.SetKey(cast(KeyboardKey)event.key.keysym.sym, false);
					break;

				case SDL_MOUSEBUTTONDOWN:
					Mouse.SetButton(SDLMouseButtonToEngine[event.button.button], true);
					break;

				case SDL_MOUSEBUTTONUP:
					Mouse.SetButton(SDLMouseButtonToEngine[event.button.button], false);
					break;

				case SDL_MOUSEMOTION:
					Mouse.Position.X = event.motion.x;
					Mouse.Position.Y = event.motion.y;
					Mouse.Acceleration.X = event.motion.xrel;
					Mouse.Acceleration.Y = event.motion.yrel;
					break;

				default:
					break;

			}		
        }    
    }

 public:

    /*
        Initialization
    */
    
    void Init() {
		Log.Print("Loading SDL and OpenGL libraries");
        DerelictSDL2.load("lib/SDL2.dll");
		DerelictSDL2Image.load("lib/SDL2_image.dll");
        DerelictGL.load();
        
        InitSDL();
        OpenWindow();

		DerelictGL.reload();
    }
    
    void Destroy() {
		Log.Print("Destroying SDL");

        SDL_DestroyWindow(window);
        SDL_Quit();    
    }
    
	void SetRenderFunc(void delegate() func) {
		renderFunc = func;
	}

	/*
		Window functions
    */
    
	@property int Width() {
		int w, h;
		SDL_GetWindowSize(window, &w, &h);
		return w;	
	}

	@property int Height() {
		int w, h;
		SDL_GetWindowSize(window, &w, &h);
		return h;	
	}

	@property ref int MaxFPS() { return maxFPS; };

	void SetWindowSize(int width, int height) {
		SDL_SetWindowSize(window, width, height);
	}

	@property void WindowTitle(string title) { SDL_SetWindowTitle(window, cast(char*)title); }
	@property string WindowTitle() { return to!string(SDL_GetWindowTitle(window)); }

    /*
        Update
    */
    
	private StopWatch sw = StopWatch();

    void Update() {
        UpdateEvents();    

		glClearColor(0.1f, 0.1f, 0.1f, 1f);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		renderFunc();

		SDL_GL_SwapWindow(window);

		// FPS limiting
		if(maxFPS != -1) {
			uint desiredMs = 1000 / maxFPS; // How much time the frame should take

			if(desiredMs - sw.peek.msecs > 0)
				SDL_Delay(cast(uint)(desiredMs - sw.peek.msecs));

			sw.start();
			sw.reset();
		}
    }

	/*
		Vertex buffers
	*/
 
	int VertexArrayCreate(Mesh mesh) {
		// Vertex array
		uint id;
		glGenVertexArrays(1, &id);
		glBindVertexArray(id);

		// Vertex buffer
		uint verticesId;
		glGenBuffers(1, &verticesId);
		glBindBuffer(GL_ARRAY_BUFFER, verticesId);
		auto data = mesh.DataXYZ;
		glBufferData(GL_ARRAY_BUFFER, data.length * 4, data.ptr, GL_STATIC_DRAW);
	
		glEnableVertexAttribArray(0);
		glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, null);

		// TexCoords buffer
		uint uvId;
		glGenBuffers(1, &uvId);
		glBindBuffer(GL_ARRAY_BUFFER, uvId);
		auto dataUV = mesh.DataUV;
		glBufferData(GL_ARRAY_BUFFER, dataUV.length * 4, dataUV.ptr, GL_STATIC_DRAW);

		glEnableVertexAttribArray(8);
		glVertexAttribPointer(8, 2, GL_FLOAT, GL_FALSE, 0, null);

		// Clear
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glBindVertexArray(0);

		return id;
	}

	void VertexArrayDestroy(uint id) {
		glDeleteVertexArrays(1, &id);
	}

	void VertexArrayBind(int id) {
		glBindVertexArray(id);
	}

	void VertexArrayUnbind() {
		glBindVertexArray(0);
	}

	void VertexArrayDraw(int id, int size) {
		glDrawArrays(GL_TRIANGLES, 0, size);
	}
    
	/*
		Shaders
	*/

	int ProgramCreate() {
		return glCreateProgram();
	}

	void ProgramDestroy(int id) {
		glDeleteProgram(id);
	}

	void ProgramUse(int id) {
		glUseProgram(id);
	}

	void ProgramUnbind() {
		glUseProgram(0);
	}

	void ProgramCompile(int id) {
		glLinkProgram(id);
	}

	int ShaderCreate(int program, ShaderType type, string source) {
		int shader = glCreateShader(type == ShaderType.Vertex ? GL_VERTEX_SHADER : (type == ShaderType.Geometry ? GL_GEOMETRY_SHADER : GL_FRAGMENT_SHADER));
		immutable(char)*[] name = [source.toStringz()];
		int len = source.length;
		glShaderSource(shader, 1, name.ptr, &len);
		glCompileShader(shader);

		// Check for errors
		int param;
		glGetShaderiv(shader, GL_COMPILE_STATUS, &param);
		if(param == 0) {
			char[1024] error;
			int strLen;
			glGetShaderInfoLog(shader, 1024, &strLen, error.ptr);
			Log.Throw(new Exception("Shader compilation error: " ~ to!string(error)));
		}

		glAttachShader(program, shader);

		return shader;
	}

	void ShaderDestroy(int id) {
		glDeleteShader(id);
	}

	/*
		Textures
	*/

	int TextureCreate(int width, int height, ubyte* data) {
		uint id;

		glGenTextures(1, &id);
		glBindTexture(GL_TEXTURE_2D, id);
		
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);

		return id;
	}

	void TextureDestroy(int id) {
		glDeleteTextures(1, cast(uint*)&id);
	}

	void TextureBind(int id) {
		glBindTexture(GL_TEXTURE_2D, id);
	}

	void TextureUnbind() {
		glBindTexture(GL_TEXTURE_2D, 0);
	}

	/*
		Projection
	*/

	void SetViewport(int x, int y, int width, int height) {
		glViewport(0, 0, width, height);
	}

	void SetMatrix(Matrix4x4 matrix) {
		float[16] arr = [
			matrix.m[0][0], matrix.m[0][1], matrix.m[0][2], matrix.m[0][3], 
			matrix.m[1][0], matrix.m[1][1], matrix.m[1][2], matrix.m[1][3], 
			matrix.m[2][0], matrix.m[2][1], matrix.m[2][2], matrix.m[2][3], 
			matrix.m[3][0], matrix.m[3][1], matrix.m[3][2], matrix.m[3][3], 
		];

		glLoadMatrixf(&arr[0]);
	}

	const int[] EngineMatrixModeToOpenGL = [
		MatrixMode.ModelView: GL_MODELVIEW,
		MatrixMode.Projection: GL_PROJECTION,
		MatrixMode.Texture: GL_TEXTURE,
		MatrixMode.Color: GL_COLOR,
	];

	void SetMatrixMode(MatrixMode mode) {
		glMatrixMode(EngineMatrixModeToOpenGL[mode]);
	}

	/*
		Face culling
	*/

	void EnableFaceCulling() {
		glEnable(GL_CULL_FACE);
	}

	void DisableFaceCulling() {
		glDisable(GL_CULL_FACE);
	}

	const int[] EngineCullingModeToOpenGL = [
		CullingMode.Back: GL_BACK,
		CullingMode.Front: GL_FRONT,
		CullingMode.FrontAndBack: GL_FRONT_AND_BACK
	];

	void SetFaceCullingMode(CullingMode mode) {
		glCullFace(EngineCullingModeToOpenGL[mode]);
	}

	/*
		Enables / disables
	*/

	void EnableDepth() {
		glEnable(GL_DEPTH_TEST);
	}

	void DisableDepth() {
		glDisable(GL_DEPTH_TEST);
	}

	void EnableTexture2D() {
		glEnable(GL_TEXTURE_2D);
	}

	void DisableTexture2D() {
		glDisable(GL_TEXTURE_2D);
	}
}
