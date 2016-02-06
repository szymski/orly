module orly.engine.backend.sdl2;

import orly.engine.engine;
import orly.engine.backend.ibackend;
import derelict.opengl3.gl;
import derelict.sdl2.sdl;
import std.conv;
import std.datetime;
import std.math;

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
					Keyboard.SetKey(KeyboardKey.A, true);
					break;

				case SDL_KEYUP:
					Keyboard.SetKey(KeyboardKey.A, false);
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
 
	int VertexBufferCreate() {
		uint id;

		glGenBuffers(1, &id);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, id);

		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

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
    
	/*
		Projection
	*/

	void SetupPerspective(float fov, float zNear, float zFar) {
		float aspect = cast(float)Width / cast(float)Height;

		float fH = tan(fov / 360f * PI) * zNear;
		float fW = fH * aspect;

		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glViewport(0, 0, Screen.Width, Screen.Height);
		glFrustum(-fW, fW, -fH, fH, zNear, zFar);

		glMatrixMode(GL_MODELVIEW);
		glEnable(GL_DEPTH_TEST);
		glDepthFunc(GL_LEQUAL);
		glShadeModel(GL_SMOOTH);
	}
}
