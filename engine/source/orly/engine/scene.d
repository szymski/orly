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
			Vertex(0, 0, Screen.Height, 0, 1),
		]), DrawType.Quads);
	} 

	/** 
		Updates the scene.
	*/
	void Update() {
		foreach(obj; gameObjects)
			obj.Update();
	}

	/**
		Renders the scene.
	*/
	void Render() {
		rt.Bind();

		if(Camera.main !is null)
			Camera.main.SetupRendering();

		foreach(obj; gameObjects)
			obj.Render();

		rt.Unbind(); // TODO: Remove - debug purposes. 

		auto m = new Matrix4x4();
		m.InitOrthographic(0, 0, Screen.Width, Screen.Height, -10f, 10f);
		Backend.SetMatrixMode(MatrixMode.Projection);
		Backend.SetMatrix(m);
		// TODO: Doesn't work
		auto m2 = new Matrix4x4();
		m2.InitIdentity();
		Backend.SetMatrixMode(MatrixMode.ModelView);
		Backend.SetMatrix(m2);

		rt.BindTexture();
		va.Render();
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