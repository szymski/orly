module orly.engine.scene;

import orly.engine.backend.ibackend;
import orly.engine.gameobjects.gameobject;
import orly.engine.components.camera;
import orly.engine.time;

final class Scene {
 private:
	GameObject[] gameObjects;

 public:

	this() {
		CurrentScene = this;
	} 

	/** 
		Updates the scene.
	*/
	void Update() {
		foreach(GameObject obj; gameObjects)
			obj.Update();
	}

	/**
		Renders the scene.
	*/
	void Render() {
		if(Camera.main !is null)
			Camera.main.SetupRendering();

		foreach(GameObject obj; gameObjects)
			obj.Render();
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