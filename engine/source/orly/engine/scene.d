module orly.engine.scene;

import orly.engine.backend.ibackend;
import orly.engine.gameobjects.gameobject;
import orly.engine.renderer.rendertarget;
import orly.engine.components.camera;
import orly.engine.time;
import orly.engine.screen;
import orly.engine.api;

final class Scene {
 private:

	GameObject[] gameObjects;

	RenderTarget rt;
	VertexArray va;

 public:

	this() {
		CurrentScene = this;
		rt = new RenderTarget(Screen.Width, Screen.Height);
		va = new VertexArray(new Mesh([
			Vertex(0, 0, 0, 0, 0),
			Vertex(Screen.Width, 0, 0, 1, 0),
			Vertex(Screen.Width, Screen.Height, 0, 1,  1),
			Vertex(0, Screen.Height, 0, 0, 1),
		]), DrawType.Quads);
	} 

	/**	Updates the scene.
	*/
	void Update() {
		foreach(obj; gameObjects)
			obj.Update();
	}

	/**
		Renders the scene.
	*/
	void Render() {
		//rt.Bind();

		import derelict.opengl3.gl;
		glClearColor(0.1f, 0.1f, 0.1f, 1f);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		if(Camera.main !is null)
			Camera.main.SetupRendering();

		foreach(obj; gameObjects)
			obj.Render();

		//rt.Unbind(); // TODO: Remove - debug purposes. 
		//
		//if(Camera.main !is null)
		//    Camera.main.SetupRendering();
		//
		//auto m3 = new Matrix4x4();
		////m3.InitOrthographic(0, 0, Screen.Width, Screen.Height, -1f, 1f);
		////Backend.SetMatrixMode(MatrixMode.Projection);
		////Backend.SetViewport(0, 0, Screen.Width, Screen.Height);
		////Backend.SetMatrix(m3);
		//
		//m3.InitIdentity();
		//auto rotM = new Matrix4x4();
		//rotM.InitRotation(0, Time.Seconds * 50f, 0);
		////m3 *= rotM;
		//Backend.SetMatrixMode(MatrixMode.ModelView);
		//Backend.SetMatrix(m3);
		//
		//Backend.EnableTexture2D();
		//glColor3f(1f,1f,1f);
		//rt.BindTexture();
		//va.Render();
	}

	/**
		Creates and adds a GameObject to the scene.
	*/
	GameObject CreateGameObject() {
		auto obj = new GameObject();
		gameObjects ~= obj;
		return obj;
	}

}

Scene CurrentScene;