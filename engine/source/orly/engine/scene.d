module orly.engine.scene;

import orly.engine.backend.ibackend;
import orly.engine.gameobjects.gameobject;

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
		import derelict.opengl3.gl;
		glLoadIdentity();

		Backend.SetupPerspective(90, 0, 1000000);


		glTranslatef(0, 0, 100f);

		glColor3f(1f, 0f, 1f);

		glBegin(GL_TRIANGLES);
		glVertex3f(100, 0, 10);
		glVertex3f(100, 100, 0);
		glVertex3f(0, 0, 0);
		glEnd();

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