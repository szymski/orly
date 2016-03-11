module orly.engine.engine;

public import orly.engine.debugging.log;
public import orly.engine.renderer.renderer;
public import orly.engine.backend.sdl2;
public import orly.engine.backend.ibackend;
public import orly.engine.input.keyboard;
public import orly.engine.input.mouse;
public import orly.engine.scene;
public import orly.engine.gameobjects.gameobject;
public import orly.engine.components.component;
public import orly.engine.time;
public import orly.engine.screen;
public import orly.engine.math.vector2;
public import orly.engine.math.vector3;

import derelict.assimp3.assimp;
import derelict.devil.il;
import std.datetime, std.stdio, std.conv;

final class Engine {
 private:

	static Engine instance;

	Scene scene;
	bool running = true;

	void RenderFunc() {
		scene.Render();
	}

 public:

	this() {
        instance = this;
    }

    ~this() {

    }

    void Init() {
		debug Log.Print("DEBUGGING ENABLED");
        Log.Print("Starting the engine");

		// Initialize the backend
	    Backend = new SDL2();
		Backend.Init();

		// Load other libraries
		DerelictASSIMP3.load("lib/assimp.dll");
		DerelictIL.load("lib/DevIL.dll");
		ilInit();

		// Set the options
		Backend.SetRenderFunc(&RenderFunc);
		Backend.MaxFPS = 120;
		//Backend.MaxFPS = -1;
		Backend.WindowTitle = "Orly";

		scene = new Scene();

		PrepareTheScene(); // Prepare a test scene

        EnterMainLoop(); // Enter the main loop

		// Destroy the backend and save the log to a file
		Backend.Destroy();
	    Log.SaveToFile();
    }
    
    void EnterMainLoop() {
		StopWatch swFrame;
		StopWatch swSecond;
		StopWatch swTotal;
		swSecond.start();
		swTotal.start();

		int frames;
		int fps;

        while(running) {
			// FPS counting
			if(swSecond.peek.nsecs >= 1_000_000_000) {
				fps = frames;
				frames = 0;
				swSecond.reset();
				Backend.WindowTitle = "Orly: " ~ to!string(fps) ~ " FPS";
			}

			swFrame.start(); // Start frame stopwatch

			// Updating
			Backend.Update();
			scene.Update();
            Renderer.Update();
			Keyboard.Reset();
			Mouse.Reset();

			Time.DeltaTime = swFrame.peek.nsecs / 1_000_000_000f; // Save delta time
			Time.Seconds = swTotal.peek.nsecs / 1_000_000_000f; // Save seconds since the start

			swFrame.reset(); // Reset frame stopwatch

			frames++;
        }   
    }
    
    /*
        Static
    */
    
    static void Close() {
        instance.running = false;
    }
    
}




import orly.engine.components.factory;

mixin RegisterComponents;

class Test : Component {
	
	override public void OnUpdate() {
		if(Keyboard.GetKeyDown(KeyboardKey.Q))
			Mouse.LockCursor = !Mouse.LockCursor;
	}
	
}

void PrepareTheScene() {
	Log.Print("Preparing a test scene");

	import orly.engine.components.test_renderer;
	import orly.engine.components.camera;
	import orly.engine.components.cameramovement;

	GameObject camera = CurrentScene.CreateGameObject();
	camera.AddComponent!Camera();
	camera.AddComponent!CameraMovement();
	camera.AddComponent!Test();
	

	GameObject obj = CurrentScene.CreateGameObject();
	obj.AddComponent!TestRenderer();
}