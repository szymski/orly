module orly.engine.backend.sdl2;

import orly.engine.engine;
import orly.engine.backend.ibackend;
import orly.engine.renderer.mesh;
import derelict.opengl3.gl;
import derelict.sdl2.sdl;
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
    }

	void OpenWindow() {
		Log.Print("Creating SDL window");

        SDL_CreateWindowAndRenderer(800, 600, SDL_WINDOW_OPENGL, &window, &renderer);

		if(SDL_GL_CreateContext(window) == null)
			throw new Exception("SDL OpenGL context could not be created! Error: " ~ to!string(SDL_GetError()));

        if(window == null)
            throw new Exception("SDL window could not be created! Error: " ~ to!string(SDL_GetError()));
    }

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
 
	int VertexBufferCreate(Mesh mesh) {
		uint id;

		glGenBuffers(1, &id);
		glBindBuffer(GL_ARRAY_BUFFER, id);
		auto data = mesh.DataXYZ;
		glBufferData(GL_ARRAY_BUFFER, data.length * 4, data.ptr, GL_STATIC_DRAW);
		glBindBuffer(GL_ARRAY_BUFFER, 0);

		return id;
	}

	void VertexBufferDestroy(int id) {
		
	}

	void VertexBufferBind(int id) {
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, id);
	}

	void VertexBufferUnbind() {
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
	}

	void VertexBufferDraw(int id, int size) {
		glEnableVertexAttribArray(0);

		glBindBuffer(GL_ARRAY_BUFFER, id);
		glVertexAttribPointer(0, 3, GL_FLOAT, false, 3 * 4, null);

		glDrawArrays(GL_TRIANGLES, 0, size);
			
		glBindBuffer(GL_ARRAY_BUFFER, 0);

		glDisableVertexAttribArray(0);
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
		Projection
	*/

	void SetupPerspective(float fov, float zNear, float zFar) {
		float aspect = cast(float)Width / cast(float)Height;

		float ymax = zNear * tan(fov * PI / 360f);
		float ymin = -ymax;
		float xmin = ymin * aspect;
		float xmax = ymax * aspect;

		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glViewport(0, 0, Screen.Width, Screen.Height);
		glFrustum(xmin, xmax, ymin, ymax, zNear, zFar);

		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();
		glEnable(GL_DEPTH_TEST);
	}
}
